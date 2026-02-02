-- Created by GitHub Copilot in SSMS - review carefully before executing

-- 1) 刪除舊觸發器（若存在）
IF OBJECT_ID(N'dbo.tr_esg_gwp_audit', N'TR') IS NOT NULL
    DROP TRIGGER dbo.tr_esg_gwp_audit;
GO

-- 2) 建立修正後的觸發器
CREATE TRIGGER dbo.tr_esg_gwp_audit
ON dbo.esg_gwp
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- INSERT: 記錄新值（明確轉換為 nvarchar）
    IF EXISTS(SELECT 1 FROM inserted) AND NOT EXISTS(SELECT 1 FROM deleted)
    BEGIN
        INSERT INTO dbo.esg_gwp_log (
            esg_gwp_num, operation, column_name, old_value, new_value,
            modified_by, modified_at, client_ip, host_name, application_name
        )
        SELECT
            i.num,
            N'INSERT',
            v.col,
            NULL,
            v.newv,
            SUSER_SNAME(),
            SYSUTCDATETIME(),
            CONVERT(nvarchar(45), CONNECTIONPROPERTY('client_net_address')),
            HOST_NAME(),
            APP_NAME()
        FROM inserted i
        CROSS APPLY (VALUES
            (N'gwp', TRY_CONVERT(nvarchar(max), i.gwp)),
            (N'AR2', TRY_CONVERT(nvarchar(max), i.AR2)),
            (N'AR3', TRY_CONVERT(nvarchar(max), i.AR3)),
            (N'AR4', TRY_CONVERT(nvarchar(max), i.AR4)),
            (N'AR5', TRY_CONVERT(nvarchar(max), i.AR5)),
            (N'AR6', TRY_CONVERT(nvarchar(max), i.AR6))
        ) v(col, newv)
        WHERE v.newv IS NOT NULL;
    END;

    -- DELETE: 記錄舊值（明確轉換為 nvarchar）
    IF EXISTS(SELECT 1 FROM deleted) AND NOT EXISTS(SELECT 1 FROM inserted)
    BEGIN
        INSERT INTO dbo.esg_gwp_log (
            esg_gwp_num, operation, column_name, old_value, new_value,
            modified_by, modified_at, client_ip, host_name, application_name
        )
        SELECT
            d.num,
            N'DELETE',
            v.col,
            v.oldv,
            NULL,
            SUSER_SNAME(),
            SYSUTCDATETIME(),
            CONVERT(nvarchar(45), CONNECTIONPROPERTY('client_net_address')),
            HOST_NAME(),
            APP_NAME()
        FROM deleted d
        CROSS APPLY (VALUES
            (N'gwp', TRY_CONVERT(nvarchar(max), d.gwp)),
            (N'AR2', TRY_CONVERT(nvarchar(max), d.AR2)),
            (N'AR3', TRY_CONVERT(nvarchar(max), d.AR3)),
            (N'AR4', TRY_CONVERT(nvarchar(max), d.AR4)),
            (N'AR5', TRY_CONVERT(nvarchar(max), d.AR5)),
            (N'AR6', TRY_CONVERT(nvarchar(max), d.AR6))
        ) v(col, oldv)
        WHERE v.oldv IS NOT NULL;
    END;

    -- UPDATE: 只記錄實際變動的欄位（明確轉換並以安全的比較判斷差異）
    IF EXISTS(SELECT 1 FROM inserted) AND EXISTS(SELECT 1 FROM deleted)
    BEGIN
        INSERT INTO dbo.esg_gwp_log (
            esg_gwp_num, operation, column_name, old_value, new_value,
            modified_by, modified_at, client_ip, host_name, application_name
        )
        SELECT
            i.num,
            N'UPDATE',
            v.col,
            v.oldv,
            v.newv,
            SUSER_SNAME(),
            SYSUTCDATETIME(),
            CONVERT(nvarchar(45), CONNECTIONPROPERTY('client_net_address')),
            HOST_NAME(),
            APP_NAME()
        FROM inserted i
        INNER JOIN deleted d ON i.num = d.num
        CROSS APPLY (VALUES
            (N'gwp', TRY_CONVERT(nvarchar(max), d.gwp), TRY_CONVERT(nvarchar(max), i.gwp)),
            (N'AR2', TRY_CONVERT(nvarchar(max), d.AR2), TRY_CONVERT(nvarchar(max), i.AR2)),
            (N'AR3', TRY_CONVERT(nvarchar(max), d.AR3), TRY_CONVERT(nvarchar(max), i.AR3)),
            (N'AR4', TRY_CONVERT(nvarchar(max), d.AR4), TRY_CONVERT(nvarchar(max), i.AR4)),
            (N'AR5', TRY_CONVERT(nvarchar(max), d.AR5), TRY_CONVERT(nvarchar(max), i.AR5)),
            (N'AR6', TRY_CONVERT(nvarchar(max), d.AR6), TRY_CONVERT(nvarchar(max), i.AR6))
        ) v(col, oldv, newv)
        WHERE
            (v.oldv IS NULL AND v.newv IS NOT NULL)
            OR (v.oldv IS NOT NULL AND v.newv IS NULL)
            OR (v.oldv <> v.newv);
    END;
END;
GO