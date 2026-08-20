from schemas.auth_schemas import LoginRequest, LoginResponse, UserResponse
from schemas.faculty_schemas import (
    FacultyRegistrationRequest, 
    FacultyRequestResponse, 
    AdminApprovalResponse, 
    TeacherResponse
)

__all__ = [
    "LoginRequest", "LoginResponse", "UserResponse",
    "FacultyRegistrationRequest", "FacultyRequestResponse",
    "AdminApprovalResponse", "TeacherResponse"
]
