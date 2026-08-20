from sqlalchemy import Column, Integer, String, Boolean, Float, DateTime, ForeignKey
from sqlalchemy.sql import func
from sqlalchemy.orm import relationship
from database import Base

class Teacher(Base):
    __tablename__ = "teachers"

    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    user_id = Column(Integer, ForeignKey("users.id"), unique=True, nullable=False)
    employee_id = Column(String, unique=True, index=True, nullable=False)
    name = Column(String, nullable=False)
    email = Column(String, unique=True, nullable=False)
    phone = Column(String, nullable=False)
    designation = Column(String, nullable=False, default="Assistant Professor")
    degree = Column(String, nullable=False, default="M.Tech")
    department_id = Column(Integer, ForeignKey("departments.id"), nullable=True)
    college = Column(String, default="Sengunthar Engineering College")
    location = Column(String, default="Tiruchengode, Tamil Nadu")
    class_advisor = Column(String, default="")
    is_present = Column(Boolean, default=True)
    attendance_percentage = Column(Float, default=96.5)
    status = Column(String, default="Active")
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())

    user = relationship("User", back_populates="teacher_profile")
    department = relationship("Department", back_populates="teachers")
