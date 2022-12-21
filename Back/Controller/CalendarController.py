from flask import request
from flask_restx import Resource, Api, Namespace, fields
from Api.CalendarApi import CalendarApi

calendar = Namespace(
    name="Calendar",
    description="기록를 만들기 위해 사용하는 API",
)

model = calendar.model('기록', strict=True, model={
    'goal_uid': fields.Integer(title='목표 고유번호', required=True),
    'date': fields.String(title='날짜', required=True),
    'order': fields.Integer(title='순서', default=0, required=True),
    'issuccess': fields.String(title='성공여부', default='잡담', required=True),
    'calendar_count': fields.String(title='현재 횟수', default='title', required=True),
    'calendar_time': fields.String(title='성공 시간', default='date', required=True),
    'start_time': fields.String(title='시작 시간'),
})

@calendar.route('/',methods=['POST'])
class CalendarCreate(Resource):
    
    @calendar.doc(params={'user_uid': '사용자 고유번호'})
    @calendar.doc(params={'content': '목표 내용'})
    @calendar.doc(responses={00: 'Success'})
    @calendar.doc(responses={99: 'Failed'})
    def post(self):
        data = request.form
        return CalendarApi.Create(data)
    
@calendar.route('/<int:uid>')
class CalendarRUD(Resource):
    
    @calendar.doc(responses={00: 'Success'})
    @calendar.doc(responses={99: 'Failed'})
    def get(self,uid):
        return CalendarApi.Read(uid)
    
    @calendar.doc(responses={00: 'Success'})
    @calendar.doc(responses={99: 'Failed'})
    def put(self,uid):
        return CalendarApi.Update(uid,request.args)
    
    @calendar.doc(responses={00: 'Success'})
    @calendar.doc(responses={99: 'Failed'})    
    def delete(self,uid):
        return CalendarApi.Delete(uid)