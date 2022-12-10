from flask import Flask
from flask_restx import Resource, Api
from Api.user import user
from Api.goal import goal
from config import uri
from model import db

app = Flask(__name__)
api = Api(app)
app.config['SQLALCHEMY_DATABASE_URI'] = uri
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.app_context().push()
db.init_app(app)
db.create_all()

api.add_namespace(user, '/user')
api.add_namespace(goal, '/goal')

if __name__ == "__main__":
    app.run(debug=True, host='0.0.0.0', port=5000)