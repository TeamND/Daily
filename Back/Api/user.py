from flask import request
from flask_restx import Resource, Api, Namespace
from model import db,User

user = Namespace('user')

@user.route('/info',methods=['POST'])
class TodoPost(Resource):
    def post(self):
        phone_uid = request.form['phone_uid']
        result = User.query.filter(User.phone_uid == phone_uid).first()
        
        if result:
            try:
                return {
                    'code': '00',
                    'message': '조회성공',
                    'data': {'uid': result.uid,'set_startday': result.set_startday,'set_language':result.set_language}
                }
            except:
                 return {
                    'code': '99',
                    'message': '조회실패'
                }
            
        else:
            user = User(phone_uid=phone_uid)
            db.session.add(user)
            db.session.commit()
            
            return {
                'code': '00',
                'message': '입력성공'
            }