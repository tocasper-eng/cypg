USE [Cloud_TOCYPRESS_cypress]
GO
 alter table [rma_整新機台序號] alter column seq nvarchar(06) not null  

 delete  [rma_整新機台序號]  where  seq is null 
 
ALTER TABLE rma_整新機台序號
ADD CONSTRAINT chk_seq_length CHECK (LEN(seq) >= 1);

SELECT [num]
      ,[rmano]
      ,[seq]
      ,[原機台序號]
      ,[原始機台KIT序號]
      ,[整新機台序號]
      ,[整新機台KIT序號]
      ,[box]
      ,[remark]
      ,[整新費用]
  FROM [dbo].[rma_整新機台序號]

GO


