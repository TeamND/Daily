from flask import request
from flask_restx import Resource, Api, Namespace, fields, reqparse
from Api.RecordApi import RecordApi
import json

record = Namespace(
    name="record",
    description="기록를 만들기 위해 사용하는 API",
)

model = record.model('기록', strict=True, model={
    'goal_uid': fields.Integer(title='목표 고유번호', required=True),
    'date': fields.String(title='날짜', required=True),
    'order': fields.Integer(title='순서', default=0, required=True),
    'issuccess': fields.String(title='성공여부', default='잡담', required=True),
    'record_count': fields.String(title='현재 횟수', default='title', required=True),
    'record_time': fields.String(title='성공 시간', default='date', required=True),
    'start_time': fields.String(title='시작 시간'),
})

day_column = reqparse.RequestParser()
day_column.add_argument('date', type=str, default='2024-07-24', help='날짜')

@record.route('/<int:uid>')
class RecordUD(Resource):
    @record.doc(responses={00: 'Success'})
    @record.doc(responses={99: 'Failed'})
    def put(self,uid):
        '''기록을 수정한다.'''
        data = request.get_data()
        data = data.decode('UTF-8')
        data = json.loads(data)
        return RecordApi.Update(uid,data)
    
    @record.doc(responses={00: 'Success'})
    @record.doc(responses={99: 'Failed'})    
    def delete(self,uid):
        '''기록을 삭제한다.'''
        return RecordApi.Delete(uid)
    

@record.route('/deleteAll/<int:goal_uid>')
class DeleteAll(Resource):
    @record.doc(responses={00: 'Success'})
    @record.doc(responses={99: 'Failed'})       
    def delete(self,goal_uid):
        '''기록의 일괄 삭제 한다.'''
        return RecordApi.DeleteAll(goal_uid)    