--1.Подключитесь к серверу ORA12D. Создайте DBLINK по схеме USER1-USER2 для подключения к вашей базе данных (ваша БД находится на сервере ORA12W). 
select * from User_sys_privs;
select * from ALL_DB_LINKS

drop database link anotherdb;

CREATE DATABASE LINK anotherdb
CONNECT TO SYSTEM
IDENTIFIED BY Admin1234
USING 'ORCLPDB1';
   
select * from all_tab_columns@anotherdb;


--2. Продемонстрируйте выполнение операторов SELECT, INSERT, UPDATE, DELETE, вызов процедур и функций с объектами удаленного сервера.
SELECT id, field FROM Table14_@anotherdb;
select * from faculty@anotherdb;
select * from pulpit@anotherdb;
select * from teacher@anotherdb;

declare
    s nvarchar2(30) := 'String number ';
begin
    for x in 21..23
    loop
        insert into table14_@anotherdb(id, field) values(x, concat(s, to_char(x)));
    end loop;
    commit;    
end;

update table14_@anotherdb set field = 'String number 88' where id = 8;
delete from table14_@anotherdb where id = 4; 

declare
	x varchar2(1000);
	status int;
begin
	dbms_output.enable@anotherdb;
	proc14@anotherdb('ISIT');
 	loop
		dbms_output.get_line@anotherdb( x,status);
	exit when status != 0;
 	dbms_output.put_line(x);
 end loop;
	dbms_output.disable@anotherdb;
end;
begin
  dbms_output.put_line('Количество преподавателей на кафедре ИСИТ: ' || func14@anotherdb('ISIT'));
end;



--3.Создайте DBLINK по схеме USER - GLOBAL.

drop public database link PUBLIC_ANOTHERDB 

create public database link PUBLIC_ANOTHERDB 
CONNECT TO SYSTEM
IDENTIFIED BY Admin1234
USING 'ORCLPDB1';

--4.Продемонстрируйте выполнение операторов SELECT, INSERT, UPDATE, DELETE, вызов процедур и функций с объектами удаленного сервера
select * from table14_@public_anotherdb;

declare
    s nvarchar2(30) := 'String number ';
begin
    for x in 11..20
    loop
        insert into table14_@public_anotherdb(id, field) values(x, concat(s, to_char(x)));
    end loop;
    commit;    
end;

select * from table14_@public_anotherdb;
update table14_@public_anotherdb set field = 'String number 222' where id = 12;
delete from table14_@public_anotherdb where id = 16; 


declare
	x varchar2(1000);
	status int;
begin
	dbms_output.enable@public_anotherdb;
	proc14@public_anotherdb('ISIT');
 	loop
		dbms_output.get_line@public_anotherdb( x,status);
	exit when status != 0;
 	dbms_output.put_line(x);
 end loop;
	dbms_output.disable@public_anotherdb;
end;
begin
  dbms_output.put_line('Количество преподавателей на кафедре ИСИТ: ' || func14@anotherdb('ISIT'));
end;



declare
    s nvarchar2(30) := 'String number ';
begin
    for x in 1..10
    loop
        insert into table14_@public_anotherdb(id, field) values(x, concat(s, to_char(x)));
    end loop;
    commit;    
end;

SELECT name FROM table14_@public_anotherdb;
update Table14 set field = 'String number 88' where id = 8;
delete from Table14 where id = 4; 



ALTER SESSION CLOSE DATABASE LINK anotherdb;
ALTER SESSION CLOSE DATABASE LINK public_anotherdb;
