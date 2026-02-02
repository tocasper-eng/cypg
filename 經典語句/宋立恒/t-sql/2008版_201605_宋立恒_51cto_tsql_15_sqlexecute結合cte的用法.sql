USE [chjer]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[xp_dts_04_bmhd_bmx]') AND type in (N'P', N'PC'))
   DROP PROCEDURE [dbo].[xp_dts_04_bmhd_bmx]
GO

--exec chjer.dbo.xp_dts_04_bmhd_loop 'RDEV1804-1'  
--drop procedure  [dbo].[xp_dts_04_bmhd_bmx]

CREATE procedure  [dbo].[xp_dts_04_bmhd_bmx]
(
@bmno char(20)
)
as
begin

SET QUOTED_IDENTIFIER  Off
declare @cnta int    declare @itemno  char(20)  
declare @tsql nvarchar(4000) 

select @tsql = '
SET QUOTED_IDENTIFIER  Off;
 with bmd_cte  (  bmno, bmseq , partno , [version] , partnm  , bmqty , remark , specnm , cnta   ) 
 as 
 ( 
    select 
    bmno   ,      bmseq  ,     partno ,    [version] ,    partnm ,    bmqty  ,
    remark ,    specnm ,    cnta   
    FROM fasdb_bmd where bmno= "' + rtrim(ltrim(@bmno)) + '"
    union all 
    select 
    b.bmno ,      b.bmseq,     b.partno ,    b.[version] ,    b.partnm ,    b.bmqty  ,
    b.remark ,    b.specnm ,    isnull(em.cnta,0)+1   
    from bmd_cte as em inner join fasdb_bmd as b  on b.bmno = em.partno  
)
select * from bmd_cte 
'
exec sp_executesql @tsql 

declare xp_dts_03 cursor for
Select bmno , min(cnta)  
From bmd_cte 
group by  bmno 
order by min(cnta) 
open    xp_dts_03 
fetch next from xp_dts_03 into  @itemno , @cnta 
while ( @@fetch_status <> -1 )
begin
   exec chjer.dbo.xp_dts_04_bmhd_single  @itemno , @itemno 
fetch next from xp_dts_03 into  @itemno , @cnta 
end
close      xp_dts_03
deallocate xp_dts_03
-----------------------------------------------------------------------------------------------------------------------


END 



GO


