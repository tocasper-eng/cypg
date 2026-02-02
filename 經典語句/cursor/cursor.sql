----------------------------------------------
use chjer
go
if exists (select name from sysobjects where name = 'ut_cursor')
   drop procedure ut_cursor
go
--exec chjer.dbo.ut_cursor
create procedure ut_cursor
as
begin

declare @userid varchar(06)
declare @stat1  int  

-----------------------------------------------------
declare menux cursor for select userid from users 
open    menux 
fetch next from menux into @userid 
set @stat1 = @@fetch_status
while ( @stat1 <> -1 )
begin

		IF 1=0
			BREAK
		ELSE
			CONTINUE

     --exec chjer.dbo.ut_ut_cursor @userid 

fetch next from menux into @userid 
set @stat1 = @@fetch_status
end
close menux
deallocate menux


------------------------------------------------------
end 
GO
