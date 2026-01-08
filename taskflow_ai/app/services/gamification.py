from sqlalchemy.orm import Session
from app.models.achievement import Achievement
from app.models.task import Task
from datetime import datetime

class GamificationService:
    def __init__(self, db: Session, user_id: int):
        self.db = db
        self.user_id = user_id
    
    def check_achievements(self):
        """Checks and unlocks badges based on stats"""
        completed_count = self.db.query(Task).filter(
            Task.assignee_id == self.user_id, 
            Task.is_completed == True
        ).count()
        
        new_badges = []
        
        # Badge 1: The Starter (1 Task)
        if completed_count >= 1:
            self._award_badge("The Starter", "Completed your first task", "🌱", new_badges)
        
        # Badge 2: Productivity Master (10 Tasks)
        if completed_count >= 10:
            self._award_badge("Productivity Master", "Completed 10 tasks", "🚀", new_badges)
        
        return new_badges
    
    def _award_badge(self, name, desc, icon, badge_list):
        exists = self.db.query(Achievement).filter(
            Achievement.user_id == self.user_id, 
            Achievement.name == name
        ).first()
        
        if not exists:
            badge = Achievement(name=name, description=desc, icon=icon, user_id=self.user_id)
            self.db.add(badge)
            self.db.commit()
            badge_list.append(name)
