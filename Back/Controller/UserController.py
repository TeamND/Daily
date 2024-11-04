from flask import request
from flask_restx import Resource, Api, Namespace, reqparse, fields
from Api.UserApi import UserApi

user = Namespace(
    name="User",
    description="사용자를 위해 사용하는 API",
)
user_model = user.model('User', strict=True, model={
        'uid': fields.Integer,
        'set_startday': fields.Integer,
        'set_language': fields.String,
        'set_dateorrepeat': fields.String,
        'set_calendarstate': fields.String,
        'version': fields.String,
        'last_time': fields.DateTime
})

version_model = user.model('Version', model={
        'isUpdateRequired': fields.Boolean,
})

@user.route('/info/<string:phone_uid>')
class Info(Resource):
    @user.doc(params={'phone_uid': '사용자 고유번호'})
    @user.response(0,'Look up Success',user.model('UserResponse', model={'code': fields.String, 'message': fields.String, "data": fields.Nested(user_model)}))
    @user.response(1,'Insert Success',user.model('UserResponse', model={'code': fields.String, 'message': fields.String, "data": fields.Nested(user_model)}))
    @user.response(99,'Failed')
    def get(self,phone_uid):
        '''유저를 확인하고 없으면 등록한다.'''
        data = request.args
        return UserApi.Info(phone_uid,data)

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
    
version_column = reqparse.RequestParser()
version_column.add_argument('version', type=str, default='1.1.1', help='버전')

@user.route('/version/<int:user_uid>',methods=['GET'])
class Version(Resource):
    @user.doc(params={'user_uid': '사용자 고유번호'})
    @user.expect(version_column)
    @user.response(0,'Success',user.model('VersionResponse', model={'code': fields.String, 'message': fields.String, "data": fields.Nested(version_model)}))
    @user.response(99,'Failed')
    def get(self,user_uid):
        '''유저의 버전값을 확인한다.'''
        data = request.args
        return UserApi.Version(user_uid,data)