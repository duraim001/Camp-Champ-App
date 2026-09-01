from typing import List, Optional
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from database import get_db
from models.user import User
from models.student import Student
from models.department import Department
from schemas.student_schemas import StudentResponse
from auth import get_current_user

router = APIRouter(prefix="/students", tags=["Students"])

@router.get("", response_model=List[StudentResponse])
def get_all_students(
    department: Optional[str] = None,
    year: Optional[str] = None,
    query: Optional[str] = None,
    db: Session = Depends(get_db),
    current_user: Optional[User] = Depends(get_current_user)
):
    q = db.query(Student)

    if department and department.upper() != "ALL":
        q = q.filter(
            (Student.department.ilike(f"%{department}%")) |
            (Student.department_id == db.query(Department.id).filter(Department.code == department).scalar_subquery())
        )

    if year and year.upper() != "ALL":
        if "4" in year or "IV" in year.upper():
            q = q.filter((Student.year_of_study == 4) | (Student.year.ilike("%4%") | (Student.year.ilike("%IV%"))))
        elif "3" in year or "III" in year.upper():
            q = q.filter((Student.year_of_study == 3) | (Student.year.ilike("%3%") | (Student.year.ilike("%III%"))))
        elif "2" in year or "II" in year.upper():
            q = q.filter((Student.year_of_study == 2) | (Student.year.ilike("%2%") | (Student.year.ilike("%II%"))))
        elif "1" in year or "I" in year.upper():
            q = q.filter((Student.year_of_study == 1) | (Student.year.ilike("%1%") | (Student.year.ilike("%I%"))))

    if query and query.strip():
        search_term = f"%{query.strip()}%"
        q = q.filter(
            (Student.name.ilike(search_term)) |
            (Student.register_number.ilike(search_term)) |
            (Student.roll_number.ilike(search_term)) |
            (Student.email.ilike(search_term))
        )

    students = q.order_by(Student.register_number.asc()).all()

    results = []
    for s in students:
        results.append(
            StudentResponse(
                id=s.id,
                user_id=s.user_id,
                name=s.name,
                register_number=s.register_number,
                roll_number=s.roll_number or "",
                date_of_birth=str(s.date_of_birth) if s.date_of_birth else "",
                department=s.department,
                department_id=s.department_id,
                course=s.course,
                year=s.year,
                year_of_study=s.year_of_study or 4,
                section=s.section,
                semester=s.semester,
                college=s.college,
                location=s.location,
                email=s.email,
                phone=s.phone,
                attendance_percentage=s.attendance_percentage or 0.0,
                status=s.status or "Active"
            )
        )
    return results

@router.get("/me", response_model=StudentResponse)
def get_my_student_profile(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    if not current_user.student_profile:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Student profile not found for the authenticated user."
        )

    s = current_user.student_profile
    return StudentResponse(
        id=s.id,
        user_id=s.user_id,
        name=s.name,
        register_number=s.register_number,
        roll_number=s.roll_number or "",
        date_of_birth=str(s.date_of_birth) if s.date_of_birth else "",
        department=s.department,
        department_id=s.department_id,
        course=s.course,
        year=s.year,
        year_of_study=s.year_of_study or 4,
        section=s.section,
        semester=s.semester,
        college=s.college,
        location=s.location,
        email=s.email,
        phone=s.phone,
        attendance_percentage=s.attendance_percentage or 0.0,
        status=s.status or "Active"
    )

@router.get("/{student_id}", response_model=StudentResponse)
def get_student_by_id(
    student_id: str,
    db: Session = Depends(get_db),
    current_user: Optional[User] = Depends(get_current_user)
):
    s = db.query(Student).filter(
        (Student.id == student_id) |
        (Student.register_number.ilike(student_id)) |
        (Student.email.ilike(student_id))
    ).first()

    if not s:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Student with identifier '{student_id}' not found."
        )

    return StudentResponse(
        id=s.id,
        user_id=s.user_id,
        name=s.name,
        register_number=s.register_number,
        roll_number=s.roll_number or "",
        date_of_birth=str(s.date_of_birth) if s.date_of_birth else "",
        department=s.department,
        department_id=s.department_id,
        course=s.course,
        year=s.year,
        year_of_study=s.year_of_study or 4,
        section=s.section,
        semester=s.semester,
        college=s.college,
        location=s.location,
        email=s.email,
        phone=s.phone,
        attendance_percentage=s.attendance_percentage or 0.0,
        status=s.status or "Active"
    )
