from fastapi.testclient import TestClient
from main import app
from database import SessionLocal
from seed import init_db
from models.user import User
from models.teacher import Teacher
from models.faculty_request import FacultyAccountRequest

client = TestClient(app)

def test_full_faculty_persistence_flow():
    init_db()
    
    # Clean previous test artifacts
    db = SessionLocal()
    try:
        db.query(FacultyAccountRequest).filter(
            (FacultyAccountRequest.username == "testfaculty001") |
            (FacultyAccountRequest.employee_id == "TEST001")
        ).delete()
        t = db.query(Teacher).filter(Teacher.employee_id == "TEST001").first()
        if t:
            db.delete(t)
        u = db.query(User).filter(User.username == "testfaculty001").first()
        if u:
            db.delete(u)
        db.commit()
    finally:
        db.close()

    print("\n--- 1. Testing Faculty Registration ---")
    reg_payload = {
        "full_name": "Dr. Test Faculty One",
        "email": "testfaculty001@sengunthar.ac.in",
        "phone": "+91 98765 43210",
        "employee_id": "TEST001",
        "department": "Artificial Intelligence and Data Science",
        "designation": "Assistant Professor",
        "degree": "M.Tech",
        "username": "testfaculty001",
        "password": "Password@123"
    }
    res = client.post("/auth/register-faculty", json=reg_payload)
    assert res.status_code == 200, f"Registration failed: {res.text}"
    req_data = res.json()
    assert req_data["success"] is True
    request_id = req_data["request_id"]
    print(f"[PASS] Faculty request submitted with ID: {request_id}")

    print("\n--- 2. Testing Admin Login ---")
    admin_login_res = client.post("/auth/login", json={"username": "admin", "password": "admin123"})
    assert admin_login_res.status_code == 200, f"Admin login failed: {admin_login_res.text}"
    admin_token = admin_login_res.json()["token"]
    admin_headers = {"Authorization": f"Bearer {admin_token}"}
    print("[PASS] Admin logged in successfully and received JWT")

    print("\n--- 3. Fetching Faculty Requests ---")
    reqs_res = client.get("/admin/faculty-requests", headers=admin_headers)
    assert reqs_res.status_code == 200
    reqs = reqs_res.json()
    assert any(r["id"] == request_id for r in reqs)
    print("[PASS] Faculty request found in Admin list")

    print("\n--- 4. Approving Faculty Request (Atomic DB Transaction) ---")
    approve_res = client.post(f"/admin/faculty-requests/{request_id}/approve", headers=admin_headers)
    assert approve_res.status_code == 200, f"Approval failed: {approve_res.text}"
    approve_data = approve_res.json()
    assert approve_data["success"] is True
    assert approve_data["teacher"]["employee_id"] == "TEST001"
    print("[PASS] Request approved and teacher account created")

    print("\n--- 5. Verifying Double-Approval Protection ---")
    double_res = client.post(f"/admin/faculty-requests/{request_id}/approve", headers=admin_headers)
    assert double_res.status_code == 400
    print("[PASS] Double-approval prevented with 400 Bad Request")

    print("\n--- 6. Verifying Direct Database Persistence ---")
    db = SessionLocal()
    try:
        user_in_db = db.query(User).filter(User.username == "testfaculty001").first()
        assert user_in_db is not None, "User record not found in DB!"
        assert user_in_db.role == "TEACHER"

        teacher_in_db = db.query(Teacher).filter(Teacher.employee_id == "TEST001").first()
        assert teacher_in_db is not None, "Teacher record not found in DB!"
        assert teacher_in_db.name == "Dr. Test Faculty One"
        assert teacher_in_db.user_id == user_in_db.id
        print("[PASS] Verified users and teachers records directly in PostgreSQL database")
    finally:
        db.close()

    print("\n--- 7. Testing Teacher Login with Credentials ---")
    teacher_login_res = client.post("/auth/login", json={
        "username": "testfaculty001",
        "password": "Password@123"
    })
    assert teacher_login_res.status_code == 200, f"Teacher login failed: {teacher_login_res.text}"
    teacher_data = teacher_login_res.json()
    teacher_token = teacher_data["token"]
    assert teacher_data["user"]["name"] == "Dr. Test Faculty One"
    assert teacher_data["user"]["role"] == "TEACHER"
    print("[PASS] Teacher logged in successfully using permanent database account")

    print("\n--- 8. Testing /auth/me with Teacher JWT ---")
    me_res = client.get("/auth/me", headers={"Authorization": f"Bearer {teacher_token}"})
    assert me_res.status_code == 200
    me_data = me_res.json()
    assert me_data["name"] == "Dr. Test Faculty One"
    assert me_data["designation"] == "Assistant Professor"
    assert me_data["degree"] == "M.Tech"
    print(f"[PASS] /auth/me returned: {me_data['name']} ({me_data['degree']}, {me_data['designation']})")

    print("\n==========================================")
    print("ALL BACKEND PERSISTENCE TESTS PASSED!")
    print("==========================================")

if __name__ == "__main__":
    test_full_faculty_persistence_flow()
