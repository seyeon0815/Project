-- p.56
-- NOT NULL
-- 제약 조건

CREATE TABLE ex2_6(
    COL_NULL       VARCHAR2(10)
    , COL_NOT_NULL VARCHAR2(10) NOT NULL
);

INSERT INTO ex2_6 VALUES ('AA, '');

INSERT INTO ex2_6 VALUES ('AA', 'BB');

SELECT *
FROM ex2_6;

-- USER CONSTRAINTS 제약 조건 확인
SELECT constraint_name, constraint_type, table_name, search_condition
FROM user_constraints
WHERE table_name = 'EX2_6'

-- UNIQUE
-- 중복값 허용 안함, 해당 컬럼에 들어가는 값이 유일해야 한다
CREATE TABLE ex2_7 (
    COL_UNIQUE_NULL VARCHAR2(10) UNIQUE 
    , COL_UNIQUE_NNULL VARCHAR2(10) UNIQUE NOT NULL
    , COL_UNIQUE VARCHAR2(10)
    , CONSTRAINTS unique_nml UNIQUE (COL_UNIQUE)
);

SELECT constraint_name, constraint_type, table_name, search_condition
FROM user_constraints
WHERE table_name = 'EX2_7';

SELECT *
FROM ex2_7;

INSERT INTO ex2_7 VALUES('AA', 'AA','AA');

SELECT *
FROM ex2_7'

INSERT INTO ex2_7 VALUES ('', 'BB', 'BB');
INSERT INTO ex2_7 VALUES ('', 'CC', 'CC');

SELECT *
FROM ex2_7;

-- 기본키(Primary Key) p.63
-- UNIQUE와 NOT NULL 속성을 동시에 가진 제약 조건, 테이블 당 1개의 기본키만 생성 가능
CREATE TABLE ex2_8(
    COL1 VARCHAR2(10)PRIMARY KEY
    , COL2 VARCHAR2(10) 
);

SELECT constraint_name, constraint_type, table_name, search_condition
FROM user_constraints
WHERE table_name = 'EX2_8';

INSERT INTO ex2_8 VALUES ('','AA');
INSERT INTO ex2_8 VALUES ('AA', 'AA');
-- ORA-00001: 무결성 제약 조건(ORA_USER.SYS_C007454)에 위배됩니다

SELECT *
FROM ex2_8;

-- p.90 테이블 1, 2, 3번 생성
CREATE TABLE ORDERS(
    ORDER_ID NUMBER(12,0)
    , ORDER_DATE DATE
    , ORDER_MODE VARCHAR2(8 BYTE)
    , CUSTOMER_ID NUMBER(6,0)
    , ORDER_STATUS NUMBER(2,0)
    , ORDER_TOTAL NUMBER(8,2)DEFAULT 0
    , SALES_REP_ID NUMBER(6,0)
    , PROMOTION_ID NUMBER(6,0)
    , CONSTRAINT PK_ORDER PRIMARY KEY (ORDER_ID)
    , CONSTRAINT CK_ORDER_MODE CHECK (ORDER_MODE in ('direct','online'))
);

SELECT *
FROM ORDERS

--2.
CREATE ORDER_ITEMS(
    ORDER_ID NUMBER(12,0)
    , LINE_ITEM_ID NUMBER(3,0)
    , PRODUCT_ID NUMBER(3,0)
    , UNIT_PRICE NUMBER(8,2) DEFAULT 0
    , QUANTITY NUMBER(8,0) 
    , CONSTRAINT PK_ORDER PRIMARY KEY(ORDER_ID, LINE_ITEM_ID)
);

SELECT *
FROM ORDER_ITEMS

-- 3.
CREATE TABLE PROMOTIONS(
    PROMO_ID   NUMBER(6,0)
    , PROMO_NAME VARCHAR2(20)
    , CONSTRAINT PK_ORDER PRIMARY KEY(PROMO_ID)
);

SELECT *
FROM PROMOTIONS

-- CHECK
CREATE TABLE ex2_9 (
    num1     NUMBER 
        CONSTRAINTS check1 CHECK ( num1 BETWEEN 1 AND 9),
    gender   VARCHAR2(10) 
        CONSTRAINTS check2 CHECK ( gender IN ('MALE', 'FEMALE'))        
); 

SELECT constraint_name, constraint_type, table_name, search_condition
  FROM user_constraints
 WHERE table_name = 'EX2_9';
 
INSERT INTO ex2_9 VALUES (10, 'MAN');

INSERT INTO ex2_9 VALUES (5, 'FEMALE');

-- DEFAULT 
-- DEFAULT SYSDATE : 자동으로 현재 일자와 시간이 입력됨
DROP TABLE ex2_10;
CREATE TABLE ex2_10 (
   Col1        VARCHAR2(10) NOT NULL, 
   Col2        VARCHAR2(10) NULL, 
   Create_date DATE DEFAULT SYSDATE);
   
-- Col1 Col2 사용자가 입력
-- Create_Date DB에서 자동으로 입력
INSERT INTO ex2_10 (col1, col2) VALUES ('AA', 'BB');

SELECT *
FROM ex2_10;   


-- 테이블 변경
-- (1) 컬럼명 변경
ALTER TABLE ex2_10 RENAME COLUMN Col1 TO Col11;

SELECT *
FROM ex2_10;

DESC ex2_10;
-- DESC: 테이블에 있는 컬럼 내역 확인

-- (2) 컬럼 타입 변경
-- (VARCHAR2(10) ~ VARCHAR2(30))으로 변경

--(3) col3 NUMBER 타입으로 신규 생성
ALTER TABLE ex2_10 ADD Col3 NUMBER;

DESC ex2_10;

-- (4) 컬럼 삭제
ALTER TABLE ex2_10 DROP COLUMN Col3;

DESC ex2_10;

-- 제약조건 추가
ALTER TABLE ex2_10 ADD CONSTRAINTS pk_ex2_10 PRIMARY KEY (col11);

-- USER CONSTRAINTS 제약 조건 확인
SELECT constraint_name, constraint_type, table_name, search_conditon
FROM user_constraints
WHERE table_name = 'EX2_10';

-- 제약조건 삭제
ALTER TABLE ex2_10 DROP CONSTRAINTS pk_ex2_10;
SELECT constraint_name, constraint_type, table_name, search_condition
FROM user_constraints
WHERE table_name = 'EX2_10';

-- 테이블 복사
-- CREATE TABLE 테이블명 AS , FROM 복사할 테이블명;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
-- p.72
CREATE TABLE ex2_9_1 AS 
SELECT * 
FROM ex2_9;

-- 뷰 (VIEW)
-- 하나 이상의 테이블이나 다른 뷰의 데이터를 볼 수 있게 하는 데이터베이스 객체
-- 테이블이랑 비슷
SELECT * FROM employees;
SELECT * FROM departments;

SELECT
    a.employee_id
    , a.emp_name
    , a.department_id -- 부서명 컬럼
    , b.department_name
FROM 
    employees a
    , departments b
WHERE a.department_id = b.department_id; 

CREATE OR REPLACE VIEW emp_dept_v1 AS -- 여러 사람이 자주 사용할 때마다 테이블 생성x, 뷰 참고
SELECT
    a.employee_id
    , a.emp_name
    , a.department_id -- 부서명 컬럼
    , b.department_name
FROM 
    employees a
    , departments b
WHERE a.department_id = b.department_id;

SELECT *
FROM emp_dept_v1;

-- 인덱스 생성
-- 인덱스: 테이블에 있는 데이터를 빨리 찾기 위한 데이터베이스 객체
-- 추후 공부해야 할 내용 인덱스 내부 구조에 따른 분류
-- B-Tree 인덱스, 비트맵 인덱스, 함수 기반 인덱스 
-- DB 성능
-- col11값에 중복값을 허용하지 않는다.
-- 인덱스 생성 시 user_indexes 시스템 뷰에서 내역 확인

CREATE UNIQUE INDEX ex2_10_ix01
ON ex2_10(col11);

SELECT index_name, index_type, table_name, uniqueness
FROM user_indexes
WHERE table_name = 'EX2_10';