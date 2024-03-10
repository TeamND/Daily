from flask import Flask
from flask_restx import Resource, Api
from config import uri
from model import db
from Controller.UserController import user
from Controller.GoalController import goal
from Controller.CalendarController import calendar

app = Flask(__name__)
api = Api(
            app,
            version='Beta',
            title="Daily's API Server",
            description="Daily's API Server!",
            terms_url="/",
            contact="e3hope93@gmail.com",
            license="MIT"
)
app.config['SQLALCHEMY_DATABASE_URI'] = uri
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.app_context().push()
db.init_app(app)
db.create_all()

api.add_namespace(user, '/user')
api.add_namespace(goal, '/goal')
api.add_namespace(calendar, '/calendar')

if __name__ == "__main__":
    app.run(debug=True, host='0.0.0.0', port=5000)