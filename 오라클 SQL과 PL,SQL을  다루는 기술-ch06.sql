-- 6장
-- 2장 CREATE, ALTER, DROP
-- 3장 SELECT, UPDATE, DELETE, INSERT
-- 4장 다양한 함수, 연산자
-- 5장 그룹 쿼리(query)

SELECT
     period
     , region
     , SUM(loan_jan_amt) totl_jan
FROM kor_loan_status
WHERE period = '201311'
GROUP BY period, region
HAVING SUM(loan_jan_amt) > 100000 -- HAVING절:조건문, WHERE과 같은 기능, 하지만 단독으로 사용 불가 GROUP BY절과 함꼐 쓰여야 함, WHERE과 구분하기 위해 사용
ORDER BY region;

-- 테이블 p.176
-- 동등 조인
SELECT 
     a.employee_id
     , a.emp_name
     , a.department_id
     , b.department_name
FROM
     employees a
    , departments b
WHERE a.department_id = b.department_id;

-- 세미 조인
-- 서브 쿼리를 사용함
-- 서브 쿼리에 존재하는 데이터만 메인 쿼리에서 추출
-- IN & EXISTS

-- EXISTS 사용
-- 조건에 만족하는 데이터가 한 건이라도 있으면 결과를 즉시 반환
SELECT
     department_id
     , department_name
FROM departments a
WHERE EXISTS (SELECT * --(서브쿼리 영역)
              FROM employees b
              WHERE a.department_id = b.department_id
              AND b. salary >3000)
ORDER BY a.department_id;

-- IN 사용
-- = OR조건
SELECT
     department_id
     , department_name
FROM departments a
WHERE a.department_id IN (SELECT b.department_id
                          FROM employees b
                          WHERE b.salary > 3000)
ORDER BY a.department_id;

-- 안티 조인
-- 세미 조인 개념의 반대
-- 서브쿼리의 B 테이블에는 없는 메인 쿼리의 A 테이블의 데이터만 추출
SELECT a.employee_id
     , a.emp_name
     , a.department_id
     , b.department_name
FROM employees a
     , departments b
WHERE a.department_id = b.department_id
 AND a.department_id NOT IN (SELECT department_id
                              FROM departments
                              WHERE manager_id IS NULL);
                    
-- 셀프조인
-- 동일한 한 테이블에서 조인하는 방법
SELECT a.employee_id
     , a.emp_name
     , b.employee_id
     , b.emp_name
     , a.department_id
FROM employees a
     , employees b
WHERE a.employee_id < b.employee_id -- 같은 부서번호를 가진 사원 중 A사원번호가 B사원번호보다 작은 건 조회
  AND a.department_id = b.department_id
  AND a.department_id = 20; -- 부서번호가 20인 건=2건 -> 위 조건에 의해 결과는 1건만 추출됨
  
-- 외부조인(OUTER JOIN)
-- 조인 조건에 만족하지 않더라도 데이터를 모두 추출함
-- 무조건 ID가 매칭이 된 것만 조회
SELECT
    a.department_id
    , a.department_name
    , b.job_id
    , b.department_id
FROM departments a
     ,job_history b
WHERE a.department_id = b.department_id(+);

--
SELECT a.employee_id
      , a.emp_name
      , b.job_id
      , b.department_id
FROM employees a
      , job_history b
WHERE a.employee_id = b.employee_id(+)
  AND a.department_id = b.department_id(+);

-- 카타시안 조인
-- 사원 테이블의 총 건수 107건
-- 부서 테이블의 총 건수 27건
-- 107x27 = 2889건

-- ANSI 조인
-- ANSI SQL 문법 ( JOIN명 들어감)

-- 2013년 1월 1일 이후 입사한 사원번호, 사원명, 부서번호,부서명을 조회하는 쿼리 비교
-- 기존 문법
SELECT a.employee_id
      , a.emp_name
      , b.department_id
      , b.department_name
FROM employees a
    ,departments b
WHERE a.department_id = b.department_id
AND a.hire_date>= TO_DATE('2003-01-01', 'YYYY-MM-DD');
 
 -- ANSI
 -- 조인 조건이 WHERE절이 아닌 FROM 절에, ON절에 명시된다. 내부조인은 INNER JOIN 구문으로 들어간다
 -- ON 대신 USING절 사용 가능(단 SELECT절에 조인조건에 포함된 컬럼명만 기술했을 때)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
SELECT a.employee_id
      , a.emp_name
      , b.department_id
      , b.department_name
FROM employees a
INNER JOIN departments b
ON(a.department_id = b.department_id)
WHERE a.hire_date>= TO_DATE('2003-01-01', 'YYYY-MM-DD');

-- 서브쿼리
-- SQL 문장 안에서 보조로 사용되는 또 다른 SELECT문을 의미
-- 구조 : (1) 메인 쿼리 / (2) 서브쿼리

--SELECT (SELECT FROM WHERE GROUP BY HAVING ORDER BY)
--FROM (SELECT FROM WHERE GROUP BY HAVING ORDER BY)
--WHERE (SELECT FROM WHERE GROUP BY HAVING ORDER BY)
--GROUP BY
--HAVING

-- 연관성 없는 서브 쿼리
SELECT *
FROM employees; --107개의 행

-- 메인 쿼리: 모든 사원 테이블을 조회하세요
-- 서브쿼리: 조건 - 사원테이블의 평균 급여보다 많은 사원
SELECT count(*)
FROM employees
WHERE salary >= ( SELECT AVG(salary) 
                  FROM employees); --51개의 행
            
-- parent_id가 NULL인 부서번호를 가진 총 사원의 건수
SELECT count(*)
FROM employees
WHERE department_id IN (SELECT department_id
                        FROM departments
                        WHERE parent_id IS NULL);
                        
SELECT employee_id
      , emp_name
      , job_id
FROM employees
WHERE (employee_id, job_id) IN (SELECT employee_id
                                      , job_id
                                FROM job_history);
-- 연관성 있는 서브 쿼리
SELECT a.department_id
       , a.department_name
FROM departments a
WHERE EXISTS(SELECT 1
             FROM job_history b
             WHERE a.department_id = b.department_id);
             
-- SELECT절에 서브쿼리가 존재하는 케이스
SELECT a.employee_id
       , (SELECT b.emp_name
          FROM employees b
          WHERE a.employee_id = b.employee_id)AS emp_name
       , a.department_id
       , (SELECT b.department_name
          FROM departments b
          WHERE a.department_id = b.department_id)AS dep_name
       , (SELECT c.job_title
          FROM jobs c
          WHERE a.job_id = c.job_id) AS title_name
FROM job_history a;

-- 중첩 서크뭐리(2개 이상의 서브 쿼리)
SELECT a.department_id
    , a.department_name
FROM departments a --27개
WHERE EXISTS (SELECT 1
              FROM employees b
              WHERE a.department_id = b.department_id
              AND b.salary > (SELECT AVG(salary)
                              FROM employees)); --결과값 10개 행 출력(부서코드,부서명만 출력)

-- 위 코드의 서브쿼리
SELECT a.department_id, a.department_name
FROM employees b, departments a
WHERE a.department_id = b.department_id
AND b.salary > (SELECT AVG(salary)
                FROM employees) --50개 행
                ORDER BY a.department_id; --해당하는 employee들의 부서코드,부서명

-- p.198 
-- 기획부 산하에 있는 부서에 속한 사원의 평균급여보다 많은 급여를 받는 사원

- 서브쿼리
-- 오전: WHERE,SELECT
-- 오후: FROM
-- 기획부: 부서 테이블
-- 급여: 사원 테이블

SELECT a.employee_id
      , a.emp_name
      , b.department_id
      , b.department_name
FROM employees a
     , departments b
     ,(SELECT AVG(c.salary) AS avg_salary
      FROM departments b
          , employees c
      WHERE b.parent_id = 90
        AND b.department_id = c.department_id) d -- 기획부 평균급여
WHERE a.department_id = b.department_id
AND a.salary > d.avg_salary;

-- p.199
-- 2000년 이탈리아 평균 매출액(연평균)보다 큰 월의 평균 매출액을 구함
-- 첫번째 서브쿼리: 월별 평균 매출
-- 두번째 서브쿼리: 연평균 매출액을 구하는 것

SELECT *
FROM sales; -- amount_sold

SELECT *
FROM customers;

SELECT *
FROM countries;

SELECT a.*
FROM (SELECT a.sales_month, ROUND(AVG(a.amount_sold)) AS month_avg
      FROM sales a,
           customers b,
           countries c
      WHERE a.sales_month BETWEEN '200001' AND '200012'
      AND a.cust_id = b.CUST_ID
      AND b.country_id = c.COUNTRY_ID
      AND c.COUNTRY_NAME = 'Italy'
      GROUP BY a.sales_month) a, (SELECT ROUND(AVG(a.amount_sold)) AS year_avg
                                  FROM sales a,
                                       customers b,
                                       countries c
                                  WHERE a.sales_month BETWEEN '200001' AND '200012'
                                  AND a.cust_id = b.CUST_ID
                                  AND b.country_id = c.COUNTRY_ID
                                  AND c.COUNTRY_NAME = 'Italy')b
      WHERE a.month_avg > b.year_avg;                            

-- p.200
-- 복잡한 쿼리 작성법 예시
-- (1),(2) --> 메인쿼리 작성
-- (3),(4) --> 서브쿼리 작성 후 합치기

-- 연도별로 이탈리아 매출 데이터를 살펴
-- 매출실적이 가장 많은 사원의 목록과 매출액을 구하라
-- 연도, 최대매출사원, 최대매출액
-- 이탈리아 찾기: countries
-- 이탈리아 고객: customers
-- 매출: sales
-- 사원정보: employees

-- (1) 연도, 사원별 이탈리아 매출액 구하기
-- 이탈리아 고객 찾기: customer,countries 테이블 country_id로 조인
-- 이탈리아 매출 찾기: 위 결과와 sales 테이블을 cust_id로 조인
-- 최대 매출액을 구하려면 MAX 함수 쓰고, 연도별로 GROUP BY

SELECT SUBSTR(a.sales_month,1,4)as years
      ,a.employee_id
      ,SUM(a.amount_sold) AS amount_sold
FROM sales a,
     customers b,
     countries c
WHERE a.cust_id = b.CUST_ID
AND b.country_id = c.COUNTRY_ID
AND c.country_name = 'Italy'
GROUP BY SUBSTR(a.sales_month,1,4),a.employee_id;

-- (2) (1)결과에서 연도별 최대, 최소 매출액 구하기
SELECT years,
       MAX(amount_sold) AS max_sold,
       MIN(amount_sold) AS min_sold
FROM (SELECT SUBSTR(a.sales_month,1,4)as years,
             a.employee_id,
             SUM(a.amount_sold) AS amount_sold
      FROM sales a,
           customers b,
           countries c
      WHERE a.cust_id = b.CUST_ID
      AND b.country_id = c.COUNTRY_ID
      AND c.country_name = 'Italy'
      GROUP BY SUBSTR(a.sales_month,1,4), a.employee_id) K
GROUP BY years
ORDER BY years;

-- (3) (1)결과와 (2)결과를 조인해서
-- 최대매출,최소매출액을 일으킨 사원을 찾는다.
SELECT emp.years
     , emp.employee_id
     , emp.amount_sold
FROM (SELECT SUBSTR(a.sales_month,1,4)as years
      ,a.employee_id
      ,SUM(a.amount_sold) AS amount_sold
FROM sales a,
     customers b,
     countries c
WHERE a.cust_id = b.CUST_ID
AND b.country_id = c.COUNTRY_ID
AND c.country_name = 'Italy'
GROUP BY SUBSTR(a.sales_month,1,4),a.employee_id) emp
    ,(SELECT years,
       MAX(amount_sold) AS max_sold,
       MIN(amount_sold) AS min_sold
FROM (SELECT SUBSTR(a.sales_month,1,4)as years,
             a.employee_id,
             SUM(a.amount_sold) AS amount_sold
      FROM sales a,
           customers b,
           countries c
      WHERE a.cust_id = b.CUST_ID
      AND b.country_id = c.COUNTRY_ID
      AND c.country_name = 'Italy'
      GROUP BY SUBSTR(a.sales_month,1,4), a.employee_id) K
GROUP BY years
ORDER BY years) sale
WHERE emp.years = sale.years
AND emp.amount_sold = sale.max_sold
ORDER BY years;