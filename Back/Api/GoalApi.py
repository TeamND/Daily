from flask import request
from flask_restx import Resource, Api, Namespace
from model import db,Goal,Record
from Api.UserApi import UserApi
import datetime
import json

class GoalApi(Resource):
    # 생성
    def Create(data):
        try:
            # 목포 추가
            if 'uid' in data:
                data.pop('uid')

            if 'cycle_date[]' in data:
                cycle_date = request.form.getlist('cycle_date[]')
                data.pop('cycle_date[]')
                data['cycle_date'] = cycle_date

            if 'is_set_time' in data and data['is_set_time']:
                if data['is_set_time'] == 'true' or data['is_set_time'] == True or data['is_set_time'] == 1:
                    data['is_set_time'] = True 
                else: 
                    data['is_set_time'] = False

            goal_query = Goal(**data)
            db.session.add(goal_query)
            db.session.commit()
            db.session.refresh(goal_query)
            
            # 타입이 반복일 경우
            date_list = []
            
            if 'start_date' in data and data['cycle_type'] == 'repeat':
                
                # 종료날이 없는경우 30일
                date_diff = 30 if 'end_date' not in data else (datetime.datetime.strptime(data['end_date'],'%Y-%m-%d') - datetime.datetime.strptime(data['start_date'],'%Y-%m-%d')).days  

                # 변수할당
                days = ['월', '화', '수', '목', '금', '토', '일']
                startday_index = datetime.date.weekday(datetime.datetime.strptime(data['start_date'],'%Y-%m-%d'))
                
                # 반복요일 계산
                for i in range(date_diff + startday_index):
                    for cycle in list(map(lambda x:days.index(x), data['cycle_date'])):
                        if i % 7 == int(cycle):
                            date_list.append(datetime.datetime.strptime(data['start_date'],'%Y-%m-%d') + datetime.timedelta(days= i - startday_index))
            
            # 반복이 아닌경우
            else:
                date_list = data['cycle_date']
            
            # 데이터 입력    
            for date in date_list:
                user_goal = db.session.query(Goal).filter_by(user_uid=goal_query.user_uid)
                order = user_goal.join(Record, Goal.uid == Record.goal_uid).count()
                db.session.add(Record(goal_uid=goal_query.uid, date=date, order=order))
            db.session.commit()

            return {
                'code': '00',
                'message': '추가에 성공했습니다.'
            }, 00
        except Exception as e:
            db.session.rollback()
            return {
                'code': '99',
                'message': e
            }, 99

    # 조회
    def Read(uid):
        result = db.session.get(Goal,uid)

        if result:
            try:
                data = result.__dict__
                data.pop('_sa_instance_state')
                data['start_date'] = str(data['start_date'])
                data['end_date'] = str(data['end_date'])
                
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

        if 'is_set_time' in data and data['is_set_time']:
                if data['is_set_time'] == 'true' or data['is_set_time'] == True or data['is_set_time'] == 1:
                    data['is_set_time'] = True 
                else: 
                    data['is_set_time'] = False

        result = db.session.get(Goal,uid)
        
        if result:
            try:
                UserApi.LastTime('goal',uid)
                for k,v in data.items():
                    if k == 'goal_count' and (result.type == 'count' or result.type == 'check'):
                        record_list = Record.query.filter_by(goal_uid=uid)
                        if record_list:
                            for record in record_list:
                                record.issuccess = True if record.record_count >= v else False
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
                       
    # 삭제
    def Delete(uid):
        try:
            result = db.session.get(Goal,uid)
            if result:
                UserApi.LastTime('goal',uid)
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
    
    # 목표 타이머 시작      
    def Timer(uid,data):
        result = db.session.get(Record,uid)
        start_time = 0

        if result:
            UserApi.LastTime('record',uid)
            try:
                # 값이 있는 경우 반환 후 초기화
                if result.start_time2:
                    diff = datetime.datetime.strptime(data['start_time'],'%Y-%m-%d %H:%M:%S') - result.start_time2
                    start_time = round(diff.total_seconds())
                    result.record_time += start_time
                    result.start_time2 = None
                # 값 저장
                else:
                    result.start_time2 = data['start_time']
                db.session.commit()
                return {
                    'code': '00',
                    'message': '목표시간 설정에 성공했습니다.',
                    'data': { 'start_time': start_time }
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
            
    # 달성
    def Count(uid,data):
        result = db.session.get(Record,uid)
        
        if result:
            try:
                UserApi.LastTime('record',uid)

                # join
                join = db.session.query(Record.record_count,Goal.goal_count)\
                        .filter(Record.goal_uid==Goal.uid, Record.uid==uid).first()
                
                if join.record_count < join.goal_count:
                    result.record_count += 1
                
                else:
                     return {
                        'code': '99',
                        'message': '더이상 목표달성을 추가할 수 없습니다.'
                    }, 99
                                    
                if result.record_count == join.goal_count:
                    result.issuccess = True
                    
                db.session.commit()  
                
                return {
                    'code': '00',
                    'message': '목표달성을 업데이트했습니다.',
                    'data': { 
                        'record_count': result.record_count,
                        'issuccess': result.issuccess 
                    }
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
