use casper
go 
drop function uf_top5_expense 
go 
CREATE FUNCTION uf_top5_expense( @datecfm char(08),@datecto char(08) )  
RETURNS TABLE  
AS  
RETURN  
    SELECT top 5 slipno , depano , accino , db_amt   
    FROM slis   
    WHERE substring(slipno,1,6) between @datecfm and @datecto  
	and accino like '6%'
	order by db_amt desc  
go 
select * from uf_top5_expense('20230101','20240105')