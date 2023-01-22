--1. ������� �� ���������� ���������������� ����� SQLNET.ORA � TNSNAMES.ORA � ������������ � �� ����������.
--/opt/oracle/oradata/dbconfig/ORCL/listener.ora

--2.����������� ��� ������ sqlplus � Oracle ��� ������������ SYSTEM, �������� �������� ���������� ���������� Oracle.
--sqlplus system/Admin1234
--select name from v$parameter

--3.����������� ��� ������ sqlplus � ������������ ����� ������ ��� ������������ SYSTEM,         /nolog
--�������� ������ ��������� �����������, ������ ��������� �����������, ����� � �������������.
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

--4.������������ � ����������� � HKEY_LOCAL_MACHINE/SOFTWARE/ORACLE �� ����� ����������.
--echo $ORACLE_HOME

--5.��������� ������� Oracle Net Manager � ����������� ������ ����������� � ������ ���_������_������������_SID, ��� SID � ������������� ������������ ���� ������. 

--6.������������ � ������� sqlplus ��� ����������� ������������� � � ����������� �������������� ������ �����������. 
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
--7.��������� select � ����� �������, ������� ������� ��� ������������. 
create table MNS_table(
    x number(3), 
    s varchar2(50)
);
select * from MNS_table;

--8.������������ � �������� HELP.�������� ������� �� ������� TIMING. �����������, ������� ������� ������ select � ����� �������.
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

--9.������������ � �������� DESCRIBE.�������� �������� �������� ����� �������.
describe MNS_table;

--10.�������� �������� ���� ���������, ���������� ������� �������� ��� ������������.
select segment_name from user_segments;

--11.�������� �������������, � ������� �������� ���������� ���� ���������, ���������� ���������, ������ ������ � ������ � ����������, ������� ��� ��������.
create view MNS_view as 
select count(*) as "segments_count", 
    sum(extents) as "extents_count", 
    sum(blocks) as "blocks_count", 
    sum(bytes) as "size" from user_segments;

   
show con_name;
select * from MNS_view;
    
drop view MNS_view;
    