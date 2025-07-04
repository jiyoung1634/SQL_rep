USE WNTRADE;
SELECT * FROM 고객;

-- CHAPTER 3 문자열 함수, 숫자형 함수
SELECT CHAR_LENGTH('HELLO')
, LENGTH('HELLO')
, CHAR_LENGTH('안녕')
, LENGTH('안녕');

SELECT CONCAT('DREAMS', 'COME', 'TRUE')   -- 문자열 연결
, CONCAT_WS('-', '2023', '01', '29');   -- 문자열과 구분자 연결

SELECT LEFT('SQL 완전정복', 3)   -- 왼쪽부터 3문자
, RIGHT('SQL 완전정복', 4)   -- 오른쪽부터 4문자
, SUBSTR('SQL 완전정복', 2, 5)   -- 2번째부터 5문자
, SUBSTR('SQL 완전정복', 2);   -- 2번째부터 끝까지

SELECT SUBSTRING_INDEX('서울시 동작구 흑석로', ' ', 2)   -- 왼쪽부터 두 번째 공백 이후 제거
, SUBSTRING_INDEX('서울시 동작구 흑석로', ' ', -2);   -- 오른쪽부터 두 번째 공백 이전 제거

SELECT LPAD('SQL', 10, '#')   -- 문자열 왼쪽에 # 채우기(문자열 제외한 빈칸)
, RPAD('SQL', 5, '+');   -- 문자열 오른쪽에 * 채우기(문자열 제외한 빈칸)

SELECT LENGTH(LTRIM(' SQL '))   -- 왼쪽 공백 제거 후 길이 반환
, LENGTH(RTRIM(' SQL '))   -- 오른쪽 공백 제거 후 길이 반환
, LENGTH(TRIM(' SQL '));   -- 양쪽 공백 제거 후 길이 반환

SELECT TRIM(BOTH 'ABC' FROM 'ABCSQLABCABC')   -- 양쪽의 모든 ABC 제거
, TRIM(LEADING 'ABC' FROM 'ABCSQLABCABC')   -- 왼쪽의 ABC 제거
, TRIM(TRAILING 'ABC' FROM 'ABCSQLABCABC');   -- 오른쪽의 ABC 제거

SELECT FIELD('JAVA', 'SQL', 'JAVA', 'C')   -- 첫 매개변수인 JAVA의 위치
, FIND_IN_SET('JAVA', 'SQL,JAVA,C')   -- ,로 구분된 두 번째 매개변수 값 중 JAVA의 위치
, INSTR('네 인생을 살아라', '인생')   -- 인생의 위치
, LOCATE ('인생', '네 인생을 살아라');   -- 인생의 위치

SELECT ELT(2, 'SQL', 'JAVA', 'C');   -- 두 번째 위치에 있는 문자열
-- 17페이지까지 했음

-- 날짜/시간형 함수
-- NOW(), SYSDATE(), CURDATE() & CURTIME()
-- 현재 날짜 + 시간 가져오기 : 
-- 쿼리 시작시점 NOW()
-- 함수 시작지점 SYSDATE()
SELECT NOW()
, SYSDATE()
, CURDATE()
, CURTIME();

SELECT NOW() AS NOW_1
, SLEEP(5)   -- 5초
, NOW() AS NOW_2
, SYSDATE() AS SYS_1
, SLEEP(5)
, SYSDATE() AS SYS_2;
-- NOW()는 쿼리 시작 시점이므로 결과가 같다
-- SYSDATE()는 함수 실행 시작 시점이므로 5초의 시간 변화 결과가 나타난다

SELECT NOW()   -- 현재 날짜
, YEAR(NOW())   -- 연도
, QUARTER(NOW())   -- 분기
, MONTH(NOW())   -- 월
, DAY(NOW())   -- 일
, HOUR(NOW())   -- 시
, MINUTE(NOW())   -- 분
, SECOND(NOW());   -- 초

-- 값을 구분해서 반환하는 함수
-- 기간 바환 함수
SELECT NOW()
, DATEDIFF(NOW(), '2025-12-20')   -- 끝에서 시작 순
, TIMESTAMPDIFF(YEAR, NOW(), '2023-12-20') AS YEAR
, TIMESTAMPDIFF(MONTH, NOW(), '2024-12-20') AS MONTH
, TIMESTAMPDIFF(WEEK, NOW(), '2025-12-20') AS WEEK;

SELECT NOW()
, LAST_DAY(NOW())   -- 이번달의 마지막 일자
, DAYOFYEAR(NOW())   -- 오늘이 올해의 몇번째 날인지
, MONTHNAME(NOW())   -- 이번달의 이름 영문으로
, WEEKDAY(NOW());   -- 요일, 월요일(0)부터 ~

-- 태어난지 몇일 되었나? DATEDIFF()
SELECT '2001-03-11'
, TIMESTAMPDIFF(DAY, '2001-03-11', NOW());   -- 결과 : 8879
-- 강사님 답 : SELECT DATEDIFF(CURDATE(), '2001-03-11');
-- 천일 기념일 DATE_ADD()
SELECT '2001-03-11'
, DATE_ADD('2001-03-11', INTERVAL 1000 DAY);   -- 결과 : 2003-12-06
-- 내가 태어난 요일 DAYNAME()
SELECT '2001-03-11'
, DAYNAME('2001-03-11');   -- 결과 : 일요일
-- WEEKDAY()를 쓰면 결과는 6

-- 형 변환
-- CAST() ANSI SQL, CONVERT() MY SQL
SELECT CAST('1' AS UNSIGNED)
, CAST(2 AS CHAR(1))
, CONVERT('1', UNSIGNED)
, CONVERT(2, CHAR(1));

-- 제어 함수
-- IF(조건식, 참, 거짓)
SELECT IF(12500 * 450 > 5000000, '초과달성', '미달성');
-- IFNULL() : NULL처리 > 속성, NULL일때 
SELECT 이름, IFNULL(상사번호, '없음')
FROM 사원;
-- 고객의 지역 -> NULL이면 '미입력'
SELECT 지역, IFNULL(지역, '미입력')
FROM 고객;
-- NULLIF() : 조건을 만족하면 NULL, 아니면 지정한 값 반환
SELECT NULLIF(12 * 10, 120)
, NULLIF (12 * 10, 1200);
SELECT 고객번호, NULLIF(마일리지, 0) AS '유효마일리지'
FROM 고객;

-- CASE문
/*
SELECT 컬럼명,
CASE WHEN 조건1 THEN 결과1
	WHEN 조건2 THEN 결과2
END */
SELECT
CASE
	WHEN 12500 * 450 > 5000000 THEN '초과달성'
	WHEN 2500 * 450 > 4000000 THEN '달성'
    ELSE '미달성'
END;
-- 고객, 마일리지 1만점 > VIP, 5000점 > GOLD, 1000점 > SILVER, ELSE는 BRONZE
SELECT 고객번호, 고객회사명, 마일리지
, CASE
	WHEN 마일리지 > 10000 THEN 'VIP'
    WHEN 마일리지 > 5000 THEN 'GOLD'
    WHEN 마일리지 > 1000 THEN 'SILVER'
    ELSE 'BRONZE'
END AS 등급
FROM 고객;

-- 주문금액 = 수량 * 단가, 할인금액 = 주문금액 * 할인율, 실주문금액 = 주문금액 - 할인금액
-- 주문세부

-- 사원테이블에서 이름, 생일, 만나이, 입사일, 입사일수, 500일기념일 계산

-- 주문테이블에서 주문번호, 고객번호, 주문일, 주문연도, 분기, 월, 일, 요일, 요일(한글로)


-- 4. 집계함수
SELECT COUNT(*)   -- 개수
, COUNT(고객번호)
, COUNT(도시)
, COUNT(지역)
FROM 고객;

-- 조건부 집계
SELECT SUM(마일리지)   -- 결과행이 1개로 축약
, AVG(마일리지)
, MIN(마일리지)
, MAX(마일리지)
FROM 고객
WHERE 도시 = '서울특별시';

-- 그룹별 집계 : 컬럼값 > 범주로 집계
-- GROUP BY
SELECT 도시
, COUNT(*) AS 고객수   -- 서브셋의 레코드 전채 * 
, AVG(마일리지) AS 평균마일리지
FROM 고객
GROUP BY 도시;

SELECT 담당자직위, 도시
, COUNT(*) AS 고객수
, AVG(마일리지) AS 평균마일리지
FROM 고객
GROUP BY 담당자직위, 도시
ORDER BY 1, 2;

-- 집계 결과에 조건부 출력
SELECT 도시
, COUNT(*) AS 고객수
, AVG(마일리지) AS 평균마일리지
FROM 고객
GROUP BY 도시
HAVING COUNT(*) >= 10;

-- WHERE : 셀렉션의 조건, 그룹바이 이전에 실행
-- HAVING : 그룹바이한 집계의 조건, 기준 미달인 경우 제외
SELECT 제품번호, AVG(주문수량)
FROM 주문세부
WHERE 주문수량 >= 30   -- 집계하기 전 조건을 주어서 제외시킴
GROUP BY 제품번호
HAVING AVG(주문수량) >= 50;   -- 집계한 후 조건을 주어서 제외시킴

SELECT 도시
, SUM(마일리지)
FROM 고객
WHERE 고객번호 LIKE 'T%'
GROUP BY 도시
HAVING SUM(마일리지) >= 1000; 

-- SQL의 실행 순서 
/*
SELECT -> 5번
FROM -> 1번
WHERE -> 2번
GROUP BY -> 3번
HAVING -> 4번
ORDER BY -> 6번
*/

SELECT 도시
, COUNT(*) AS 고객수
, AVG(마일리지) AS 평균마일리지
FROM 고객
GROUP BY 도시
WITH ROLLUP;   -- 결과 맨아래에 고객수의 SUM, 평균마일리지의 SUM이 붙음

-- 고객번호가 'T'로 시작하는 고객에 대해 도시별로 묶어서
-- 고객의 마일리지 합을 구하시오.
-- 이때 마일리지 합이 1,000점 이상인 레코드만
-- 총계를 출력
SELECT 도시, SUM(마일리지)
FROM 고객
WHERE 고객번호 LIKE 'T%'
GROUP BY 도시
WITH ROLLUP
HAVING SUM(마일리지) >= 1000;
-- 개선
SELECT 도시, 합계
FROM (SELECT 도시, SUM(마일리지) AS 합계   -- SELECT 그룹 (서브쿼리)
	FROM 고객
    WHERE 고객번호 LIKE 'T%'
    GROUP BY 도시 WITH ROLLUP
) AS 그룹
WHERE (도시 IS NULL OR 합계 >= 1000);

-- 담당자직위에 '마케팅'이 들어가 있는 고객
-- 고객(담당자직위, 도시)별 고객수를 보이시오.
-- 담당자직위별 고객수와 전체 고객수 조회
SELECT 담당자직위, 도시, COUNT(*) AS 고객수
FROM 고객
WHERE 담당자직위 LIKE '%마케팅%'
GROUP BY 담당자직위, 도시
WITH ROLLUP;   
-- 결과에 마케팅과장 고객수 12, 마케팅담당 고객수4, 마지막 한줄은 총계로 고객수16(12+4)가 나온다

SELECT 지역
, IF (GROUPING(지역) = 1, '합계행', 지역) AS 도시명
, COUNT(*) AS 고객수
, GROUPING(지역) AS 구분
FROM 고객
WHERE 담당자직위 = '대표 이사'
GROUP BY 지역
WITH ROLLUP;

SELECT GROUP_CONCAT(고객회사명)
FROM 고객;

-- 성별에 따른 사원수, NULL > 총 사원수를 출력
SELECT COUNT(*) AS 사원수
, IF (GROUPING(성별)=1, '총 사원수', 성별) AS 성별
FROM 사원
GROUP BY 성별
WITH ROLLUP;

-- 연습문제 WRAP UP
-- 주문연도별 주문건수
SELECT COUNT(*) AS 주문건수, YEAR(주문일) AS 주문연도
FROM 주문
GROUP BY 주문연도;

-- 주문연도별, 분기별, 전체주문건수 추가
SELECT COUNT(*) AS 주문건수, YEAR(주문일) AS 주문연도, QUARTER(주문일) AS 분기
FROM 주문
GROUP BY 주문연도, 분기
WITH ROLLUP;

SELECT * 
FROM 주문;
-- 주문내역에서 월별 발송지연건
SELECT MONTH(주문일) AS 주문월
, COUNT(*) AS 발송지연건수
FROM 주문
WHERE 발송일 > 요청일
GROUP BY 주문월
ORDER BY 1;


-- 아이스크림 제품별 재고합
SELECT 제품명, SUM(재고)
FROM 제품
WHERE 제품명 LIKE '%아이스크림%'
GROUP BY 제품명;


-- 고객구분(VIP,일반)에 따른 고객수, 평균 마일리지, 총합
SELECT COUNT(*) AS 고객수, AVG(마일리지) AS 평균마일리지
, CASE
	WHEN 마일리지 > 10000 THEN 'VIP고객'
    ELSE '일반고객'
END AS 고객구분
FROM 고객
GROUP BY 고객구분
WITH ROLLUP;
-- 강사님 답
SELECT
 CASE
 	WHEN 마일리지 > 10000 THEN 'VIP'
     ELSE '일반'
 END AS 고객구분
, COUNT(*) AS 고객수
, AVG(마일리지) AS 평균
FROM 고객
GROUP BY 고객구분 WITH ROLLUP;
-- CASE 대신 IF(마일리지>10000, 'VIP', '일반') AS 고객구분 라고 적어도 된다


