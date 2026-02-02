-- Created by GitHub Copilot in SSMS - review carefully before executing

-- 1) 建表（若不存在）
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[esg_gwp_log]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[esg_gwp_log](
        log_id bigint IDENTITY(1,1) NOT NULL,
        esg_gwp_num bigint NULL, -- 參考 dbo.esg_gwp.num
        operation nvarchar(16) NOT NULL, -- INSERT|UPDATE|DELETE
        column_name nvarchar(128) NULL,
        old_value nvarchar(max) NULL,
        new_value nvarchar(max) NULL,
        modified_by nvarchar(256) NOT NULL DEFAULT SUSER_SNAME(),
        modified_at datetimeoffset(7) NOT NULL DEFAULT SYSUTCDATETIME(),
        client_ip nvarchar(45) NULL,
        host_name nvarchar(255) NULL,
        application_name nvarchar(255) NULL,
        additional_info nvarchar(4000) NULL,
        CONSTRAINT pk_esg_gwp_log_log_id PRIMARY KEY (log_id),
        CONSTRAINT fk_esg_gwp_log_esg_gwp_num FOREIGN KEY (esg_gwp_num) REFERENCES dbo.esg_gwp(num)
    );
    CREATE INDEX ix_esg_gwp_log_esg_gwp_num_modified_at ON dbo.esg_gwp_log (esg_gwp_num, modified_at);
END
GO

 