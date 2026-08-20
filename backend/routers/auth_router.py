import uuid
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from database import get_db
from models.user import User
from models.teacher import Teacher
from models.faculty_request import FacultyAccountRequest
from models.department import Department
from schemas.auth_schemas import LoginRequest, LoginResponse, UserResponse
from schemas.faculty_schemas import FacultyRegistrationRequest, FacultyRequestResponse
from auth import hash_password, verify_password, create_access_token, get_current_user

router = APIRouter(prefix="/auth", tags=["Authentication"])

@router.post("/register-faculty", response_model=dict)
def register_faculty(req: FacultyRegistrationRequest, db: Session = Depends(get_db)):
    clean_username = req.username.strip()
    clean_email = req.email.strip().lower()
    clean_emp_id = req.employee_id.strip().upper()

    # Check for existing user or teacher in database
    existing_user = db.query(User).filter(
        (User.username == clean_username) | (User.email == clean_email)
    ).first()
    if existing_user:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="A user with this username or email already exists."
        )

    existing_teacher = db.query(Teacher).filter(Teacher.employee_id == clean_emp_id).first()
    if existing_teacher:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="A faculty member with this Employee ID already exists."
        )

    # Check for pending request
    existing_req = db.query(FacultyAccountRequest).filter(
        (FacultyAccountRequest.username == clean_username) |
        (FacultyAccountRequest.employee_id == clean_emp_id) |
        (FacultyAccountRequest.email == clean_email)
    ).first()
    if existing_req and existing_req.status == "PENDING":
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="A pending faculty registration request with this details already exists."
        )

    # Create new request
    pwd_hash = hash_password(req.password)
    request_id = f"REQ-{uuid.uuid4().hex[:8].upper()}"
    new_request = FacultyAccountRequest(
        id=request_id,
        full_name=req.full_name.strip(),
        email=clean_email,
        phone=req.phone.strip(),
        employee_id=clean_emp_id,
        department=req.department.strip(),
        designation=req.designation.strip(),
        degree=req.degree.strip() if req.degree else "M.Tech",
        username=clean_username,
        password_hash=pwd_hash,
        status="PENDING"
    )

    db.add(new_request)
    db.commit()
    db.refresh(new_request)

    return {
        "success": True,
        "message": "Faculty registration request submitted successfully. Awaiting administrator approval.",
        "request_id": new_request.id
    }

@router.post("/login", response_model=LoginResponse)
def login(login_req: LoginRequest, db: Session = Depends(get_db)):
    clean_username = login_req.username.strip()
    user = db.query(User).filter(
        (User.username == clean_username) | (User.email == clean_username.lower())
    ).first()

    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid username or password."
        )

    if not verify_password(login_req.password, user.password_hash):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid username or password."
        )

    if not user.is_active:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="This account has been deactivated. Please contact the administrator."
        )

    # Generate JWT
    token_data = {"sub": user.username, "role": user.role, "user_id": user.id}
    token = create_access_token(token_data)

    # Resolve details from teacher profile or user
    dept_name = None
    designation = None
    degree = None
    emp_id = None

    if user.department:
        dept_name = user.department.name

    if user.teacher_profile:
        emp_id = user.teacher_profile.employee_id
        designation = user.teacher_profile.designation
        degree = user.teacher_profile.degree
        if user.teacher_profile.department:
            dept_name = user.teacher_profile.department.name

    user_resp = UserResponse(
        id=user.id,
        username=user.username,
        name=user.name,
        email=user.email,
        role=user.role,
        department=dept_name,
        designation=designation,
        degree=degree,
        employee_id=emp_id,
        is_active=user.is_active
    )

    return LoginResponse(success=True, token=token, user=user_resp)

@router.get("/me", response_model=UserResponse)
def get_current_user_profile(current_user: User = Depends(get_current_user)):
    dept_name = None
    designation = None
    degree = None
    emp_id = None

    if current_user.department:
        dept_name = current_user.department.name

    if current_user.teacher_profile:
        emp_id = current_user.teacher_profile.employee_id
        designation = current_user.teacher_profile.designation
        degree = current_user.teacher_profile.degree
        if current_user.teacher_profile.department:
            dept_name = current_user.teacher_profile.department.name

    return UserResponse(
        id=current_user.id,
        username=current_user.username,
        name=current_user.name,
        email=current_user.email,
        role=current_user.role,
        department=dept_name,
        designation=designation,
        degree=degree,
        employee_id=emp_id,
        is_active=current_user.is_active
    )
