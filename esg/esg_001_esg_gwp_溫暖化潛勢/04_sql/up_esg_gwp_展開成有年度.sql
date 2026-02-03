USE Cloud_TOCYPRESS_cypress
GO

-- 如果原本就有這支預存程序則刪除
IF OBJECT_ID('up_esg_gwp', 'P') IS NOT NULL
    DROP PROCEDURE up_esg_gwp
GO
--exec .dbo.up_esg_gwp 
--select * from esg_gwp_yyyy 
 

CREATE PROCEDURE up_esg_gwp 
--casper--
AS
BEGIN  -- 第一個 begin (對應最後一個 end)
    SET NOCOUNT ON; 

    -- 清空目標表
    TRUNCATE TABLE dbo.esg_gwp_yyyy;

    -- 使用 CROSS APPLY 進行欄位轉列
    INSERT INTO dbo.esg_gwp_yyyy (gwp, yyyy, ar)
    SELECT 
        src.gwp,
        v.yyyy,
        v.ar
    FROM dbo.esg_gwp AS src
    CROSS APPLY (
        VALUES 
            (1995, src.ar2),
            (2001, src.ar3),
            (2007, src.ar4),
            (2013, src.ar5),
            (2021, src.ar6)
    ) AS v(yyyy, ar)
    WHERE v.ar IS NOT NULL; 

END -- 結束預存程序
GO