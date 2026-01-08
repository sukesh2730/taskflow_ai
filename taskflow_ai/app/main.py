from fastapi import FastAPI
from app.core.config import settings
from app.core.database import engine, Base
from app.api.v1 import tasks, analytics, projects

# Import all models to ensure they're registered with SQLAlchemy
from app.models import user, project, task, achievement, user_log

# Create Tables
Base.metadata.create_all(bind=engine)

app = FastAPI(title=settings.PROJECT_NAME)

# Include Routers
app.include_router(tasks.router, prefix=f"{settings.API_V1_STR}/tasks", tags=["Tasks"])
app.include_router(projects.router, prefix=f"{settings.API_V1_STR}/projects", tags=["Projects"])
app.include_router(analytics.router, prefix=f"{settings.API_V1_STR}/analytics", tags=["Analytics"])

@app.get("/")
def root():
    return {"message": "TaskFlow AI API v2.0 is running"}
