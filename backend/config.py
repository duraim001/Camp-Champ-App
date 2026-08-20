import os
from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    PROJECT_NAME: str = "Camp Champ API"
    VERSION: str = "1.0.0"
    API_V1_STR: str = ""
    
    # Supabase / PostgreSQL Configuration
    SUPABASE_URL: str = os.getenv("SUPABASE_URL", "https://exfixmqlcmsaegzuabgy.supabase.co")
    SUPABASE_ANON_KEY: str = os.getenv("SUPABASE_ANON_KEY", "sb_publishable_-z-1Y-pK5hJGKna2P9Ql-w_WS0us43k")
    SUPABASE_SERVICE_ROLE_KEY: str = os.getenv("SUPABASE_SERVICE_ROLE_KEY", "")
    
    # Database URL: Can connect to Supabase PostgreSQL directly or use SQLite local fallback for seamless dev/testing
    DATABASE_URL: str = os.getenv(
        "DATABASE_URL", 
        "sqlite:///./camp_champ.db"
    )
    
    # JWT Settings
    JWT_SECRET_KEY: str = os.getenv("JWT_SECRET_KEY", "camp_champ_super_secret_jwt_key_2026_secur3")
    JWT_ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 60 * 24 * 7  # 7 days

    class Config:
        case_sensitive = True
        env_file = ".env"

settings = Settings()
