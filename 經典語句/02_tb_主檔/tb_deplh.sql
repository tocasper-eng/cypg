USE [casper]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[deplh]') AND type in (N'U'))
    DROP TABLE [dbo].[deplh]
GO
--銀行借款編號
CREATE TABLE [dbo].[deplh](
[num] [bigint] IDENTITY(1,1) NOT NULL,--主流水號
[chjernoi] [nvarchar](48)        NULL,--新增資訊
[chjernou] [nvarchar](48)        NULL,--修改資訊
[compno]   [nvarchar](48)        NULL,--公司代碼
[deplno]   [char](08)   NOT      NULL,--借款編號
[deplnm]   [nvarchar](48)        NULL,--借款說明
[datec]    [char](08)   NOT      NULL,--借款日期
[datefm]   [char](08)            NULL,--起始日期
[dateto]   [char](08)            NULL,--終止日期
[dayq]     [int]                 NULL,--借款天數
[rate]     [decimal](12, 4)      NULL,--利息年率
interest   [decimal](18, 2)      NULL,--利息總額
[amt]      [decimal](18, 2)      NULL,--借款總額
[depano]   [char](6)             NULL,--傳票部門 91A
[depanm]   [nvarchar](20)        NULL,--部門名稱 91A 
[accinod]  [char](06)            NULL,--銀行存款 92A 
[accinmd]  [nvarchar](36)        NULL,--銀行存款 92A
[banknod]  [char](08)            NULL,--銀行帳戶 91F
[banknmd]  [nvarchar](20)        NULL,--帳戶名稱 91F
[accino]   [char](6)             NULL,--利息科目 92A
[accinm]   [nvarchar](36)        NULL,--科目名稱 92A
[accinoc]  [char](6)             NULL,--銀行借款 92A
[accinmc]  [nvarchar](36)        NULL,--銀行借款 92A 
[remark]   [nvarchar](1024)      NULL,--備註說明
[exrate]   [decimal](12, 4)      NULL,--暫不處理外幣
[currno]   [char](03)            NULL,--暫不處理外幣
[slipno2z] [nvarchar](20)        NULL,--取得傳票
[slipno2a] [nvarchar](20)        NULL,--利息傳票
[slipno2e] [nvarchar](20)        NULL,--結清傳票
[slipnoz]  [nvarchar](12)        NULL,--取得傳票
[slipnoa]  [nvarchar](12)        NULL,--利息傳票
[slipnoe]  [nvarchar](12)        NULL,--結清傳票
[date_m]   [nvarchar](08)        NULL,--製單日期
[code_m]   [nvarchar](01)        NULL,--製單旗標
[ownerm]   [nvarchar](30)        NULL,--製單人員
[date_s]   [nvarchar](08)        NULL,--審核日期
[code_s]   [nvarchar](01)        NULL,--審核旗標
[owners]   [nvarchar](30)        NULL,--審核人員
[date_z]   [nvarchar](08)        NULL,--核准日期
[code_z]   [nvarchar](01)        NULL,--核准旗標
[ownerz]   [nvarchar](30)        NULL,--核准人員
[date_a]   [nvarchar](08)        NULL,--立帳日期
[sta]      [nvarchar](01)        NULL,--立帳旗標
[ownera]   [nvarchar](30)        NULL,--立帳人員
[date_e]   [nvarchar](08)        NULL,--立帳日期
[ste]      [nvarchar](01)        NULL,--立帳旗標
[ownere]   [nvarchar](30)        NULL,--立帳人員
[sqlpass]  [nvarchar](96)        NULL,--後端訊息
[sono2]    [nvarchar](30)        NULL,--客戶月序
[zoomnm]   [nvarchar](96)        NULL --專案名稱
constraint pk_deplh_num  primary key ( num )  
)
GO 
CREATE INDEX in_deplh_depano ON deplh ( depano )
CREATE INDEX in_deplh_datec  ON deplh ( datec  )
CREATE INDEX in_deplh_deplno ON deplh ( deplno )
GO
use chjer
go
IF EXISTS(SELECT NAME FROM sysobjects WHERE NAME ='deplh')
   DROP VIEW deplh
GO
CREATE VIEW deplh as select * from casper.dbo.deplh 
go
