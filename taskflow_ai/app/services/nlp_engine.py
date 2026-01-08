import re
from datetime import datetime, timedelta

class NLPEngine:
    def parse_task(self, raw_text: str):
        """
        Extracts task details from natural language.
        Input: "Finish report by tomorrow at 5pm priority high"
        """
        text = raw_text.lower()
        today = datetime.now()
        
        # Default values
        task_data = {
            "title": raw_text,
            "priority": 3,
            "energy_req": 3,
            "estimated_minutes": 30,
            "category": "General"
        }
        
        # 1. Detect Priority
        if "urgent" in text or "high priority" in text:
            task_data["priority"] = 5
        elif "low priority" in text:
            task_data["priority"] = 1
        
        # 2. Detect Energy
        if "focus" in text or "deep work" in text:
            task_data["energy_req"] = 5
            task_data["category"] = "Deep Work"
        elif "quick" in text or "easy" in text:
            task_data["energy_req"] = 1
            task_data["category"] = "Admin"
        
        # 3. Detect Time (Simple Heuristic)
        if "tomorrow" in text:
            # In a real app, we would calculate the actual date object here
            task_data["title"] = task_data["title"].replace("tomorrow", "").strip()
        
        # 4. Clean up title
        # Remove keywords we processed
        for word in ["urgent", "high priority", "focus", "deep work"]:
            task_data["title"] = task_data["title"].replace(word, "", 1)
        
        task_data["title"] = task_data["title"].strip().capitalize()
        
        return task_data
