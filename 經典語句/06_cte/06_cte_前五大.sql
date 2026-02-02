WITH top5 (custno, cnt) AS (
    SELECT TOP 5 custno , COUNT(*) as cnt 
    FROM sdh 
    GROUP BY custno 
    ORDER BY COUNT(*) DESC
),
前五大的訂單號 (vbeln) AS (
    SELECT sdno 
    FROM sdh  
    WHERE custno IN (SELECT custno  FROM top5)
)
SELECT TOP 5 itemno , SUM(sdqty) AS qty, COUNT(*) AS cnt 
FROM sdt 
WHERE sdno IN (SELECT sdno FROM 前五大的訂單號)
GROUP BY itemno  
ORDER BY qty DESC;

--select * from sdh 
--select * from sdd

