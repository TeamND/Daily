from flask import request
from flask_restx import Resource, Api, Namespace
from model import db,Goal,Record
import datetime
import json

class GoalApi(Resource):
   
    # 생성
    def Create(data):
        try:
            # 목포 추가
            # goal_data = data.copy()
            # goal_data.pop('date')
            # goal_query = Goal(**data)
            # db.session.add(goal_query)
            # db.session.commit()
            # db.session.refresh(goal_query)
            
            # 날짜 반복계산
            date_list = []
            if data['start_date'] and data['cycle_type'] == 'repeat':
                if data['end_date']:
                    
                    # date string index
                    days = ['월', '화', '수', '목', '금', '토', '일']
                    startday_index = datetime.date.weekday(datetime.datetime.strptime(data['start_date'],'%Y-%m-%d'))
                    
                    for i in range((datetime.datetime.strptime(data['end_date'],'%Y-%m-%d') - datetime.datetime.strptime(data['start_date'],'%Y-%m-%d')).days + startday_index):
                        for cycle in list(map(lambda x:days.index(x), data['cycle_date'].split(','))):
                            if i % 7 == int(cycle):
                                date_list.append(datetime.datetime.strptime(data['start_date'],'%Y-%m-%d') + datetime.timedelta(days= i - startday_index))
            print(date_list)
                        
            # 기록추가
            # date_list = data['cycle_date'].split(',')
            # for date in date_list:
            #     db.session.add(Record(goal_uid = goal_query.uid, date = date))
            # db.session.commit()
            
            # return {
            #     'code': '00',
            #     'message': '추가에 성공했습니다.'
            # }, 00
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