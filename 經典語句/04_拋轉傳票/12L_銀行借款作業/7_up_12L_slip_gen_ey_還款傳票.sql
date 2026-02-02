USE [CHJER]
GO

DROP PROCEDURE up_12L_slip_gen_ey
GO
--exec  chjer.dbo.up_12L_slip_gen_ey 'ac2102H001','casper'
create procedure up_12L_slip_gen_ey 
( 
@num     bigint , 
@userid  nvarchar(20)
)
--casper--
as
begin

--01.宣告變數
declare @cnt     int           declare @ustono    nvarchar(96)  declare @swt        char(04)
declare @datee   char(08)      declare @yyyymm    char(06)      declare @yyyymm_85z char(06) 
declare @slipnoe varchar(20)   declare @slipno2   varchar(20)   declare @group2     varchar(02)
declare @sqlpass varchar(1024) declare @slipno    varchar(20)   declare @remark     nvarchar(255)
declare @num_25a bigint        declare @dateto    char(08)      declare @chjernoi   nvarchar(48)
declare @currno  char(03)      declare @exrate    decimal(20,6) 
declare @currno2 char(03)      declare @exrate2   decimal(20,6) 

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
declare @slipno2z  nvarchar(20)        --取得傳票
declare @codeno    nvarchar(20) 
declare @codenm    nvarchar(20)  
declare @remano    nvarchar(20)
declare @remanm    nvarchar(20) 
declare @relano    nvarchar(20) 
declare @dates     char(08) 



--02.設定初值
set @swt    = '12LE'
set @ustono= 'up_12L_slip_gen_ey'
exec chjer.dbo.up_usto_delete @userid,@ustono, '' , '' , ''

--03.取出主檔
select 
@compno   = compno   ,--公司代碼
@deplno   = deplno   ,--借款編號
@deplnm   = deplnm   ,--借款說明
@datec    = datec    ,--借款日期
@dateto   = dateto   ,--還款日期
@rate     = rate     ,--利息年率
@interest = interest  ,--利息總額
@amt      = amt      ,--借款總額
@depano   = depano   ,--傳票部門 91A
@depanm   = depanm   ,--部門名稱 91A 
@accinod  = accinod  ,--銀行存款 92A 
@accinmd  = accinmd  ,--銀行存款 92A
@banknod  = banknod  ,--銀行帳戶 91F
@banknmd  = banknmd  ,--帳戶名稱 91F
@accinoc  = accinoc  ,--銀行借款 92A
@accinmc  = accinmc  ,--銀行借款 92A 
@slipno2z = slipno2z  --取得傳票
from deplh 
where num = @num 

set @group2 = chjer.dbo.uf_depa_group2(@depano) 

set @yyyymm     = substring(@datec,1,06)
set @yyyymm_85z = chjer.dbo.uf_get_85z()

if  @yyyymm_85z >= @yyyymm
begin
   set @sqlpass = '傳票日已成本結算。不可核准。'
   exec chjer.dbo.up_usto_insert @userid,@ustono, 'A' , @sqlpass , @sqlpass  
   return
end

--09.設定傳票流水號
set @slipno2 = chjer.dbo.uf_get_stype(@swt,@deplno)

--10.刪除已建檔傳票
delete slip where slipno2=@slipno2
delete slis where slipno2=@slipno2

--11.建立傳票主檔
insert into slip ( slipno2 ,  swt ,  datec ,group2    ,  userid  )
          values (@slipno2 , @swt , @datee ,@group2   , @userid  ) 


set @relano = @deplno  --借款編號
set @dates  = @dateto  --還款日期
set @remark = '借款編號:'+@deplno+',借款銀行:'+@banknmd+
              '金額:'+convert(varchar(20),@amt)+
			  '利率:'+convert(varchar(20),@rate)+
			  '借款日:'+@datec+
			  '還款日:'+@dateto

set @currno  = chjer.dbo.uf_currno()
set @exrate  = 1 
set @currno2 = chjer.dbo.uf_currno()
set @exrate2 = 1 

--貸：銀行借款 借款編號
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
@slipno2      ,'0010'    	  ,@depano		  ,@depanm		  ,
@accinoc	  ,@accinmc 	  ,@deplno        ,@deplnm        ,
@codeno		  ,@codenm		  ,@remano		  ,@remanm		  ,
@relano		  ,@dates		  ,@remark		  ,@swt			  ,
@amt		  ,0       	      ,@amt			  ,0              ,
@currno		  ,@exrate		  ,@currno2 	  ,@exrate2	      ,	  
@amt 		  ,0      		  ,@depano   	  ,@depano        ,
''            ,0              ,@chjernoi	  ,@compno		  
) 


--貸：銀行存款 銀行帳戶
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
@slipno2      ,'0020'    	  ,@depano		  ,@depanm		  ,
@accinod	  ,@accinmd 	  ,@banknod       ,@banknmd       ,
@codeno		  ,@codenm		  ,@remano		  ,@remanm		  ,
@relano		  ,@dates		  ,@remark		  ,@swt			  ,
0             ,@amt		      ,0       	      ,@amt			  ,
@currno		  ,@exrate		  ,@currno2 	  ,@exrate2	      ,	  
0             ,@amt 		  ,@depano   	  ,@depano        ,
''            ,0              ,@chjernoi	  ,@compno		  
) 


update deplh set  slipno2z = @slipno2 where num = @num 

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
   update deplh set slipno2z=@slipno2 ,slipnoz=@slipno  where num = @num 
end 



GO


