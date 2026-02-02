SELECT 
    o.name AS TableName,
    MAX(ius.last_user_update) AS LastUpdatedTime
FROM 
    sys.dm_db_index_usage_stats ius
JOIN 
    sys.objects o ON ius.object_id = o.object_id
WHERE 
    o.type = 'U'  -- 使用者表
    AND ius.database_id = DB_ID()
    AND ius.last_user_update >= DATEADD(DAY, -3, CAST(GETDATE() AS DATE))
GROUP BY 
    o.name
ORDER BY 
    LastUpdatedTime DESC;

