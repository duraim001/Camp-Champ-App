from datetime import datetime
from typing import List, Optional
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from database import get_db
from models.user import User
from models.teacher import Teacher
from models.faculty_request import FacultyAccountRequest
from models.department import Department
from schemas.faculty_schemas import (
    FacultyRequestResponse, 
    AdminApprovalResponse, 
    TeacherResponse
)
from auth import require_admin, get_current_user

router = APIRouter(prefix="/admin", tags=["Administrator"])

@router.get("/faculty-requests", response_model=List[FacultyRequestResponse])
def get_faculty_requests(
    status_filter: Optional[str] = None,
    db: Session = Depends(get_db),
    admin: User = Depends(require_admin)
):
    query = db.query(FacultyAccountRequest)
    if status_filter and status_filter.upper() != "ALL":
        query = query.filter(FacultyAccountRequest.status == status_filter.upper())
    requests = query.order_by(FacultyAccountRequest.requested_at.desc()).all()
    return requests

@router.post("/faculty-requests/{request_id}/approve", response_model=AdminApprovalResponse)
def approve_faculty_request(
    request_id: str,
    db: Session = Depends(get_db),
    admin: User = Depends(require_admin)
):
    # 1. Load pending request
    req = db.query(FacultyAccountRequest).filter(FacultyAccountRequest.id == request_id).first()
    if not req:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Faculty request not found."
        )

    # Double approval protection
    if req.status == "APPROVED":
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Faculty request has already been processed and approved."
        )
    elif req.status != "PENDING":
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Faculty request has already been processed with status: {req.status}."
        )

    # Start atomic transaction
    try:
        # Resolve or create Department
        dept = db.query(Department).filter(
            (Department.name.ilike(req.department.strip())) | 
            (Department.code.ilike(req.department.strip()))
        ).first()

        if not dept:
            # Create department if it doesn't exist
            dept_code = req.department.strip().replace(" ", "").upper()[:6]
            dept = Department(name=req.department.strip(), code=dept_code)
            db.add(dept)
            db.flush()

        # Check for user conflicts
        existing_user = db.query(User).filter(
            (User.username == req.username) | (User.email == req.email)
        ).first()

        if existing_user:
            user = existing_user
            user.role = "TEACHER"
            user.department_id = dept.id
            user.is_active = True
        else:
            user = User(
                username=req.username,
                password_hash=req.password_hash,
                name=req.full_name,
                email=req.email,
                role="TEACHER",
                department_id=dept.id,
                is_active=True
            )
            db.add(user)
            db.flush()

        # Check for teacher conflict
        teacher = db.query(Teacher).filter(
            (Teacher.employee_id == req.employee_id) | (Teacher.user_id == user.id)
        ).first()

        if not teacher:
            teacher = Teacher(
                user_id=user.id,
                employee_id=req.employee_id,
                name=req.full_name,
                email=req.email,
                phone=req.phone,
                designation=req.designation,
                degree=req.degree if req.degree else "M.Tech",
                department_id=dept.id,
                college="Sengunthar Engineering College",
                location="Tiruchengode, Tamil Nadu",
                class_advisor=f"{dept.name} Advisor",
                is_present=True,
                attendance_percentage=96.5,
                status="Active"
            )
            db.add(teacher)
            db.flush()
        else:
            teacher.designation = req.designation
            teacher.degree = req.degree if req.degree else "M.Tech"
            teacher.department_id = dept.id
            teacher.status = "Active"

        # Mark request APPROVED
        req.status = "APPROVED"
        req.reviewed_by = admin.username
        req.reviewed_at = datetime.utcnow()

        # Commit all changes atomically
        db.commit()
        db.refresh(teacher)

        teacher_resp = TeacherResponse(
            id=teacher.id,
            user_id=teacher.user_id,
            employee_id=teacher.employee_id,
            name=teacher.name,
            email=teacher.email,
            phone=teacher.phone,
            designation=teacher.designation,
            degree=teacher.degree,
            department=dept.name,
            college=teacher.college,
            location=teacher.location,
            status=teacher.status,
            class_advisor=teacher.class_advisor,
            is_present=teacher.is_present,
            attendance_percentage=teacher.attendance_percentage
        )

        return AdminApprovalResponse(
            success=True,
            message="Faculty account approved and created successfully",
            teacher=teacher_resp
        )

    except Exception as e:
        db.rollback()
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to approve faculty account: {str(e)}"
        )

@router.post("/faculty-requests/{request_id}/reject", response_model=dict)
def reject_faculty_request(
    request_id: str,
    reason: Optional[str] = "Application does not meet institutional criteria.",
    db: Session = Depends(get_db),
    admin: User = Depends(require_admin)
):
    req = db.query(FacultyAccountRequest).filter(FacultyAccountRequest.id == request_id).first()
    if not req:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Faculty request not found."
        )

    if req.status != "PENDING":
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Faculty request has already been processed with status: {req.status}."
        )

    try:
        req.status = "REJECTED"
        req.rejection_reason = reason
        req.reviewed_by = admin.username
        req.reviewed_at = datetime.utcnow()
        db.commit()

        return {
            "success": True,
            "message": "Faculty request has been rejected."
        }
    except Exception as e:
        db.rollback()
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to reject request: {str(e)}"
        )

@router.get("/teachers", response_model=List[TeacherResponse])
def get_all_teachers(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    teachers = db.query(Teacher).all()
    results = []
    for t in teachers:
        dept_name = t.department.name if t.department else "Engineering"
        results.append(
            TeacherResponse(
                id=t.id,
                user_id=t.user_id,
                employee_id=t.employee_id,
                name=t.name,
                email=t.email,
                phone=t.phone,
                designation=t.designation,
                degree=t.degree,
                department=dept_name,
                college=t.college,
                location=t.location,
                status=t.status,
                class_advisor=t.class_advisor,
                is_present=t.is_present,
                attendance_percentage=t.attendance_percentage
            )
        )
    return results
