-- SELECT 연산
-- INSERT : INSERT SELECT, INSERT ON DUPLICATE KEY UPDATE
-- UPDATE : UPDATE SELECT, UPDATE JOIN
-- DELETE : DELETE SELECT, DELETE JOIN

-- INSERT
SELECT * FROM 부서;
INSERT INTO 부서
VALUES('A5', '마케팅부');

SELECT * FROM 제품;
INSERT INTO 제품
VALUES(91, '연어피클소스', NULL, 5000, 40);   -- NULL외에 ''(공백) 넣어도 됨

INSERT INTO 제품
VALUES('AA', '피클소스', NULL, 5000, 40);

INSERT INTO 제품(제품번호, 제품명, 단가, 재고)
VALUES(90, '연어핫소스', NULL, 4000, 50);

SELECT * FROM 제품;
SELECT * FROM 사원;
INSERT INTO 사원(사원번호, 이름, 직위, 성별, 입사일)
VALUES('E20', '김사과', '수습사원', '남', CURDATE())
, ('E21', '박사과', '수습사원', '여', CURDATE())
, ('E22', '정사과', '수습사원', '여', CURDATE());

DESCRIBE 사원;
-- UPDATE

UPDATE 사원
SET 이름 = '김레몬'
WHERE 사원번호='E20';

UPDATE 제품
SET 포장단위 = '200 ml bottles'
WHERE 제품번호 = 91;

UPDATE 제품
SET 단가 = 단가 * 1.1
, 재고 = 재고 - 10
WHERE 제품번호 = 91;

-- DELETE
DELETE FROM 제품
WHERE 제품번호 = 91;


  
SELECT * FROM 사원;
DELETE FROM 사원
ORDER BY 입사일 DESC
LIMIT 3;

-- --------------------------------------------- 
INSERT INTO 제품(제품번호, 제품명, 단가, 재고)
VALUES(91, '연어피클핫소스', 6000, 50)
ON DUPLICATE KEY UPDATE
제품명 = '연어피클', 단가=6000, 재고=50;

SELECT * FROM 제품 WHERE 제품번호=91;


CREATE TABLE 고객주문요약
(
고객번호 CHAR(5) PRIMARY KEY
, 고객회사명 VARCHAR(50)
, 주문건수 INT
, 최종주문일 DATE
);

describe 고객주문요약;

select 고객.고객번호, 고객회사명
, count(*) as 주문건수
,max(주문일) as 최종주문일
from 고객 join 주문
on 고객.고객번호 = 주문.고객번호
group by 고객.고객번호, 고객회사명;

select * from 고객주문요약;

update 제품
set 단가 = (select *
from ( select avg(단가)
from 제품
where 제품명 like '%소스%' )
) as t
where 제품번호 = 91;

describe 제품;

-- 예제 7-13번부터
UPDATE 고객
, (
SELECT DISTINCT 고객번호
FROM 주문
) AS 주문고객
SET 마일리지 = 마일리지 * 1.1
WHERE 고객.고객번호 IN (주문고객.고객번호);

SELECT *
FROM 고객
WHERE 고객번호 IN (
SELECT DISTINCT 고객번호
FROM 주문
);

UPDATE 고객
INNER JOIN 마일리지등급
ON 마일리지 BETWEEN 하한마일리지 AND 상한마일리지
SET 마일리지 = 마일리지 + 1000
WHERE 등급명 = 'S';

SELECT * FROM 주문;
SELECT * FROM 주문세부;

DELETE FROM 주문
WHERE 주문번호 NOT IN (
SELECT DISTINCT 주문번호
FROM 주문세부
);

DELETE 주문, 주문세부
FROM 주문
INNER JOIN 주문세부
ON 주문.주문번호 = 주문세부.주문번호
WHERE 주문.주문번호 = 'H0248';

SELECT * FROM 고객;

SELECT 고객.*
FROM 고객
LEFT OUTER JOIN 주문
ON 고객.고객번호 = 주문.고객번호
WHERE 주문.고객번호 IS NULL;

DELETE 고객
FROM 고객
LEFT JOIN 주문
ON 고객.고객번호 = 주문.고객번호
WHERE 주문.고객번호 IS NULL;

SELECT *
FROM 고객
WHERE 고객번호 IN ('BQQZA', 'RISPA', 'SSAFI', 'TTRAN');


USE WNTRADE;

SELECT *
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE CONSTRAINT_SCHEMA = 'WNTRADE'
AND TABLE_NAME = '제품';
-- 제품 테이블의 재고 컬럼 '0보다 크거나 같아야 한다'
ALTER TABLE 제품 ADD CONSTRAINT CHECK(재고 >= 0);
-- 제품테이블 재고금액 컬럼 추가 '단가*재고' 자동 계산, 저장
ALTER TABLE 제품 ADD 재고금액 INT AS (단가*재고) STORED;
-- 제품 레코드 삭제시 주문 세부 테이블의 관련 레코드도 함께 삭제되도록 주문 세부 테이블에 설정
ALTER TABLE 주문세부 ADD CONSTRAINT FOREIGN KEY (제품번호) REFERENCES 제품(제품번호) ON DELETE CASCADE;