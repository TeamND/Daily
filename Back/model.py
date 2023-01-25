import flask_sqlalchemy
import datetime
db = flask_sqlalchemy.SQLAlchemy()

class User(db.Model):
    __tablename__ = 'user'
    uid = db.Column(db.Integer, primary_key=True)
    phone_uid = db.Column(db.Integer)
    set_startday = db.Column(db.Integer, default=0)
    set_language = db.Column(db.String(100), default='korea')
    set_dateorrepeat = db.Column(db.String(100), default='date')
    set_calendarstate = db.Column(db.String(100), default='month')
    
class Goal(db.Model):
    __tablename__ = 'goal'
    uid = db.Column(db.Integer, primary_key=True)
    user_uid = db.Column(db.Integer, db.ForeignKey('user.uid'))
    content = db.Column(db.String(100))
    symbol = db.Column(db.String(100), default='운동')
    start_date = db.Column(db.DateTime)
    end_date = db.Column(db.DateTime)
    cycle_type = db.Column(db.String(100), default='date')
    cycle_date = db.Column(db.String(100), default='0')
    type = db.Column(db.String(100), default='check')
    goal_count = db.Column(db.Integer, default=1)
    goal_time = db.Column(db.Integer, default=60)
    record = db.relationship('Record', backref='goal', lazy=True) 
    
    def __repr__(self):
        return f"Goal('{self.uid}', '{self.user_uid}', '{self.content}', '{self.symbol}', '{self.start_date}', '{self.end_date}', '{self.cycle_type}', '{self.cycle_date}', '{self.type}', '{self.goal_count}', '{self.goal_time}')"
    
class Record(db.Model):
    __tablename__ = 'record'
    uid = db.Column(db.Integer, primary_key=True)
    goal_uid = db.Column(db.Integer, db.ForeignKey('goal.uid'))
    date = db.Column(db.DateTime)
    order = db.Column(db.Integer)
    issuccess = db.Column(db.Boolean, default=False)
    record_count = db.Column(db.Integer)
    record_time = db.Column(db.Integer)
    start_time = db.Column(db.DateTime)
    
    def __repr__(self):
        return f"Record('{self.uid}', '{self.goal_uid}', '{self.date}', '{self.order}', '{self.issuccess}', '{self.record_count}', '{self.goal_count}', '{self.record_time}', '{self.goal_time}', '{self.start_time}')"