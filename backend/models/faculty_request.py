from sqlalchemy import Column, String, DateTime, ForeignKey, Integer
from sqlalchemy.sql import func
from database import Base

class FacultyAccountRequest(Base):
    __tablename__ = "faculty_account_requests"

    id = Column(String, primary_key=True, index=True)
    full_name = Column(String, nullable=False)
    email = Column(String, nullable=False)
    phone = Column(String, nullable=False)
    employee_id = Column(String, nullable=False)
    department = Column(String, nullable=False)
    designation = Column(String, nullable=False)
    degree = Column(String, nullable=False, default="M.Tech")
    username = Column(String, nullable=False)
    password_hash = Column(String, nullable=False)
    status = Column(String, default="PENDING")  # "PENDING", "APPROVED", "REJECTED"
    rejection_reason = Column(String, nullable=True)
    reviewed_by = Column(String, nullable=True)
    requested_at = Column(DateTime(timezone=True), server_default=func.now())
    reviewed_at = Column(DateTime(timezone=True), nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())
