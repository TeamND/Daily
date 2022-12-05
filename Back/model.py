import flask_sqlalchemy

db = flask_sqlalchemy.SQLAlchemy()

class User(db.Model):
    __tablename__ = 'user'
    uid = db.Column(db.Integer, primary_key=True)
    phone_uid = db.Column(db.String(100))
    set_startday = db.Column(db.Integer, default=0)
    set_language = db.Column(db.String(100),default='korea')