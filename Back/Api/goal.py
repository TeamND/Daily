from flask import request
from flask_restx import Resource, Api, Namespace
from model import db,Goal

goal = Namespace('goal')

@goal.route('/',methods=['POST'])
class GoalCreate(Resource):
    def post(self):
    
        try:
            query = Goal(**request.form)
            db.session.add(query)
            db.session.commit()
            return {
                'code': '00',
                'message': '추가에 성공했습니다.'
            }
        except Exception as e:
            return {
                'code': '99',
                'message': e
            }
    
@goal.route('/<int:uid>')
class GoalRUD(Resource):
    def get(self,uid):
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
                }
                
            except Exception as e:
                return {
                    'code': '99',
                    'message': e
                }
        else:
            return {
                'code': '99',
                'message': '조회실패'
            }
            
    def put(self,uid):
        request_data = request.args
        result = db.session.get(Goal,uid)
        
        if result:
            try:
                for k,v in request_data.items():
                    setattr(result, k, v)
                db.session.commit()
                return {
                    'code': '00',
                    'message': '수정에 성공했습니다.'
                }
            except Exception as e:
                return {
                    'code': '99',
                    'message': e
                }
        else: 
           return {
                'code': '99',
                'message': '조회된 데이터가 없습니다.'
            }
            
    def delete(self,uid):
        
        try:
            db.session.delete(Goal,uid)
            db.session.commit()
            return {
                'code': '00',
                'message': '삭제에 성공했습니다.'
            }
        except Exception as e:
            return {
                'code': '99',
                'message': e
            }