-- Created by GitHub Copilot in SSMS - review carefully before executing
/*
目的：為 `dbo.esg_gwp_yyyy` 建立參照 `dbo.esg_gwp(gwp)` 的外鍵。
步驟：
 1) 在父表建立唯一約束 (gwp)
 2) 在子表建立外鍵 (gwp) -> 父表 (gwp)
*/
ALTER TABLE dbo.esg_gwp
ADD CONSTRAINT UQ_esg_gwp_gwp UNIQUE NONCLUSTERED (gwp);
 