import os
import sys
import csv
import re
import argparse
from typing import Dict, List, Tuple

# Ensure backend directory is in path
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from database import engine, SessionLocal, Base
from models.user import User
from models.department import Department
from models.student import Student
from auth import hash_password

DEFAULT_CSV_PATH = os.path.join(
    os.path.dirname(os.path.dirname(os.path.abspath(__file__))),
    "database",
    "IVth year students details.csv"
)

def normalize_name_for_username(full_name: str) -> str:
    """Extracts first name and converts to clean lowercase alphanumeric."""
    parts = full_name.strip().split()
    first_part = parts[0] if parts else "student"
    clean = re.sub(r'[^a-zA-Z0-9]', '', first_part).lower()
    return clean if clean else "student"

def generate_initial_password(full_name: str, reg_no: str) -> str:
    """
    Generates password: normalized student name + last 2 digits of register number
    Example: Duraimurugan + 61232319013 -> duraimurugan13
    """
    clean_name = normalize_name_for_username(full_name)
    clean_reg = re.sub(r'[^0-9]', '', reg_no.strip())
    last2 = clean_reg[-2:] if len(clean_reg) >= 2 else "00"
    return f"{clean_name}{last2}"

def validate_csv(csv_path: str) -> Tuple[bool, List[Dict[str, str]], List[str]]:
    """
    Performs full dry-run validation on the CSV file.
    Returns: (is_valid, rows, error_messages)
    """
    if not os.path.exists(csv_path):
        return False, [], [f"CSV file not found at: {csv_path}"]

    with open(csv_path, mode="r", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        rows = list(reader)

    errors = []
    seen_regs = {}
    seen_emails = {}

    print(f"=== CSV DRY-RUN VALIDATION ===")
    print(f"File: {csv_path}")
    print(f"Total Rows: {len(rows)}")

    for idx, r in enumerate(rows, 1):
        name = r.get("NAME", "").strip()
        reg = r.get("Register number", "").strip()
        email = r.get("Email", "").strip().lower()
        phone = r.get("Phone Number", "").strip()

        if not name:
            errors.append(f"Row {idx}: Missing student NAME.")
        if not reg:
            errors.append(f"Row {idx}: Missing student Register number.")
        if not email:
            errors.append(f"Row {idx}: Missing student Email.")

        if reg in seen_regs:
            prev_idx, prev_name = seen_regs[reg]
            errors.append(
                f"Row {idx} ({name}): Duplicate Register Number '{reg}' matches Row {prev_idx} ({prev_name})."
            )
        else:
            seen_regs[reg] = (idx, name)

        if email in seen_emails:
            prev_idx, prev_name = seen_emails[email]
            errors.append(
                f"Row {idx} ({name}): Duplicate Email '{email}' matches Row {prev_idx} ({prev_name})."
            )
        else:
            seen_emails[email] = (idx, name)

    return len(errors) == 0, rows, errors

def import_students(csv_path: str = DEFAULT_CSV_PATH, dry_run: bool = False):
    """
    Imports students from CSV into database (Supabase PostgreSQL / SQLite) atomically.
    """
    # 1. Initialize Tables
    Base.metadata.create_all(bind=engine)

    # 2. Dry run validation
    is_valid, rows, validation_errors = validate_csv(csv_path)

    if validation_errors:
        print("\n--- Validation Warnings / Notices ---")
        for err in validation_errors:
            print(f"  [WARN] {err}")
        print("------------------------------------\n")

    if dry_run:
        print("DRY-RUN completed. No database changes were made.")
        return

    print("\nStarting database import transaction...")
    db = SessionLocal()

    imported_count = 0
    updated_count = 0
    skipped_count = 0

    try:
        # 3. Resolve or Create AI&DS Department
        aids_dept = db.query(Department).filter(
            (Department.code == "AI&DS") | 
            (Department.name.ilike("%Artificial Intelligence%"))
        ).first()

        if not aids_dept:
            aids_dept = Department(
                name="Artificial Intelligence and Data Science",
                code="AI&DS"
            )
            db.add(aids_dept)
            db.flush()
            print(f"Created Department: {aids_dept.name} ({aids_dept.code}) [ID: {aids_dept.id}]")
        else:
            print(f"Using Existing Department: {aids_dept.name} ({aids_dept.code}) [ID: {aids_dept.id}]")

        # Track usernames to avoid collisions within batch
        username_counts = {}
        # Pre-populate with existing usernames in database
        existing_users = db.query(User.username).all()
        for (u,) in existing_users:
            base = re.sub(r'\d+$', '', u.lower())
            username_counts[base] = max(username_counts.get(base, 0), 1)

        # 4. Process each student row
        for idx, row in enumerate(rows, 1):
            name = row.get("NAME", "").strip()
            raw_reg = row.get("Register number", "").strip()
            email = row.get("Email", "").strip().lower()
            phone = row.get("Phone Number", "").strip()
            course = row.get("Course", "").strip() or "B.TECH"
            year_str = row.get("Year", "").strip() or "IV"
            dept_name = row.get("Department", "").strip() or aids_dept.name
            semester = row.get("Semester", "").strip() or "VII"

            if not name or not raw_reg or not email:
                print(f"Skipping row {idx} due to missing required fields.")
                skipped_count += 1
                continue

            # Handle duplicate register number in raw CSV deterministically to avoid primary key crash
            reg_clean = raw_reg
            existing_student_by_reg = db.query(Student).filter(Student.register_number == reg_clean).first()
            if existing_student_by_reg and existing_student_by_reg.name != name:
                # Disambiguate duplicate register number from CSV
                reg_clean = f"{raw_reg}-{idx:02d}"
                print(f"Notice: Disambiguating duplicate reg for row {idx} ({name}) -> {reg_clean}")

            # Derive Roll Number (last 2 digits or sequential)
            roll_number = raw_reg[-2:] if len(raw_reg) >= 2 else f"{idx:02d}"

            # Generate unique username
            base_username = normalize_name_for_username(name)
            
            # Check if user already exists for this email
            user = db.query(User).filter((User.email == email)).first()
            
            if not user:
                # Generate unique username
                if base_username in username_counts:
                    count = username_counts[base_username] + 1
                    username_counts[base_username] = count
                    username = f"{base_username}{count:02d}"
                else:
                    # Check if base username is already taken in DB
                    db_check = db.query(User).filter(User.username == base_username).first()
                    if db_check:
                        username_counts[base_username] = 1
                        username = f"{base_username}01"
                    else:
                        username_counts[base_username] = 0
                        username = base_username

                # Generate initial plain password & hash with bcrypt
                plain_password = generate_initial_password(name, raw_reg)
                pwd_hash = hash_password(plain_password)

                user = User(
                    username=username,
                    password_hash=pwd_hash,
                    name=name,
                    email=email,
                    role="STUDENT",
                    department_id=aids_dept.id,
                    is_active=True
                )
                db.add(user)
                db.flush()
                is_new_user = True
            else:
                user.name = name
                user.role = "STUDENT"
                user.department_id = aids_dept.id
                user.is_active = True
                db.flush()
                is_new_user = False

            # Create or update Student record
            student = db.query(Student).filter(
                (Student.register_number == reg_clean) | (Student.user_id == user.id)
            ).first()

            if not student:
                student = Student(
                    id=f"SEC-STD-{reg_clean}",
                    user_id=user.id,
                    name=name,
                    register_number=reg_clean,
                    roll_number=roll_number,
                    department=dept_name,
                    department_id=aids_dept.id,
                    course=course,
                    year="4th Year",
                    year_of_study=4,
                    section="A",
                    semester=semester,
                    college="Sengunthar Engineering College",
                    location="Tiruchengode, Tamil Nadu",
                    email=email,
                    phone=phone,
                    attendance_percentage=90.0,
                    status="Active",
                    admission_year=2023
                )
                db.add(student)
                imported_count += 1
            else:
                student.user_id = user.id
                student.name = name
                student.register_number = reg_clean
                student.roll_number = roll_number
                student.department = dept_name
                student.department_id = aids_dept.id
                student.course = course
                student.year = "4th Year"
                student.year_of_study = 4
                student.section = "A"
                student.semester = semester
                student.email = email
                student.phone = phone
                student.status = "Active"
                student.admission_year = 2023
                updated_count += 1

        # 5. Commit atomic transaction
        db.commit()

        print("\n" + "=" * 50)
        print("IMPORT SUMMARY")
        print("=" * 50)
        print(f"Total CSV Rows Processed : {len(rows)}")
        print(f"Successfully Imported    : {imported_count}")
        print(f"Updated Existing Records : {updated_count}")
        print(f"Skipped / Invalid Records: {skipped_count}")
        print(f"Department               : {aids_dept.name} ({aids_dept.code})")
        print("Status                   : Transaction Committed Successfully")
        print("=" * 50 + "\n")

    except Exception as e:
        db.rollback()
        print(f"\n[FATAL ERROR] Import failed: {str(e)}")
        print("Database transaction rolled back safely.")
        raise
    finally:
        db.close()

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Import 4th-year AI&DS students into Camp Champ database.")
    parser.add_argument("--csv", default=DEFAULT_CSV_PATH, help="Path to student CSV file")
    parser.add_argument("--dry-run", action="store_true", help="Perform dry-run validation without database writes")
    args = parser.parse_args()

    import_students(csv_path=args.csv, dry_run=args.dry_run)
