from flask import request
from flask_restx import Resource, Api, Namespace
from sqlalchemy import extract,func
from model import db,Goal,Record
import datetime
import json

class CalendarApi(Resource):
    def Day(uid,data):
        try:
            date = data['date'] if data.get('date',type=str) is not None else datetime.datetime.now().strftime('%Y-%m-%d')
            
            # join
            join = db.session.query(Record.uid, Record.goal_uid, Goal.content, Goal.symbol, Goal.type, Record.record_time, Goal.goal_time, Record.record_count, Goal.goal_count, Record.start_time, Record.issuccess)\
                        .filter(Record.goal_uid == Goal.uid, Goal.user_uid == uid, Record.date == date)\
                        .order_by(Record.order).all()
            
            # 데이터 가공
            result = []
            for k in join:
                result.append(json.loads(json.dumps(k._mapping,default=str)))

            return {
                'code': '00',
                'message': '조회에 성공했습니다.',
                'data': result
            }, 00
        except Exception as e:
            return {
                'code': '99',
                'message': e
            }, 99
        
    def Week(uid,data):
        try:
            start_date = data['date'] if data.get('date',type=str) is not None else datetime.datetime.now().strftime('%Y-%m-%d')
            start_date = datetime.datetime.strptime(start_date, '%Y-%m-%d')
            end_date = start_date + datetime.timedelta(days=6)
            days = [(start_date + datetime.timedelta(days=i)).strftime("%Y-%m-%d") for i in range((end_date - start_date).days+1)]
           
            # join
            join = db.session.query(func.to_char(Record.date, 'YYYY-mm-dd'), Record.issuccess, func.count(Record.issuccess))\
                    .filter(Record.goal_uid==Goal.uid, Goal.user_uid == uid, Record.date.between(start_date,end_date))\
                    .group_by(Record.date,Record.issuccess).order_by(Record.date).all()
            
            join_result = {}
            for k in join:
                
                # 목표가 성공 실패 둘다 있는경우
                if k[0] in join_result:
                    join_result[k[0]] = round(k[2] / (k[2] + temp), 2)
                    
                # 목표가 성공 실패중 한가지인 경우
                else:
                    if k[1] is True:
                        join_result[k[0]] = 1
                    else:
                        join_result[k[0]] = 0
                        temp = k[2]
            
            # 주간 일달성률 할당        
            result = []
            for day in days:
                if day in join_result.keys():
                    result.append(join_result[day])
                else:
                    result.append(0)
               
            return {
                'code': '00',
                'message': '조회에 성공했습니다.',
                'data': result
            }, 00
        except Exception as e:
            return {
                'code': '99',
                'message': e
            }, 99
        
    def Month(uid,data):
        # try:
            date = data['date'] if data.get('date',type=str) is not None else datetime.datetime.now().strftime('%Y-%m')
            
            # join
            join = db.session.query(func.to_char(Record.date, 'dd'), Goal.symbol, Record.issuccess)\
                    .filter(Record.goal_uid==Goal.uid, Goal.user_uid == uid, extract('year', Record.date) == date[0:4], extract('month', Record.date) == date[5:7])\
                    .order_by(Record.date,Record.order).all()
            
            # 데이터 가공
            result = {}
            for k in join:
                
                if k[0] not in result:
                    count = 0
                    issuccess = 0
                    result[k[0]] = {'symbol':[{"imageName":k[1],"isSuccess":k[2]}]}
                else:
                    result[k[0]]['symbol'].append({"imageName":k[1],"isSuccess":k[2]})
                
                count += 1
                if k[2] is True:
                    issuccess += 1
                    
                result[k[0]]['rating'] = round(issuccess/count,2)
            
            # 4칸 채우기
            for k,v in result.items():
                while len(v['symbol']) < 4:
                    v['symbol'].append({"imageName": "", "isSuccess": False})

            return {
                'code': '00',
                'message': '조회에 성공했습니다.',
                'data': result
            }, 00
        # except Exception as e:
        #     return {
        #         'code': '99',
        #         'message': e
        #     }, 99
        
    def Year(uid,data):
        try:
            date = data['date'] if data.get('date',type=str) is not None else datetime.datetime.now().strftime('%Y')
            
            # join
            join = db.session.query(func.to_char(Record.date, 'mm'), func.to_char(Record.date, 'dd'), Record.issuccess, func.count(Record.issuccess))\
                    .filter(Record.goal_uid==Goal.uid, Goal.user_uid == uid, extract('year', Record.date) == date[0:4])\
                    .group_by(Record.date,Record.issuccess).order_by(Record.date).all()
            
            result = {}
            for k in join:
                
                # 달 할당
                if k[0] not in result:
                    result[k[0]] = {}
                
                # 목표가 성공 실패 둘다 있는경우
                if k[1] in result[k[0]]:
                    result[k[0]][k[1]] = round(k[3] / (k[3] + temp), 2)
                
                # 목표가 성공 실패중 한가지인 경우
                else:
                    if k[2] is True:
                        result[k[0]][k[1]] = 1
                    else:
                        result[k[0]][k[1]] = 0
                        temp = k[3]
                        
            return {
                'code': '00',
                'message': '조회에 성공했습니다.',
                'data': result
            }, 00
        except Exception as e:
            return {
                'code': '99',
                'message': e
            }, 99