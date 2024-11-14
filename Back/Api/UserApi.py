from flask import request,g
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
                if 'appVersion' in data and result.version != data['appVersion']:
                    setattr(result,'version',data['appVersion'])
                    db.session.commit()

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
                    response['last_time'] = datetime.strftime(result.last_time,"%Y-%m-%d %H:%M:%S") if result.last_time else None

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
                version = data['appVersion'] if 'appVersion' in data and data['appVersion'] else None
                user = User(phone_uid=phone_uid,version=version)
                db.session.add(user)
                db.session.commit()
                result = User.query.filter(User.phone_uid == phone_uid).first()

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
                    response['last_time'] = datetime.strftime(result.last_time,"%Y-%m-%d %H:%M:%S") if result.last_time else None

                return {
                    'code': '01',
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

    def Version(version):

        if version:
            try:
                isUpdateRequired = True
                # 유저의 기존버전과 비교(정규식으로 비교?)
                user_version = version.split('.')
                app_version = g.app_version.split('.')
                if user_version[0] >= app_version[0] and user_version[1] >= app_version[1]:
                    isUpdateRequired = False
                return {
                    'code': '00',
                    'message': '조회에 성공했습니다.',
                    'data': {'isUpdateRequired':isUpdateRequired}
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