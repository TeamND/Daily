from flask import request
from flask_restx import Resource, Api, Namespace
from model import db,Goal,Record
import datetime
import json

class CalendarApi(Resource):
    def Read():
        print('h')