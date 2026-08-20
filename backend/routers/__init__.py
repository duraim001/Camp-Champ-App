from routers.auth_router import router as auth_router
from routers.admin_router import router as admin_router
from routers.teacher_router import router as teacher_router

__all__ = ["auth_router", "admin_router", "teacher_router"]
