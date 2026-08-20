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
            {"name": "Artificial Intelligence and Data Science", "code": "AIDS"},
            {"name": "Computer Science and Engineering", "code": "CSE"},
            {"name": "Electronics and Communication Engineering", "code": "ECE"},
            {"name": "Electrical and Electronics Engineering", "code": "EEE"},
            {"name": "Mechanical Engineering", "code": "MECH"},
            {"name": "Civil Engineering", "code": "CIVIL"},
            {"name": "Information Technology", "code": "IT"},
        ]
        
        dept_map = {}
        for d in departments:
            existing = db.query(Department).filter(Department.code == d["code"]).first()
            if not existing:
                dept = Department(name=d["name"], code=d["code"])
                db.add(dept)
                db.flush()
                dept_map[d["code"]] = dept
            else:
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

        # 3. Seed Initial Faculty Member
        pream_user = db.query(User).filter(User.username == "preamkumar").first()
        if not pream_user:
            aids_dept = dept_map.get("AIDS")
            pream_user = User(
                username="preamkumar",
                password_hash=hash_password("faculty123"),
                name="Mr. M. Preamkumar",
                email="preamkumar@sengunthar.ac.in",
                role="TEACHER",
                department_id=aids_dept.id if aids_dept else None,
                is_active=True
            )
            db.add(pream_user)
            db.flush()

            pream_teacher = Teacher(
                user_id=pream_user.id,
                employee_id="SEC-TCH-001",
                name="Mr. M. Preamkumar",
                email="preamkumar@sengunthar.ac.in",
                phone="+91 90000 00002",
                designation="Assistant Professor",
                degree="M.Tech",
                department_id=aids_dept.id if aids_dept else None,
                college="Sengunthar Engineering College",
                location="Tiruchengode, Tamil Nadu",
                class_advisor="2nd Year AI&DS Advisor",
                is_present=True,
                attendance_percentage=96.5,
                status="Active"
            )
            db.add(pream_teacher)

        db.commit()
        print("Database initialized and seeded successfully.")
    except Exception as e:
        db.rollback()
        print(f"Error seeding database: {e}")
    finally:
        db.close()

if __name__ == "__main__":
    init_db()
