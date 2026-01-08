from sqlalchemy.orm import Session
from app.models.task import Task
from app.models.user_log import UserLog
from datetime import datetime

class AIEngine:
    def __init__(self, db: Session):
        self.db = db
    
    def get_current_state(self):
        """Get the most recent user log"""
        return self.db.query(UserLog).order_by(UserLog.timestamp.desc()).first()
    
    def calculate_task_score(self, task: Task, current_energy: int, current_mood: str) -> float:
        """
        Scoring Algorithm:
        Higher score = Better recommendation for RIGHT NOW.
        """
        score = 0.0
        
        # 1. Energy Alignment (Weighted 40%)
        # Map user energy (1-10) to task energy (1-5)
        normalized_user_energy = current_energy / 2
        energy_delta = abs(normalized_user_energy - task.energy_req)
        score += (5 - energy_delta) * 4 
        
        # 2. Priority Impact (Weighted 30%)
        score += task.priority * 3
        
        # 3. Mood Context (Weighted 30%)
        if current_mood == "Stressed" and task.energy_req > 3:
            score -= 10 # Penalty for hard tasks when stressed
        if current_mood == "Focused" and task.category == "Deep Work":
            score += 10 # Bonus for deep work when focused
            
        return score
    
    def get_recommendations(self, limit: int = 5):
        """Returns tasks sorted by AI score"""
        state = self.get_current_state()
        
        # Default state if no logs exist
        current_energy = state.energy_level if state else 5
        current_mood = state.mood if state else "Neutral"
        
        tasks = self.db.query(Task).filter(Task.is_completed == False).all()
        
        # Calculate scores
        scored_tasks = []
        for task in tasks:
            score = self.calculate_task_score(task, current_energy, current_mood)
            scored_tasks.append({"task": task, "score": score})
        
        # Sort descending
        scored_tasks.sort(key=lambda x: x["score"], reverse=True)
        
        return [item["task"] for item in scored_tasks[:limit]]
    
    def analyze_burnout_risk(self):
        """Simple heuristic for burnout"""
        logs = self.db.query(UserLog).order_by(UserLog.timestamp.desc()).limit(5).all()
        if not logs:
            return "Unknown"
        
        avg_energy = sum([l.energy_level for l in logs]) / len(logs)
        if avg_energy < 3:
            return "High Risk"
        elif avg_energy < 5:
            return "Moderate Risk"
        return "Low Risk"
