WITH top5 (kunnt, cnt) AS (
    SELECT TOP 5 kunnr, COUNT(*) as cnt 
    FROM saleorderheader 
    GROUP BY kunnr 
    ORDER BY COUNT(*) DESC
),
前五大的訂單號 (vbeln) AS (
    SELECT vbeln 
    FROM saleorderheader 
    WHERE kunnr IN (SELECT kunnt FROM top5)
)
SELECT TOP 5 matnr, SUM(netpr) AS total_netpr, COUNT(*) AS cnt 
FROM saleorderitem
WHERE vbeln IN (SELECT vbeln FROM 前五大的訂單號)
GROUP BY matnr  
ORDER BY total_netpr DESC;
