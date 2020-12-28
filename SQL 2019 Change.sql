DELETE FROM REPORTS.DBO.CDR_OUTPUT
Delete from Reports.dbo.ProspectiveTotalDonations Where [Month]<month(Getdate()) or ([Month]=month(Getdate()) and [Day]<day(Getdate()))
Delete from Reports.dbo.ProspectiveRegDonations Where [Month]<month(Getdate()) or ([Month]=month(Getdate()) and [Day]<day(Getdate()))
;
IF @TOGGLE = 1
BEGIN
INSERT INTO REPORTS.DBO.CDR_OUTPUT ([DATE],[MONTH],[MONTHNAME],[DAY],[2016WKDAY],[DAY2016A],[DAYCT2016],[CUM2016A],[MOCUM2016A],[COUNT2016],[DAY2016P],[CUM2016P],[MOCUM2016P]
      ,[DAILYBUDGET],[BUDGET2016],[MOBUDGET2016],[2015WKDAY],[DAY2015A],[DAYCT2015],[CUM2015A],[MOCUM2015A],[COUNT2015],[2014WKDAY],[DAY2014A],[DAYCT2014],[CUM2014A]
      ,[MOCUM2014A],[COUNT2014],[2013WKDAY],[DAY2013A],[DAYCT2013],[CUM2013A],[MOCUM2013A],[COUNT2013])
SELECT [DATE], [MONTH], 
[MONTHNAME] = CASE [MONTH]
				WHEN 1 THEN 'January'
				WHEN 2 THEN 'February'
				WHEN 3 THEN 'March'
				WHEN 4 THEN 'April'
				WHEN 5 THEN 'May'
				WHEN 6 THEN 'June'
				WHEN 7 THEN 'July'
				WHEN 8 THEN 'August'
				WHEN 9 THEN 'September'
				WHEN 10 THEN 'October'
				WHEN 11 THEN 'November'
				WHEN 12 THEN 'December'
				ELSE NULL END,
[DAY], [2016WKDAY], [DAY2016A], [DAYCT2016], [CUM2016A], [MOCUM2016A], [COUNT2016], coalesce([DAY2016P],[DAY2016A]) as [DAY2016P], [CUM2016P], [MOCUM2016P], [DAILYBUDGET], [BUDGET2016], [MOBUDGET2016], 
[2015WKDAY], [DAY2015A], [DAYCT2015], [CUM2015A], [MOCUM2015A], [COUNT2015],
[2014WKDAY], [DAY2014A], [DAYCT2014], [CUM2014A], [MOCUM2014A], [COUNT2014],
[2013WKDAY], [DAY2013A], [DAYCT2013], [CUM2013A], [MOCUM2013A], [COUNT2013]
FROM
(SELECT (RTRIM(CAST(COALESCE(Q.[Month],R.[Month]) as char)) + '/' + RTRIM(CAST(COALESCE(Q.[Day],R.[Day]) as char))) + '/2016' as [DATE], 
Q.[MONTH],Q.[DAY],
[2016WKDAY] = CASE 
				WHEN (RTRIM(CAST(COALESCE(Q.[Month],R.[Month]) as char)) + '/' + RTRIM(CAST(COALESCE(Q.[Day],R.[Day]) as char)))<>'2/29' THEN DATENAME(weekday,CAST('2019-'+CAST(Q.[Month] as Char)+'-'+CAST(Q.[Day] as Char) as Date))
				ELSE NULL END,
[DAY2016A] = CASE 
				WHEN GETDATE()>'2019-12-31' THEN [TotalAmount1a]
				WHEN Q.[MONTH]<MONTH(GETDATE()) THEN isnull([TotalAmount1a],0)
				WHEN Q.[MONTH]=MONTH(GETDATE()) AND Q.[DAY]<=DAY(GETDATE()) THEN [TotalAmount1a]
				ELSE NULL END,
[COUNT1] as [DAYCT2016],
[CUM2016A] = CASE 
				WHEN GETDATE()>'2019-12-31' THEN [CUM2016A]
				WHEN Q.[MONTH]<MONTH(GETDATE()) THEN [CUM2016A]
				WHEN Q.[MONTH]=MONTH(GETDATE()) AND Q.[DAY]<=DAY(GETDATE()) THEN [CUM2016A]
				ELSE NULL END,
[MOCUM2016A] = CASE 
				WHEN GETDATE()>'2019-12-31' THEN [MOCUM2016A]
				WHEN Q.[MONTH]<MONTH(GETDATE()) THEN [MOCUM2016A]
				WHEN Q.[MONTH]=MONTH(GETDATE()) AND Q.[DAY]<=DAY(GETDATE()) THEN [MOCUM2016A]
				ELSE NULL END,
[COUNT2016] = CASE 
				WHEN GETDATE()>'2019-12-31' THEN [COUNT2016]
				WHEN Q.[MONTH]<MONTH(GETDATE()) THEN [COUNT2016]
				WHEN Q.[MONTH]=MONTH(GETDATE()) AND Q.[DAY]<=DAY(GETDATE()) THEN [COUNT2016]
				ELSE NULL END,
[DAY2016P] = CASE 
				WHEN GETDATE()>'2019-12-31' THEN NULL
				WHEN Q.[MONTH]>MONTH(GETDATE()) THEN [TotalAmount1p]
				WHEN Q.[MONTH]=MONTH(GETDATE()) AND Q.[DAY]>=DAY(GETDATE()) THEN [TotalAmount1p]
				ELSE NULL END,
[CUM2016P] = CASE 
				WHEN GETDATE()>'2019-12-31' THEN NULL
				WHEN Q.[MONTH]>MONTH(GETDATE()) THEN [CUM2016P]
				WHEN Q.[MONTH]=MONTH(GETDATE()) AND Q.[DAY]>=DAY(GETDATE()) THEN [CUM2016P]
				ELSE NULL END,
[MOCUM2016P] = CASE 
				WHEN GETDATE()>'2019-12-31' THEN NULL
				WHEN Q.[MONTH]>MONTH(GETDATE()) THEN [MOCUM2016P]
				WHEN Q.[MONTH]=MONTH(GETDATE()) AND Q.[DAY]>=DAY(GETDATE()) THEN [MOCUM2016P]
				ELSE NULL END,
[DAILYBUDGET],
[BUDGETAMT] as [BUDGET2016],
[MOBUDGETAMT] as [MOBUDGET2016], 
[2015WKDAY] = CASE 
				WHEN (RTRIM(CAST(COALESCE(Q.[Month],R.[Month]) as char)) + '/' + RTRIM(CAST(COALESCE(Q.[Day],R.[Day]) as char)))<>'2/29' THEN DATENAME(weekday,CAST('2018-'+CAST(Q.[Month] as Char)+'-'+CAST(Q.[Day] as Char) as Date))
				ELSE NULL END,
ISNULL([TotalAmount2],0) as [DAY2015A], [COUNT2] as [DAYCT2015], [CUM2015A], [MOCUM2015A], ISNULL([COUNT2015],0) as [COUNT2015],
[2014WKDAY] = CASE 
				WHEN (RTRIM(CAST(COALESCE(Q.[Month],R.[Month]) as char)) + '/' + RTRIM(CAST(COALESCE(Q.[Day],R.[Day]) as char)))<>'2/29' THEN DATENAME(weekday,CAST('2017-'+CAST(Q.[Month] as Char)+'-'+CAST(Q.[Day] as Char) as Date))
				ELSE NULL END,
ISNULL([TotalAmount3],0) as [DAY2014A], [COUNT3] as [DAYCT2014], [CUM2014A], [MOCUM2014A], ISNULL([COUNT2014],0) as [COUNT2014],
[2013WKDAY] = CASE 
				WHEN (RTRIM(CAST(COALESCE(Q.[Month],R.[Month]) as char)) + '/' + RTRIM(CAST(COALESCE(Q.[Day],R.[Day]) as char)))<>'2/29' THEN DATENAME(weekday,CAST('2016-'+CAST(Q.[Month] as Char)+'-'+CAST(Q.[Day] as Char) as Date))
				ELSE NULL END,
ISNULL([TotalAmount4],0) as [DAY2013A], ISNULL([CUM2013A],0) as [CUM2013A], isnull([MOCUM2013A],0) as [MOCUM2013A], ISNULL([COUNT4],0) as [DAYCT2013], ISNULL([COUNT2013],0) as [COUNT2013]

FROM

(SELECT [MONTH], [DAY], 
TotalAmount1a, TotalAmount1p,
TotalAmount2, TotalAmount3, TotalAmount4,  Count1, Count2, Count3, Count4,
SUM(TotalAmount1a) OVER (ORDER BY [Month],[Day]) as [CUM2016A],
SUM(TotalAmount1a) OVER (PARTITION BY [Month] ORDER BY [Month],[Day]) as [MOCUM2016A],
SUM(TotalAmount1p) OVER (ORDER BY [Month],[Day]) as [CUM2016P],
SUM(TotalAmount1p) OVER (PARTITION BY [Month] ORDER BY [Month],[Day]) as [MOCUM2016P],
SUM(TotalAmount2) OVER (ORDER BY [Month],[Day]) as [CUM2015A],
SUM(TotalAmount2) OVER (PARTITION BY [Month] ORDER BY [Month],[Day]) as [MOCUM2015A],
SUM(TotalAmount3) OVER (ORDER BY [Month],[Day]) as [CUM2014A],
SUM(TotalAmount3) OVER (PARTITION BY [Month] ORDER BY [Month],[Day]) as [MOCUM2014A],
SUM(TotalAmount4) OVER (ORDER BY [Month],[Day]) as [CUM2013A],
SUM(TotalAmount4) OVER (PARTITION BY [Month] ORDER BY [Month],[Day]) as [MOCUM2013A],
SUM(Count1) OVER (ORDER BY [Month],[Day]) as [COUNT2016],
SUM(Count2) OVER (ORDER BY [Month],[Day]) as [COUNT2015],
SUM(Count3) OVER (ORDER BY [Month],[Day]) as [COUNT2014],
SUM(Count4) OVER (ORDER BY [Month],[Day]) as [COUNT2013]
 FROM

(SELECT COALESCE(AAA.[Month],BBB.[Month]) as [Month], COALESCE(AAA.[Day],BBB.[Day]) as [Day], TotalAmount1a, TotalAmount1p, 
ISNULL(TotalAmount2,0) as TotalAmount2, ISNULL(TotalAmount3,0) as TotalAmount3, ISNULL(TotalAmount4,0) as TotalAmount4, 
Count1, ISNULL(Count2,0) as Count2, ISNULL(Count3,0) as Count3, ISNULL(Count4,0) as Count4 FROM

(SELECT COALESCE(AA.[Month],BB.[Month]) as [Month], COALESCE(AA.[Day],BB.[Day]) as [Day], TotalAmount1a, TotalAmount1p, TotalAmount2, TotalAmount3, Count1, Count2, Count3 FROM

(SELECT COALESCE(A.[Month],B.[Month]) as [Month], COALESCE(A.[Day],B.[Day]) as [Day], TotalAmount1a, TotalAmount1p, TotalAmount2, Count1, Count2 FROM

(SELECT COALESCE (H.[Month],I.[Month]) as [Month], COALESCE(H.[Day],I.[Day]) as [Day], TotalAmount1p, TotalAmount1a, Count1 FROM
(SELECT COALESCE(B.[Month],C.[Month]) as [Month], COALESCE(B.[Day],C.[Day]) as [Day], COALESCE(B.[TotalAmount],C.[Amount]) as [TotalAmount1p] FROM
(SELECT MONTH(T01.[Date]) as [Month], DAY(T01.[Date]) as [Day], SUM(T04.TotalAmount)  As TotalAmount 
  FROM DS_Prod.dbo.T04_GiftDetails T04
  Join DS_prod.dbo.T01_TransactionMaster T01
  On T04.DocumentNumber = T01.DocumentNumber   
  Where ProjectCode not like '3%' and [Status] not in ('E','X') and T01.[Date] between '2019-01-01' and getdate()-1 and T01.[Date]<='2019-12-31'
  Group By YEAR(T01.[Date]), MONTH(T01.[Date]), DAY(T01.[Date])) B
  FULL JOIN
  (SELECT * FROM Reports.dbo.ProspectiveRegDonations) C
  ON B.[Month]=C.[Month] and B.[Day]=C.[Day]) H
  
  FULL JOIN
  
  (SELECT MONTH(T01.[Date]) as [Month], DAY(T01.[Date]) as [Day], SUM(T04.TotalAmount)  As TotalAmount1a, sum(DonationCt) as Count1
  FROM (SELECT *, DonationCt = CASE WHEN TotalAmount>0 THEN 1 WHEN TotalAmount<0 THEN -1 ELSE 0 END FROM DS_Prod.dbo.T04_GiftDetails) T04
  Join DS_prod.dbo.T01_TransactionMaster T01
  On T04.DocumentNumber = T01.DocumentNumber   
  Where ProjectCode not like '3%' and [Status] not in ('E','X') and YEAR(T01.[Date]) = 2019
  Group By YEAR(T01.[Date]), MONTH(T01.[Date]), DAY(T01.[Date])) I
  
  ON H.[Month]=I.[Month] and H.[Day]=I.[Day]) A

FULL JOIN

(SELECT MONTH(T01.[Date]) as [Month], DAY(T01.[Date]) as [Day], SUM(T04.TotalAmount)  As TotalAmount2, sum(DonationCt) as Count2
  FROM (SELECT *, DonationCt = CASE WHEN TotalAmount>0 THEN 1 WHEN TotalAmount<0 THEN -1 ELSE 0 END FROM DS_Prod.dbo.T04_GiftDetails) T04
  Join DS_prod.dbo.T01_TransactionMaster T01
  On T04.DocumentNumber = T01.DocumentNumber   
  Where ProjectCode not like '3%' and [Status] not in ('E','X') and YEAR(T01.[Date]) = 2018
  Group By YEAR(T01.[Date]), MONTH(T01.[Date]), DAY(T01.[Date])) B

ON A.[Month]=B.[Month] and A.[Day]=B.[Day]) AA

FULL JOIN

(SELECT MONTH(T01.[Date]) as [Month], DAY(T01.[Date]) as [Day], SUM(T04.TotalAmount)  As TotalAmount3, sum(DonationCt) as Count3
  FROM (SELECT *, DonationCt = CASE WHEN TotalAmount>0 THEN 1 WHEN TotalAmount<0 THEN -1 ELSE 0 END FROM DS_Prod.dbo.T04_GiftDetails) T04
  Join DS_prod.dbo.T01_TransactionMaster T01
  On T04.DocumentNumber = T01.DocumentNumber   
  Where ProjectCode not like '3%' and [Status] not in ('E','X') and YEAR(T01.[Date]) = 2017
  Group By YEAR(T01.[Date]), MONTH(T01.[Date]), DAY(T01.[Date])) BB

ON AA.[Month]=BB.[Month] and AA.[Day]=BB.[Day]) AAA


FULL JOIN

(SELECT MONTH(T01.[Date]) as [Month], DAY(T01.[Date]) as [Day], SUM(T04.TotalAmount)  As TotalAmount4, sum(DonationCt) as Count4
  FROM (SELECT *, DonationCt = CASE WHEN TotalAmount>0 THEN 1 WHEN TotalAmount<0 THEN -1 ELSE 0 END FROM DS_Prod.dbo.T04_GiftDetails) T04
  Join DS_prod.dbo.T01_TransactionMaster T01
  On T04.DocumentNumber = T01.DocumentNumber   
  Where ProjectCode not like '3%' and [Status] not in ('E','X') and YEAR(T01.[Date]) = 2016
  Group By YEAR(T01.[Date]), MONTH(T01.[Date]), DAY(T01.[Date])) BBB

ON AAA.[Month]=BBB.[Month] and AAA.[Day]=BBB.[Day]) Y) Q

FULL JOIN

(SELECT [MONTH], [DAY], [DAILYBUDGET], SUM([DAILYBUDGET]) OVER (ORDER BY [MONTH], [DAY]) AS BUDGETAMT,
SUM([DAILYBUDGET]) OVER (PARTITION BY [MONTH] ORDER BY [MONTH], [DAY]) AS MOBUDGETAMT FROM
(SELECT COALESCE(B.[MONTH],C.[MONTH]) as [MONTH],C.[DAY],B.[BUDGETAMT]/[MONTHDAYS] as [DAILYBUDGET] FROM
(SELECT [MONTH],
[MONTHDAYS] = CASE [MONTH]
			WHEN 1 THEN 31
			WHEN 2 THEN 29
			WHEN 3 THEN 31
			WHEN 4 THEN 30
			WHEN 5 THEN 31
			WHEN 6 THEN 30
			WHEN 7 THEN 31
			WHEN 8 THEN 31
			WHEN 9 THEN 30
			WHEN 10 THEN 31
			WHEN 11 THEN 30
			WHEN 12 THEN 31
			ELSE NULL END,
[BUDGETAMT]
FROM
(SELECT [PERIODID] as [MONTH]
      , -SUM([BALANCE]) as BUDGETAMT FROM REPORTS.DBO.FS_BRDATA 
WHERE ACTINDX IN (SELECT ACTINDX FROM LM.DBO.GL00100 WHERE ACTNUMBR_3 BETWEEN 5000 AND 5099) 
AND YEAR1=2019 AND R=@R
GROUP BY PERIODID) A) B
JOIN Reports.dbo.Dates_2019 C
ON B.[MONTH]=C.[MONTH]) D) R

ON Q.[MONTH]=R.[MONTH] and Q.[DAY]=R.[DAY]) Z
ORDER BY [MONTH], [DAY]
END

ELSE

BEGIN

INSERT INTO REPORTS.DBO.CDR_OUTPUT ([DATE],[MONTH],[MONTHNAME],[DAY],[2016WKDAY],[DAY2016A],[DAYCT2016],[CUM2016A],[MOCUM2016A],[COUNT2016],[DAY2016P],[CUM2016P],[MOCUM2016P]
      ,[DAILYBUDGET],[BUDGET2016],[MOBUDGET2016],[2015WKDAY],[DAY2015A],[DAYCT2015],[CUM2015A],[MOCUM2015A],[COUNT2015],[2014WKDAY],[DAY2014A],[DAYCT2014],[CUM2014A]
      ,[MOCUM2014A],[COUNT2014],[2013WKDAY],[DAY2013A],[DAYCT2013],[CUM2013A],[MOCUM2013A],[COUNT2013])
SELECT [DATE], [MONTH], 
[MONTHNAME] = CASE [MONTH]
				WHEN 1 THEN 'January'
				WHEN 2 THEN 'February'
				WHEN 3 THEN 'March'
				WHEN 4 THEN 'April'
				WHEN 5 THEN 'May'
				WHEN 6 THEN 'June'
				WHEN 7 THEN 'July'
				WHEN 8 THEN 'August'
				WHEN 9 THEN 'September'
				WHEN 10 THEN 'October'
				WHEN 11 THEN 'November'
				WHEN 12 THEN 'December'
				ELSE NULL END,
[DAY], [2016WKDAY], [DAY2016A], [DAYCT2016], [CUM2016A], [MOCUM2016A], [COUNT2016], coalesce([DAY2016P],[DAY2016A]) as [DAY2016P], [CUM2016P], [MOCUM2016P], [DAILYBUDGET], [BUDGET2016], [MOBUDGET2016], 
[2015WKDAY], [DAY2015A], [DAYCT2015], [CUM2015A], [MOCUM2015A], [COUNT2015],
[2014WKDAY], [DAY2014A], [DAYCT2014], [CUM2014A], [MOCUM2014A], [COUNT2014],
[2013WKDAY], [DAY2013A], [DAYCT2013], [CUM2013A], [MOCUM2013A], [COUNT2013]
FROM
(SELECT (RTRIM(CAST(COALESCE(Q.[Month],R.[Month]) as char)) + '/' + RTRIM(CAST(COALESCE(Q.[Day],R.[Day]) as char))) + '/2016' as [DATE], 
Q.[MONTH],Q.[DAY],
[2016WKDAY] = CASE 
				WHEN (RTRIM(CAST(COALESCE(Q.[Month],R.[Month]) as char)) + '/' + RTRIM(CAST(COALESCE(Q.[Day],R.[Day]) as char)))<>'2/29' THEN DATENAME(weekday,CAST('2019-'+CAST(Q.[Month] as Char)+'-'+CAST(Q.[Day] as Char) as Date))
				ELSE NULL END,
[DAY2016A] = CASE 
				WHEN GETDATE()>'2019-12-31' THEN [TotalAmount1a]
				WHEN Q.[MONTH]<MONTH(GETDATE()) THEN isnull([TotalAmount1a],0)
				WHEN Q.[MONTH]=MONTH(GETDATE()) AND Q.[DAY]<=DAY(GETDATE()) THEN [TotalAmount1a]
				ELSE NULL END,
[COUNT1] as [DAYCT2016],
[CUM2016A] = CASE 
				WHEN GETDATE()>'2019-12-31' THEN [CUM2016A]
				WHEN Q.[MONTH]<MONTH(GETDATE()) THEN [CUM2016A]
				WHEN Q.[MONTH]=MONTH(GETDATE()) AND Q.[DAY]<=DAY(GETDATE()) THEN [CUM2016A]
				ELSE NULL END,
[MOCUM2016A] = CASE 
				WHEN GETDATE()>'2019-12-31' THEN [MOCUM2016A]
				WHEN Q.[MONTH]<MONTH(GETDATE()) THEN [MOCUM2016A]
				WHEN Q.[MONTH]=MONTH(GETDATE()) AND Q.[DAY]<=DAY(GETDATE()) THEN [MOCUM2016A]
				ELSE NULL END,
[COUNT2016] = CASE 
				WHEN GETDATE()>'2019-12-31' THEN [COUNT2016]
				WHEN Q.[MONTH]<MONTH(GETDATE()) THEN [COUNT2016]
				WHEN Q.[MONTH]=MONTH(GETDATE()) AND Q.[DAY]<=DAY(GETDATE()) THEN [COUNT2016]
				ELSE NULL END,
[DAY2016P] = CASE 
				WHEN GETDATE()>'2019-12-31' THEN NULL
				WHEN Q.[MONTH]>MONTH(GETDATE()) THEN [TotalAmount1p]
				WHEN Q.[MONTH]=MONTH(GETDATE()) AND Q.[DAY]>=DAY(GETDATE()) THEN [TotalAmount1p]
				ELSE NULL END,
[CUM2016P] = CASE 
				WHEN GETDATE()>'2019-12-31' THEN NULL
				WHEN Q.[MONTH]>MONTH(GETDATE()) THEN [CUM2016P]
				WHEN Q.[MONTH]=MONTH(GETDATE()) AND Q.[DAY]>=DAY(GETDATE()) THEN [CUM2016P]
				ELSE NULL END,
[MOCUM2016P] = CASE 
				WHEN GETDATE()>'2019-12-31' THEN NULL
				WHEN Q.[MONTH]>MONTH(GETDATE()) THEN [MOCUM2016P]
				WHEN Q.[MONTH]=MONTH(GETDATE()) AND Q.[DAY]>=DAY(GETDATE()) THEN [MOCUM2016P]
				ELSE NULL END,
[DAILYBUDGET],
[BUDGETAMT] as [BUDGET2016],
[MOBUDGETAMT] as [MOBUDGET2016], 
[2015WKDAY] = CASE 
				WHEN (RTRIM(CAST(COALESCE(Q.[Month],R.[Month]) as char)) + '/' + RTRIM(CAST(COALESCE(Q.[Day],R.[Day]) as char)))<>'2/29' THEN DATENAME(weekday,CAST('2018-'+CAST(Q.[Month] as Char)+'-'+CAST(Q.[Day] as Char) as Date))
				ELSE NULL END,
ISNULL([TotalAmount2],0) as [DAY2015A], [COUNT2] as [DAYCT2015], [CUM2015A], [MOCUM2015A], ISNULL([COUNT2015],0) as [COUNT2015],
[2014WKDAY] = CASE 
				WHEN (RTRIM(CAST(COALESCE(Q.[Month],R.[Month]) as char)) + '/' + RTRIM(CAST(COALESCE(Q.[Day],R.[Day]) as char)))<>'2/29' THEN DATENAME(weekday,CAST('2017-'+CAST(Q.[Month] as Char)+'-'+CAST(Q.[Day] as Char) as Date))
				ELSE NULL END,
ISNULL([TotalAmount3],0) as [DAY2014A], [COUNT3] as [DAYCT2014], [CUM2014A], [MOCUM2014A], ISNULL([COUNT2014],0) as [COUNT2014],
[2013WKDAY] = CASE 
				WHEN (RTRIM(CAST(COALESCE(Q.[Month],R.[Month]) as char)) + '/' + RTRIM(CAST(COALESCE(Q.[Day],R.[Day]) as char)))<>'2/29' THEN DATENAME(weekday,CAST('2016-'+CAST(Q.[Month] as Char)+'-'+CAST(Q.[Day] as Char) as Date))
				ELSE NULL END,
ISNULL([TotalAmount4],0) as [DAY2013A], ISNULL([CUM2013A],0) as [CUM2013A], isnull([MOCUM2013A],0) as [MOCUM2013A], ISNULL([COUNT4],0) as [DAYCT2013], ISNULL([COUNT2013],0) as [COUNT2013]

FROM

(SELECT [MONTH], [DAY], 
TotalAmount1a, TotalAmount1p,
TotalAmount2, TotalAmount3, TotalAmount4,  Count1, Count2, Count3, Count4,
SUM(TotalAmount1a) OVER (ORDER BY [Month],[Day]) as [CUM2016A],
SUM(TotalAmount1a) OVER (PARTITION BY [Month] ORDER BY [Month],[Day]) as [MOCUM2016A],
SUM(TotalAmount1p) OVER (ORDER BY [Month],[Day]) as [CUM2016P],
SUM(TotalAmount1p) OVER (PARTITION BY [Month] ORDER BY [Month],[Day]) as [MOCUM2016P],
SUM(TotalAmount2) OVER (ORDER BY [Month],[Day]) as [CUM2015A],
SUM(TotalAmount2) OVER (PARTITION BY [Month] ORDER BY [Month],[Day]) as [MOCUM2015A],
SUM(TotalAmount3) OVER (ORDER BY [Month],[Day]) as [CUM2014A],
SUM(TotalAmount3) OVER (PARTITION BY [Month] ORDER BY [Month],[Day]) as [MOCUM2014A],
SUM(TotalAmount4) OVER (ORDER BY [Month],[Day]) as [CUM2013A],
SUM(TotalAmount4) OVER (PARTITION BY [Month] ORDER BY [Month],[Day]) as [MOCUM2013A],
SUM(Count1) OVER (ORDER BY [Month],[Day]) as [COUNT2016],
SUM(Count2) OVER (ORDER BY [Month],[Day]) as [COUNT2015],
SUM(Count3) OVER (ORDER BY [Month],[Day]) as [COUNT2014],
SUM(Count4) OVER (ORDER BY [Month],[Day]) as [COUNT2013]
 FROM

(SELECT COALESCE(AAA.[Month],BBB.[Month]) as [Month], COALESCE(AAA.[Day],BBB.[Day]) as [Day], TotalAmount1a, TotalAmount1p, 
ISNULL(TotalAmount2,0) as TotalAmount2, ISNULL(TotalAmount3,0) as TotalAmount3, ISNULL(TotalAmount4,0) as TotalAmount4, 
Count1, ISNULL(Count2,0) as Count2, ISNULL(Count3,0) as Count3, ISNULL(Count4,0) as Count4 FROM

(SELECT COALESCE(AA.[Month],BB.[Month]) as [Month], COALESCE(AA.[Day],BB.[Day]) as [Day], TotalAmount1a, TotalAmount1p, TotalAmount2, TotalAmount3, Count1, Count2, Count3 FROM

(SELECT COALESCE(A.[Month],B.[Month]) as [Month], COALESCE(A.[Day],B.[Day]) as [Day], TotalAmount1a, TotalAmount1p, TotalAmount2, Count1, Count2 FROM

(SELECT COALESCE (H.[Month],I.[Month]) as [Month], COALESCE(H.[Day],I.[Day]) as [Day], TotalAmount1p, TotalAmount1a, Count1 FROM
(SELECT COALESCE(B.[Month],C.[Month]) as [Month], COALESCE(B.[Day],C.[Day]) as [Day], COALESCE(B.[TotalAmount],C.[Amount]) as [TotalAmount1p] FROM
(SELECT MONTH(T01.[Date]) as [Month], DAY(T01.[Date]) as [Day], SUM(T04.TotalAmount)  As TotalAmount 
  FROM DS_Prod.dbo.T04_GiftDetails T04
  Join DS_prod.dbo.T01_TransactionMaster T01
  On T04.DocumentNumber = T01.DocumentNumber   
  Where [Status] not in ('E','X') and T01.[Date] between '2019-01-01' and getdate()-1 and T01.[Date]<='2019-12-31'
  Group By YEAR(T01.[Date]), MONTH(T01.[Date]), DAY(T01.[Date])) B
  FULL JOIN
  (SELECT * FROM Reports.dbo.ProspectiveTotalDonations) C
  ON B.[Month]=C.[Month] and B.[Day]=C.[Day]) H
  
  FULL JOIN
  
  (SELECT MONTH(T01.[Date]) as [Month], DAY(T01.[Date]) as [Day], SUM(T04.TotalAmount)  As TotalAmount1a, sum(DonationCt) as Count1
  FROM (SELECT *, DonationCt = CASE WHEN TotalAmount>0 THEN 1 WHEN TotalAmount<0 THEN -1 ELSE 0 END FROM DS_Prod.dbo.T04_GiftDetails) T04
  Join DS_prod.dbo.T01_TransactionMaster T01
  On T04.DocumentNumber = T01.DocumentNumber   
  Where [Status] not in ('E','X') and YEAR(T01.[Date]) = 2019
  Group By YEAR(T01.[Date]), MONTH(T01.[Date]), DAY(T01.[Date])) I
  
  ON H.[Month]=I.[Month] and H.[Day]=I.[Day]) A

FULL JOIN

(SELECT MONTH(T01.[Date]) as [Month], DAY(T01.[Date]) as [Day], SUM(T04.TotalAmount)  As TotalAmount2, sum(DonationCt) as Count2
  FROM (SELECT *, DonationCt = CASE WHEN TotalAmount>0 THEN 1 WHEN TotalAmount<0 THEN -1 ELSE 0 END FROM DS_Prod.dbo.T04_GiftDetails) T04
  Join DS_prod.dbo.T01_TransactionMaster T01
  On T04.DocumentNumber = T01.DocumentNumber   
  Where [Status] not in ('E','X') and YEAR(T01.[Date]) = 2018
  Group By YEAR(T01.[Date]), MONTH(T01.[Date]), DAY(T01.[Date])) B

ON A.[Month]=B.[Month] and A.[Day]=B.[Day]) AA

FULL JOIN

(SELECT MONTH(T01.[Date]) as [Month], DAY(T01.[Date]) as [Day], SUM(T04.TotalAmount)  As TotalAmount3, sum(DonationCt) as Count3
  FROM (SELECT *, DonationCt = CASE WHEN TotalAmount>0 THEN 1 WHEN TotalAmount<0 THEN -1 ELSE 0 END FROM DS_Prod.dbo.T04_GiftDetails) T04
  Join DS_prod.dbo.T01_TransactionMaster T01
  On T04.DocumentNumber = T01.DocumentNumber   
  Where [Status] not in ('E','X') and YEAR(T01.[Date]) = 2017
  Group By YEAR(T01.[Date]), MONTH(T01.[Date]), DAY(T01.[Date])) BB

ON AA.[Month]=BB.[Month] and AA.[Day]=BB.[Day]) AAA


FULL JOIN

(SELECT MONTH(T01.[Date]) as [Month], DAY(T01.[Date]) as [Day], SUM(T04.TotalAmount)  As TotalAmount4, sum(DonationCt) as Count4
  FROM (SELECT *, DonationCt = CASE WHEN TotalAmount>0 THEN 1 WHEN TotalAmount<0 THEN -1 ELSE 0 END FROM DS_Prod.dbo.T04_GiftDetails) T04
  Join DS_prod.dbo.T01_TransactionMaster T01
  On T04.DocumentNumber = T01.DocumentNumber   
  Where [Status] not in ('E','X') and YEAR(T01.[Date]) = 2016
  Group By YEAR(T01.[Date]), MONTH(T01.[Date]), DAY(T01.[Date])) BBB

ON AAA.[Month]=BBB.[Month] and AAA.[Day]=BBB.[Day]) Y) Q

FULL JOIN

(SELECT [MONTH], [DAY], [DAILYBUDGET], SUM([DAILYBUDGET]) OVER (ORDER BY [MONTH], [DAY]) AS BUDGETAMT,
SUM([DAILYBUDGET]) OVER (PARTITION BY [MONTH] ORDER BY [MONTH], [DAY]) AS MOBUDGETAMT FROM
(SELECT COALESCE(B.[MONTH],C.[MONTH]) as [MONTH],C.[DAY],B.[BUDGETAMT]/[MONTHDAYS] as [DAILYBUDGET] FROM
(SELECT [MONTH],
[MONTHDAYS] = CASE [MONTH]
			WHEN 1 THEN 31
			WHEN 2 THEN 29
			WHEN 3 THEN 31
			WHEN 4 THEN 30
			WHEN 5 THEN 31
			WHEN 6 THEN 30
			WHEN 7 THEN 31
			WHEN 8 THEN 31
			WHEN 9 THEN 30
			WHEN 10 THEN 31
			WHEN 11 THEN 30
			WHEN 12 THEN 31
			ELSE NULL END,
[BUDGETAMT]
FROM
(SELECT [PERIODID] as [MONTH]
      , -SUM([BALANCE]) as BUDGETAMT FROM REPORTS.DBO.FS_BRDATA 
WHERE ACTINDX IN (SELECT ACTINDX FROM LM.DBO.GL00100 WHERE (ACTNUMBR_3 BETWEEN 5000 AND 5099) OR (ACTNUMBR_3 between 3020 and 4000))
AND YEAR1=2019 AND R=@R
GROUP BY PERIODID) A) B
JOIN Reports.dbo.Dates_2019 C
ON B.[MONTH]=C.[MONTH]) D) R

ON Q.[MONTH]=R.[MONTH] and Q.[DAY]=R.[DAY]) Z
ORDER BY [MONTH], [DAY]
END
;
SELECT *, CAVG2016 = CASE WHEN LINE<=DATEDIFF(day,'2018-12-31',@LineDate) THEN LINE * AVG2016A ELSE NULL END
FROM
((SELECT *, ROW_NUMBER() OVER (ORDER BY [MONTH] ASC, [DAY] ASC) AS LINE
FROM REPORTS.DBO.CDR_OUTPUT) A
CROSS JOIN
(SELECT AVG2016A =CUM2016A/ DATEDIFF(day,'2018-12-31',@LineDate) FROM
(SELECT [DATE], CUM2016A, MOCUM2016A, ROW_NUMBER() OVER (ORDER BY [MONTH] ASC, [DAY] ASC) AS LINE FROM REPORTS.DBO.CDR_OUTPUT) A
WHERE LINE = DATEDIFF(day,'2018-12-31',@LineDate)) B)
ORDER BY MONTH ASC, DAY ASC