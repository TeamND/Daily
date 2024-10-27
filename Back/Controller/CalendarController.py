from flask import request
from flask_restx import Resource, Api, Namespace, fields, reqparse
from Api.CalendarApi import CalendarApi
import json

calendar = Namespace(
    name="Calendar",
    description="달력 조회를 만들기 위해 사용하는 API",
)

day_model = calendar.model('Day', strict=True, model={
    'uid':fields.Integer(title='고유번호', required=True),
    'goal_uid': fields.Integer(title='목표 고유번호', required=True),
    'content': fields.String(title='내용'),
    'symbol': fields.String(title='심볼'),
    'type': fields.String,
    'record_time': fields.Integer,
    'goal_time': fields.Integer,
    'record_count':fields.Integer,
    'goal_count': fields.Integer,
    'set_time': fields.Boolean,
    'is_set_time': fields.Boolean,
    'cycle_type': fields.String,
    'parent_uid': fields.Integer,
    'issuccess': fields.String(title='성공여부', default='잡담', required=True),
    'start_time': fields.String(title='시작 시간')
})

day_list_model = calendar.model('DayList',model={
    'goalList': fields.List(fields.Nested(day_model))
})

week_model = calendar.model('Week',model={
    'rating': fields.List(fields.Integer),
    'ratingOfWeek': fields.Integer
})

month_model = calendar.model('Month',model={
    'imageName': fields.String,
    'isSuccess': fields.Boolean
})

month_list_model = calendar.model('MonthList',model={
    'symbol': fields.List(fields.Nested(month_model)),
    'rating': fields.Integer
})

widget_model = calendar.model('Widget',model={
    'content': fields.String, 
    'symbol': fields.String, 
    'issuccess': fields.Boolean, 
    'is_set_time': fields.Boolean, 
    'set_time': fields.Boolean
})

widget_list_model = calendar.model('WidgetList',model={
    'rating': fields.Integer,
    'date': fields.String,
    'goalList': fields.List(fields.Nested(widget_model))
})

date_column = reqparse.RequestParser()
date_column.add_argument('date', type=str, default='2024-07-04', help='날짜')

@calendar.route('/<int:uid>')
class CalendarUD(Resource):
    @calendar.doc(responses={00: 'Success'})
    @calendar.doc(responses={99: 'Failed'})
    def put(self,uid):
        '''기록을 수정한다.'''
        data = request.get_data()
        data = data.decode('UTF-8')
        data = json.loads(data)
        return CalendarApi.Update(uid,data)
    
    @calendar.doc(responses={00: 'Success'})
    @calendar.doc(responses={99: 'Failed'})    
    def delete(self,uid):
        '''기록을 삭제한다.'''
        return CalendarApi.Delete(uid)


@calendar.route('/day/<int:user_uid>')
class CalendarDay(Resource):
    @calendar.doc(params={'user_uid': '사용자 고유번호'})
    @calendar.expect(date_column)
    @calendar.response(00,'Success',calendar.model('DayResponse', model={'code': fields.String, 'message': fields.String, "data": fields.Nested(day_list_model)}))
    @calendar.response(99,'Failed')
    def get(self,user_uid):
        '''달력을 일단위로 조회한다.'''
        data = request.args
        return CalendarApi.Day(user_uid,data)

@calendar.route('/week/<int:user_uid>')
class CalendarWeek(Resource):
    @calendar.doc(params={'user_uid': '사용자 고유번호'})
    @calendar.expect(date_column)
    @calendar.response(00,'Success',calendar.model('WeekResponse', model={'code': fields.String, 'message': fields.String, "data": fields.Nested(week_model)}))
    @calendar.response(99,'Failed')
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
    @calendar.response(00,'Success',calendar.model('MonthResponse', model={'code': fields.String, 'message': fields.String, "data": fields.Nested(month_list_model)}))
    @calendar.response(99,'Failed')
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
    @calendar.response(00,'Success',calendar.model('MonthResponse', model={'code': fields.String, 'message': fields.String, "data": fields.List(fields.List(fields.Integer))}))
    @calendar.response(99,'Failed')
    def get(self,user_uid):
        '''달력을 년단위로 조회한다.'''
        data = request.args
        return CalendarApi.Year(user_uid,data)

@calendar.route('/widget/<string:phone_uid>')
class CalendarWidget(Resource):
    @calendar.doc(params={'phone_uid': '폰 고유번호'})
    @calendar.expect(date_column)
    @calendar.response(00,'Success',calendar.model('MonthResponse', model={'code': fields.String, 'message': fields.String, "data": fields.Nested(widget_list_model)}))
    @calendar.response(99,'Failed')
    def get(self,phone_uid):
        '''달력을 일단위로 조회한다.'''
        return CalendarApi.Widget(phone_uid)