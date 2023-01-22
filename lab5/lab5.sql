--1.Получите список всех файлов табличных пространств (перманентных  и временных).
select FILE_NAME, TABLESPACE_NAME FROM DBA_DATA_FILES;
select FILE_NAME, TABLESPACE_NAME FROM DBA_TEMP_FILES;

show parameter control;

--2.Создайте табличное пространство с именем XXX_QDATA (10m). При создании установите его в состояние offline. Затем переведите табличное пространство в состояние online. Выделите пользователю XXX квоту 2m в пространстве XXX_QDATA. 
--(05_MNS) От имени XXX в  пространстве XXX_T1создайте таблицу из двух столбцов, один из которых будет являться первичным ключом. В таблицу добавьте 3 строки.
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

--2. От имени XXX в  пространстве XXX_T1создайте таблицу из двух столбцов, один из которых будет являться первичным ключом. В таблицу добавьте 3 строки.
create table MNS_T1(
    x integer primary key, 
    s varchar2(50)
) tablespace  MNS_QDATA;

insert into MNS_T1 (x, s) values (10, 'one');
insert into MNS_T1 (x, s) values (2, 'two');
insert into MNS_T1 (x, s) values (3, '3');
commit;

select * from MNS_T1;


--4.Удалите (DROP) таблицу XXX_T1. Получите список сегментов табличного пространства  XXX_QDATA. Определите сегмент таблицы XXX_T1. 
--Выполните SELECT-запрос к представлению USER_RECYCLEBIN, поясните результат.
drop table MNS_T1;
--select v file
select * from USER_RECYCLEBIN;

--5.Восстановите (FLASHBACK) удаленную таблицу. 
FLASHBACK TABLE MNS_T1 to before drop;

--6.Выполните PL/SQL-скрипт, заполняющий таблицу XXX_T1 данными (10000 строк).
declare i integer :=0;
begin
while i<1000 LOOP
insert into MNS_T1 (x, s) values (i, 'loop');
i := i+1;
end loop;
end;

commit;





--3.Получите список сегментов табличного пространства  XXX_QDATA. Определите сегмент таблицы XXX_T1. Определите остальные сегменты.
select * from dba_segments where tablespace_name like 'MNS_QDATA';

--4. 05_MNS.sql
select * from dba_segments where tablespace_name like 'MNS_QDATA';

--5. 05_MNS.sql
--6. 05_MNS.sql

--7.Определите сколько в сегменте таблицы XXX_T1 экстентов, их размер в блоках и байтах. Получите перечень всех экстентов. 
--Удалите табличное пространство XXX_QDATA и его файл.
select * from dba_segments where tablespace_name like 'MNS_QDATA';

--8.Удалите табличное пространство XXX_QDATA и его файл. 
drop tablespace MNS_QDATA including contents and datafiles;


--9.Получите перечень всех групп журналов повтора. Определите текущую группу журналов повтора.
select * from v$log;

--10.Получите перечень файлов всех журналов повтора инстанса.
select * from v$logfile;

--11.EX. С помощью переключения журналов повтора пройдите полный цикл переключений. Запишите серверное время в момент вашего первого переключения (оно понадобится для выполнения следующих заданий).
select * from v$log;
alter system switch logfile;
--2:56 AM
--SCN: 4180570 

--12.EX. Создайте дополнительную группу журналов повтора с тремя файлами журнала. Убедитесь в наличии группы и файлов, а также в работоспособности группы (переключением). Проследите последовательность SCN. 
alter database add logfile group 4 'REDO04.LOG' size 50m blocksize 512;
alter database add logfile member 'REDO041.LOG'  to group 4;
alter database add logfile member 'REDO042.LOG'  to group 4;
select * from v$log;
alter system switch logfile;
--SCN: 4180679

--13.EX. Удалите созданную группу журналов повтора. Удалите созданные вами файлы журналов на сервере.
alter database drop logfile member 'REDO042.LOG';
alter database drop logfile member 'REDO041.LOG';
alter database drop logfile group 4; 

select * from v$log;


--14.Определите, выполняется или нет архивирование журналов повтора (архивирование должно быть отключено, иначе дождитесь, пока другой студент выполнит задание и отключит).
select NAME, LOG_MODE from V$DATABASE;
select INSTANCE_NAME, ARCHIVER, ACTIVE_STATE from V$INSTANCE;

--15.Определите номер последнего архива.  
select * from v$archived_log

--16.EX.  Включите архивирование. 
--sql plus "connect as sysdba"
--shutdown immediate;
--startup mount;
--alter database archivelog;
--alter database open;
select NAME, LOG_MODE from V$DATABASE;
select INSTANCE_NAME, ARCHIVER, ACTIVE_STATE from V$INSTANCE;

--17.EX. Принудительно создайте архивный файл. Определите его номер. Определите его местоположение и убедитесь в его наличии. Проследите последовательность SCN в архивах и журналах повтора. 
alter system switch logfile;
select * from v$archived_log; --1124237505    4180900  4183996


--18.EX. Отключите архивирование. Убедитесь, что архивирование отключено. 
--shutdown immediate;
--startup mount;
--alter database noarchivelog;
--alter database open;
select NAME, LOG_MODE from V$DATABASE;
select INSTANCE_NAME, ARCHIVER, ACTIVE_STATE from V$INSTANCE;


--19.Получите список управляющих файлов.
select * from v$controlfile;


--20.Получите и исследуйте содержимое управляющего файла. Поясните известные вам параметры в файле.
show parameter control;
select * from v$controlfile_record_section;


--21.Определите местоположение файла параметров инстанса. Убедитесь в наличии этого файла. 
--/opt/oracle/oradata/dbconfig/ORCL/SPFILEORCL.ora
--select * from v$parameter; содержимое

--22.Сформируйте PFILE с именем XXX_PFILE.ORA. Исследуйте его содержимое. Поясните известные вам параметры в файле.
--create pfile = 'MNS_PFILE.ORA' from spfile; sysdba
-- cat /opt/oracle/homes/OraDB21Home1/dbs/MNS_PFILE.ORA

--23.Определите местоположение файла паролей инстанса. Убедитесь в наличии этого файла. 
--"/opt/oracle/oradata/dbconfig/ORCL/orapwORCL"

--24.Получите перечень директориев для файлов сообщений и диагностики. 
select * from v$diag_info;

--25.EX. Найдите и исследуйте содержимое протокола работы инстанса (LOG.XML), найдите в нем команды переключения журналов которые вы выполняли.
--/opt/oracle/diag/rdbms/orcl/ORCL/alert


