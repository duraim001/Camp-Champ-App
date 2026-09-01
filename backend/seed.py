from database import engine, Base, SessionLocal
from models.user import User
from models.department import Department
from models.teacher import Teacher
from models.faculty_request import FacultyAccountRequest
from auth import hash_password

def init_db():
    # Create all tables in database
    Base.metadata.create_all(bind=engine)
    
    db = SessionLocal()
    try:
        # 1. Seed Departments
        departments = [
            {"name": "Artificial Intelligence and Data Science", "code": "AI&DS"},
            {"name": "Computer Science and Engineering", "code": "CSE"},
            {"name": "Electronics and Communication Engineering", "code": "ECE"},
            {"name": "Electrical and Electronics Engineering", "code": "EEE"},
            {"name": "Mechanical Engineering", "code": "MECH"},
            {"name": "Civil Engineering", "code": "CIVIL"},
            {"name": "Information Technology", "code": "IT"},
        ]
        
        dept_map = {}
        for d in departments:
            existing = db.query(Department).filter(
                (Department.code == d["code"]) | (Department.name == d["name"])
            ).first()
            if not existing:
                dept = Department(name=d["name"], code=d["code"])
                db.add(dept)
                db.flush()
                dept_map[d["code"]] = dept
            else:
                existing.code = d["code"]
                existing.name = d["name"]
                db.flush()
                dept_map[d["code"]] = existing

        # 2. Seed Default Admin User
        admin_user = db.query(User).filter(User.username == "admin").first()
        if not admin_user:
            admin_user = User(
                username="admin",
                password_hash=hash_password("admin123"),
                name="Principal / Administrator",
                email="admin@sengunthar.ac.in",
                role="ADMIN",
                is_active=True
            )
            db.add(admin_user)
            db.flush()

        # 3. Seed AI&DS Permanent Department Coordinator Account
        aids_dept = dept_map.get("AI&DS")
        coord_user = db.query(User).filter(User.username == "aidscoordinator").first()
        if not coord_user:
            coord_user = User(
                username="aidscoordinator",
                password_hash=hash_password("aidscoordinator"),
                name="M. Premkumar",
                email="aidscoordinator@sengunthar.ac.in",
                role="TEACHER",
                department_id=aids_dept.id if aids_dept else None,
                is_active=True
            )
            db.add(coord_user)
            db.flush()
        else:
            coord_user.name = "M. Premkumar"
            coord_user.password_hash = hash_password("aidscoordinator")
            coord_user.role = "TEACHER"
            coord_user.department_id = aids_dept.id if aids_dept else None
            coord_user.is_active = True
            db.flush()

        coord_teacher = db.query(Teacher).filter(
            (Teacher.user_id == coord_user.id) | (Teacher.employee_id == "SEC-AIDS-COORD")
        ).first()
        if not coord_teacher:
            coord_teacher = Teacher(
                user_id=coord_user.id,
                employee_id="SEC-AIDS-COORD",
                name="M. Premkumar",
                email="aidscoordinator@sengunthar.ac.in",
                phone="+91 90000 00003",
                designation="Department Coordinator",
                degree="M.E.",
                department_id=aids_dept.id if aids_dept else None,
                college="Sengunthar Engineering College",
                location="Tiruchengode, Tamil Nadu",
                class_advisor="AI&DS Department Coordinator",
                is_present=True,
                attendance_percentage=100.0,
                status="Active"
            )
            db.add(coord_teacher)
        else:
            coord_teacher.user_id = coord_user.id
            coord_teacher.employee_id = "SEC-AIDS-COORD"
            coord_teacher.name = "M. Premkumar"
            coord_teacher.email = "aidscoordinator@sengunthar.ac.in"
            coord_teacher.designation = "Department Coordinator"
            coord_teacher.degree = "M.E."
            coord_teacher.department_id = aids_dept.id if aids_dept else None
            coord_teacher.status = "Active"

        # 4. Check if students need to be imported
        from models.student import Student
        student_count = db.query(Student).count()
        if student_count == 0:
            db.commit()
            from import_students import import_students
            print("Importing students into database...")
            import_students()
        else:
            db.commit()
            print(f"Database initialized. Total students present: {student_count}")
    except Exception as e:
        db.rollback()
        print(f"Error seeding database: {e}")
    finally:
        db.close()

if __name__ == "__main__":
    init_db()

