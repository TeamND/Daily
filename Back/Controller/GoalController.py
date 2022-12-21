from flask import request
from flask_restx import Resource, Api, Namespace, fields
from Api.GoalApi import GoalApi

goal = Namespace(
    name="Goal",
    description="목표를 만들기 위해 사용하는 API",
)

model = goal.model('목표', strict=True, model={
    'user_uid': fields.Integer(title='사용자 고유번호', required=True),
    'content': fields.String(title='내용', required=True),
    'symbol': fields.String(title='심볼', default='운동', required=True),
    'start_date': fields.String(title='글 카테고리', default='잡담', required=True),
    'end_date': fields.String(title='글 제목', default='title', required=True),
    'cycle_type': fields.String(title='날짜/반복 선택', default='date', required=True),
    'cycle_date': fields.String(title='날짜/반복 일'),
    'type': fields.String(title='횟수/시간 선택', default='check', required=True),
    'goal_count': fields.String(title='목표 횟수', default='1'),
    'goal_time': fields.String(title='목표 시간', default='1M'),
})
# @Todo.response(201, 'Success', todo_fields_with_id)
@goal.route('/',methods=['POST'])

class GoalCreate(Resource):
    @goal.doc(params={'user_uid': '사용자 고유번호'})
    @goal.doc(params={'content': '목표 내용'})
    @goal.doc(responses={00: 'Success'})
    @goal.doc(responses={99: 'Failed'})
    def post(self):
        data = request.form
        return GoalApi.Create(data)
    
@goal.route('/<int:uid>')
class GoalRUD(Resource):
    
    @goal.doc(responses={00: 'Success'})
    @goal.doc(responses={99: 'Failed'})
    def get(self,uid):
        return GoalApi.Read(uid)
    
    @goal.doc(responses={00: 'Success'})
    @goal.doc(responses={99: 'Failed'})
    def put(self,uid):
        return GoalApi.Update(uid,request.args)
    
    @goal.doc(responses={00: 'Success'})
    @goal.doc(responses={99: 'Failed'})    
    def delete(self,uid):
        return GoalApi.Delete(uid)
    
@goal.route('/achive/<int:record_uid>')
class GoalAchive(Resource):
    
    @goal.doc(responses={00: 'Success'})
    @goal.doc(responses={99: 'Failed'})  
    def put(self,record_uid):
        return GoalApi.Achieve(record_uid,request.args)