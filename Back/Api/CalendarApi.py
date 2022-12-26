from flask import request
from flask_restx import Resource, Api, Namespace
from sqlalchemy import extract,func
from model import db,Goal,Record
import datetime
import json

class CalendarApi(Resource):
    def Week():
        print('h')
        
    def Month(uid,data):
        try:
            date = data['date'] if 'date' in data else datetime.datetime.today()
            
            # join
            join = db.session.query(func.to_char(Record.date, 'YYYY-mm-dd'), Goal.symbol, Record.issuccess)\
                    .filter(Record.goal_uid==Goal.uid, Goal.user_uid == uid, extract('year', Record.date) == date[0:4], extract('month', Record.date) == date[5:7])\
                    .order_by(Record.date,Record.order).all()
            
            # 데이터 가공
            result = {}
            for k in join:
                
                if k[0] not in result:
                    count = 0
                    issuccess = 0
                    result[k[0]] = {'symbol':[{k[1]:k[2]}]}
                else:
                    result[k[0]]['symbol'].append({k[1]:k[2]})
                    
                count += 1
                if k[2] is True:
                    issuccess += 1
                    
                result[k[0]]['rating'] = round(issuccess/count,2)
            
            return {
                'code': '00',
                'message': '목표달성을 업데이트했습니다.',
                'data': result
            }, 00
        except Exception as e:
            return {
                'code': '99',
                'message': e
            }, 99
        
    def Year(uid,data):
        try:
            date = data['date'] if 'date' in data else datetime.datetime.today()
            
            # join
            join = db.session.query(func.to_char(Record.date, 'YYYY-mm-dd'),Record.issuccess, func.count(Record.issuccess))\
                    .filter(Record.goal_uid==Goal.uid, Goal.user_uid == uid, extract('year', Record.date) == date[0:4])\
                    .group_by(Record.date,Record.issuccess).order_by(Record.date).all()
            
            print(join)
            
            # 데이터 가공
            result = {}
            for k in join:
                
                # 목표가 성공 실패 둘다 있는경우
                if k[0] in result:
                    result[k[0]] = round(k[2] / (k[2] + temp), 2)
                
                # 목표가 성공 실패중 한가지인 경우
                else:
                    if result is True:
                        result[k[0]] = 1
                    else:
                        result[k[0]] = 0
                        temp = k[2]
           
            return {
                'code': '00',
                'message': '목표달성을 업데이트했습니다.',
                'data': result
            }, 00
        except Exception as e:
            return {
                'code': '99',
                'message': e
            }, 99