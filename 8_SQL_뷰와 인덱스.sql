USE WNTRADE;
CREATE OR REPLACE VIEW VIEW_사원_여
AS
SELECT 사원번호, 이름, 집전화 AS 전화번호, 입사일, 주소, 성별
FROM 사원
WHERE 성별 = '여'
WITH CHECK OPTION;

SELECT * FROM VIEW_사원_여;

CREATE OR REPLACE VIEW VIEW_제품별주문수량합
AS
SELECT 제품명, SUM(주문수량) AS 주문수량합
FROM 제품
INNER JOIN 주문세부
ON 제품.제품번호 = 주문세부.제품번호
GROUP BY 제품명;

SELECT * FROM VIEW_제품별주문수량합;
DESCRIBE VIEW_제품별주문수량합;
SHOW CREATE VIEW VIEW_제품별주문수량합;


INSERT INTO VIEW_사원_여(사원번호, 이름, 전화번호, 입사일, 주소 , 성별)
VALUES('E12', '황여름','(02)587-4989','2023-02-10','서울시 강남구 청담동 23-5','여');

SELECT * FROM 사원;

INSERT INTO VIEW_사원_여(사원번호, 이름, 입사일, 주소, 성별)
VALUES('E13', '강겨울', '2023-02-10', '서울시 성북구 장위동 123-7', '남');   -- ERROR

INSERT INTO VIEW_사원_여(사원번호, 이름, 성별)
VALUES('E14', '유봄', '남');   -- ERROR



INSERT INTO VIEW_제품별주문수량합
VALUES('단짠 새우깡', 250);   -- ERROR


-- 뷰 : 가상의 테이블, 데이터 복제X, 쿼리만 저장 -> CREATE, ALTER DROP, SELECT
-- WITH CHECK OPTION

-- 인덱스
-- 기본 인덱스(1 PK) + 보조 인덱스(0, 1, ... , N개)
-- 복합인덱스 : 2개 이상의 컬럼으로 구성. AND로 연결. %로 시작하면 X
USE 분석실습;
SELECT * FROM SALES;
SELECT * FROM CUSTOMER;

-- 국가별/상품별 총 판매량 뷰 생성
CREATE OR REPLACE VIEW VIEW_SALES_SUMMARY AS
SELECT COUNTRY, STOCKCODE
, SUM(QUANTITY) AS TOTAL_QUANTITY
, SUM(QUANTITY * UNITPRICE) AS TOTAL_SALES
FROM SALES
GROUP BY COUNTRY, STOCKCODE;

SELECT * FROM VIEW_SALES_SUMMARY;

-- 뷰 조회
SELECT *
FROM VIEW_SALES_SUMMARY
WHERE COUNTRY = 'UNITED KINGDOM';

SHOW INDEX FROM SALES;

-- 고객 ID, 인보이스 날짜 기준으로 자주 조회 시 성능 향상
CREATE INDEX IDX_CUSTOMER_DATE ON SALES (CUSTOMERID, INVOICEDATE);   -- 인덱스 생성(복합인덱스)

EXPLAIN ANALYZE
SELECT * FROM SALES
WHERE CUSTOMERID = 17850 AND INVOICEDATE >= '2010-12-01';

ALTER TABLE SALES DROP INDEX IDX_CUSTOMER_DATE;   -- 인덱스 삭제

EXPLAIN ANALYZE
SELECT * FROM SALES;

CREATE INDEX IDX_CUSTOMER_DATE ON SALES (CUSTOMERID, INVOICEDATE);
EXPLAIN ANALYZE
SELECT * FROM SALES
WHERE CUSTOMERID LIKE '%17850' AND INVOICEDATE >= '2010-12-01';   -- %의 경우


CREATE TABLE 날씨
(
년도 INT
, 월 INT
, 일 INT
, 도시 VARCHAR(20)
, 기온 NUMERIC(3,1)
, 습도 INT
, PRIMARY KEY(년도, 월, 일, 도시)
, INDEX 기온인덱스(기온)
, INDEX 도시인덱스(도시)
);


use 분석실습;

SELECT *
FROM sales
WHERE Quantity BETWEEN 8 AND 9; -- 0.015sec, 0.016

-- 수량 인덱스
CREATE INDEX idx_quantity ON sales(Quantity);

ALTER TABLE sales DROP INDEX idx_quantity;

-- 또는 단가 인덱스
CREATE INDEX idx_unitprice ON sales(UnitPrice);

EXPLAIN analyze
SELECT *
FROM sales
WHERE Quantity BETWEEN 8 AND 9;

EXPLAIN
SELECT *
FROM sales FORCE INDEX (idx_quantity)
WHERE Quantity BETWEEN 5 AND 10;

EXPLAIN
SELECT /+ INDEX(sales idx_quantity)/ Quantity
FROM sales
WHERE Quantity BETWEEN 5 AND 10;