use master
go

create schema testschema
go

create procedure testschema.proc1 as select 1
go

create table testschema.table1 (a int primary key);
go

create view testschema.view1 as select a from testschema.table1;
go

create procedure dbo.proc2 as select 1
go

create table dbo.table2 (a int primary key);
go

create view dbo.view2 as select a from dbo.table2;
go

-- test procedure, table, constraint and view are visible for testschema
select name from sys.objects where name ='proc1' or name = 'table1' or name = 'view1' or name = 'table1_pkey';
go

-- test procedure, table, constraint and view are visible for dbo schema
select name from sys.objects where name ='proc2' or name = 'table2' or name = 'view2' or name = 'table2_pkey';
go

-- test proc1 and proc2 are visible in sys.procedures
select name from sys.procedures where name ='proc1'
go

select name from sys.procedures where name ='proc2'
go

--Clean up
drop procedure testschema.proc1;
drop view testschema.view1;
drop table testschema.table1;
drop schema testschema;
drop procedure dbo.proc2;
drop view dbo.view2;
drop table dbo.table2;
go
