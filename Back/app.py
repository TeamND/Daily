from flask import Flask
from flask_restx import Resource, Api
from config import uri
from model import db
from Controller.UserController import user
from Controller.GoalController import goal
from Controller.RecordController import record
from Controller.CalendarController import calendar
import logging
import os

# 로그 저장 폴더. 없을 시 생성
if not os.path.isdir('logs'):
  os.mkdir('logs')
  
# 3. 기본 설정된 werkzeug 로그 끄기
logging.getLogger('werkzeug').disabled = True

# 4. 저장위치, 레벨, 포맷 세팅
logging.basicConfig(filename = "logs/daily.log", level = logging.DEBUG
                  , datefmt = '%Y/%m/%d %H:%M:%S' 
                  , format = '%(asctime)s:%(levelname)s:%(message)s')

logger = logging.getLogger(__name__)

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
api.add_namespace(record, '/record')
api.add_namespace(calendar, '/calendar')

if __name__ == "__main__":
    app.run(debug=True, host='0.0.0.0', port=5000)