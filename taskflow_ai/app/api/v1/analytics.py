from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.core.database import get_db
from app.models.user_log import UserLog
from app.schemas.analytics import LogCreate, LogResponse
from app.services.ai_engine import AIEngine

router = APIRouter()

@router.post("/log-state", response_model=LogResponse)
def log_user_state(log: LogCreate, db: Session = Depends(get_db)):
    db_log = UserLog(**log.model_dump())
    db.add(db_log)
    db.commit()
    db.refresh(db_log)
    return db_log

@router.get("/burnout-risk")
def get_burnout_risk(db: Session = Depends(get_db)):
    ai = AIEngine(db)
    return {"risk_level": ai.analyze_burnout_risk()}
