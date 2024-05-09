FROM python:3.9

COPY . /app
WORKDIR /app
RUN pip install -r requirements.txt

#CMD ["python3","-m","flask","run","--host=0.0.0.0","--port=5000"]
#CMD ["gunicorn","app:app","-w","4","--preload","--bind","0.0.0.0:5000","--timeout","600"]
ENV TZ Asia/Seoul
EXPOSE 5000
