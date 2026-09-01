import os
import sys
from fastapi.testclient import TestClient

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from main import app

client = TestClient(app)

def test_api():
    print("Testing Student Login API...")
    resp = client.post("/auth/login", json={"username": "duraimurugan", "password": "duraimurugan13"})
    print(f"Login Status: {resp.status_code}")
    assert resp.status_code == 200, f"Login failed: {resp.text}"
    login_data = resp.json()
    token = login_data["token"]
    user = login_data["user"]
    print(f"Logged in user: {user['name']}, Role: {user['role']}, Dept: {user['department']}, Reg: {user['register_number']}")
    assert user["role"] == "STUDENT"
    assert user["register_number"] == "61232319013"

    print("\nTesting GET /auth/me...")
    me_resp = client.get("/auth/me", headers={"Authorization": f"Bearer {token}"})
    assert me_resp.status_code == 200
    print(f"Profile: {me_resp.json()['name']} ({me_resp.json()['email']})")

    print("\nTesting GET /students/me...")
    std_me_resp = client.get("/students/me", headers={"Authorization": f"Bearer {token}"})
    assert std_me_resp.status_code == 200
    print(f"Student Me: {std_me_resp.json()['name']}, Reg: {std_me_resp.json()['register_number']}, Year: {std_me_resp.json()['year']}")

    print("\nTesting GET /students (Filter by Department AI&DS & Year 4)...")
    all_std_resp = client.get("/students?department=AI%26DS&year=4", headers={"Authorization": f"Bearer {token}"})
    assert all_std_resp.status_code == 200
    stds = all_std_resp.json()
    print(f"Found {len(stds)} 4th-year AI&DS students via API.")
    assert len(stds) == 55

    print("\nTesting Student Search by Name 'Duraimurugan'...")
    search_resp = client.get("/students?query=Duraimurugan", headers={"Authorization": f"Bearer {token}"})
    assert search_resp.status_code == 200
    search_results = search_resp.json()
    print(f"Search found {len(search_results)} matching student(s): {search_results[0]['name']}")
    assert search_results[0]["register_number"] == "61232319013"

    print("\nALL FASTAPI BACKEND TESTS PASSED SUCCESSFULLY!")

if __name__ == "__main__":
    test_api()
