# Travis CI & Elasticbeanstalk 배포 테스트

## Travis CI 구성

### 구성이슈

- CI Build Queued hang 이슈
  - 강의에 나온 <https://travis-ci.org> 를 사용시에 Queued 상태로(hanged) 오랫동안 머물러 있다.
  - yml 구문을 수정 후 build 가 되긴 하지만 거의 한시간이 지난 후 완료가 됨
  - travis-ci.com 에서 빌드 및 배포하는걸 권장
  - 기존 .travis.yml 구문을 수정하고 travis-ci.org => travis-ci.com 으로 변경하고 해결함
    - 기존 .travis.yml 을 수정함
    - 기존 .travis.yml

      ```yml
      sudo: required

      language: generic

      services:
        - docker

      before_install:
        - echo "start creating an image with dockerfile"
        - docker build -t chane81/docker-react-app -f Dockerfile.dev .

      script:
        - docker run -e CI=true chane81/docker-react-app npm run test -- --coverage

      after_success:
        - echo "Test Success!"
      ```

    - 변경 .travis.yml

      ```yml
      os: linux

      language: generic

      dist: xenial

      services:
        - docker

      before_install:
        - echo "start creating an image with dockerfile"
        - docker build -t chane81/docker-react-app -f Dockerfile.dev .

      script:
        - docker run -e CI=true chane81/docker-react-app npm run test -- --coverage

      after_success:
        - echo "Test Success!"

      deploy:
        provider: elasticbeanstalk
        region: "ap-northeast-2"
        app: "docker-react-app-v2"
        env: "DockerReactAppV2-env"
        bucket_name: "elasticbeanstalk-ap-northeast-2-611302950754"
        on:
          branch: master

        access_key_id: $AWS_ACCESS_KEY
        secret_access_key: $AWS_SECRET_KEY
      ```

- deploy 구성의 aws 키 명 이슈
  - AWS-SECRET-KEY 이름처럼 중간에 바(-)의 형태로 Environment 변수명을 지었을 때 오류가 난다.
  - AWS_SECRET_KEY 라는 언더바(_) 형식으로 Environment 변수명을 지어 주어야 오류가 나지 않는다.

## AWS 구성

### Elasticbeanstalk 생성

- 애플리케이션 이름
  - <원하는 이름>
- 애플리케이션 태그
  - 옵션적임(태그 그룹으로 관리하고자 한다면 생성)
- 플랫폼
  - Docker
- 플랫폼 브랜치
  - `싱글컨테이너의 경우`
    - `Docker running on 64bit Amazon Linux`
  - `멀티컨테이너의 경우`
    - `Multi-container Docker running on 64bit Amazon Linux`
  - 플랫폼 버전
    - 디폴트 선택
- 애플리케이션 코드
  - 샘플 애플리케이션
