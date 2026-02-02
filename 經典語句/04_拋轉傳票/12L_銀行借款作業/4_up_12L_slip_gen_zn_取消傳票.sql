USE [CHJER]
GO

DROP PROCEDURE up_12L_slip_gen_zn
GO
create procedure up_12L_slip_gen_zn (
@num bigint ,
@userid varchar(20)
)
as
begin
--01.宣告變數
declare @swt       char(10)		declare @slipnoe   varchar(20)	  declare @ustono   char(20)
declare @yyyymm    char(04)     declare @datec     char(008)      declare @num_25a  bigint 
declare @cnt       bigint       declare @sqlpass   nvarchar(1024)
declare @slipno2z  nvarchar(20)        --取得傳票

--02.設定初值
set @swt    = '12LZ'
set @ustono = 'up_12L_slip_gen_zn'
exec chjer.dbo.up_usto_delete @userid,@ustono , '' , '' , ''


--03.取出主檔
--03.取出主檔
select 
@datec    = datec   ,
@slipno2z = slipno2z  --取得傳票
from deplh 
where num = @num 

--04.防呆機制之二
set @yyyymm=chjer.dbo.uf_get_85z()
if substring(@datec,3,4)<=substring(@yyyymm,3,4)
begin
   set @sqlpass = '傳票日已結帳。不可核准。'
   exec chjer.dbo.up_usto_insert @userid,@ustono, 'A' , @sqlpass , @sqlpass 
end

select @num_25a=num from slip where slipno2=@slipno2z 
--05.防呆機制之二
if chjer.dbo.uf_empty(@slipnoe)='N' 
begin
	exec chjer.dbo.up_25a_code_z_n @num_25a , @userid 
	exec chjer.dbo.up_25a_code_s_n @num_25a , @userid 
	exec chjer.dbo.up_25a_code_m_n @num_25a , @userid 
end

--06.防呆機制之三
select @cnt=count(*) from slip where num=@num_25a and isnull(code_m,'') ='Y' 
if @cnt > 0 
begin 
   set @sqlpass = '自動取消傳票失敗，請跳轉至 25A 確認。'
   exec chjer.dbo.up_usto_insert @userid,@ustono, 'A' , @sqlpass , @sqlpass 
   return 
end

--07.刪除已建檔傳票
delete slip where slipno2=@slipno2z
delete slis where slipno2=@slipno2z

--08回寫單據之傳票序號
update deplh set slipno2z = '' , slipnoz = '' where num = @num 
end 

GO


