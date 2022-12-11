from flask import request
from flask_restx import Resource, Api, Namespace
from model import db,Goal

class GoalApi(Resource):
    
    # 생성
    def Create(data):
    
        try:
            query = Goal(**data)
            db.session.add(query)
            db.session.commit()
            return {
                'code': '00',
                'message': '추가에 성공했습니다.'
            }, 00
        except Exception as e:
            return {
                'code': '99',
                'message': e
            }, 99

    # 조회
    def Read(uid):
        result = db.session.get(Goal,uid)
        
        if result:
            data = result.__dict__
            data.pop('_sa_instance_state')
            data['start_date'] = str(data['start_date'])
            data['end_date'] = str(data['end_date'])
            
            try:
                return {
                    'code': '00',
                    'message': '조회성공',
                    'data': data
                }, 00
                
            except Exception as e:
                return {
                    'code': '99',
                    'message': e
                }, 99
        else:
            return {
                'code': '99',
                'message': '조회실패'
            }, 99

    # 수정
    def Update(uid,data):
        
        result = db.session.get(Goal,uid)
        
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
                       
    # 삭제
    def Delete(uid):
        
        try:
            db.session.delete(Goal,uid)
            db.session.commit()
            return {
                'code': '00',
                'message': '삭제에 성공했습니다.'
            }, 00
        except Exception as e:
            return {
                'code': '99',
                'message': e
            }, 99