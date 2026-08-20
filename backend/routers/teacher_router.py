from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from database import get_db
from models.user import User
from models.teacher import Teacher
from schemas.faculty_schemas import TeacherResponse
from auth import get_current_user

router = APIRouter(prefix="/teachers", tags=["Teachers"])

@router.get("/{teacher_id}", response_model=TeacherResponse)
def get_teacher_by_id(
    teacher_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    teacher = db.query(Teacher).filter(
        (Teacher.employee_id.ilike(teacher_id)) | 
        (Teacher.name.ilike(teacher_id)) | 
        (Teacher.email.ilike(teacher_id))
    ).first()

    if not teacher:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Teacher not found."
        )

    dept_name = teacher.department.name if teacher.department else "Engineering"

    return TeacherResponse(
        id=teacher.id,
        user_id=teacher.user_id,
        employee_id=teacher.employee_id,
        name=teacher.name,
        email=teacher.email,
        phone=teacher.phone,
        designation=teacher.designation,
        degree=teacher.degree,
        department=dept_name,
        college=teacher.college,
        location=teacher.location,
        status=teacher.status,
        class_advisor=teacher.class_advisor,
        is_present=teacher.is_present,
        attendance_percentage=teacher.attendance_percentage
    )
