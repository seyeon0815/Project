# [ORACLE ERROR]ORA-00937: 단일 그룹의 그룹 함수가 아닙니다

<ORA-00937: 단일 그룹의 그룹 함수가 아닙니다> 오류 발생

```sql
SELECT
      period
      , region
      , SUM(loan_jan_amt) totl_jan
FROM kor_loan_status;
```

![Untitled](%5BORACLE%20ERROR%5DORA-00937%20%E1%84%83%E1%85%A1%E1%86%AB%E1%84%8B%E1%85%B5%E1%86%AF%20%E1%84%80%E1%85%B3%E1%84%85%E1%85%AE%E1%86%B8%E1%84%8B%E1%85%B4%20%E1%84%80%E1%85%B3%E1%84%85%E1%85%AE%E1%86%B8%20%E1%84%92%E1%85%A1%E1%86%B7%E1%84%89%E1%85%AE%20b7e79dbf5f214d1f8cd2e62981edc04b/Untitled.png)

 

- SELECT SUM(loan_jan_amt), AVG(loan_jan_amt) → 그룹 함수끼리 단일 결과 확인할 경우 정상 출력 된다.
- SELECT period, SUM/AVG(loan_jan_amt)등 그룹 함수와 다른 column을 한꺼번에 출력하려면 그룹 별로 처리해야 된다.

→ ***그룹 함수가 존재하면 GROUP BY절을 작성해 그룹별로 처리해야 한다!***

 -그룹 함수 종류: AVG, SUM, MIN/MAX, STDDEV, VARIANCE, COUNT, LAST 등

**<해결 방법>**

```sql
SELECT
      period
      ,region
      ,SUM(loan_jan_amt) totl_jan
FROM kor_loan_status;
GROUP BY period, region
ORDER BY period, region; -- 생략 가능
```

![Untitled](%5BORACLE%20ERROR%5DORA-00937%20%E1%84%83%E1%85%A1%E1%86%AB%E1%84%8B%E1%85%B5%E1%86%AF%20%E1%84%80%E1%85%B3%E1%84%85%E1%85%AE%E1%86%B8%E1%84%8B%E1%85%B4%20%E1%84%80%E1%85%B3%E1%84%85%E1%85%AE%E1%86%B8%20%E1%84%92%E1%85%A1%E1%86%B7%E1%84%89%E1%85%AE%20b7e79dbf5f214d1f8cd2e62981edc04b/Untitled%201.png)

- 기간별, 지역별 TOTL_JAN(SUM(loan_jan_amt)) 확인 가능