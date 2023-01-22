--1.�������� ������ ���� ������ ��������� ����������� (������������  � ���������).
select FILE_NAME, TABLESPACE_NAME FROM DBA_DATA_FILES;
select FILE_NAME, TABLESPACE_NAME FROM DBA_TEMP_FILES;

show parameter control;

--2.�������� ��������� ������������ � ������ XXX_QDATA (10m). ��� �������� ���������� ��� � ��������� offline. ����� ���������� ��������� ������������ � ��������� online. �������� ������������ XXX ����� 2m � ������������ XXX_QDATA. 
--(05_MNS) �� ����� XXX �  ������������ XXX_T1�������� ������� �� ���� ��������, ���� �� ������� ����� �������� ��������� ������. � ������� �������� 3 ������.
drop tablespace MNS_QDATA including contents and datafiles;
create tablespace MNS_QDATA
datafile 'MNS_QDATA05.dbf'
size 10M
offline;

alter tablespace MNS_QDATA online;

alter session set "_ORACLE_SCRIPT" = true;
create user MNS identified by 123;
grant create session, create table, drop any table to MNS;
alter user MNS quota 2M on MNS_QDATA;

--2. �� ����� XXX �  ������������ XXX_T1�������� ������� �� ���� ��������, ���� �� ������� ����� �������� ��������� ������. � ������� �������� 3 ������.
create table MNS_T1(
    x integer primary key, 
    s varchar2(50)
) tablespace  MNS_QDATA;

insert into MNS_T1 (x, s) values (10, 'one');
insert into MNS_T1 (x, s) values (2, 'two');
insert into MNS_T1 (x, s) values (3, '3');
commit;

select * from MNS_T1;


--4.������� (DROP) ������� XXX_T1. �������� ������ ��������� ���������� ������������  XXX_QDATA. ���������� ������� ������� XXX_T1. 
--��������� SELECT-������ � ������������� USER_RECYCLEBIN, �������� ���������.
drop table MNS_T1;
--select v file
select * from USER_RECYCLEBIN;

--5.������������ (FLASHBACK) ��������� �������. 
FLASHBACK TABLE MNS_T1 to before drop;

--6.��������� PL/SQL-������, ����������� ������� XXX_T1 ������� (10000 �����).
declare i integer :=0;
begin
while i<1000 LOOP
insert into MNS_T1 (x, s) values (i, 'loop');
i := i+1;
end loop;
end;

commit;





--3.�������� ������ ��������� ���������� ������������  XXX_QDATA. ���������� ������� ������� XXX_T1. ���������� ��������� ��������.
select * from dba_segments where tablespace_name like 'MNS_QDATA';

--4. 05_MNS.sql
select * from dba_segments where tablespace_name like 'MNS_QDATA';

--5. 05_MNS.sql
--6. 05_MNS.sql

--7.���������� ������� � �������� ������� XXX_T1 ���������, �� ������ � ������ � ������. �������� �������� ���� ���������. 
--������� ��������� ������������ XXX_QDATA � ��� ����.
select * from dba_segments where tablespace_name like 'MNS_QDATA';

--8.������� ��������� ������������ XXX_QDATA � ��� ����. 
drop tablespace MNS_QDATA including contents and datafiles;


--9.�������� �������� ���� ����� �������� �������. ���������� ������� ������ �������� �������.
select * from v$log;

--10.�������� �������� ������ ���� �������� ������� ��������.
select * from v$logfile;

--11.EX. � ������� ������������ �������� ������� �������� ������ ���� ������������. �������� ��������� ����� � ������ ������ ������� ������������ (��� ����������� ��� ���������� ��������� �������).
select * from v$log;
alter system switch logfile;
--2:56 AM
--SCN: 4180570 

--12.EX. �������� �������������� ������ �������� ������� � ����� ������� �������. ��������� � ������� ������ � ������, � ����� � ����������������� ������ (�������������). ���������� ������������������ SCN. 
alter database add logfile group 4 'REDO04.LOG' size 50m blocksize 512;
alter database add logfile member 'REDO041.LOG'  to group 4;
alter database add logfile member 'REDO042.LOG'  to group 4;
select * from v$log;
alter system switch logfile;
--SCN: 4180679

--13.EX. ������� ��������� ������ �������� �������. ������� ��������� ���� ����� �������� �� �������.
alter database drop logfile member 'REDO042.LOG';
alter database drop logfile member 'REDO041.LOG';
alter database drop logfile group 4; 

select * from v$log;


--14.����������, ����������� ��� ��� ������������� �������� ������� (������������� ������ ���� ���������, ����� ���������, ���� ������ ������� �������� ������� � ��������).
select NAME, LOG_MODE from V$DATABASE;
select INSTANCE_NAME, ARCHIVER, ACTIVE_STATE from V$INSTANCE;

--15.���������� ����� ���������� ������.  
select * from v$archived_log

--16.EX.  �������� �������������. 
--sql plus "connect as sysdba"
--shutdown immediate;
--startup mount;
--alter database archivelog;
--alter database open;
select NAME, LOG_MODE from V$DATABASE;
select INSTANCE_NAME, ARCHIVER, ACTIVE_STATE from V$INSTANCE;

--17.EX. ������������� �������� �������� ����. ���������� ��� �����. ���������� ��� �������������� � ��������� � ��� �������. ���������� ������������������ SCN � ������� � �������� �������. 
alter system switch logfile;
select * from v$archived_log; --1124237505    4180900  4183996


--18.EX. ��������� �������������. ���������, ��� ������������� ���������. 
--shutdown immediate;
--startup mount;
--alter database noarchivelog;
--alter database open;
select NAME, LOG_MODE from V$DATABASE;
select INSTANCE_NAME, ARCHIVER, ACTIVE_STATE from V$INSTANCE;


--19.�������� ������ ����������� ������.
select * from v$controlfile;


--20.�������� � ���������� ���������� ������������ �����. �������� ��������� ��� ��������� � �����.
show parameter control;
select * from v$controlfile_record_section;


--21.���������� �������������� ����� ���������� ��������. ��������� � ������� ����� �����. 
--/opt/oracle/oradata/dbconfig/ORCL/SPFILEORCL.ora
--select * from v$parameter; ����������

--22.����������� PFILE � ������ XXX_PFILE.ORA. ���������� ��� ����������. �������� ��������� ��� ��������� � �����.
--create pfile = 'MNS_PFILE.ORA' from spfile; sysdba
-- cat /opt/oracle/homes/OraDB21Home1/dbs/MNS_PFILE.ORA

--23.���������� �������������� ����� ������� ��������. ��������� � ������� ����� �����. 
--"/opt/oracle/oradata/dbconfig/ORCL/orapwORCL"

--24.�������� �������� ����������� ��� ������ ��������� � �����������. 
select * from v$diag_info;

--25.EX. ������� � ���������� ���������� ��������� ������ �������� (LOG.XML), ������� � ��� ������� ������������ �������� ������� �� ���������.
--/opt/oracle/diag/rdbms/orcl/ORCL/alert


