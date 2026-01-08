from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List, Optional
from app.core.database import get_db
from app.models.task import Task
from app.schemas.task import TaskCreate, TaskResponse
from app.services.ai_engine import AIEngine
from app.services.nlp_engine import NLPEngine
from app.services.gamification import GamificationService
from app.services.notifications import check_overdue_tasks
from datetime import datetime
from pydantic import BaseModel

router = APIRouter()

# New Schema for NLP Input
class SmartTaskInput(BaseModel):
    text: str

@router.post("/", response_model=TaskResponse)
def create_task(task: TaskCreate, db: Session = Depends(get_db)):
    db_task = Task(**task.model_dump())
    db.add(db_task)
    db.commit()
    db.refresh(db_task)
    return db_task

@router.get("/", response_model=List[TaskResponse])
def get_tasks(
    project_id: Optional[int] = None, 
    priority: Optional[int] = None,
    db: Session = Depends(get_db)
):
    query = db.query(Task)
    if project_id:
        query = query.filter(Task.project_id == project_id)
    if priority:
        query = query.filter(Task.priority == priority)
    return query.all()

# --- NLP ENDPOINT ---
@router.post("/smart-add", response_model=TaskResponse)
def create_smart_task(input: SmartTaskInput, db: Session = Depends(get_db)):
    nlp = NLPEngine()
    parsed_data = nlp.parse_task(input.text)
    
    db_task = Task(**parsed_data)
    db.add(db_task)
    db.commit()
    db.refresh(db_task)
    return db_task

@router.get("/recommended", response_model=List[TaskResponse])
def get_recommended_tasks(db: Session = Depends(get_db)):
    ai = AIEngine(db)
    return ai.get_recommendations()

@router.put("/{task_id}/complete")
def complete_task(task_id: int, db: Session = Depends(get_db)):
    task = db.query(Task).filter(Task.id == task_id).first()
    if not task:
        raise HTTPException(status_code=404, detail="Task not found")
    
    task.is_completed = True
    task.completed_at = datetime.utcnow()
    db.commit()
    
    # 🏆 Trigger Gamification
    # Assuming User ID 1 for MVP
    game_service = GamificationService(db, user_id=1)
    new_badges = game_service.check_achievements()
    
    return {
        "status": "success", 
        "badges_unlocked": new_badges
    }

@router.get("/check-reminders")
def trigger_reminders(db: Session = Depends(get_db)):
    alerts = check_overdue_tasks(db)
    return {"alerts_sent": len(alerts), "messages": alerts}
