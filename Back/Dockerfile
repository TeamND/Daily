# Base 이미지를 nodeJS alpine 버전으로 사용
FROM node:18.12.0

# 작업 디렉토리 전환
WORKDIR /usr/src/app

# local 컴터에있는  package.json 파일을 현재 워킹 디렉토리에 복사 
COPY package*.json ./

COPY . /usr/src/app

EXPOSE 3000
EXPOSE 5000

RUN npm install
RUN npm install -g nodemon

#ENTRYPOINT ["node"]
CMD ["nodemon","-L","app.js"]
