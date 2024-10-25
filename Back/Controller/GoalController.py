from flask import request
from flask_restx import Resource, Api, Namespace, reqparse, fields
from Api.GoalApi import GoalApi
import json
# import yaml

goal = Namespace(
    name="Goal",
    description="목표를 만들기 위해 사용하는 API",
)

model = goal.model('Goal', strict=True, model={
    'user_uid': fields.Integer,
    'content': fields.String,
    'symbol': fields.String,
    'start_date': fields.String,
    'end_date': fields.String,
    'cycle_type': fields.String,
    'cycle_date': fields.String,
    'type': fields.String,
    'goal_count': fields.String,
    'goal_time': fields.String,
    'is_set_time': fields.Boolean,
})

timer_model = goal.model('Timer',model={
    'start_time': fields.DateTime
})

count_model = goal.model('Count',model={
    'record_count': fields.Integer,
    'issuccess': fields.Boolean
})

goal_column = reqparse.RequestParser()
goal_column.add_argument('user_uid', type=int, default=None, help='사용자 고유번호',required=True)
goal_column.add_argument('content', type=str, default='', help='내용', required=True)
goal_column.add_argument('symbol', type=str, default='운동', help='심볼')
goal_column.add_argument('start_date', type=str, default='now()', help='시작일')
goal_column.add_argument('end_date', type=str, help='종료일')
goal_column.add_argument('cycle_type', type=str, default='date', help='날짜/반복 선택')
goal_column.add_argument('cycle_date', type=list, help='날짜/반복 일')
goal_column.add_argument('type', type=str, default='check', help='횟수/시간 선택')
goal_column.add_argument('goal_count', type=str, default='1', help='목표 횟수')
goal_column.add_argument('goal_time', type=str, default='1M', help='목표 시간')
goal_column.add_argument('is_set_time', type=bool, default=False, help='시간 설정')
@goal.route('/',methods=['POST'])
class GoalCreate(Resource):
    @goal.expect(goal_column)
    @goal.doc(responses={00: 'Success'})
    @goal.doc(responses={99: 'Failed'})
    def post(self):
        '''목표를 추가한다.'''
        data_list = request.form.copy()
        for data in data_list:
            data = json.loads(data)
        return GoalApi.Create(data)
    
@goal.route('/<int:uid>')
class GoalRUD(Resource):
    @goal.response(00,'Success',model)
    @goal.response(99,'Failed')
    def get(self,uid):
        '''목표를 조회한다.'''
        return GoalApi.Read(uid)
    
    @goal.doc(responses={00: 'Success'})
    @goal.doc(responses={99: 'Failed'})
    def put(self,uid):
        '''목표를 수정한다.'''
        data = request.get_data()
        data = data.decode('UTF-8')
        data = json.loads(data)
        return GoalApi.Update(uid,data)
    
    @goal.doc(responses={00: 'Success'})
    @goal.doc(responses={99: 'Failed'})    
    def delete(self,uid):
        '''목표를 삭제한다.'''
        return GoalApi.Delete(uid)
    
@goal.route('/timer/<int:record_uid>')
class GoalTimer(Resource):
    
    @goal.response(00,'Success',timer_model)
    @goal.doc(responses={99: 'Failed'})  
    def put(self,record_uid):
        '''목표의 타이머를 시작한다.'''
        data = request.get_data()
        data = data.decode('UTF-8')
        data = json.loads(data)
        return GoalApi.Timer(record_uid,data)    

@goal.route('/count/<int:record_uid>')
class GoalCount(Resource):
    
    @goal.response(00,'Success',count_model)
    @goal.doc(responses={99: 'Failed'})  
    def put(self,record_uid):
        '''목표의 달성을 추가한다.'''
        return GoalApi.Count(record_uid,request.args)

@goal.route('/removeRecordAll/<int:goal_uid>')
class RemoveRecordAll(Resource):
    
    @goal.doc(responses={00: 'Success'})
    @goal.doc(responses={99: 'Failed'})  
    def delete(self,goal_uid):
        '''기록의 일괄 삭제 한다.'''
        return GoalApi.RemoveRecordAll(goal_uid)
    
@goal.route('/separateGoal/<int:record_uid>')
class SeparateGoal(Resource):
    
    @goal.doc(responses={00: 'Success'})
    @goal.doc(responses={99: 'Failed'})  
    def put(self,record_uid):
        '''기록의 목표를 변경 한다.'''
        data = request.get_data()
        data = data.decode('UTF-8')
        data = json.loads(data)
        return GoalApi.SeparateGoal(record_uid,data)