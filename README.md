# 인프라 구축 완료 보고서

## 개요

본 보고서는 Rust 기반 API 서버와 PostgreSQL 데이터베이스를 Kubernetes 환경에서 구축한 내용을 담고 있습니다. 전체 인프라는 Terraform과 Helm을 활용하여 구현되었으며, Infrastructure as Code 원칙을 준수하였습니다.

## 인프라 아키텍처

![인프라 구성도](https://placeholder.com/infrastructure.png)

### 주요 구성 요소

1. Kubernetes 클러스터 (Minikube)
   - 단일 노드 클러스터 환경 구성
   - 네임스페이스를 통한 애플리케이션 격리

2. API 서버 (Rust)
   - 상태 확인을 위한 헬스 체크 엔드포인트 구현
   - 데이터베이스 CRUD 작업 구현
   - 컨테이너 자원 관리 설정
   - 안정성을 위한 라이브니스/레디니스 프로브 구성

3. 데이터베이스 (PostgreSQL)
   - 영구 볼륨을 통한 데이터 저장
   - Helm 차트를 통한 배포
   - 보안 인증 정보 설정

## 구현 세부 사항

### 1. 기술 스택

- 컨테이너 오케스트레이션: Kubernetes (Minikube)
- 인프라 프로비저닝: Terraform
- 애플리케이션 배포: Helm
- 데이터베이스: PostgreSQL
- API 서버: Rust (Axum 프레임워크)

### 2. 배포 프로세스

```bash
# 1. Minikube 클러스터 시작
minikube start --driver=docker

# 2. Terraform을 통한 인프라 구성
terraform init
terraform apply

# 3. PostgreSQL 데이터베이스 배포
helm install postgresql bitnami/postgresql \
  --namespace application \
  --set auth.password="postgres" \
  --set auth.database="stclab"

# 4. API 서버 배포
helm install api-service ./api-service --namespace application
```

### 3. 보안 구성

- Kubernetes Secrets를 통한 데이터베이스 인증 정보 관리
- 네임스페이스를 통한 네트워크 격리
- 컨테이너 보안 컨텍스트 설정
- 리소스 제한 및 요청 설정

## 구축 결과 확인

### 1. 리소스 상태

```bash
➜  kubectl get all -n application                                                                                                                                                                           [16:03:33]
NAME                              READY   STATUS    RESTARTS   AGE
pod/api-service-966c546bc-k2cmr   1/1     Running   0          12s
pod/postgresql-0                  1/1     Running   0          21s

NAME                    TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
service/api-service     ClusterIP   10.100.201.120   <none>        8080/TCP   173m
service/postgresql      ClusterIP   10.104.201.69    <none>        5432/TCP   21s
service/postgresql-hl   ClusterIP   None             <none>        5432/TCP   21s

NAME                          READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/api-service   1/1     1            1           12s

NAME                                    DESIRED   CURRENT   READY   AGE
replicaset.apps/api-service-966c546bc   1         1         1       12s

NAME                          READY   AGE
statefulset.apps/postgresql   1/1     21s
```

[]("~/Pictures/Screenshots/리소스_상태.png")

### 2. 헬스 체크 확인

```bash
➜  curl http://localhost:8080/
{"status":"healthy","timestamp":"2024-12-10T07:08:23.626882784+00:00"}
```

[]("~/Pictures/Screenshots/헬스체크.png/")

### 3. 데이터베이스 연결 확인

```bash

➜  kubectl exec -it postgresql-0 -n application -- psql -U postgres                                                                                                                                         [16:03:45]
Password for user postgres:
psql (17.2)
Type "help" for help.

postgres=# \d
Did not find any relations.
postgres=# \l
                                                     List of databases
   Name    |  Owner   | Encoding | Locale Provider |   Collate   |    Ctype    | Locale | ICU Rules |   Access privileges
-----------+----------+----------+-----------------+-------------+-------------+--------+-----------+-----------------------
 postgres  | postgres | UTF8     | libc            | en_US.UTF-8 | en_US.UTF-8 |        |           |
 stclab    | postgres | UTF8     | libc            | en_US.UTF-8 | en_US.UTF-8 |        |           |
 template0 | postgres | UTF8     | libc            | en_US.UTF-8 | en_US.UTF-8 |        |           | =c/postgres          +
           |          |          |                 |             |             |        |           | postgres=CTc/postgres
 template1 | postgres | UTF8     | libc            | en_US.UTF-8 | en_US.UTF-8 |        |           | =c/postgres          +
           |          |          |                 |             |             |        |           | postgres=CTc/postgres
(4 rows)

postgres=# \q

```

[]("~/Pictures/Screenshots/db_connection.png")

## 구축 완료 체크리스트

✅ Kubernetes 클러스터 정상 동작
✅ PostgreSQL 데이터베이스 배포 및 접근 가능
✅ API 서버 동작 및 헬스 체크 정상
✅ CRUD 작업 구현 완료
✅ Infrastructure as Code 구현
✅ Helm 차트 배포 구성
✅ 보안 설정 완료

## 스크린샷

### 1. Kubernetes 대시보드

[Kubernetes 대시보드 실행 화면]

### 2. API 헬스 체크

[API 헬스 체크 응답 화면]

### 3. 데이터베이스 연결

[데이터베이스 연결 로그 화면]

## 향후 개선 사항

1. 모니터링 시스템 구축
2. 백업 및 복구 전략 수립
3. CI/CD 파이프라인 구축

## 결론

요구사항에 맞춰 인프라 구축을 완료하였으며, 다음 사항들을 성공적으로 구현하였습니다:

- Kubernetes 환경 구성 및 운영
- Infrastructure as Code 적용
- 컨테이너 오케스트레이션
- 데이터베이스 통합
- 애플리케이션 배포 전략

시스템은 추가 모니터링 솔루션 구축 및 보안 강화와 같은 향후 확장에 대비하여 준비되어 있습니다.
