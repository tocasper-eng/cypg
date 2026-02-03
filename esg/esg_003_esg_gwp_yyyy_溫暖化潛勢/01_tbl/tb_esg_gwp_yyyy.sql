USE Cloud_TOCYPRESS_cypress
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[esg_gwp_yyyy]') AND type in (N'U'))
    DROP TABLE [dbo].[esg_gwp_yyyy]
GO
--溫暖化潛式
CREATE TABLE [dbo].[esg_gwp_yyyy](
num     bigint IDENTITY(1,1) NOT NULL,--主流水號
gwp     nvarchar(255) ,  
yyyy    char(04)      ,
AR      NVARCHAR(48) ,
 

constraint pk_esg_gwp_yyyy_num  primary key ( num )  
)
GO 
CREATE INDEX in_esg_gwp_yyyy_num ON esg_gwp_yyyy ( gwp, yyyy )
go 

 