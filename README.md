# 🐬 SQL 실습 프로젝트

MySQL을 활용한 SQL 기초 문법부터 연습 문제 해결까지!  
기초 쿼리 작성부터 다양한 조인, 집계 함수, 조건 분기, 날짜 함수 등을 직접 코딩하며 학습한 내용을 정리한 실습 레포지토리입니다.

---

## 📁 폴더 구조  
SQL_rep/ <br>
├── 📄 *.sql              # SQL 실습 SQL 파일들 <br>
├── 📂 data/              # CSV 데이터셋 폴더
│   └── *.csv             # 실습에 사용된 CSV 파일
├── 📂 mig/               # 텍스트 데이터셋 및 추가 자료
│   └── *.txt             # 마이그레이션 관련 데이터 등
└── 📄 README.md          # 프로젝트 설명 파일 


---

## 📚 실습 내용

- **기초 문법 학습**: `SELECT`, `FROM`, `WHERE`, `GROUP BY`, `ORDER BY`, `LIMIT`
- **조건 분기**: `IF`, `CASE`
- **문자열 함수**: `CONCAT()`, `LEFT()`, `RIGHT()`, `SUBSTR()`, `SUBSTRING_INDEX()`
- **날짜 함수**: `CURDATE()`, `NOW()`, `DATE_FORMAT()`, `DATEDIFF()`, `MONTH()`, `DAY()`
- **집계 함수**: `SUM()`, `AVG()`, `COUNT()`, `MAX()`, `MIN()`
- **GROUP BY 확장**: `ROLLUP`, `GROUPING`, `HAVING`
- **다양한 JOIN 실습**:
  - `CROSS JOIN` 
  - `INNER JOIN`
  - `LEFT JOIN`, `RIGHT JOIN`
  - `SELF JOIN`
  - `FULL OUTER JOIN` 대체 방식(`UNION` 활용)
- **서브 쿼리 실습**:
  - `WHERE절`, `FROM절(인라인 뷰)`, `SELECT절(스칼라 서브쿼리)`
- **DML (데이터 조작어)**:
  - `INSERT`, `UPDATE`, `DELETE`
- **DDL (데이터 정의어)**:
  - `CREATE`, `ALTER`, `DROP`

---

## 🧠 실습 예제 주제

- 부서별 최고 급여 사원 찾기
- 부서/직무별 평균 급여
- 커미션을 받는 사원들의 평균 커미션
- 제품별 매출 금액, 주문수량 합계
- 입사일 기준 선배-후배 관계 분석
- 월별 발송 지연건 분석
- 서브쿼리를 활용한 고객별 총주문건수

---

## 💻 환경

- MySQL Workbench
- Git / GitHub
- CSV 파일 기반 실습

---

## 🌱 앞으로의 계획

- 다양한 실무형 SQL 문제 확장
- 실습 내용을 기반으로 한 분석 리포트 작성

---

> 🚀 SQL 실력을 차근차근 키워가는 과정을 담았습니다.  

