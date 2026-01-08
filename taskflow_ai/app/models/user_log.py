from sqlalchemy import Column, Integer, String, DateTime
from datetime import datetime
from app.core.database import Base

class UserLog(Base):
    __tablename__ = "user_logs"
    
    id = Column(Integer, primary_key=True, index=True)
    energy_level = Column(Integer) # 1-10
    mood = Column(String) # Focused, Tired, Stressed, etc.
    timestamp = Column(DateTime, default=datetime.utcnow)
