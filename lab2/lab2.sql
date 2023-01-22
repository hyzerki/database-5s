
ALTER DATABASE OPEN;

SELECT FILE_NAME, TABLESPACE_NAME, STATUS, MAXBYTES, USER_BYTES FROM DBA_DATA_FILES
UNION
SELECT FILE_NAME, TABLESPACE_NAME, STATUS, MAXBYTES, USER_BYTES FROM DBA_TEMP_FILES;

--������� 1. �������� ��������� ������������ ��� ���������� ������ �� ���������� �����������

CREATE TABLESPACE TS_MNS
    DATAFILE 'ts_MNS.dbf'
    SIZE 7M
    AUTOEXTEND ON NEXT 5M
    MAXSIZE 20M
    EXTENT MANAGEMENT LOCAL;
COMMIT;

DROP TABLESPACE TS_MNS INCLUDING CONTENTS AND DATAFILES;



--������� 2. �������� ��������� ������������ ��� ��������� ������ �� ���������� �����������:
CREATE TEMPORARY TABLESPACE TS_MNS_TEMP
    TEMPFILE 'ts_MNS_TEMP.dbf'
    SIZE 5M
    AUTOEXTEND ON NEXT 3M
    MAXSIZE 30M
    EXTENT MANAGEMENT LOCAL;
COMMIT;

DROP TABLESPACE TS_MNS_TEMP INCLUDING CONTENTS AND DATAFILES;

--������� 3. �������� ������ ���� ��������� �����������, ������ ���� ������ � ������� select-������� � �������.    
SELECT FILE_NAME, TABLESPACE_NAME, STATUS, MAXBYTES, USER_BYTES FROM DBA_DATA_FILES
UNION
SELECT FILE_NAME, TABLESPACE_NAME, STATUS, MAXBYTES, USER_BYTES FROM DBA_TEMP_FILES;

SELECT TABLESPACE_NAME, STATUS, contents  from SYS.dba_tablespaces;

--������� 4. �������� ���� � ������ RL_XXXCORE. ��������� �� ��������� ��������� ����������:
ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;
CREATE ROLE RL_MNSCORE;
COMMIT;

--GRANT CREATE SESSION, CREATE TABLE, CREATE VIEW, CREATE PROCEDURE TO C##RL_MNSCORE;

GRANT
    CREATE SESSION,
    CREATE TABLE,
    CREATE VIEW,
    CREATE PROCEDURE,
    DROP ANY TABLE,
    DROP ANY VIEW,
    DROP ANY PROCEDURE 
TO RL_MNSCORE;
COMMIT;


DROP ROLE RL_MNSCORE;

--������� 5. ������� � ������� select-������� ���� � �������. ������� � ������� select-������� ��� ��������� ����������, ����������� ����. 
SELECT * FROM DBA_ROLES WHERE role='RL_MNSCORE';
SELECT * FROM DBA_SYS_PRIVS WHERE GRANTEE = 'RL_MNSCORE';

--������� 6. �������� ������� ������������ � ������ PF_XXXCORE, ������� �����, ����������� ������� �� ������.
CREATE PROFILE PF_MNSCORE LIMIT
    PASSWORD_LIFE_TIME 180
    SESSIONS_PER_USER 3
    FAILED_LOGIN_ATTEMPTS 7
    PASSWORD_LOCK_TIME 1
    PASSWORD_REUSE_TIME 10
    PASSWORD_GRACE_TIME DEFAULT
    CONNECT_TIME 180
    IDLE_TIME 30;
COMMIT;
DROP PROFILE PF_MNSCORE;
    
--������� 7. �������� ������ ���� �������� ��. �������� �������� ���� ���������� ������� PF_XXXCORE. �������� �������� ���� ���������� ������� DEFAULT.
SELECT * FROM DBA_PROFILES;
SELECT * FROM DBA_PROFILES WHERE PROFILE = 'PF_MNSCORE';
SELECT * FROM DBA_PROFILES WHERE PROFILE = 'DEFAULT';

--������� 8. �������� ������������ � ������ XXXCORE �� ���������� �����������:
CREATE USER MNSCORE IDENTIFIED BY default1234
DEFAULT TABLESPACE TS_MNS QUOTA UNLIMITED ON TS_MNS
TEMPORARY TABLESPACE TS_MNS_TEMP
PROFILE PF_MNSCORE
ACCOUNT UNLOCK
PASSWORD EXPIRE;

GRANT RL_MNSCORE TO MNSCORE;
GRANT CREATE TABLESPACE, ALTER TABLESPACE TO MNSCORE;
COMMIT;

SELECT * FROM DBA_USERS;

DROP USER MNSCORE;

-- ������� 9. ����������� � �������� Oracle � ������� sqlplus � ������� ����� ������ ��� ������������ XXXCORE.  

--SQLPLUS >> connect MNSCORE/<password>@localhost:1521/pdb_main
-- alter user MNSCORE identified by <password>;


-- ������� 10. �������� ���������� � ������� SQL Developer ��� ������������ XXXCORE. �������� ����� ������� � ����� �������������.

CREATE TABLE points(x NUMBER(2), y NUMBER(2));

CREATE VIEW points_view AS SELECT * FROM points;

--������� 11. �������� ��������� ������������ � ������ XXX_QDATA (10m). ��� �������� ���������� ��� � ��������� offline. ����� ���������� ��������� ������������ � ��������� online. �������� ������������ XXX ����� 2m � ������������ XXX_QDATA. �� ����� ������������ XXX �������� ������� � ������������ XXX_T1. � ������� �������� 3 ������.

GRANT CREATE TABLESPACE,
    ALTER TABLESPACE TO MNSCORE;
    
CREATE TABLESPACE MNS_QDATA
    DATAFILE 'MNS_QDATA.dbf'
    SIZE 10M
    EXTENT MANAGEMENT LOCAL
    OFFLINE;
commit;
ALTER TABLESPACE MNS_QDATA ONLINE;
ALTER USER MNSCORE QUOTA 2M ON MNS_QDATA;

INSERT INTO POINTS(X, Y) VALUES (1, 1);
INSERT INTO POINTS(X, Y) VALUES (1, 2);
INSERT INTO POINTS(X, Y) VALUES (1, 3);