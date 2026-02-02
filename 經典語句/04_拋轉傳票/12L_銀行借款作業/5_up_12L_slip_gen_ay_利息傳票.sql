USE [CHJER]
GO

DROP PROCEDURE up_12L_slip_gen_ay
GO
--exec  chjer.dbo.up_12L_slip_gen_ay 'ac2102H001','casper'
create procedure up_12L_slip_gen_ay 
( 
@yyyymm  char(06)     , 
@group2  char(02)     , 
@userid  nvarchar(20)
)
--casper--
as
begin

--01.宣告變數
declare @cnt     int           declare @ustono     nvarchar(96)  declare @swt        char(04)
declare @datee   char(08)      declare @yyyymm_85z char(06)      declare @seqn       int 
declare @slipnoe varchar(20)   declare @slipno2    varchar(20)   declare @accino     char(06)  
declare @sqlpass varchar(1024) declare @slipno     varchar(20)   declare @remark     nvarchar(255)
declare @num_25a bigint        declare @dateto     char(08)      declare @chjernoi   nvarchar(48)
declare @currno  char(03)      declare @exrate     decimal(20,6) declare @accinm     nvarchar(36) 
declare @currno2 char(03)      declare @exrate2    decimal(20,6) declare @code       char(08) 
declare @stat1   int           declare @stat2      int           declare @textz      nvarchar(36)
declare @seq     char(04)      declare @num        bigint        declare @nos        bigint 

declare @compno    nvarchar(48)        --公司代碼
declare @deplno    char(08)            --借款編號
declare @deplnm    nvarchar(48)        --借款說明
declare @datec     char(08)            --借款日期
declare @rate      decimal(12, 4)      --利息年率
declare @interest  decimal(18, 2)      --利息總額
declare @amt       decimal(18, 2)      --借款總額
declare @depano    char(6)             --傳票部門 91A
declare @depanm    nvarchar(20)        --部門名稱 91A 
declare @accinod   char(06)            --銀行存款 92A 
declare @accinmd   nvarchar(36)        --銀行存款 92A
declare @banknod   char(08)            --銀行帳戶 91F
declare @banknmd   nvarchar(20)        --帳戶名稱 91F
declare @accinoc   char(06)            --銀行借款 92A
declare @accinmc   nvarchar(36)        --銀行借款 92A 
declare @slipno2a  nvarchar(20)        --取得傳票
declare @codeno    nvarchar(20) 
declare @codenm    nvarchar(20)  
declare @remano    nvarchar(20)
declare @remanm    nvarchar(20) 
declare @relano    nvarchar(20) 
declare @dates     char(08) 


--02.設定初值
set @swt    = '12LA'
set @ustono= 'up_12L_slip_gen_ay'
exec chjer.dbo.up_usto_delete @userid,@ustono, '' , '' , ''

set @yyyymm_85z = chjer.dbo.uf_get_85z()

if  @yyyymm_85z >= @yyyymm
begin
   set @sqlpass = '傳票日已成本結算。不可核准。'
   exec chjer.dbo.up_usto_insert @userid,@ustono, 'A' , @sqlpass , @sqlpass  
   return
end


declare @deplh table ( deplno char(08) , slipno2a varchar(20) )

insert into @deplh ( deplno , slipno2a )
select deplno , slipno2a 
from deplh 
where chjer.dbo.uf_depa_group2(depano) = @group2 
and   @yyyymm between datefm and dateto 

select @cnt = count(*) from @deplh where isnull(slipno2a,'')<>'' 
if  @cnt >= 1
begin
   set @sqlpass = '已產生傳票，請先取消傳票。'
   exec chjer.dbo.up_usto_insert @userid,@ustono, 'A' , @sqlpass , @sqlpass  
   return
end


--利息日期算在月底
set @datec = chjer.dbo.uf_lastday(@yyyymm+'01') 

--09.設定傳票流水號
set @slipno2 = chjer.dbo.uf_get_stype(@swt,@deplno)

--10.刪除已建檔傳票
delete slip where slipno2=@slipno2
delete slis where slipno2=@slipno2

--11.建立傳票主檔
insert into slip ( slipno2 ,  swt ,  datec ,group2    ,  userid  )
          values (@slipno2 , @swt , @datee ,@group2   , @userid  ) 


set @currno  = chjer.dbo.uf_currno()
set @exrate  = 1 
set @currno2 = chjer.dbo.uf_currno()
set @exrate2 = 1 

set @seqn = 0 

-----------------------------------------------------
declare m12La cursor for 
select  deplno , deplnm  , depano   , depanm , banknmd , num    ,
        datec  , dateto  , amt      , rate   , accino  , accinm 
from deplh 
where deplno in ( select deplno from @deplh ) order by deplno 
open    m12La 
fetch next from m12La into @deplno , @deplnm  , @depano   , @depanm  , @banknmd  , @num    ,
                           @datec  , @dateto  , @amt      , @rate    , @accino   , @accinm 
set @stat1 = @@fetch_status
while ( @stat1 <> -1 )
begin

   set @relano = @deplno  --借款編號
   set @dates  = @dateto  --還款日期
   set @remark =  '支付借款利息:'+@yyyymm+','+
                  '借款編號:'+@deplno+',借款銀行:'+@banknmd+
                  '金額:'+convert(varchar(20),@amt)+
   			      '利率:'+convert(varchar(20),@rate)+
   			      '借款日:'+@datec+
   			      '還款日:'+@dateto


   declare m12La2 cursor for 
   select  nos , interest , accinoc , accinmc , code , textz 
   from depld 
   where deplno = @deplno and yyyymm = @yyyymm and isnull(interest,0)<>0 
   open    m12La2 
   fetch next from m12La2 into @nos , @interest , @accinoc , @accinmc  , @code , @textz 
   set @stat2 = @@fetch_status
   while ( @stat2 <> -1 )
   begin
      set @seqn  =  @seqn + 10 
      set @seq   = chjer.dbo.uf_strzero(@seqn,4) 

	  --借：利息費用 
      insert into slis
      (
      slipno2		  ,seq			  ,depano		  ,depanm		  ,
      accino		  ,accinm		  ,code		      ,textz		  ,
      codeno		  ,codenm		  ,remano		  ,remanm		  ,
      relano		  ,dates		  ,remark		  ,swt			  ,
      db_amt		  ,cr_amt		  ,amt			  ,amt2		      ,
      currno		  ,exrate		  ,currno2		  ,exrate2		  ,
      db_amt2		  ,cr_amt2		  ,zoomnm		  ,sono2          ,
      itemno        ,qty            ,chjernoi	      ,compno		  
      )
      values (
      @slipno2        ,@seq     	  ,@depano		  ,@depanm		  ,
      @accino         ,@accinm 	  ,@deplno        ,@deplnm        ,
      @codeno		  ,@codenm		  ,@remano		  ,@remanm		  ,
      @relano		  ,@dates		  ,@remark		  ,@swt			  ,
      @interest	      ,0       	      ,@interest 	  ,0              ,
      @currno		  ,@exrate		  ,@currno2 	  ,@exrate2	      ,	  
      @interest  	  ,0      		  ,@depano   	  ,@depano        ,
      ''              ,0              ,@chjernoi	  ,@compno		  
      ) 
      
      set @seqn  =  @seqn + 10 
      set @seq   = chjer.dbo.uf_strzero(@seqn,4) 
      
      --貸：銀行存款，銀行子目
      insert into slis
      (
      slipno2		  ,seq			  ,depano		  ,depanm		  ,
      accino		  ,accinm		  ,code		      ,textz		  ,
      codeno		  ,codenm		  ,remano		  ,remanm		  ,
      relano		  ,dates		  ,remark		  ,swt			  ,
      db_amt		  ,cr_amt		  ,amt			  ,amt2		      ,
      currno		  ,exrate		  ,currno2		  ,exrate2		  ,
      db_amt2		  ,cr_amt2		  ,zoomnm		  ,sono2          ,
      itemno        ,qty            ,chjernoi	      ,compno		  
      )
      values (
      @slipno2        ,@seq     	  ,@depano		  ,@depanm		  ,
      @accinoc	      ,@accinmc 	  ,@deplno        ,@deplnm        ,
      @codeno		  ,@codenm		  ,@remano		  ,@remanm		  ,
      @relano		  ,@dates		  ,@remark		  ,@swt			  ,
      0               ,@interest		      ,0       	      ,@interest			  ,
      @currno		  ,@exrate		  ,@currno2 	  ,@exrate2	      ,	  
      0               ,@interest 		  ,@depano   	  ,@depano        ,
      ''              ,0              ,@chjernoi	  ,@compno		  
      ) 

	  update depld set slipno2 = @slipno2 where nos = @nos 


   fetch next from m12La2 into @nos , @interest , @accinoc , @accinmc  , @code , @textz 
   set @stat2 = @@fetch_status
   end
   close m12La2 
   deallocate m12La2

   update deplh set  slipno2a = @slipno2 where num = @num 

fetch next from m12La into @deplno , @deplnm  , @depano   , @depanm  , @banknmd  , 
                           @datec  , @dateto  , @amt      , @rate    , @accino   , @accinm 
set @stat1 = @@fetch_status
end
close m12La 
deallocate m12La 



--16.序號重排
EXEC chjer.dbo.up_set_slis_seq @slipno2 , 'Y'


--18.自動製審核
select @num_25a=num from slip where slipno2=@slipno2

exec chjer.dbo.up_25a_code_m_y @num_25a , @userid 
exec chjer.dbo.up_25a_code_s_y @num_25a , @userid 
exec chjer.dbo.up_25a_code_z_y @num_25a , @userid 

--19.傳票核准成功
select @slipno=slipno from slip where slipno2=@slipno2   and ISNULL(code_z,'')='Y' 

--20.回寫單據之傳票編號
if chjer.dbo.uf_empty(@slipno)='Y'
begin 
   set @sqlpass = '沒有核准成功。'+@slipno2 
   exec chjer.dbo.up_usto_insert @userid,@ustono, 'A' , @sqlpass , @sqlpass 
   return
end
else 
   update deplh set slipnoa=@slipno  where slipno2a = @slipno2 
   update depld set slipno =@slipno  where slipno2  = @slipno2 

end 



GO


