from flask import request
from flask_restx import Resource, Api, Namespace
from model import db,User
import json

class UserApi(Resource):
    def Info(phone_uid):
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
                        'set_dateorrepeat': result.set_dateorrepeat,
                        'set_calendarstate': result.set_calendarstate
                    }
                }, 00
            except Exception as e:
                 return {
                    'code': '99',
                    'message': e
                }, 99
            
        else:
            try:
                user = User(phone_uid=phone_uid)
                db.session.add(user)
                db.session.commit()
                result = User.query.filter(User.phone_uid == phone_uid).first()
                
                return {
                    'code': '00',
                    'message': '입력성공',
                    'data': {
                            'uid': result.uid,
                            'set_startday': result.set_startday,
                            'set_language': result.set_language,
                            'set_dateorrepeat': result.set_dateorrepeat,
                            'set_calendarstate': result.set_calendarstate
                    }
                }, 00
            except Exception as e:
                return {
                    'code': '99',
                    'message': e
                }, 99

    def Set(data):
        result = User.query.filter(User.uid == data['uid']).first()
    
        if result:
            try:
                for k,v in data.items():
                    setattr(result, k, v)
                db.session.commit()
                return {
                    'code': '00',
                    'message': '수정에 성공했습니다.'
                }, 00
            except Exception as e:
                return {
                    'code': '99',
                    'message': e
                }, 99
        else: 
           return {
                'code': '99',
                'message': '조회된 데이터가 없습니다.'
            }, 99
        