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