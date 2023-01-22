ALTER DATABASE OPEN;

-- 1. Получите список всех существующих PDB в рамках экземпляра ORA12W. Определите их текущее состояние.
select name,open_mode from v$pdbs; 

-- 2. Выполните запрос к ORA12W, позволяющий получить перечень экземпляров.
select INSTANCE_NAME from v$instance;

-- 3. Выполните запрос к ORA12W, позволяющий получить перечень установленных компонентов СУБД Oracle 12c и их версии и статус. 
select * from PRODUCT_COMPONENT_VERSION;

-- 4. Создайте собственный экземпляр PDB (необходимо подключиться к серверу с серверного компьютера и используйте Database Configuration Assistant) с именем XXX_PDB, где XXX – инициалы студента. 

-- 5. Получите список всех существующих PDB в рамках экземпляра ORA12W. Убедитесь, что созданная PDB-база данных существует.
select name,open_mode from v$pdbs;


-- 6. Подключитесь к XXX_PDB c помощью SQL Developer создайте инфраструктурные объекты (табличные пространства, роль, профиль безопасности, пользователя с именем U1_XXX_PDB).
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

-- 7. Подключитесь к пользователю U1_XXX_PDB, с помощью SQL Developer, создайте таблицу XXX_table, добавьте в нее строки, выполните SELECT-запрос к таблице.
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

-- 8. С помощью представлений словаря базы данных определите, все табличные пространства, все  файлы (перманентные и временные), все роли (и выданные им привилегии), профили безопасности, всех пользователей  базы данных XXX_PDB и  назначенные им роли.
select * from DBA_USERS; 
select * from DBA_TABLESPACES; 
select * from DBA_DATA_FILES;   
select * from DBA_TEMP_FILES;  
select * from DBA_ROLES;
select * from DBA_ROLE_PRIVS t1 inner join DBA_SYS_PRIVS t2 on t1.GRANTED_ROLE = t2.GRANTEE where t1.GRANTEE='U1_MNS_PDB'; 

select * from DBA_PROFILES; 

-- 9. Подключитесь  к CDB-базе данных, создайте общего пользователя с именем C##XXX, назначьте ему привилегию, позволяющую подключится к базе данных XXX_PDB. Создайте 2 подключения пользователя C##XXX в SQL Developer к CDB-базе данных и  XXX_PDB – базе данных. Проверьте их работоспособность.  
create user C##MNS identified by orcl1
account unlock;
-- 10. Назначьте привилегию, разрешающему подключение к XXX_PDB общему пользователю C##YYY, созданному другим студентом. Убедитесь в работоспособности  этого пользователя в базе данных XXX_PDB. 
grant create session to  C##MNS;
commit;



select * from v$session where USERNAME is not null;

select PRIVILEGE from USER_SYS_PRIVS; 
-- 11. Подключитесь к пользователю U1_XXX_PDB со своего компьютера, а к пользователям C##XXX и C##YYY с другого (к XXX_PDB-базе данных). На своем компьютере получите список всех текущих подключений к XXX_PDB (найдите в списке созданные вами подключения). На своем компьютере получите список всех текущих подключений к СDB (найдите в списке созданные вами подключений).

-- 12. Продемонстрируйте преподавателю, работоспособную PDB-базу данных и созданную инфраструктуру (результаты всех запросов). Покажите файлы PDB-базы данных (на серверном компьютере).

-- 13. Удалите созданную базу данных XXX_DB. Убедитесь, что все файлы PDB-базы данных удалены. Удалите пользователя C##XXX. Удалите в SQL Developer все подключения к XXX_PDB.