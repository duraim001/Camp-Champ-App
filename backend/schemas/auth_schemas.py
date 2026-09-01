from typing import Optional
from pydantic import BaseModel, EmailStr

class LoginRequest(BaseModel):
    username: str
    password: str

class UserResponse(BaseModel):
    id: int
    username: str
    name: str
    email: str
    role: str
    department: Optional[str] = None
    designation: Optional[str] = None
    degree: Optional[str] = None
    employee_id: Optional[str] = None
    register_number: Optional[str] = None
    roll_number: Optional[str] = None
    year: Optional[str] = None
    section: Optional[str] = None
    course: Optional[str] = None
    semester: Optional[str] = None
    phone: Optional[str] = None
    attendance_percentage: Optional[float] = None
    is_active: bool = True

    class Config:
        from_attributes = True

class LoginResponse(BaseModel):
    success: bool = True
    token: str
    token_type: str = "bearer"
    user: UserResponse
