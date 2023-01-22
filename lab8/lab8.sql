--1. Найдите на компьютере конфигурационные файлы SQLNET.ORA и TNSNAMES.ORA и ознакомьтесь с их содержимым.
--/opt/oracle/oradata/dbconfig/ORCL/listener.ora

--2.Соединитесь при помощи sqlplus с Oracle как пользователь SYSTEM, получите перечень параметров экземпляра Oracle.
--sqlplus system/Admin1234
--select name from v$parameter

--3.Соединитесь при помощи sqlplus с подключаемой базой данных как пользователь SYSTEM,         /nolog
--получите список табличных пространств, файлов табличных пространств, ролей и пользователей.
--sqlplus system/Admin1234@ORCLPDB1

--select tablespace_name from dba_tablespaces;
--TABLESPACE_NAME
------------------------------
--SYSTEM
--SYSAUX
--UNDOTBS1
--TEMP
--USERS

--select file_name from dba_data_files;
--FILE_NAME
--------------------------------------------------------------------------------
--/opt/oracle/oradata/ORCL/ORCLPDB1/system01.dbf
--/opt/oracle/oradata/ORCL/ORCLPDB1/sysaux01.dbf
--/opt/oracle/oradata/ORCL/ORCLPDB1/undotbs01.dbf
--/opt/oracle/oradata/ORCL/ORCLPDB1/users01.dbf

select role from dba_roles;
select username from dba_users;

--4.Ознакомьтесь с параметрами в HKEY_LOCAL_MACHINE/SOFTWARE/ORACLE на вашем компьютере.
--echo $ORACLE_HOME

--5.Запустите утилиту Oracle Net Manager и подготовьте строку подключения с именем имя_вашего_пользователя_SID, где SID – идентификатор подключаемой базы данных. 

--6.Подключитесь с помощью sqlplus под собственным пользователем и с применением подготовленной строки подключения. 
--sqlplus system/Admin1234@mns_orclpdb1

/*

sh-4.2$ sqlplus system/Admin1234@mns_orclpdb1

SQL*Plus: Release 21.0.0.0.0 - Production on Sat Dec 24 08:42:36 2022
Version 21.3.0.0.0

Copyright (c) 1982, 2021, Oracle.  All rights reserved.

Last Successful login time: Sat Dec 24 2022 08:41:13 +00:00

Connected to:
Oracle Database 21c Enterprise Edition Release 21.0.0.0.0 - Production
Version 21.3.0.0.0

SQL> create table MNS_table(
  2  x number(3),
  3  s varchar2(50)
  4  );

Table created.

SQL> select * from MNS_table;

no rows selected

SQL>

*/
--7.Выполните select к любой таблице, которой владеет ваш пользователь. 
create table MNS_table(
    x number(3), 
    s varchar2(50)
);
select * from MNS_table;

--8.Ознакомьтесь с командой HELP.Получите справку по команде TIMING. Подсчитайте, сколько времени длится select к любой таблице.
declare i integer :=0;
begin
while i<1000 LOOP
insert into MNS_table (x, s) values (i, 'loop');
i := i+1;
end loop;
end;
commit;


--timing start t;
--select * from MNS_table;
--timing stop;

--9.Ознакомьтесь с командой DESCRIBE.Получите описание столбцов любой таблицы.
describe MNS_table;

--10.Получите перечень всех сегментов, владельцем которых является ваш пользователь.
select segment_name from user_segments;

--11.Создайте представление, в котором получите количество всех сегментов, количество экстентов, блоков памяти и размер в килобайтах, которые они занимают.
create view MNS_view as 
select count(*) as "segments_count", 
    sum(extents) as "extents_count", 
    sum(blocks) as "blocks_count", 
    sum(bytes) as "size" from user_segments;

   
show con_name;
select * from MNS_view;
    
drop view MNS_view;
    