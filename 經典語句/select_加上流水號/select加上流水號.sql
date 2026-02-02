Select * From (Select Row_Number() Over(Order by [asetno]) As RowNum, * from aset) As aset 
