-- SELECT 1개 테이블
-- JOIN 두 개 이상 테이블
-- 서브쿼리 (내부쿼리) 

/*
SELECT *
FROM 고객
INNER JOIN 주문
ON 고객번호
WHERE 

SELECT *
FROM 테이블
WHERE 컬럼 = (서브쿼리)
*/

-- 종류
-- 1. 서브쿼리가 반환하는 행의 갯수 : 단일행, 복수행
-- 2. 서브쿼리의 위치 : 조건절(WHERE), FROM절, SELECT절 가능
-- 3. 상관서브쿼리 : 메인쿼리와 서브쿼리 상관(컬럼)
-- 4.반환하는 컬럼수에 따라 단일컬럼, 다중컬럼 서브쿼리가 있음

SELECT 고객회사명, 담당자명, 마일리지
FROM 고객
WHERE 마일리지 = (
	SELECT MAX(마일리지)
    FROM 고객
);

SELECT A.고객회사명, A.담당자명, A.마일리지
FROM 고객 AS A
LEFT JOIN 고객 AS B
ON A.마일리지 < B.마일리지
WHERE B.고객번호 IS NULL;


SELECT 고객번호
FROM 주문
WHERE 주문번호='H0250';
    
SELECT 고객번호, 고객회사명, 담당자명
FROM 고객
WHERE 고객번호 = (   -- 서브쿼리 단일행, 컬럼1개
	SELECT 고객번호
    FROM 주문
    WHERE 주문번호='H0250'
);

SELECT 고객회사명, 담당자명
FROM 고객
INNER JOIN 주문
ON 고객.고객번호 = 주문.고객번호
WHERE 주문번호 = 'H0250';

SELECT 담당자명, 고객회사명, 마일리지
FROM 고객
WHERE 마일리지 > (
	SELECT MIN(마일리지)
	FROM 고객
	WHERE 도시='부산광역시');
-- WHERE 마일리지 > 806(서브쿼리 실행결과 단일행) 과 같다

-- 복수행 서브쿼리 (서브쿼리의 결과가 여러 행이 나오는 쿼리)
SELECT 고객번호
FROM 고객
WHERE 도시='부산광역시';

SELECT COUNT(*) AS 주문건수
FROM 주문
WHERE 고객번호 IN (   -- 비교연산자 IN : 서브쿼리의 각 결과마다 = 연산자 사용
	SELECT 고객번호
    FROM 고객
    WHERE 도시='부산광역시'
);
-- 복수행 서브쿼리는 IN, ANY, SOME, ALL, EXISTS 연산자를 사용한다

-- ANY
SELECT 담당자명, 고객회사명, 마일리지
FROM 고객
WHERE 마일리지 > ANY (   -- 비교연산자 ANY : 서브쿼리의 각 결과값을 비교연산자로 비교하여 하나 이상 일치하면 참
	SELECT 마일리지
	FROM 고객
	WHERE 도시='부산광역시');
    
-- ANY(=SOME)는 최솟값과 비교 / ALL은 최댓값과 비교 
SELECT 담당자명, 고객회사명, 마일리지
FROM 고객
WHERE 마일리지 > ALL (   -- 비교연산자 ALL : 서브쿼리의 각 결과값을 비교연산자로 비교하여 모두 일치하면 참
	SELECT 마일리지
	FROM 고객
	WHERE 도시='부산광역시');

-- 한번이라도 주문한 적이 있는 고객의 정보
SELECT 고객번호, 고객회사명
FROM 고객
WHERE EXISTS (   -- 비교연산자 EXISTS : 서브쿼리에 비교 조건을 만족하는 결과가 존재하면 참
	SELECT *
    FROM 주문
    WHERE 고객번호 = 고객.고객번호   -- 상관서브쿼리 
);
SELECT 고객번호, 고객회사명
FROM 고객
WHERE 고객번호 IN (
	SELECT DISTINCT 고객번호
    FROM 주문
);
SELECT DISTINCT 고객.고객번호, 고객회사명
FROM 고객
INNER JOIN 주문
ON 고객.고객번호 = 주문.고객번호;

-- 위치 : WHERE에 존재하는 서브쿼리

-- GROUP BY절에 사용하는 서브쿼리
SELECT 도시, AVG(마일리지) AS 평균마일리지
FROM 고객
GROUP BY 도시
HAVING 평균마일리지 > (
	SELECT AVG(마일리지)
    FROM 고객
);

-- FROM절에 사용하는 서브쿼리 : 인라인 뷰(INLINE VIEW)쿼리의 결과를 가상의 테이블로 인식 -> 별명 지정 필수
SELECT 도시, AVG(마일리지) AS 도시_평균마일리지
FROM 고객
GROUP BY 도시;

SELECT 담당자명, 고객회사명, 마일리지
, 고객.도시, 도시_평균마일리지
, 도시_평균마일리지 - 마일리지 AS 마일리지차이
FROM 고객, (   -- 원래는 JOIN문법 적용해야하지만 NON ANSI SQL에서는 ,로 가능
	SELECT 도시, AVG(마일리지) AS 도시_평균마일리지
	FROM 고객
	GROUP BY 도시) AS 도시별요약
WHERE 고객.도시 = 도시별요약.도시;

-- 사원별 상사의 이름 출력을 인라인뷰로 구현
SELECT A.이름 AS 사원명, B.이름 AS 상사명
FROM 사원 AS A
JOIN (
	SELECT 사원번호, 이름
    FROM 사원
) AS B
ON A.상사번호 = B.사원번호;

-- 제품별 총 주문 수량과 재고 비교를 인라인뷰로 구현
SELECT A.제품번호, 제품명, 총주문수량, 재고
FROM 제품 AS A
, (
	SELECT 제품번호, SUM(주문수량) AS 총주문수량
    FROM 주문세부
    GROUP BY 제품번호
) AS B
WHERE A.제품번호 = B.제품번호;
-- 강사님 답
SELECT 제품명, 재고, 주문요약.총주문수량
, (제품.재고 - 주문요약.총주문수량) AS 잔여가능수량
FROM 제품
JOIN (
	SELECT 제품번호, SUM(주문수량) AS 총주문수량
    FROM 주문세부
    GROUP BY 제품번호
) AS 주문요약   -- 제품별 총주문수량 집계 테이블
ON 제품.제품번호 = 주문요약.제품번호;

-- 고객별 가장 최근 주문일 출력
SELECT A.고객번호, 가장최근주문일
FROM 고객 AS A
, (
	SELECT 고객번호, MAX(주문일) AS 가장최근주문일
    FROM 주문
    GROUP BY 고객번호
) AS B
WHERE A.고객번호 = B.고객번호;
-- 강사님 답
SELECT 고객.고객번호, 고객회사명, 최근주문.최근주문일
FROM 고객
JOIN (
	SELECT 고객번호, MAX(주문일) AS 최근주문일
    FROM 주문
    GROUP BY 고객번호
) AS 최근주문
ON 고객.고객번호 = 최근주문.고객번호;

-- 인라인뷰, 조인 : 되도록이면 조인을 추천


-- 스칼라 서브쿼리(SCALAR SUBQUERY) : SELECT문 내에 서브쿼리 사용
SELECT 고객번호, (
	SELECT MAX(주문일)
    FROM 주문
    WHERE 주문.고객번호 = 고객.고객번호
) AS 최근주문일
FROM 고객;

-- 고객별 총주문건수
EXPLAIN ANALYZE
SELECT 고객.고객번호
, (
	SELECT COUNT(주문번호) 
    FROM 주문
    WHERE 주문.고객번호 = 고객.고객번호
) AS 총주문건수
FROM 고객
GROUP BY 고객.고객번호;
-- 조인
EXPLAIN ANALYZE
SELECT 고객.고객번호
     , 고객.담당자명
     , COUNT(주문.주문번호) AS 총주문건수
FROM 고객
LEFT JOIN 주문
  ON 고객.고객번호 = 주문.고객번호
GROUP BY 고객.고객번호, 고객.담당자명;



SELECT * FROM 주문세부;
SELECT * FROM 주문;
SELECT * FROM 제품;
-- 각 제품의 마지막 주문단가
SELECT 주문세부.제품번호, (
	SELECT MAX(주문일) AS 마지막주문
    FROM 주문
    WHERE 주문.주문번호 = 주문세부.주문번호
) AS 마지막주문일
, (
	SELECT 
    FROM 제품
    WHERE 제품.제품번호 = 주문세부.제품번호
    GROUP BY 제품번호
) AS 마지막주문단가

FROM 주문세부;


SELECT * FROM 사원;
-- 각 사원별 최대 주문수량
SELECT 주문.주문번호, (
	SELECT 사원.이름
    FROM 사원
    WHERE 사원.사원번호 = 주문.사원번호
    -- GROUP BY 사원.사원번호
) AS 사원명
, (
	SELECT MAX(주문수량)
    FROM 주문세부
    WHERE 주문세부.주문번호 = 주문.주문번호
    GROUP BY 주문번호
) AS 최대주문수량
FROM 주문;


-- CTE : 임시테이블 정의, 쿼리 1개
WITH 도시요약 AS (
	SELECT 도시, AVG(마일리지) AS 도시평균마일리지
    FROM 고객
    GROUP BY 도시
)

SELECT 담당자명, 고객회사명, 마일리지, 고객.도시
, 도시평균마일리지
FROM 고객
JOIN 도시요약
ON 고객.도시 = 도시요약.도시;


-- 다중 컬럼 서브쿼리
SELECT 고객회사명, 도시, 담당자명, 마일리지
FROM 고객
WHERE (도시, 마일리지) IN (
	SELECT 도시, MAX(마일리지)
    FROM 고객
    GROUP BY 도시
);

SELECT A.고객회사명, A.도시, A.담당자명, A.마일리지
FROM 고객 AS A
JOIN 고객 AS B
ON A.도시 = B.도시
GROUP BY A.고객회사명, A.도시, A.담당자명, A.마일리지
HAVING A.마일리지 = MAX(B.마일리지)
ORDER BY 1;