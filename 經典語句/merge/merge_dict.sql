 

MERGE  dict    USING [PC13XPDB\MSSQLSERVER01].casper.dbo.dict as dict2  ON  dict.dictno = dict2.dictno and dict.dictnm = dict2.dictnm  
when not matched by target THEN 
     insert ( dictno,dictnm,remark ,chjernoi  )  values (dict2.dictno,dict2.dictnm,dict2.remark  ,dict2.chjernoi );

 