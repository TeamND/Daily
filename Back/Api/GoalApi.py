from flask import request
from flask_restx import Resource, Api, Namespace
from model import db,User,Goal,Record
from Api.UserApi import UserApi
from Api.RecordApi import RecordApi
import datetime
import json

class GoalApi(Resource):
    # 생성
    def Create(data):
        try:
            user = db.session.get(User,data['user_uid'])
            if user:
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

                # 레코드 관련
                issuccess = False
                record_count = 0
                record_time = 0
               
                if 'issuccess' in data:
                    issuccess = data['issuccess']
                    data.pop('issuccess')

                if 'record_time' in data:
                    record_time = data['record_time']
                    data.pop('record_time')

                if 'record_count' in data:
                    record_count = data['record_count']
                    data.pop('record_count')

                goal_query = Goal(**data)
                db.session.add(goal_query)
                db.session.commit()
                db.session.refresh(goal_query)
                
                # 타입이 반복일 경우
                date_list = []
                
                if 'start_date' in data and data['cycle_type'] == 'repeat':
                    # 종료날이 없는경우 30일
                    date_diff = 30 if 'end_date' not in data else (datetime.datetime.strptime(data['end_date'],'%Y%m%d') - datetime.datetime.strptime(data['start_date'],'%Y%m%d')).days  

                    # 변수할당
                    startday_index = datetime.date.weekday(datetime.datetime.strptime(data['start_date'],'%Y%m%d'))
                    
                    # 반복요일 계산
                    for i in range(date_diff + startday_index + 1):
                        for cycle in list(map(lambda x:int(x) - (0 if user.set_startday else 1), data['cycle_date'])):
                            cycle = 6 if cycle == -1 else cycle
                            if i % 7 == int(cycle) and i >= startday_index:
                                date_list.append(datetime.datetime.strptime(data['start_date'],'%Y%m%d') + datetime.timedelta(days= i - startday_index))
                
                # 반복이 아닌경우
                else:
                    date_list = data['cycle_date']
                
                # 데이터 입력    
                for date in date_list:
                    user_goal = db.session.query(Goal).filter_by(user_uid=goal_query.user_uid)
                    order = user_goal.join(Record, Goal.uid == Record.goal_uid).count()
                    db.session.add(Record(goal_uid=goal_query.uid, issuccess=issuccess, record_count=record_count, record_time=record_time, date=date, order=order))
                db.session.commit()

                return {
                    'code': '00',
                    'message': '추가에 성공했습니다.'
                }, 00
            
            else:
                return {
                    'code': '99',
                    'message': '유저에 정보가 없습니다.'
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

                if result.parent_uid != None:
                    goal_list = db.session.query(Goal.uid).filter((Goal.parent_uid == result.parent_uid)|(Goal.uid == result.parent_uid),Goal.user_uid == result.user_uid).all()
                else:
                    goal_list = db.session.query(Goal.uid).filter((Goal.parent_uid == result.uid)|(Goal.uid == result.uid),Goal.user_uid == result.user_uid).all()
                uid_list = [element[0] for element in goal_list]
                Record.query.filter(Record.goal_uid.in_(uid_list)).delete()
                Goal.query.filter(Goal.uid.in_(uid_list)).delete()
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

    # 목표에 해당하는 기록 전체 삭제
    def RemoveRecordAll(uid):
        try:
            result = db.session.get(Goal,uid)
            if result:
                UserApi.LastTime('goal',uid)

                if result.parent_uid != None:
                    goal_list = db.session.query(Goal.uid).filter((Goal.parent_uid == result.parent_uid)|(Goal.uid == result.parent_uid),Goal.user_uid == result.user_uid).all()
                else:
                    goal_list = db.session.query(Goal.uid).filter((Goal.parent_uid == result.uid)|(Goal.uid == result.uid),Goal.user_uid == result.user_uid).all()
                uid_list = [element[0] for element in goal_list]
                Record.query.filter(Record.goal_uid.in_(uid_list), Record.date > datetime.datetime.today()).delete()
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
        
    # 기록의 목표 변경
    def SeparateGoal(uid,data):
        try:
            record = db.session.get(Record,uid)
            if record:
                UserApi.LastTime('goal',uid)
                goal = db.session.get(Goal,data['uid'])

                update_list = ['content','symbol','type','goal_count','goal_time','is_set_time','set_time']

                for update in update_list:
                    if update not in data:
                        data[update] = getattr(goal, update)
                
                data['user_uid'] = getattr(goal,'user_uid')
                data['cycle_type'] = 'repeat'
                data['parent_uid'] = data['uid']          
                data['cycle_date'] = {record.date.strftime("%Y%m%d")}
                data['record_count'] = record.record_count
                data['record_time'] = record.record_time
                data['issuccess'] = record.issuccess

                res = GoalApi.Create(data)
                if res[1] == 99:
                    return {
                    'code': '99',
                    'message': '조회된 데이터가 없습니다.'
                }, 99
                else:
                    RecordApi.Delete(uid)
                    return {
                    'code': '00',
                    'message': '수정에 성공했습니다.'
                }, 0
        except Exception as e:
            db.session.rollback()
            return {
                'code': '99',
                'message': e
            }, 99
        