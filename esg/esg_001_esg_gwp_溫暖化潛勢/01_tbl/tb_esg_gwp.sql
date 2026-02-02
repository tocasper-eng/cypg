USE Cloud_TOCYPRESS_cypress
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[esg_gwp]') AND type in (N'U'))
    DROP TABLE [dbo].[esg_gwp]
GO
--溫暖化潛式
CREATE TABLE [dbo].[esg_gwp](
num     bigint IDENTITY(1,1) NOT NULL,--主流水號
gwp     nvarchar(255) ,    
AR2     NVARCHAR(48) ,
AR3     NVARCHAR(48) ,
AR4     NVARCHAR(48) ,
AR5     NVARCHAR(48) ,
AR6     NVARCHAR(48) ,

constraint pk_esg_gwp_num  primary key ( num )  
)
GO 
CREATE INDEX in_esg_gwp_yyyy ON esg_gwp ( gwp )
go 

 