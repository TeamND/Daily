from flask import request
from flask_restx import Resource, Api, Namespace
from model import db,User

user = Namespace('user')

@user.route('/info/<string:phone_uid>')
class Info(Resource):
    def get(self,phone_uid):
        result = User.query.filter(User.phone_uid == phone_uid).first()
        
        if result:
            try:
                return {
                    'code': '00',
                    'message': '조회성공',
                    'data': {
                        'uid': result.uid,
                        'set_startday': result.set_startday,
                        'set_language': result.set_language,
                        'set_dateorrepeat': result.set_dateorrepeat
                    }
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

@user.route('/set',methods=['POST'])
class Set(Resource):
    def post(self):
        request_data = request.form
        result = User.query.filter(User.uid == request_data['uid']).first()
    
        if result:
            try:
                for k,v in request_data.items():
                    setattr(result, k, v)
                db.session.commit()
                return {
                    'code': '00',
                    'message': '수정에 성공했습니다.'
                }
            except:
                return {
                    'code': '99',
                    'message': '확인되지않은 이유로 수정에 실패했습니다.'
                }
        else: 
           return {
                'code': '99',
                'message': '조회된 데이터가 없습니다.'
            }
        