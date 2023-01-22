ALTER DATABASE OPEN;

-- 1. �������� ������ ���� ������������ PDB � ������ ���������� ORA12W. ���������� �� ������� ���������.
select name,open_mode from v$pdbs; 

-- 2. ��������� ������ � ORA12W, ����������� �������� �������� �����������.
select INSTANCE_NAME from v$instance;

-- 3. ��������� ������ � ORA12W, ����������� �������� �������� ������������� ����������� ���� Oracle 12c � �� ������ � ������. 
select * from PRODUCT_COMPONENT_VERSION;

-- 4. �������� ����������� ��������� PDB (���������� ������������ � ������� � ���������� ���������� � ����������� Database Configuration Assistant) � ������ XXX_PDB, ��� XXX � �������� ��������. 

-- 5. �������� ������ ���� ������������ PDB � ������ ���������� ORA12W. ���������, ��� ��������� PDB-���� ������ ����������.
select name,open_mode from v$pdbs;


-- 6. ������������ � XXX_PDB c ������� SQL Developer �������� ���������������� ������� (��������� ������������, ����, ������� ������������, ������������ � ������ U1_XXX_PDB).
CREATE TABLESPACE TS1_MNS_PDB
    DATAFILE 'ts1_MNS_PDB.dbf'
    SIZE 7M
    AUTOEXTEND ON NEXT 5M
    MAXSIZE 20M
    EXTENT MANAGEMENT LOCAL;
COMMIT;

DROP TABLESPACE TS1_MNS_PDB INCLUDING CONTENTS AND DATAFILES;

CREATE TEMPORARY TABLESPACE TS1_MNS_TEMP_PDB
    TEMPFILE 'ts1_MNS_TEMP_PDB.dbf'
    SIZE 5M
    AUTOEXTEND ON NEXT 3M
    MAXSIZE 30M
    EXTENT MANAGEMENT LOCAL;
COMMIT;

DROP TABLESPACE TS1_MNS_TEMP_PDB INCLUDING CONTENTS AND DATAFILES;



ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;
CREATE ROLE RL_MNS_PDB;
COMMIT;

DROP ROLE RL_MNS_PDB;

grant create session, create any table, create any view, create any procedure,ALTER ANY SEQUENCE,CREATE SEQUENCE to RL_MNS_PDB;
grant  create  view to RL_MNS_PDB;
grant drop any table, drop any view, drop any procedure to RL_MNS_PDB;
commit;
COMMIT;


CREATE PROFILE PF_MNS LIMIT
    PASSWORD_LIFE_TIME 180
    SESSIONS_PER_USER 3
    FAILED_LOGIN_ATTEMPTS 7
    PASSWORD_LOCK_TIME 1
    PASSWORD_REUSE_TIME 10
    PASSWORD_GRACE_TIME DEFAULT
    CONNECT_TIME 180
    IDLE_TIME 30;
COMMIT;

DROP PROFILE PF_MNS;

CREATE USER U1_MNS_PDB IDENTIFIED BY default1234
DEFAULT TABLESPACE TS1_MNS_PDB QUOTA UNLIMITED ON TS1_MNS_PDB
TEMPORARY TABLESPACE TS1_MNS_TEMP_PDB
PROFILE PF_MNS
ACCOUNT UNLOCK;

GRANT RL_MNS_PDB TO U1_MNS_PDB;
GRANT CREATE TABLESPACE, ALTER TABLESPACE TO U1_MNS_PDB;
COMMIT;

DROP USER U1_MNS_PDB;

-- 7. ������������ � ������������ U1_XXX_PDB, � ������� SQL Developer, �������� ������� XXX_table, �������� � ��� ������, ��������� SELECT-������ � �������.
create table MNS_table(
    x int,
    s varchar(20)
)


insert into MNS_table(x,s) values(1,'asd');
insert into MNS_table(x,s) values(2,'ashx');
insert into MNS_table(x,s) values(3,'afgd');
insert into MNS_table(x,s) values(4,'add');
commit;

select * from MNS_table;

-- 8. � ������� ������������� ������� ���� ������ ����������, ��� ��������� ������������, ���  ����� (������������ � ���������), ��� ���� (� �������� �� ����������), ������� ������������, ���� �������������  ���� ������ XXX_PDB �  ����������� �� ����.
select * from DBA_USERS; 
select * from DBA_TABLESPACES; 
select * from DBA_DATA_FILES;   
select * from DBA_TEMP_FILES;  
select * from DBA_ROLES;
select * from DBA_ROLE_PRIVS t1 inner join DBA_SYS_PRIVS t2 on t1.GRANTED_ROLE = t2.GRANTEE where t1.GRANTEE='U1_MNS_PDB'; 

select * from DBA_PROFILES; 

-- 9. ������������  � CDB-���� ������, �������� ������ ������������ � ������ C##XXX, ��������� ��� ����������, ����������� ����������� � ���� ������ XXX_PDB. �������� 2 ����������� ������������ C##XXX � SQL Developer � CDB-���� ������ �  XXX_PDB � ���� ������. ��������� �� �����������������.  
create user C##MNS identified by orcl1
account unlock;
-- 10. ��������� ����������, ������������ ����������� � XXX_PDB ������ ������������ C##YYY, ���������� ������ ���������. ��������� � �����������������  ����� ������������ � ���� ������ XXX_PDB. 
grant create session to  C##MNS;
commit;



select * from v$session where USERNAME is not null;

select PRIVILEGE from USER_SYS_PRIVS; 
-- 11. ������������ � ������������ U1_XXX_PDB �� ������ ����������, � � ������������� C##XXX � C##YYY � ������� (� XXX_PDB-���� ������). �� ����� ���������� �������� ������ ���� ������� ����������� � XXX_PDB (������� � ������ ��������� ���� �����������). �� ����� ���������� �������� ������ ���� ������� ����������� � �DB (������� � ������ ��������� ���� �����������).

-- 12. ����������������� �������������, ��������������� PDB-���� ������ � ��������� �������������� (���������� ���� ��������). �������� ����� PDB-���� ������ (�� ��������� ����������).

-- 13. ������� ��������� ���� ������ XXX_DB. ���������, ��� ��� ����� PDB-���� ������ �������. ������� ������������ C##XXX. ������� � SQL Developer ��� ����������� � XXX_PDB.