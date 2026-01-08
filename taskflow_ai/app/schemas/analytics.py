from pydantic import BaseModel
from datetime import datetime

class LogCreate(BaseModel):
    energy_level: int
    mood: str

class LogResponse(LogCreate):
    id: int
    timestamp: datetime
    
    class Config:
        from_attributes = True
