--- SELECT
-- 사원 테이블에서 급여가 5000이 넘는 사원번호와 사원명을 조회한다.

DESC employees;

-- ORDER BY 추가
SELECT
    employee_id
    , emp_name
    , salary
FROM employees
WHERE salary > 5000
ORDER BY employee_id;

-- 급여가 5000 이상이고 job_id가 IT_PROG 사원 조회
SELECT
    employee_id
    , emp_name
    , salary
    , job_id
FROM employees
WHERE salary >= 5000
AND job_id = 'IT_PROG' -- 대소문자 구분
ORDER BY employee_id;

-- p.94

-- 급여가 5000 이상이거나 job_id가 'IR_PROG'인 사원 (OR)
-- 합집합
SELECT
    employee_id
    , emp_name
    , salary
    , job_id
FROM employees
WHERE salary > 5000
    OR job_id = 'it_prog'
ORDER BY employee_id;

SELECT *
FROM employees;

-- INSERT
CREATE TABLE ex3_1 (
    Col1 VARCHAR2(10),
    Col2 NUMBER,
    Col3 DATE
);

INSERT INTO ex3_1(Col1, Col2, Col3)
VALUES ('ABC',10,SYSDATE);

-- 컬럼 순서를 바꿔도 큰 문제가 안됨
INSERT INTO ex3_1(Col3,Col2,Col1)
VALUES (SYSDATE, 'DEF', 20);

GROUP BY e.emloyee_id

SELECT *
FROM ex3_1


DROP TABLE ex3_3;
CREATE TABLE ex3_3(
    employee_id    NUMBER
    , bonus_amt    NUMBER DEFAULT 0
);

SELECT * FROM SALES;
DESC SALES;

-- ex3_3 신규테이블 생성
INSERT INTO ex3_3 (employee_id)
SELECT 
    e.employee_id
FROM employees e, sales s
WHERE e.employee_id = s.employee_id
    AND s.SALES_MONTH BETWEEN '200010' AND '200012'
GROUP BY e.employee_id;

-- 
SELECT * FROM ex3_3 ORDER BY employee_id;

-- (1) 관리자 사번(manager_id)이 146번인 사원을 찾는다.
-- (2) ex3_3 테이블에 있는 사원의 사번과 일치하면 
--     보너스 금액에 자신의 급여의 1%를 보너스로 갱신
-- (3) ex3_3 테이블에 있는 사원의 사번과 일치하지 않으면
--     (1)의 결과의 사원을 신규로 입력(이 때 보너스 금액은 급여의 0.1% 
-- (4) 이 때 급여가 8000미만인 사원만 처리해보자. 

-- 서브쿼리
SELECT 
    employee_id
    , manager_id
    , salary
    , salary * 0.01 -- 10%
FROM employees;

SELECT employee_id FROM ex3_3;

SELECT 
    employee_id
    , manager_id
    , salary
    , salary * 0.01 -- 10%
FROM employees
WHERE employee_id IN (SELECT employee_id FROM ex3_3);

-- 관리자 사번이 146인 사원은 161번 사원 한 명이므로 
-- ex3_3 테이블에서 161인 건의 보너스 금액은 7,000 * 0.001, 즉 70으로 갱신

SELECT 
    employee_id
    , manager_id
    , salary
    , salary * 0.001 -- 1%
FROM employees
WHERE employee_id NOT IN (SELECT employee_id FROM ex3_3)
    AND manager_id = 146; 
    
SELECT * FROM ex3_3;

MERGE INTO ex3_3 d 
    USING (SELECT
                employee_id
                , salary 
                , manager_id
           FROM employees
           WHERE manager_id = 146) b 
        ON (d.employee_id = b.employee_id)
WHEN MATCHED THEN 
    UPDATE SET d.bonus_amt = d.bonus_amt + b.salary * 0.01 
WHEN NOT MATCHED THEN 
    INSERT (d.employee_id, d.bonus_amt) VALUES (b.employee_id, b.salary * 0.001)
    WHERE (b.salary < 8000);
    
SELECT * FROM ex3_3 ORDER BY employee_id;









