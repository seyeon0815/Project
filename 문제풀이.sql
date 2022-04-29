p.205/256,257

--1.
SELECT a.employee_id, a.emp_name, d.job_title, b.start_date, end_date, c.department_name 
FROM employees a
    , job_history b
    , departments c
    , jobs d
WHERE a.employee_id = b.employee_id
  AND b.department_id = c.department_id
  AND b.job_id = d.job_id
  AND a.employee_id = 101;
    
--2.
SELECT a.employee_id, a.emp_name, b.job_id, b.department_id
FROM employees a
    , job_history b
WHERE a.employee_id = b.employee_id(+)
--employees 테이블에 employee_id(100~206) 총 107개,job_history 테이블에는 employee_id(101~201,다양하게,중복값 존재,unique=7개) 10개
-- join시 10개 행 출력됨 / outer join시 110개 행 출력됨(107+10-7(unique값,조인돼었기 때문))
AND a.department_id = b.department_id(+); -- a.department_id가 아닌 b.department_id에 (+)
-- ORA-01416: 두 개의 테이블을 outer-join할 수 없습니다
-- 외부 조인의 경우 조인 조건에서 데이터가 없는 테이블의 컬럼에 (+)를 붙여야 한다.

--3.외부조인시 (+)연산자를 같이 사용할 수 없는데, IN절에 사용하는 값이 1개인 경우는 사용 가능하다. 그 이유는 무엇일까?
-- 답변) IN절에 포함된 값을 OR로 변환할 수 있다. 그런데 IN절에 값이 1개인 경우 department_id = 10으로 변환할 수 있어 외부 조인을 하더라도 값이 1개인 경우는 사용 가능하다.

--4. 다음의 쿼리를 ANSI 문법으로 변경해 보자.
SELECT a.department_id, a.department_name
  FROM departments a, employees b
 WHERE a.department_id = b.department_id
   AND b.salary > 3000
ORDER BY a.department_name;
------------------------------------------
--<정답>
SELECT a.department_id, a.department_name
FROM departments a
INNER JOIN employees b
ON (a.department_id = b.department_id)
WHERE b.salary > 3000
ORDER BY a.department_name;

--5. 다음은 연관성 있는 서브쿼리이다. 이를 연관성 없는 서브쿼리로 변환해 보자. 

SELECT a.department_id, a.department_name
 FROM departments a
WHERE EXISTS ( SELECT 1 
                 FROM job_history b
                WHERE a.department_id = b.department_id );
---------------------------------------------------------------
--<정답>
SELECT a.department_id, a.department_name
FROM departments a
WHERE department_id IN (SELECT department_id
                        FROM job_history);
                        
6. 연도별 이태리 최대매출액과 사원을 작성하는 쿼리를 학습했다. 이 쿼리를 기준으로 최대 매출액 뿐만 아니라 최소매출액과 해당 사원을 조회하는 쿼리를 작성해 보자. 
SELECT emp.years,
        emp.employee_id,
        emp2.emp_name,
        emp.amount_sold
FROM (SELECT SUBSTR(a.sales_month,1,4) as years,
             a.employee_id,
             SUM(amount_sold) AS amount_sold
      FROM sales a,
           customers b,
           countries c
      WHERE a.cust_id = b.CUST_ID
        AND b.country_id = c.COUNTRY_ID
        AND c.country_name = 'Italy'
     GROUP BY SUBSTR(a.sales_month,1,4), a.employee_id) emp, (SELECT years, 
                                                                    MAX(amount_sold) AS max_sold,
                                                                    MIN(amount_sold) AS min_sold
                                                              FROM (SELECT SUBSTR(a.sales_month, 1, 4) as years,
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
                                                            ) sale,
                                                            employees emp2
                                                        WHERE emp.years = sale.years
                                                          AND (emp.amount_sold = sale.max_sold OR emp.amount_sold = sale.min_sold)
                                                          AND emp.employee_id = emp2.employee_id
                                                          ORDER BY years;
                                                        
p.256
--1.계층형 쿼리 응용편에서 LISTAGG 함수를 사용해 다음과 같이 로우를 컬럼으로 분리했었다.  
  SELECT department_id,
         LISTAGG(emp_name, ',') WITHIN GROUP (ORDER BY emp_name) as empnames
    FROM employees
   WHERE department_id IS NOT NULL
   GROUP BY department_id;
   
-- LISTAGG 함수 대신 계층형 쿼리, 분석함수를 사용해서 위 쿼리와 동일한 결과를 산출하는 쿼리를 작성해 보자. 
SELECT department_id, 
       SUBSTR(SYS_CONNECT_BY_PATH(emp_name, ','),2) empnames
 FROM ( SELECT emp_name, 
               department_id, 
               COUNT(*) OVER ( partition BY department_id ) cnt, 
               ROW_NUMBER () OVER ( partition BY department_id order BY emp_name) rowseq 
          FROM employees
         WHERE department_id IS NOT NULL) 
 WHERE rowseq = cnt 
 START WITH rowseq = 1 
CONNECT BY PRIOR rowseq + 1 = rowseq 
    AND PRIOR department_id = department_id; 

--2. 아래의 쿼리는 사원테이블에서 JOB_ID가 'SH_CLERK'인 사원을 조회하는 쿼리이다. 
SELECT employee_id, emp_name, hire_date
FROM employees
WHERE job_id = 'SH_CLERK'
ORDER BY hire_date;

SELECT employee_id, hire_date, retire_date
FROM employees
ORDER BY hire_date;


-- 사원테이블에서 퇴사일자(retire_date)는 모두 비어있는데, 위 결과에서 사원번호가 184인 사원의 퇴사일자는 다음으로 입사일자가 빠른 192번 사원의 입사일자라고 가정해서
다음과 같은 형태로 결과를 추출해낼 수 있도록 쿼리를 작성해 보자. (입사일자가 가장 최근인 183번 사원의 퇴사일자는 NULL이다)
SELECT employee_id, emp_name, hire_date, LEAD(hire_date) OVER (PARTITION BY JOB_ID ORDER BY HIRE_DATE) AS retire_date
FROM employees
WHERE job_id = 'SH_CLERK'
ORDER BY hire_date;

--3. sales 테이블에는 판매데이터, customers 테이블에는 고객정보가 있다. 2001년 12월(SALES_MONTH = '200112') 판매데이터 중 현재일자를 기준으로 고객의 나이(customers.cust_year_of_birth)를 계산해서 다음과 같이 연령대별 매출금액을 보여주는 쿼리를 작성해 보자.
DESC sales;
DESC customers; --cust_id,create_date, update_date
SELECT *
FROM customers;
-- 연령대별 매출금액
WITH basis AS (SELECT WIDTH_BUCKET(to_char(sysdate, 'yyyy') - c.cust_year_of_birth,10,90,8)AS old_seg,
                      TO_CHAR(SYSDATE, 'yyyy') - c.cust_year_of_birth as olds, -설정한 포맷으로 날짜 데이터 조회
                      s.amount_sold
                FROM sales s, customers c
                WHERE s.sales_month = '200112'
                  AND s.cust_id = c.CUST_ID), real_data AS (SELECT old_seg * 10 || '대' AS old_segment,
                                                                  SUM(amount_sold) as old_seg_amt
                                                             FROM basis
                                                            GROUP BY old_seg)
SELECT *
FROM real_data
ORDER BY old_segment;

--4. 3번 문제를 이용해 월별로 판매금액이 가장 하위에 속하는 대륙 목록을 뽑아보자.
--( 대륙목록은 countries 테이블의 country_region에 있으며, country_id 컬럼으로 customers 테이블과 조인을 해서 구한다.)
WITH basis AS (SELECT ct.country_region, s.sales_month, SUM(s.amount_sold) AS amt
                 FROM countries ct, sales s, customers c
                WHERE s.cust_id = c.CUST_ID
                  AND c.country_id = ct.COUNTRY_ID
                GROUP BY ct.country_region, s.sales_month), real_data AS (SELECT sales_month,
                                                                                 country_region,
                                                                                 amt,
                                                                                 RANK() OVER (PARTITION BY sales_month ORDER BY amt) ranks
                                                                           FROM basis)
SELECT *
FROM real_data
WHERE ranks =1;

--5. 5장 연습문제 5번의 정답 결과를 이용해 다음과 같이 지역별, 대출종류별, 월별 대출잔액과 지역별 파티션을 만들어 대출종류별 대출잔액의 %를 구하는 쿼리를 작성해보자.
--5장 5번 정답
SELECT REGION, 
       SUM(AMT1) AS "201111", 
       SUM(AMT2) AS "201112", 
       SUM(AMT3) AS "201210", 
       SUM(AMT4) AS "201211", 
       SUM(AMT5) AS "201312", 
       SUM(AMT6) AS "201310",
       SUM(AMT6) AS "201311"
  FROM ( 
         SELECT REGION,
                CASE WHEN PERIOD = '201111' THEN LOAN_JAN_AMT ELSE 0 END AMT1,
                CASE WHEN PERIOD = '201112' THEN LOAN_JAN_AMT ELSE 0 END AMT2,
                CASE WHEN PERIOD = '201210' THEN LOAN_JAN_AMT ELSE 0 END AMT3, 
                CASE WHEN PERIOD = '201211' THEN LOAN_JAN_AMT ELSE 0 END AMT4, 
                CASE WHEN PERIOD = '201212' THEN LOAN_JAN_AMT ELSE 0 END AMT5, 
                CASE WHEN PERIOD = '201310' THEN LOAN_JAN_AMT ELSE 0 END AMT6,
                CASE WHEN PERIOD = '201311' THEN LOAN_JAN_AMT ELSE 0 END AMT7
         FROM KOR_LOAN_STATUS
       )
GROUP BY REGION
ORDER BY REGION       
;

--정답
WITH basis AS (
SELECT REGION, GUBUN,
       SUM(AMT1) AS AMT1, 
       SUM(AMT2) AS AMT2, 
       SUM(AMT3) AS AMT3, 
       SUM(AMT4) AS AMT4, 
       SUM(AMT5) AS AMT5, 
       SUM(AMT6) AS AMT6, 
       SUM(AMT6) AS AMT7 
  FROM ( 
         SELECT REGION,
                GUBUN,
                CASE WHEN PERIOD = '201111' THEN LOAN_JAN_AMT ELSE 0 END AMT1,
                CASE WHEN PERIOD = '201112' THEN LOAN_JAN_AMT ELSE 0 END AMT2,
                CASE WHEN PERIOD = '201210' THEN LOAN_JAN_AMT ELSE 0 END AMT3, 
                CASE WHEN PERIOD = '201211' THEN LOAN_JAN_AMT ELSE 0 END AMT4, 
                CASE WHEN PERIOD = '201212' THEN LOAN_JAN_AMT ELSE 0 END AMT5, 
                CASE WHEN PERIOD = '201310' THEN LOAN_JAN_AMT ELSE 0 END AMT6,
                CASE WHEN PERIOD = '201311' THEN LOAN_JAN_AMT ELSE 0 END AMT7
         FROM KOR_LOAN_STATUS
       )
GROUP BY REGION, GUBUN
)   
SELECT REGION, 
       GUBUN,
       AMT1 || '( ' || ROUND(RATIO_TO_REPORT(amt1) OVER ( PARTITION BY REGION ),2) * 100 || '% )' AS "201111",
       AMT2 || '( ' || ROUND(RATIO_TO_REPORT(amt2) OVER ( PARTITION BY REGION ),2) * 100 || '% )' AS "201112",
       AMT3 || '( ' || ROUND(RATIO_TO_REPORT(amt3) OVER ( PARTITION BY REGION ),2) * 100 || '% )' AS "201210",
       AMT4 || '( ' || ROUND(RATIO_TO_REPORT(amt4) OVER ( PARTITION BY REGION ),2) * 100 || '% )' AS "201211",
       AMT5 || '( ' || ROUND(RATIO_TO_REPORT(amt5) OVER ( PARTITION BY REGION ),2) * 100 || '% )' AS "201212",
       AMT6 || '( ' || ROUND(RATIO_TO_REPORT(amt6) OVER ( PARTITION BY REGION ),2) * 100 || '% )' AS "201310",
       AMT7 || '( ' || ROUND(RATIO_TO_REPORT(amt7) OVER ( PARTITION BY REGION ),2) * 100 || '% )' AS "201311"
FROM basis
ORDER BY REGION;