from flask import request
from flask_restx import Resource, Api, Namespace
from Api.UserApi import UserApi

user = Namespace(
    name="User",
    description="사용자를 위해 사용하는 API",
)

@user.route('/info/<string:phone_uid>')
class Info(Resource):
    @user.doc(responses={00: 'Success'})
    @user.doc(responses={99: 'Failed'})
    def get(self,phone_uid):
        return UserApi.Info(phone_uid)
    
@user.route('/set',methods=['POST'])
class Set(Resource):
    @user.doc(params={'user_uid': '사용자 고유번호'})
    @user.doc(responses={00: 'Success'})
    @user.doc(responses={99: 'Failed'})
    def post(self):
        return UserApi.Set(request.form)