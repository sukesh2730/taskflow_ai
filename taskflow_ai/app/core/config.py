import os
from dotenv import load_dotenv

load_dotenv()

class Settings:
    PROJECT_NAME: str = os.getenv("PROJECT_NAME", "TaskFlow AI")
    API_V1_STR: str = os.getenv("API_V1_STR", "/api/v1")
    
    # Default to SQLite, but use Env Var if present (for Docker)
    DATABASE_URL: str = os.getenv("DATABASE_URL", "sqlite:///./taskflow.db")

settings = Settings()
