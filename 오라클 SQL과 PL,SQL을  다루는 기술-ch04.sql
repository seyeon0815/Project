-- REVIEW

-- 테이블 생성 : CREATE
-- 테이블 변경 (컬럼명, 데이터 타입 등) : ALTER
-- 테이블 삭제 : DROP

-- 쿼리 
-- SELECT (조회) FROM WHERE ORDER BY 
-- MERGE
-- 테이블 데이터 변경 : UPDATE SET 
-- 테이블 특정 데이터 삭제 : DELETE

-- 연산자
DESC employees;

SELECT employee_id || '-' || emp_name AS emloyee_info
FROM employees;

-- 표현식 (조건문)
-- CASE WHEN 조건 THEN ELSE END

SELECT
     employee_id
     , salary
     , CASE WHEN salary <= 5000 THEN 'C등급'
            WHEN salary > 5000 AND salary <= 15000 THEN 'B등급'
            ELSE 'A등급'
       END AS salary_grade
FROM employees;

--p.114
-- 비교 조건식 : ANY, SOME, ALL 키워드로 비교하는 조건식
-- ANY = OR

SELECT
      employee_id
      , salary
FROM employees
WHERE salary = ANY(2000,3000,4000);

-- ALL
-- 모든 조건을 동시에 만족해야 함
SELECT
     employee_id
     , salary
FROM employees
WHERE salary = ALL(2000,3000,4000)
ORDER BY employee_id;

--SOME
-- ANY와 이름만 다를뿐 같은 기능
SELECT
     employee_id
     , salary
FROM employees
WHERE salary = SOME(2000,3000,4000);

-- 논리 조건식
SELECT 
     employee_id
    , salary
FROM employees
WHERE NOT (salary >= 2500)
ORDER BY employee_id;

-- BETWEEN AND 조건식
-- 범위 지정
-- 급여가 2000에서 2500 사이에 해당하는 사원을 조회해라
SELECT
    employee_id
    , salary
FROM employees
WHERE salary BETWEEN 2000 AND 2500
ORDER BY employee_id;

-- IN 조건식 (OR, =ANY)
SELECT
    employee_id
    , salary
FROM employees
WHERE salary IN (2000,3000,4000)
ORDER BY employee_id;

SELECT
    employee_id
    , salary
FROM employees
WHERE salary NOT IN (2000,3000,4000) --NOT IN:()안의 값을 제외한 모든 값
ORDER BY employee_id;

SELECT
    employee_id
    , salary
FROM employees
WHERE salary <> ALL(2000,3000,4000)
ORDER BY employee_id;

-- EXISTS 조건식
-- IN과 비슷함, 단 서브쿼리 절에서만 사용 가능
SELECT department_id
       , department_name
FROM departments a
WHERE EXISTS (SELECT *
             FROM employees b
             WHERE a.department_id = b.department_id
               AND b. salary > 3000)
ORDER BY a.department_name;

-- LIKE 조건식
-- 문자열의 패턴을 검색할 때 사용하는 조건식
-- 사원 테이블 사원 이름이 'A'로 시작되는 사원 조회
SELECT emp_name
FROM employees
WHERE emp_name LIKE 'A%'
ORDER BY emp_name;

SELECT emp_name
FROM employees
WHERE emp_name LIKE '__a%' -- __(_2개):세번째 자리가 a인 name 출력
ORDER BY emp_name;

-- SQL 함수 살펴보기
-- ABS(n): 절대값 반환하는 함수
SELECT
     ABS(10)
     , ABS(-10)
     , ABS(-10.123)
FROM DUAL;

-- CEIL FLOOR
SELECT 
     CEIL(10.123) 
     , CEIL(-10.123)
     , FLOOR(10.123)
     , FLOOR(-10.123)
FROM DUAL;

-- ROUND & TRUNC (n1,n2)
-- ROUND: 반올림 함수, n2 = 표현할 소숫점 자리 수
-- TRUNC: 절삭 함수
SELECT
    ROUND(10.154)
    , ROUND(10.151)
    , ROUND(11.001)
    , ROUND(-10.154)
    , ROUND(-11.001)
FROM DUAL;

SELECT
    ROUND(10.154,1)
    , ROUND(10.151,2)
    , ROUND(11.001,2)
    , ROUND(-10.154,2)
    , ROUND(-11.001,1)
    , ROUND(11.999,1)
FROM DUAL;

SELECT
     ROUND(0,3)
     , ROUND(115.155, -1)
     , ROUND(115.155, -2)
FROM DUAL;

-- TRUNC
-- 반올림 안하고 소수점 절삭
SELECT 
     TRUNC(115.155)
     , TRUNC(115.155, 1)
     , TRUNC(115.155, 2)
     , TRUNC(115.155, -2)
     , TRUNC(115.155, -1)
     , TRUNC(-115.155, -1)
FROM DUAL;

-- p.128
-- POWER(n2, n1) SQRT(n)
-- 제곱& 제곱근
SELECT
     POWER(3,2)
     , POWER(3,3)
     , SQRT(9)
     , SQRT(8)
FROM DUAL;

-- MOD(n2,n1)와 REMAINDER(n2,n1)
-- MOD 함수는 n2를 n1로 나눈 나머지 값 반환
SELECT
     MOD(19,4)
     ,REMAINDER(19,4)
     ,REMAINDER(21,4)
FROM DUAL;

-- EXP, LN, LOG
-- EXP = 지수 함수 e의 n제곱 값 반환 (e= 2.71828183)
-- LN = 자연 로그 함수, 밑수가 e인 로그 함수
-- LOG = n2를 밑수로 하는 n1의 로그값 반환
SELECT EXP(2), LN(2.713), LOG(10, 100)
FROM DUAL;

-- 문자 함수
-- CONCAT: '||' 연산자처럼 두 문자를 붙여 반환
SELECT 
    CONCAT('I Have', 'A Dream'),
    'I Have' || ' A Dream'
FROM DUAL;

-- SUBSTR (***중요***)
-- (문자,n1,n2) n1 : 시작할 문자 위치, n2: 출력 자릿수 ex)4 -> 시작 문자부터 4글자 출력
SELECT 
     SUBSTR('ABCDEFG',1, 4)
     ,SUBSTR('ABCDEFG', -1,4)
      ,SUBSTR('ABCDEFG', -5,1)
FROM DUAL;

-- SUBSTRB
-- 문자열의 바이트 수만큼
SELECT
    SUBSTRB('ABCDEFG', 1, 4)
    , SUBSTRB('가나다라마바사' , 1, 4)
FROM DUAL;

-- LTRIM(char, set), RTRIM(char, set)
-- LTRIM = 왼쪽부터 set문자 제거, RTRIM = 오른쪽부터 set 문자 제거
SELECT
     LTRIM('ABCDEFGABC', 'ABC')
     , LTRIM('가나다라', '가')
     , RTRIM('가나다라', '라')
     , RTRIM('ABCDEFGABC', 'ABC')
FROM DUAL;

-- LPAD, RPAD
-- 무언가를 입력해준다.
CREATE TABLE ex4_1 (
  phone_num VARCHAR2(30)
);

INSERT INTO ex4_1 VALUES('111-1111');
INSERT INTO ex4_1 VALUES('111-2222');
INSERT INTO ex4_1 VALUES('111-3333');

SELECT *
FROM ex4_1;

SELECT LPAD(phone_num, 12, '(02)') -- 12: 자릿수,(02)삽입
FROM ex4_1;
SELECT RPAD(phone_num, 12, '(02)')
FROM ex4_1;

-- 날짜 함수 (p.138)
SELECT 
    SYSDATE
    , SYSTIMESTAMP
FROM DUAL;

-- ADD_MONTHS
SELECT
     SYSDATE
     , ADD_MONTHS(SYSDATE,1)
     , ADD_MONTHS(SYSDATE, -1)
FROM DUAL;

-- MONTHS_BETWEEN
-- (n1, n2) -> n1 - n2
SELECT
     MONTHS_BETWEEN(SYSDATE, ADD_MONTHS(SYSDATE,1)) mon1
     , MONTHS_BETWEEN(ADD_MONTHS(SYSDATE,1),SYSDATE) mon2
FROM DUAL;

-- LAST_DAY
SELECT 
    LAST_DAY(SYSDATE)
    , LAST_DAY(ADD_MONTHS(SYSDATE, 1))
FROM DUAL;

-- ROUND(date, format)
-- TRUNC(date, format)
SELECT
     SYSDATE
     , ROUND(SYSDATE, 'month')
     , TRUNC(SYSDATE, 'month')
FROM DUAL;

-- NEXT_DAY (date, char)
-- 돌아오는 ''요일
SELECT 
     NEXT_DAY(SYSDATE, '금요일')
FROM DUAL;