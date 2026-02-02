USE [chjer]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[up_12L_set_seq]') AND type in (N'P', N'PC'))
    DROP PROCEDURE up_12L_set_seq
GO
create procedure up_12L_set_seq 
(
@num    bigint  , 
@userid nvarchar(20) 
) 
as
begin
------------------------------------------------
declare @tmpn     int          declare @seq     char(04)
declare @seqn     int          declare @nos     bigint 
declare @interest decimal(18, 2) 

update depld set tmpn = convert(int,yyyymm ) where num = @num 

set @seqn = 0 

declare cur_seq cursor for
select nos , tmpn from depld where num = @num order by tmpn,nos  
open    cur_seq
fetch next from cur_seq into @nos , @tmpn 
while ( @@fetch_status <> -1 )
begin
   set @seqn = @seqn + 10
   update deplno set seqn = .dbo.uf_strzero(@seqn,4)
   where nos = @nos 
fetch next from cur_seq into @nos , @tmpn 
end
close cur_seq
deallocate cur_seq


--檔身利息合，寫入檔頭
select @interest = sum(interest) from depld where num = @num 

update deplh set interest = @interest where num = @num 


end 


GO


