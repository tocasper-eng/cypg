SELECT a1.Name, a1.Sales, SUM(a2.Sales) Running_Total 
FROM Total_Sales a1, Total_Sales a2 
WHERE a1.Sales <= a2.Sales OR (a1.Sales=a2.Sales AND a1.Name = a2.Name) 
GROUP BY a1.Name, a1.Sales 
ORDER BY a1.Sales DESC, a1.Name DESC;