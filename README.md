# docker-개발환경

## react 파일 실시간 변화감지

- docker 의 volumn 옵션을 이용한 파일 맵핍을 하여도 파일변화시에 실시간으로 바뀌지 않았다.
- 아래와 같이 docker 시작시 "-e CHOKIDAR_USEPOLLING=true" 옵션을 주어야만 실시간 변화 감지하여 화면에 보여준다.
  - docker run -it -e CHOKIDAR_USEPOLLING=true
