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

@calendar.route('/day/<int:uid>')
class CalendarWeek(Resource):

    @calendar.doc(responses={00: 'Success'})
    @calendar.doc(responses={99: 'Failed'})
    def get(self,uid):
        '''달력을 주단위로 조회한다.'''
        data = request.args
        return CalendarApi.Week(uid,data)
    
@calendar.route('/month/<int:uid>')
class CalendarMonth(Resource):
    
    @calendar.doc(responses={00: 'Success'})
    @calendar.doc(responses={99: 'Failed'})
    def get(self,uid):
        '''달력을 월단위로 조회한다.'''
        data = request.args
        return CalendarApi.Month(uid,data)
    
@calendar.route('/year/<int:uid>')
class CalendarYear(Resource):
    
    @calendar.doc(responses={00: 'Success'})
    @calendar.doc(responses={99: 'Failed'})
    def get(self,uid):
        '''달력을 년단위로 조회한다.'''
        data = request.args
        return CalendarApi.Year(uid,data)
