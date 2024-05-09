from flask import request
from flask_restx import Resource, Api, Namespace
from datetime import datetime
from model import db,User,Goal,Record
import json
import hashlib
class UserApi(Resource):
    def Info(phone_uid,data=None):

        # 해시
        phone_uid = hashlib.sha256(phone_uid.encode()).hexdigest()
        result = User.query.filter(User.phone_uid == phone_uid).first()

        if result:
            try:
                UserApi.LastTime('user',result.uid)

                response = {
                        'uid': result.uid,
                        'set_startday': result.set_startday,
                        'set_language': result.set_language,
                        'set_dateorrepeat': result.set_dateorrepeat,
                        'set_calendarstate': result.set_calendarstate
                    }
                
                if hasattr(result,'version'):
                    response['version'] = result.version
                
                if hasattr(result,'last_time'):
                    response['last_time'] = datetime.strftime(result.last_time,"%Y-%m-%d %H:%M:%S")

                return {
                    'code': '00',
                    'message': '조회성공',
                    'data': response
                }, 00
            except Exception as e:
                 return {
                    'code': '99',
                    'message': e
                }, 99
            
        else:
            try:
                user = User(phone_uid=phone_uid,version=data['version'])
                db.session.add(user)
                db.session.commit()
                result = User.query.filter(User.phone_uid == phone_uid).first()
                UserApi.LastTime('user',result.uid)

                response = {
                        'uid': result.uid,
                        'set_startday': result.set_startday,
                        'set_language': result.set_language,
                        'set_dateorrepeat': result.set_dateorrepeat,
                        'set_calendarstate': result.set_calendarstate
                    }
                if hasattr(result,'version'):
                    response['version'] = result.version
                
                if hasattr(result,'last_time'):
                    response['last_time'] = datetime.strftime(result.last_time,"%Y-%m-%d %H:%M:%S")

                return {
                    'code': '00',
                    'message': '입력성공',
                    'data': response
                }, 00
            except Exception as e:
                db.session.rollback()
                return {
                    'code': '99',
                    'message': e
                }, 99

    def Set(data):
        result = User.query.filter(User.uid == data['uid']).first()

        if result:
            try:
                UserApi.LastTime('user',result.uid)
                for k,v in data.items():
                    setattr(result, k, v)
                db.session.commit()
                return {
                    'code': '00',
                    'message': '수정에 성공했습니다.'
                }, 00
            except Exception as e:
                db.session.rollback()
                return {
                    'code': '99',
                    'message': e
                }, 99
        else: 
           return {
                'code': '99',
                'message': '조회된 데이터가 없습니다.'
            }, 99
        
    def LastTime(table,uid):
        try:
            if table == 'record':
                LTresult = db.session.query(Goal.user_uid).filter(Record.goal_uid == Goal.uid, Record.uid == uid).first()
                uid = LTresult.user_uid
            elif table == 'goal':
                LTresult = db.session.query(Goal.user_uid).filter(Goal.uid == uid).first()
                uid = LTresult.user_uid
            
            LTresult = User.query.filter(User.uid == uid).first()
            setattr(LTresult, 'last_time', datetime.now())
            db.session.commit()

        except Exception as e:
            db.session.rollback()