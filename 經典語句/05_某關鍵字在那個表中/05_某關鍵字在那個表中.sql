DECLARE @SearchStr NVARCHAR(100) = N'TE202503050001'
DECLARE @SQL NVARCHAR(MAX) = N''
 

 
SELECT @SQL = @SQL +
'IF EXISTS (SELECT 1 FROM [' + s.name + '].[' + t.name + '] WHERE [' + c.name + '] LIKE N''%' + @SearchStr + '%'')
    PRINT ''[資料表: ' + s.name + '.' + t.name + '] 欄位: ' + c.name + '''' + CHAR(13) + CHAR(10)

FROM sys.columns c
JOIN sys.tables t ON c.object_id = t.object_id
JOIN sys.schemas s ON t.schema_id = s.schema_id
JOIN sys.types ty ON c.user_type_id = ty.user_type_id
WHERE ty.name IN ('varchar', 'nvarchar', 'text', 'ntext')
and  t.name not like '%tmp%'and     T.name not like '%TEMP%'  
--AND C.name IN('SELLID','ORDERID','email','WAYORDERID')
EXEC sp_executesql @SQL
