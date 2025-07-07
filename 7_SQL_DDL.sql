CREATE DATABASE WNCAMP_CLASS;
USE WNCAMP_CLASS;
CREATE TABLE 학과
(
학과번호 CHAR(2)
, 학과명 VARCHAR(20)
, 학과장명 VARCHAR(20)
);

INSERT INTO 학과
VALUES
('AA', '컴퓨터공학과', '배경민')
, ('BB', '소프트웨어학과', '김남준')
, ('CC', '디자인융합학과', '박선영');

CREATE TABLE 학생
(
학번 CHAR(5)
, 이름 VARCHAR(20)
, 생일 DATE
, 연락처 VARCHAR(20)
, 학과번호 CHAR(2)
);

INSERT INTO 학생
VALUES ('S0001','이윤주','2020-01-30','01033334444','AA')
    ,('S0001','이승은','2021-02-23',NULL,'AA')
    ,('S0003','백재용','2018-03-31','01077778888','DD');
    
SELECT * FROM 학생;

CREATE TABLE 휴학생 AS
SELECT * 
FROM 학생
WHERE 1 = 2;





CREATE TABLE 회원
(
아이디 VARCHAR(20) PRIMARY KEY   -- PRIMARY KEY : 기본 키
, 회원명 VARCHAR(20)
, 키 INT
, 몸무게 INT
, 체질량지수 DECIMAL(4,1) AS (몸무게 / POWER(키 / 100, 2)) STORED
);

INSERT INTO 회원(아이디, 회원명, 키, 몸무게)
VALUES('APPLE', '김사과', 178, 70);

SELECT * FROM 회원;

-- 수정 ALTER, 삭제
-- 테이블 컬럼 추가 ADD, 삭제 DROP, 변경 MODIFY/CHANGE, 테이블이름 RENAME
ALTER TABLE 학생 ADD 성별 CHAR(1);
DESCRIBE 학생;

ALTER TABLE 학생 MODIFY COLUMN 성별 VARCHAR(2);
DESCRIBE 학생;

-- 컬럼명 변경, 컬럼 삭제
ALTER TABLE 학생 CHANGE COLUMN 연락처 휴대폰번호 VARCHAR(20);
DESCRIBE 학생;

ALTER TABLE 학생 DROP COLUMN 성별;
DESCRIBE 학생;

-- 테이블명 변경
ALTER TABLE 휴학생 RENAME 졸업생;
DESCRIBE 졸업생;

-- 테이블 삭제
DROP TABLE 학과;
DROP TABLE 학생;

-- 제약조건 : 무결성
-- PRIMARY KEY = NOT NULL + UNIQUE(유일한 값, 중복X)
-- CHECK, DEFAULT, FOREIGN KEY
CREATE TABLE 학과
(
학과번호 CHAR(2) PRIMARY KEY
, 학과명 VARCHAR(20) NOT NULL
, 학과장명 VARCHAR(20)
);

CREATE TABLE 학생
(
학번 CHAR(5) PRIMARY KEY
, 이름 VARCHAR(20) NOT NULL
, 생일 DATE NOT NULL
, 연락처 VARCHAR(20) UNIQUE
, 학과번호 CHAR(2) REFERENCES 학과(학과번호)
, 성별 CHAR(1) CHECK(성별 IN ('남', '여'))
, 등록일 DATE DEFAULT(CURDATE())
, FOREIGN KEY(학과번호) REFERENCES 학과(학과번호)
);

INSERT INTO 학과
VALUES ('AA', '컴퓨터공학과', '배경민');

INSERT INTO 학과
VALUES ('AA', '소프트웨어학과', '김남준');   -- ERROR

INSERT INTO 학과
VALUES ('CC', '디자인융합학과', '박선영');


INSERT INTO 학생(학번, 이름, 생일, 학과번호)
VALUES ('S0001', '이윤주', '2020-01-30', 'AA');

INSERT INTO 학생(이름, 생일, 학과번호)
VALUES ('이승은', '2021-02-23', 'AA');   -- ERROR

INSERT INTO 학생(학번, 이름, 생일, 학과번호)
VALUES ('S0002', '이승은', '2021-02-23', 'AA');

INSERT INTO 학생(학번, 이름, 생일, 학과번호)
VALUES ('S0003', '백재용', '2018-03-31', 'DD');   -- ERROR

INSERT INTO 학생(학번, 이름, 생일, 학과번호)
VALUES ('S0003', '백재용', '2018-03-31', 'AA');


CREATE TABLE 과목
    (
       과목번호 CHAR(5) PRIMARY KEY
      ,과목명 VARCHAR(20) NOT NULL
      ,학점 INT NOT NULL CHECK(학점 BETWEEN 2 AND 4)
      ,구분 VARCHAR(20) CHECK(구분 IN ('전공','교양','일반'))
    );
    

INSERT INTO 과목(과목번호, 과목명, 구분)
VALUES ('C0001', '데이터베이스실습', '전공');   -- ERROR

INSERT INTO 과목(과목번호, 과목명, 학점, 구분)
VALUES ('C0001', '데이터베이스실습', 3, '전공');

INSERT INTO 과목(과목번호, 과목명, 구분, 학점)
VALUES ('C0002', '데이터베이스 설계와 구축', '전공', 5);   -- ERROR

INSERT INTO 과목(과목번호, 과목명, 구분, 학점)
VALUES ('C0002', '데이터베이스 설계와 구축', '전공', 4);

INSERT INTO 과목(과목번호, 과목명, 구분, 학점)
VALUES ('C0003', '데이터 분석', '전공', 3);


CREATE TABLE 수강_1
(
수강년도 CHAR(4) NOT NULL
, 수강학기 VARCHAR(20) NOT NULL CHECK(수강학기 IN ('1학기', '2학기', '여름학기', '겨울학기'))
, 학번 CHAR(5) NOT NULL
, 과목번호 CHAR(5) NOT NULL
, 성적 NUMERIC(3, 1) CHECK(성적 BETWEEN 0 AND 4.5)
, PRIMARY KEY(수강년도, 수강학기, 학번, 과목번호)   -- 복합 키
, FOREIGN KEY (학번) REFERENCES 학생(학번)
, FOREIGN KEY(과목번호) REFERENCES 과목(과목번호)
);

-- 대리 키 : 복합 키를 심플하게 만들어줌

CREATE TABLE 수강_2
(
수강번호 INT PRIMARY KEY AUTO_INCREMENT   -- 대리키 : 데이터 들어갈때마다 지정해주지 않아도 DB가 알아서 관리
, 수강년도 CHAR(4) NOT NULL
, 수강학기 VARCHAR(20) NOT NULL CHECK(수강학기 IN ('1학기', '2학기', '여름학기', '겨울학기'))
, 학번 CHAR(5) NOT NULL
, 과목번호 CHAR(5) NOT NULL
, 성적 NUMERIC(3, 1) CHECK(성적 BETWEEN 0 AND 4.5)
, FOREIGN KEY (학번) REFERENCES 학생(학번)
, FOREIGN KEY (과목번호) REFERENCES 과목(과목번호)
);



INSERT INTO 수강_1(수강년도, 수강학기, 학번, 과목번호, 성적)
VALUES('2023','1학기','S0001','C0001',4.3);

INSERT INTO 수강_1(수강년도, 수강학기, 학번, 과목번호, 성적)
VALUES('2023','1학기','S0001','C0001',4.5);   -- ERROR

INSERT INTO 수강_1(수강년도, 수강학기, 학번, 과목번호, 성적)
VALUES('2023','1학기','S0001','C0002',4.6);   -- ERROR

INSERT INTO 수강_1(수강년도, 수강학기, 학번, 과목번호, 성적)
VALUES('2023','1학기','S0002','C0009',4.3);   -- ERROR


INSERT INTO 수강_2(수강년도, 수강학기, 학번, 과목번호, 성적)
VALUES('2023', '1학기', 'S0001', 'C0001', 4.3);

INSERT INTO 수강_2(수강년도, 수강학기, 학번, 과목번호, 성적)
VALUES('2023', '1학기', 'S0001', 'C0001', 4.5);

SELECT * FROM 수강_1;
SELECT * FROM 수강_2;
SELECT * FROM 학생;

-- 제약조건의 추가와 삭제
ALTER TABLE 학생 ADD CONSTRAINT CHECK(학번 LIKE 'S%');

SELECT *
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS   -- DBMS가 보는 테이블 : 우리가 만든 제약조건들 들어가있음
WHERE CONSTRAINT_SCHEMA = 'WNCAMP_CLASS'
AND TABLE_NAME = '학생';


ALTER TABLE 학생 DROP CONSTRAINT 연락처;

-- 성별 컬럼에 설정되어 있는 CHECK 제약조건 삭제
-- 학생 테이블에 걸려있는 CHECK 제약조건 2개를 삭제하고 학번에 설정했던 CHECK 제약조건은 다시 설정
SHOW CREATE TABLE 학생;
ALTER TABLE 학생 DROP CONSTRAINT 학생_CHK_1;
ALTER TABLE 학생 DROP CONSTRAINT 학생_CHK_2;

ALTER TABLE 학생 ADD CHECK (학번 LIKE 'S%');


CREATE TABLE 학생_2
(
학번 CHAR(5)
, 이름 VARCHAR(20) NOT NULL
, 생일 DATE NOT NULL
, 연락처 VARCHAR(20)
, 학과번호 CHAR(2)
, 성별 CHAR(1)
, 등록일 DATE DEFAULT(CURDATE())
, PRIMARY KEY(학번)
, CONSTRAINT UK_학생2_연락처 UNIQUE(연락처)
, CONSTRAINT CK_학생2_성별 CHECK(성별 IN ('남', '여'))
, CONSTRAINT FK_학생2_학과번호 FOREIGN KEY(학과번호) REFERENCES 학과(학과번호)
);

SELECT *
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE CONSTRAINT_SCHEMA = 'WNCAMP_CLASS'
AND TABLE_NAME = '학생_2';

CREATE TABLE 수강평가
(
평가순번 INT PRIMARY KEY AUTO_INCREMENT
, 학번 CHAR(5) NOT NULL
, 과목번호 CHAR(5) NOT NULL
, 평점 INT CHECK(평점 BETWEEN 0 AND 5)
, 과목평가 VARCHAR(500)
, 평가일시 DATETIME DEFAULT CURRENT_TIMESTAMP
, FOREIGN KEY (학번) REFERENCES 학생(학번)
, FOREIGN KEY (과목번호) REFERENCES 과목(과목번호) ON DELETE CASCADE
);

SELECT * FROM 학생;
SELECT * FROM 과목;

INSERT INTO 수강평가(학번, 과목번호, 평점, 과목평가)
VALUES('S0001', 'C0001', 5, 'SQL학습에 도움이 되었습니다.')
, ('S0001', 'C0003', 5, 'SQL 활용을 배워서 좋았습니다.')
, ('S0002', 'C0003', 5, '데이터 분석에 관심이 생겼습니다.')
, ('S0003', 'C0003', 5, '머신러닝과 시각화 부분이 유용했습니다.');


DELETE FROM 과목 WHERE 과목번호 = 'C0003';

SELECT * FROM 과목;
SELECT * FROM 수강평가;

DELETE FROM 과목 WHERE 과목번호 = 'C0001';   -- ERROR