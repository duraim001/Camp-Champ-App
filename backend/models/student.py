from sqlalchemy import Column, Integer, String, Float, DateTime, Date, ForeignKey
from sqlalchemy.sql import func
from sqlalchemy.orm import relationship
from database import Base

class Student(Base):
    __tablename__ = "students"

    id = Column(String, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), unique=True, nullable=True)
    name = Column(String, nullable=False)
    register_number = Column(String, unique=True, index=True, nullable=False)
    roll_number = Column(String, default="")
    date_of_birth = Column(Date, nullable=True)
    department = Column(String, nullable=False, default="Artificial intelligence and Data science")
    department_id = Column(Integer, ForeignKey("departments.id"), nullable=True)
    course = Column(String, default="B.TECH")
    year = Column(String, default="IV")
    year_of_study = Column(Integer, default=4)
    section = Column(String, default="A")
    semester = Column(String, default="VII")
    college = Column(String, default="Sengunthar Engineering College")
    location = Column(String, default="Tiruchengode, Tamil Nadu")
    email = Column(String, unique=True, nullable=False)
    phone = Column(String, nullable=False)
    attendance_percentage = Column(Float, default=0.0)
    status = Column(String, default="Active")
    admission_year = Column(Integer, default=2023)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())

    user = relationship("User", back_populates="student_profile")
    dept = relationship("Department", back_populates="students")
