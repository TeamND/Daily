from flask import request
from flask_restx import Resource, Api, Namespace
from model import db,Goal

goal = Namespace('goal')

@goal.route('/',methods=['POST'])
class GoalCreate(Resource):
    def post(self):
        response = request.form
        try:
            for k,v in response.items():
                goal = setattr(Goal, k, v)
            db.session.add(goal)
            db.session.commit()
            return {
                'code': '00',
                'message': '수정에 성공했습니다.'
            }
        except:
            return {
                'code': '99',
                'message': '확인되지않은 이유로 추가에 실패했습니다.'
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
                
            except:
                    return {
                    'code': '99',
                    'message': '알수없는 이유로 추가에 실패했습니다'
                }
        else:
            return {
                'code': '99',
                'message': '조회실패'
            }
    def put(self):
        return {'put'}
    def delete(self):
        return {'delete'}