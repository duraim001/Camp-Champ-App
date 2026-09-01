import os
import sys

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from database import SessionLocal
from models.user import User
from models.department import Department
from models.student import Student
from auth import verify_password

def verify():
    db = SessionLocal()
    try:
        total_students = db.query(Student).count()
        total_student_users = db.query(User).filter(User.role == "STUDENT").count()
        total_depts = db.query(Department).count()

        print(f"Total Students in DB: {total_students}")
        print(f"Total Student Users in DB: {total_student_users}")
        print(f"Total Departments in DB: {total_depts}")

        # Check Duraimurugan record
        durai_student = db.query(Student).filter(Student.register_number == "61232319013").first()
        if durai_student:
            print("\n[VERIFIED] Duraimurugan Student Record:")
            print(f"  Name: {durai_student.name}")
            print(f"  Register Number: {durai_student.register_number}")
            print(f"  Department: {durai_student.department} (Dept ID: {durai_student.department_id})")
            print(f"  Year: {durai_student.year} (Year of Study: {durai_student.year_of_study})")
            print(f"  Email: {durai_student.email}")
            print(f"  Status: {durai_student.status}")
            print(f"  User ID linked: {durai_student.user_id}")

            durai_user = db.query(User).filter(User.id == durai_student.user_id).first()
            if durai_user:
                print("\n[VERIFIED] Linked User Account:")
                print(f"  Username: {durai_user.username}")
                print(f"  Role: {durai_user.role}")
                print(f"  Is Active: {durai_user.is_active}")
                
                # Test bcrypt authentication
                pass_check = verify_password("duraimurugan13", durai_user.password_hash)
                print(f"  Password Verification ('duraimurugan13'): {'SUCCESS (VALID BCRYPT)' if pass_check else 'FAILED'}")

        # Check all student users have valid role and department
        invalid_users = db.query(User).filter(User.role == "STUDENT", User.is_active != True).count()
        print(f"\nInactive Student Users: {invalid_users}")

    finally:
        db.close()

if __name__ == "__main__":
    verify()
