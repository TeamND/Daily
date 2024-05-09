from flask import request
from flask_restx import Resource, Api, Namespace, reqparse
from Api.UserApi import UserApi

user = Namespace(
    name="User",
    description="사용자를 위해 사용하는 API",
)

@user.route('/info/<string:phone_uid>')
class Info(Resource):
    @user.doc(params={'phone_uid': '사용자 고유번호'})
    @user.doc(responses={00: 'Success'})
    @user.doc(responses={99: 'Failed'})
    def get(self,phone_uid):
        '''유저를 확인하고 없으면 등록한다.'''
        return UserApi.Info(phone_uid)

user_column = reqparse.RequestParser()
user_column.add_argument('user_uid', type=int, default=None, help='유저 고유정보',required=True)
user_column.add_argument('set_startday', type=str, default='mon', help='시작 요일')
user_column.add_argument('set_language', type=str, default='korea', help='기본 언어')
user_column.add_argument('set_dateorrepeat', type=str, default='date', help='날짜/반복 여부')
user_column.add_argument('set_calendarstate', type=str, default='week', help='달력주기 표기')

@user.route('/set',methods=['POST'])
class Set(Resource):
    @user.expect(user_column)
    @user.doc(responses={00: 'Success'})
    @user.doc(responses={99: 'Failed'})
    def post(self):
        '''유저의 설정값을 변경한다.'''
        return UserApi.Set(request.form.copy())