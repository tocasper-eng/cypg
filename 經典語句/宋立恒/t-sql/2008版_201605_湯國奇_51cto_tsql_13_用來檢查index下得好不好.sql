--SQL Server 2005 provides metadata about missing indexes through four dynamic management objects.


SELECT 

[Total Cost] = ROUND(avg_total_user_cost * avg_user_impact * (user_seeks + user_scans),0)


, convert(varchar(32),  statement) as TableName 

, convert(varchar(32), equality_columns) as [EqualityUsage] 

, convert( varchar(48),inequality_columns) as InequalityUsage 

, [Include Cloumns] = included_columns

, avg_user_impact

FROM    sys.dm_db_missing_index_groups g

INNER JOIN sys.dm_db_missing_index_group_stats s

ON s.group_handle = g.index_group_handle

INNER JOIN sys.dm_db_missing_index_details d

ON d.index_handle = g.index_handle
 

ORDER BY [Total Cost] DESC;

