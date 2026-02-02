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

declare @userid varchar(06) declare @cnt    int 
declare @stat1  int         declare @stat2 int 

-----------------------------------------------------
declare menux cursor for select userid from users 
open    menux 
fetch next from menux into @userid 
set @stat1 = @@fetch_status
while ( @stat1 <> -1 )
begin

   declare menux2 cursor for select userid from users 
   open    menux2 
   fetch next from menux2 into @userid 
   set @stat2 = @@fetch_status
   while ( @stat2 <> -1 )
   begin

   		IF 1=0
			BREAK
		ELSE
			CONTINUE
    

   fetch next from menux2 into @userid 
   set @stat2 = @@fetch_status
   end
   close menux2
   deallocate menux2

fetch next from menux into @userid 
set @stat1 = @@fetch_status
end
close menux
deallocate menux


------------------------------------------------------
end 
GO
