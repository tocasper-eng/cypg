SELECT 
    OBJECT_NAME(m.object_id) AS ProcedureName,
    o.type_desc AS ObjectType,
    m.definition AS ProcedureScript
FROM sys.sql_modules m
JOIN sys.objects o ON m.object_id = o.object_id
WHERE m.definition LIKE '%debitc%'
