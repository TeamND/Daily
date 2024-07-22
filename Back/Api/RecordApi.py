from flask import request
from flask_restx import Resource, Api, Namespace
from sqlalchemy import extract,func
from model import db,Goal,Record
from Api.UserApi import UserApi
import datetime

class RecordApi(Resource):
    def Update(uid,data):
        result = db.session.get(Record,uid)
        
        if result:
            UserApi.LastTime('record',uid)
            if 'record_count' in data:
                goal = Goal.query.filter(Goal.uid == result.goal_uid).first()
                data['issuccess'] = True if goal.goal_count == data['record_count'] else False
            
            if 'record_time' in data:
                goal = Goal.query.filter(Goal.uid == result.goal_uid).first()
                data['issuccess'] = True if goal.goal_time <= data['record_time'] else False

            try:
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
        

    def Delete(uid):
        try:
            result = db.session.get(Record,uid)
            if result:
                UserApi.LastTime('record',uid)
                db.session.delete(result)
                db.session.commit()
                return {
                    'code': '00',
                    'message': '삭제에 성공했습니다.'
                }, 00
            else:
                return {
                    'code': '99',
                    'message': '조회된 데이터가 없습니다.'
                }, 99
        except Exception as e:
            db.session.rollback()
            return {
                'code': '99',
                'message': e
            }, 99
        

    # def DeleteAll(uid):
    #     try:
    #         result = db.session.get(Goal,uid)
    #         if result:
    #             UserApi.LastTime('goal',uid)
    #             if result.parent_uid != None:
    #                 goal_list = db.session.query(Goal.uid).filter((Goal.parent_uid == result.parent_uid)|(Goal.uid == result.parent_uid),Goal.user_uid == result.user_uid).all()
    #             else:
    #                 goal_list = db.session.query(Goal.uid).filter((Goal.parent_uid == result.uid)|(Goal.uid == result.uid),Goal.user_uid == result.user_uid).all()
    #             uid_list = [element[0] for element in goal_list]
    #             Record.query.filter(Record.goal_uid.in_(uid_list), Record.date > datetime.datetime.today()).delete()
    #             db.session.commit()
    #             return {
    #                 'code': '00',
    #                 'message': '삭제에 성공했습니다.'
    #             }, 00
    #         else:
    #             return {
    #                 'code': '99',
    #                 'message': '조회된 데이터가 없습니다.'
    #             }, 99
    #     except Exception as e:
    #         db.session.rollback()
    #         return {
    #             'code': '99',
    #             'message': e
    #         }, 99