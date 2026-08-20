from typing import Optional, List
from datetime import datetime
from pydantic import BaseModel, EmailStr

class FacultyRegistrationRequest(BaseModel):
    full_name: str
    email: EmailStr
    phone: str
    employee_id: str
    department: str
    designation: str
    degree: Optional[str] = "M.Tech"
    username: str
    password: str

class FacultyRequestResponse(BaseModel):
    id: str
    full_name: str
    email: str
    phone: str
    employee_id: str
    department: str
    designation: str
    degree: str
    username: str
    status: str
    rejection_reason: Optional[str] = None
    reviewed_by: Optional[str] = None
    requested_at: Optional[datetime] = None
    reviewed_at: Optional[datetime] = None

    class Config:
        from_attributes = True

class TeacherResponse(BaseModel):
    id: int
    user_id: int
    employee_id: str
    name: str
    email: str
    phone: str
    designation: str
    degree: str
    department: Optional[str] = None
    college: str
    location: str
    status: str
    class_advisor: Optional[str] = None
    is_present: bool = True
    attendance_percentage: float = 96.5

    class Config:
        from_attributes = True

class AdminApprovalResponse(BaseModel):
    success: bool
    message: str
    teacher: Optional[TeacherResponse] = None
