USE Cloud_TOCYPRESS_cypress
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[esg_gwp]') AND type in (N'U'))
    DROP TABLE [dbo].[esg_gwp]
GO
--溫暖化潛式
CREATE TABLE [dbo].[esg_gwp](
num     bigint IDENTITY(1,1) NOT NULL,--主流水號
gwp     nvarchar(255) ,    
AR2     NVARCHAR(48)  ,--1995
AR3     NVARCHAR(48)  ,--2001
AR4     NVARCHAR(48)  ,--2007
AR5     NVARCHAR(48)  ,--2013
AR6     NVARCHAR(48)  ,--2021
                      
constraint pk_esg_gwp _num  primary key ( num )  
)                     
GO                    
CREATE INDEX in_esg_g wp_yyyy ON esg_gwp ( gwp )
go 

 