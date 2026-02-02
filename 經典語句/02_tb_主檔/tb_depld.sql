USE [casper]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[depld]') AND type in (N'U'))
   DROP TABLE [dbo].[depld]
GO
CREATE TABLE [dbo].[depld](
deplno    char(08)             NOT NULL,--借款編號
seq       char(04)                 NULL,--項次
yyyymm    char(06)             NOT NULL,--傳票月份
slipno2   nvarchar(20)             NULL,--利息傳票
slipno    nvarchar(12)             NULL,--利息傳票
remark    Nvarchar(192)            NULL,--備註說明
interest  decimal(18, 2)           NULL,--利息總額
accinoc   char(06)                 null,--銀行帳號
accinmc   nvarchar(20)             null,--銀行帳號
code      char(08)                 null,--銀行子目
textz     nvarchar(20)             null,--銀行帳號
nos       bigint IDENTITY(1,1) NOT NULL,--子流水號
num       bigint                   NULL,--主流水號
tmpn      int                      NULL,--暫存欄位
chjernoi  nvarchar(48)             NULL,--新增資訊
chjernou  nvarchar(48)             NULL,--修改資訊
constraint pk_depld_nos primary key ( nos )  
)
GO 
CREATE INDEX in_depld_depano ON depld ( deplno , seq )
CREATE INDEX in_depld_num    ON depld ( num          )
GO
use chjer
go
IF EXISTS(SELECT NAME FROM sysobjects WHERE NAME ='depld')
   DROP VIEW depld
GO
CREATE VIEW depld as select * from casper.dbo.depld 
go

