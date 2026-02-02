USE cgu 
GO
DROP PROCEDURE up_業績報表

gO
/*
select * from 標的
exec .dbo.up_業績報表
*/
create PROCEDURE up_業績報表  
as
begin
declare @num bigint 


declare @業績 table ( 業務  nvarchar(20) ,  地號  nvarchar(20) , 獎金  int ) 


insert into  @業績 (業務    ,  地號     ) 
select 業務, 地號 
from 標的 
where isnull(屋主,'')<>''

update  @業績  set 獎金 = convert( int , substring(地號,2,3) )  * 100 


select * from  @業績

--declare cur_區域 cursor for
--select num   from 區域  
----where num between 1 to 10 
--order by num 
--open    cur_區域   --資料的第0列
--fetch next from cur_區域 into @num   --下一列
--while ( @@fetch_status <> -1 ) -- 若到最末列的下一筆
--begin
--	exec .dbo.up_傳入區域_更新標的  @num 
--fetch next from cur_區域 into @num   --下一列
--end
--close cur_區域
--deallocate cur_區域
END

GO


