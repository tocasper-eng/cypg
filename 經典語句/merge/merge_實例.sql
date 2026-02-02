--聯集
declare @t1 table ( code char(01), name char(1),name2 char(1) ) 
insert into @t1 ( code,name) values 
( '1','A'),
( '2','D'),
( '3','C')
declare @t2 table ( code char(01), name char(1) ) 
insert into @t2 ( code,name) values 
( '2','X'),
( '3','Y'),
( '4','C'),
( '5','C')

MERGE  @T1 AS t1    USING @T2 AS t2    ON  t1.code = t2.code 
when matched THEN                 update set  name2 = t2.name  --以T2的NAME為主
when not matched by target THEN 
     insert ( code , name, name2 )  values ( T2.code , T2.name , T2.name);

SELECT * FROM @T1 

--二年都有看的。
declare @t1 table ( code char(01), name char(1),name2 char(1) ) 
insert into @t1 ( code,name) values --今年
( '1','A'),
( '2','D'),
( '3','C')
declare @t2 table ( code char(01), name char(1) ) 
insert into @t2 ( code,name) values --去年
( '2','X'),
( '3','Y'),
( '4','C'),
( '5','C')

MERGE  @T1 AS t1    USING @T2 AS t2    ON  t1.code = t2.code 
when not matched by source THEN delete;

SELECT * FROM @T1 
--2	D	NULL
--3	C	NULL

--今年新增的
declare @t1 table ( code char(01), name char(1),name2 char(1) ) 
insert into @t1 ( code,name) values --今年
( '1','A'),
( '2','D'),
( '3','C')
declare @t2 table ( code char(01), name char(1) ) 
insert into @t2 ( code,name) values --去年
( '2','X'),
( '3','Y'),
( '4','C'),
( '5','C')

MERGE  @T1 AS t1    USING @T2 AS t2    ON  t1.code = t2.code 
when matched THEN  delete;

SELECT * FROM @T1 
--1	A	NULL 