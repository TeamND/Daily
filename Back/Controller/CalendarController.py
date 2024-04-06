from flask import request
from flask_restx import Resource, Api, Namespace, fields, reqparse
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

day_column = reqparse.RequestParser()
day_column.add_argument('date', type=str, default='2022-12-25', help='날짜')

@calendar.route('/<int:uid>')
class CalendarUD(Resource):
    @calendar.doc(responses={00: 'Success'})
    @calendar.doc(responses={99: 'Failed'})
    def put(self,uid):
        '''기록을 수정한다.'''
        return CalendarApi.Update(uid,request.args)
    
    @calendar.doc(responses={00: 'Success'})
    @calendar.doc(responses={99: 'Failed'})    
    def delete(self,uid):
        '''기록을 삭제한다.'''
        return CalendarApi.Delete(uid)


@calendar.route('/day/<int:user_uid>')
class CalendarDay(Resource):
    @calendar.doc(params={'user_uid': '사용자 고유번호'})
    @calendar.expect(day_column)
    @calendar.doc(responses={00: 'Success'})
    @calendar.doc(responses={99: 'Failed'})
    def get(self,user_uid):
        '''달력을 일단위로 조회한다.'''
        data = request.args
        return CalendarApi.Day(user_uid,data)

@calendar.route('/week/<int:user_uid>')
class CalendarWeek(Resource):
    @calendar.doc(params={'user_uid': '사용자 고유번호'})
    @calendar.expect(day_column)
    @calendar.doc(responses={00: 'Success'})
    @calendar.doc(responses={99: 'Failed'})
    def get(self,user_uid):
        '''달력을 주단위로 조회한다.'''
        data = request.args
        return CalendarApi.Week(user_uid,data)
    
month_column = reqparse.RequestParser()
month_column.add_argument('date', type=str, default='2022-12', help='날짜')

@calendar.route('/month/<int:user_uid>')
class CalendarMonth(Resource):
    @calendar.doc(params={'user_uid': '사용자 고유번호'})
    @calendar.expect(month_column)
    @calendar.doc(responses={00: 'Success'})
    @calendar.doc(responses={99: 'Failed'})
    def get(self,user_uid):
        '''달력을 월단위로 조회한다.'''
        data = request.args
        return CalendarApi.Month(user_uid,data)
    
year_column = reqparse.RequestParser()
year_column.add_argument('date', type=str, default='2022', help='날짜')
    
@calendar.route('/year/<int:user_uid>')
class CalendarYear(Resource):
    @calendar.doc(params={'user_uid': '사용자 고유번호'})
    @calendar.expect(year_column)
    @calendar.doc(responses={00: 'Success'})
    @calendar.doc(responses={99: 'Failed'})
    def get(self,user_uid):
        '''달력을 년단위로 조회한다.'''
        data = request.args
        return CalendarApi.Year(user_uid,data)
