# node이미지 빌드
FROM node:24-slim AS build

#작업 디렉토리 생성 및 설정
WORKDIR /app

#현재 위치에 있는 package.json 파일을 /APP 폴더로 이동한고
#dependencies에 있는 라이브러리 설치
COPY package.json ./
RUN npm install

#현재 위치에 있는 파일들을 /APP폴더로 복사
#build 명령어로 React 정적 웹 파일 생성
COPY . .
RUN npm run build

#nginx이미지 빌드
FROM nginx:alpine

#nginx실행시 BACkEND_HOST 환경변수 주입
#ENV BACKEND_HOST=${BACKEND_HOST}

#nginx 설정 탬플릿 파일을  conf.d 폴더로 복사
# default.conf.template 파일은 nginx 설정 파일로, BACKEND_HOST 환경변수를 사용하여 프론트엔드에서 백엔드 API 서버로의 프록시 설정을 포함하고 있음
COPY nginx/default.conf.template /etc/nginx/templates/default.conf.template
#node이미지에서 빌드과정에서 생성된 React정적 폴더 /dist'를 
#nginx이미지의 html폴더로 복사
COPY  --from=build /app/dist /usr/share/nginx/html

#해당 컨테이너의포트를 80으로 설정
EXPOSE 80





