from datetime import datetime, timedelta
from app.models.task import Task

def check_overdue_tasks(db):
    """
    In a real app, this would run via Celery/Cron every hour.
    """
    now = datetime.utcnow()
    overdue = db.query(Task).filter(
        Task.is_completed == False,
        Task.due_date < now
    ).all()
    
    alerts = []
    for task in overdue:
        # Mock Email Sending
        msg = f"🔔 REMINDER: Task '{task.title}' was due on {task.due_date}"
        print(f"SENDING EMAIL TO USER: {msg}")
        alerts.append(msg)
    
    return alerts
