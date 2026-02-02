一是每条数据需要记有插入时间 Create Time 及修改时间 Update Time；

二是需要设置一个表，用于记录每次同步的完成时间。

具体设置步骤，以 Customer 表为例，说明如下：

（1）在源数据库里创建表 DBSync：
CREATE TABLE DBSync ( SyncDate smalldatetime, TableName nchar(30) )

（2）在任务设置 Step4 页面，为源数据库设置 Update 语句，记录同步完成时间：

UPDATE dbsync set syncDate=date() where tablename=' Customer'

（3）在任务设置 Step4 页面，为源数据库设置 Select 语句，将同步范围限定于上次同步后的增量：

SELECT a.* FROM Customer AS a,
(SELECT syncDate FROM dbsync WHERE tablename='Customer') AS b 
where b.SyncDate is null or a.CreateTime>=b.SyncDate or a.UpdateTime >=b.SyncDate

如果数据表没有 Create Time 及 Update Time 字段，安排一个时间戳字段也可以，道理是一样的。