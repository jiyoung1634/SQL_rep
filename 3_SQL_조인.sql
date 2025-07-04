-- 관계형 데이터베이스 : 관계연산 - 프로젝션, 셀렉션, 조인

-- 조인의 종류
-- 크로스조인(Cartesian Product) n*m건의 결과셋
-- 이너조인(내부조인, 이퀴조인, 동등조인) 
-- 외부조인(LEFT, RIGHT, FULL OUTER) 
-- 셀프조인(1개의 테이블 * 2번 조인)


USE WNTRADE;
SHOW CREATE TABLE 주문;

-- ANSI SQL (실습)
SELECT *
FROM A
JOIN B
;

-- NON-ANSI SQL (MySQL버전)
SELECT *
FROM A,B
;

-- 크로스조인
SELECT *
FROM 부서
CROSS JOIN 사원
WHERE 이름='이소미';

SELECT *
FROM 부서, 사원
WHERE 이름='이소미';

-- 고객, 제품 크로스조인
SELECT *
FROM 고객, 제품;

-- 내부 조인
-- 가장 일반적인 조인 방식, 두 테이블에서 조건에 만족하는 행만 연결 추출
-- 연결컬럼을 찾아서 맵핑
SELECT 사원번호, 직위, 사원.부서번호, 부서명
FROM 사원
INNER JOIN 부서
ON 사원.부서번호 = 부서.부서번호   -- =을 사용해 같은 컬럼명 기준으로 JOIN
WHERE 이름='이소미';

-- 주문세부, 제품 제품명을 연결
SELECT 주문번호, 주문세부.제품번호, 제품.제품명
FROM 주문세부
INNER JOIN 제품
ON 주문세부.제품번호 = 제품.제품번호;

-- 고객, 주문
SELECT 고객.고객번호, 담당자명, 고객회사명, COUNT(*) AS 주문건수
FROM 고객
INNER JOIN 주문
ON 고객.고객번호 = 주문.고객번호
GROUP BY 고객.고객번호, 담당자명, 고객회사명
ORDER BY COUNT(*) DESC;

SELECT 고객.고객번호, 담당자명, 고객회사명, SUM(주문수량*단가)AS 주문금액
FROM 고객
INNER JOIN 주문
ON 고객.고객번호 = 주문.고객번호
INNER JOIN 주문세부
ON 주문.주문번호 = 주문세부.주문번호
GROUP BY 고객.고객번호, 담당자명, 고객회사명
ORDER BY 주문금액 DESC;

-- 고객 X 마일리지등급
SELECT 고객번호, 담당자명, 마일리지, 마일리지등급.*
FROM 고객
CROSS JOIN 마일리지등급
ON 마일리지 >= 하한마일리지 AND 마일리지 <= 상한마일리지
-- ON 마일리지 BETWEEN 하한마일리지 AND 상한마일리지 라고 써도 된다
WHERE 담당자명='이은광';

-- 카테지안 프로덕트 : 범위성 테이블과 나올수 있는 모든 조합을 확인
-- 내부조인 : 연결(컬럼)된 테이블에서 매핑된 행의 컬럼을 가져올 때
-- 외부조인 : 기준 테이블의 결과를 유지하면서 맵핑된 컬럼을 가져오려 할 때

-- 외부조인
-- LEFT, RIGHT, 양쪽 다 (MySQL은 지원 X)
-- 부서, 사원
SELECT 사원번호, 이름, 부서명
FROM 사원
LEFT JOIN 부서
ON 사원.부서번호 = 부서.부서번호;

SELECT * FROM 고객;   -- 93
SELECT * FROM 주문;   -- 830
SELECT * FROM 주문세부;   -- 1000
SELECT * FROM 부서;   -- 4
SELECT * FROM 사원;   -- 10
SELECT * FROM 마일리지등급;   -- 5
-- 고객, 주문번호, 주문금액
SELECT 고객.고객번호, 주문.주문번호, 제품번호, (단가*주문수량) AS 주문금액
FROM 고객
LEFT JOIN 주문
ON 고객.고객번호 = 주문.고객번호
LEFT JOIN 주문세부
ON 주문.주문번호 = 주문세부.주문번호;

-- 사원이 없는 부서
SELECT 부서명, 사원번호, 이름, 부서.부서번호
FROM 부서
LEFT JOIN 사원
ON 부서.부서번호 = 사원.부서번호
WHERE 사원.부서번호 IS NULL;
-- 교재 정답
-- 사원이 없는 부서
SELECT 부서명, 사원.*
FROM 부서
LEFT JOIN 사원
ON 부서.부서번호 = 사원.부서번호;
--
SELECT 사원번호, 직위, 사원.부서번호, 부서명
FROM 사원
LEFT JOIN 부서
ON 사원.부서번호 = 부서.부서번호
UNION
SELECT 사원번호, 직위, 사원.부서번호, 부서명
FROM 사원
RIGHT JOIN 부서
ON 사원.부서번호 = 부서.부서번호;

-- 주문, 고객 FULL OUTER JOIN
SELECT *
FROM 주문
LEFT JOIN 고객
ON 주문.고객번호 = 고객.고객번호
UNION
SELECT *
FROM 주문
RIGHT JOIN 고객
ON 주문.고객번호 = 고객.고객번호;

-- 등급이 할당되지 않는 고객
SELECT 고객회사명, 등급명
FROM 고객
LEFT JOIN 마일리지등급
ON 마일리지 BETWEEN 하한마일리지 AND 상한마일리지;   -- 등급이 할당되지 않은 고객이 없어서 93개 결과가 다 나옴

-- 셀프조인, 내부조인
SELECT 사원.이름, 사원.직위, 상사.이름
FROM 사원
INNER JOIN 사원 AS 상사
ON 사원.상사번호 = 상사.사원번호;

-- 외부조인+셀프조인
SELECT 사원.이름, 사원.직위, 상사.이름
FROM 사원 AS 상사
RIGHT OUTER JOIN 사원 
ON 사원.상사번호 = 상사.사원번호
ORDER BY 상사.이름;

-- 주문, 고객 FULL OUTER JOIN
SELECT *
FROM 주문
LEFT JOIN 고객
ON 주문.고객번호 = 고객.고객번호
UNION
SELECT *
FROM 주문
RIGHT JOIN 고객
ON 주문.고객번호 = 고객.고객번호;

SELECT * FROM 사원;
-- 입사일이 빠른 선배-후배 관계 찾기
SELECT 선배.이름, 선배.직위, 선배.성별, 선배.입사일, 후배.이름, 후배.직위, 후배.성별, 후배.입사일
FROM 사원 AS 선배
RIGHT OUTER JOIN 사원 AS 후배
ON 선배.입사일 < 후배.입사일;

SELECT * FROM 고객;   -- 93
SELECT * FROM 주문;   -- 830
SELECT * FROM 주문세부;   -- 1000
SELECT * FROM 부서;   -- 4
SELECT * FROM 사원;   -- 10
SELECT * FROM 마일리지등급;   -- 5
SELECT * FROM 제품;   -- 78
-- 점검 문제
-- 제품별로 주문수량합, 주문금액 합
SELECT 주문세부.제품번호, SUM(주문수량) AS 주문수량합, SUM(주문세부.단가*주문수량) AS 주문금액
FROM 주문세부
INNER JOIN 제품
ON 주문세부.제품번호 = 제품.제품번호
GROUP BY 주문세부.제품번호;

-- 아이스크림 제품의 주문연도, 제품명 별 주문수량 합
SELECT 제품.제품명, YEAR(주문.주문일) AS 주문연도, SUM(주문세부.주문수량) AS 주문수량합
FROM 주문세부
JOIN 제품
ON 주문세부.제품번호 = 제품.제품번호
JOIN 주문
ON 주문.주문번호 = 주문세부.주문번호
WHERE 제품.제품명 LIKE '%아이스크림%'
GROUP BY 주문연도, 제품.제품명;

-- 주문이 한번도 안된 제품도 포함한 제품별로 수문수량합, 주문금액 합
SELECT 제품.제품번호, 제품.제품명
, SUM(주문세부.주문수량) AS 주문수량합
, SUM(주문세부.단가*주문수량) AS 주문금액
FROM 제품
LEFT JOIN 주문세부
ON 주문세부.제품번호 = 제품.제품번호
GROUP BY 제품.제품번호;

SELECT * FROM 고객;   -- 93
SELECT * FROM 주문;   -- 830
SELECT * FROM 주문세부;   -- 1000
SELECT * FROM 부서;   -- 4
SELECT * FROM 사원;   -- 10
SELECT * FROM 마일리지등급;   -- 5
SELECT * FROM 제품;   -- 78
-- 고객 회사 중 마일리지 등급이 'A'인 고객의 정보(고객번호, 담당자명, 고객회사명, 등급명, 마일리지)
SELECT 고객번호, 담당자명, 고객회사명, 마일리지, 마일리지등급.등급명
FROM 고객
CROSS JOIN 마일리지등급
ON 마일리지등급.등급명 = 'A';


