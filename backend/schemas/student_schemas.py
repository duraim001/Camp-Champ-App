from typing import Optional
from pydantic import BaseModel

class StudentResponse(BaseModel):
    id: str
    user_id: Optional[int] = None
    name: str
    register_number: str
    roll_number: Optional[str] = ""
    date_of_birth: Optional[str] = ""
    department: str
    department_id: Optional[int] = None
    course: str
    year: str
    year_of_study: Optional[int] = 4
    section: str
    semester: str
    college: str
    location: str
    email: str
    phone: str
    attendance_percentage: float = 0.0
    status: str = "Active"

    class Config:
        from_attributes = True
