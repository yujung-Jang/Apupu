#!/usr/bin/env bash

# bash는 값을 리턴할 수 없으므로 echo로 결과를 출력하여 클라이언트에서 값을 사용한다

# 쉬고 있는 profile 찾기: real1이 사용중이면 real2가 쉬고 있고, 반대면 real1이 쉬고 있음
function find_idle_profile()
{
    # 현재 엔진엑스가 바라보는 스프링 부트의 정상 수행 여부 확인 -> HttpStatus
    RESPONSE_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost/profile)

    if [ ${RESPONSE_CODE} -ge 400 ] # 400 보다 크면 (즉, 40x/50x 에러 모두 포함)
    then
        CURRENT_PROFILE=real2 # 정상적으로 수행 중이지 않을 경우
    else
        CURRENT_PROFILE=$(curl -s http://localhost/profile)
    fi

    if [ ${CURRENT_PROFILE} == real1 ]
    then
      IDLE_PROFILE=real2 # 엔진엑스랑 연결되지 않은 profile
    else
      IDLE_PROFILE=real1
    fi

    echo "${IDLE_PROFILE}" # 마지막에 echo를 통해 출력하여 클라이언트가 값을 사용할 수 있도록 한다
}

# 쉬고 있는 profile의 port 찾기
function find_idle_port()
{
    IDLE_PROFILE=$(find_idle_profile)

    if [ ${IDLE_PROFILE} == real1 ]
    then
      echo "8081"
    else
      echo "8082"
    fi
}