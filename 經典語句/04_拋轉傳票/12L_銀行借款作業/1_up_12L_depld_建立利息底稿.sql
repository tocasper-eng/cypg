USE [CHJER]
GO
DROP PROCEDURE up_12L_depld
GO
create procedure up_12L_depld 
(
@num bigint          ,  
@userid nvarchar(20) 
)
--casper--
as
begin

declare @sqlpass    varchar(255)       declare @deplno char(08) 
declare @chjernoi   nvarchar(48)       declare @cnt    int 
declare @stat1      int           

declare @yyyymm     char(06) 
declare @yyyymmfm   char(06) 
declare @yyyymmto   char(06)
declare @datefm    char(08) 
declare @dateto    char(08)

declare @ym table ( yyyymm char(06) )


select @datefm   = datefm  , 
       @dateto   = dateto  ,
	   @deplno   = deplno  ,
	   @chjernoi = chjernoi 
from deplh 
where num = @num 

set @yyyymmfm = substring(@datefm,1,6) 
set @yyyymmto = substring(@dateto,1,6) 

set @yyyymm = @yyyymmfm 


while ( @yyyymm <= @yyyymmto ) 
begin 
   insert into @ym ( yyyymm ) values ( @yyyymm ) 
   set @yyyymm = chjer.dbo.uf_yyyymmn(@yyyymm) 
end 

 
declare c_12L    cursor for 
select yyyymm from @ym order by yyyymm 
open c_12L
fetch next from c_12L into  @yyyymm 
set @stat1 = @@fetch_status
while @stat1 = 0 
begin
   select @cnt = count(*) from depld 
   where deplno = @deplno and yyyymm=@yyyymm 
   if @cnt=0 
      insert into depld( deplno , num , yyyymm , chjernoi  ) 
	  values ( @deplno , @num , @yyyymm , @chjernoi  )
fetch next from c_12L into  @yyyymm 
set @stat1 = @@fetch_status
end
close c_12L
deallocate c_12L



--序號重排 
 

exec chjer.dbo.up_12L_set_seq @num ,  @userid 

end

--加寫 rzh 
--加寫 pzh 
--核准時，產生 重估傳票
--同時產生回轉傳票也無妨。
--借力使力，用此程序，只是 傳票號碼要回寫到 ach
--up_fb08_迴轉傳票










GO


