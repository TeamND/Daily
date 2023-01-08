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
    'symbol': fields.String(title='심볼', default='운동'),
    'start_date': fields.String(title='글 카테고리', default='시작일'),
    'end_date': fields.String(title='글 제목', default='시작일 + 30일'),
    'cycle_type': fields.String(title='날짜/반복 선택', default='date'),
    'cycle_date': fields.String(title='날짜/반복 일'),
    'type': fields.String(title='횟수/시간 선택', default='check'),
    'goal_count': fields.String(title='목표 횟수', default='1'),
    'goal_time': fields.String(title='목표 시간', default='1M'),
})
# @Todo.response(201, 'Success', todo_fields_with_id)
@goal.route('/',methods=['POST'])

class GoalCreate(Resource):
    @goal.expect(model)
    @goal.doc(responses={00: 'Success'})
    @goal.doc(responses={99: 'Failed'})
    def post(self):
        '''목표를 추가한다.'''
        data = request.form
        return GoalApi.Create(data)
    
@goal.route('/<int:uid>')
class GoalRUD(Resource):
    
    @goal.doc(responses={00: 'Success'})
    @goal.doc(responses={99: 'Failed'})
    def get(self,uid):
        '''목표를 조회한다.'''
        return GoalApi.Read(uid)
    
    @goal.doc(responses={00: 'Success'})
    @goal.doc(responses={99: 'Failed'})
    def put(self,uid):
        '''목표를 수정한다.'''
        return GoalApi.Update(uid,request.args)
    
    @goal.doc(responses={00: 'Success'})
    @goal.doc(responses={99: 'Failed'})    
    def delete(self,uid):
        '''목표를 삭제한다.'''
        return GoalApi.Delete(uid)
    
@goal.route('/timer/<int:record_uid>')
class GoalTimer(Resource):
    
    @goal.doc(responses={00: 'Success'})
    @goal.doc(responses={99: 'Failed'})  
    def put(self,record_uid):
        '''목표의 타이머를 시작한다.'''
        return GoalApi.Timer(record_uid,request.args)    

@goal.route('/count/<int:record_uid>')
class GoalCount(Resource):
    
    @goal.doc(responses={00: 'Success'})
    @goal.doc(responses={99: 'Failed'})  
    def put(self,record_uid):
        '''목표의 달성을 추가한다.'''
        return GoalApi.Count(record_uid,request.args)