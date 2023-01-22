--1.Определите общий размер области SGA.
--select * from v$sga;
select SUM(VALUE) from v$sga;

--2.Определите текущие размеры основных пулов SGA.
select component, current_size from v$sga_dynamic_components where component in ('shared pool', 'large pool', 'java pool', 'streams pool');

--3.Определите размеры гранулы для каждого пула.
select COMPONENT, GRANULE_SIZE from v$sga_dynamic_components where current_size > 0;

--4.Определите объем доступной свободной памяти в SGA.
--select sum(min_size), sum(max_size), sum(current_size) from v$sga_dynamic_components;
select current_size from v$sga_dynamic_free_memory;

--5.Определите размеры пулов КЕЕP, DEFAULT и RECYCLE буферного кэша.
select component, min_size, current_size, max_size from v$sga_dynamic_components where component like '%cache%';


--6.Создайте таблицу, которая будут помещаться в пул КЕЕP. Продемонстрируйте сегмент таблицы.
create table T_6(x int) storage(buffer_pool keep) tablespace users; --по умолчанию пул default
insert into T_6 values (1);
commit;

select segment_name, segment_type, tablespace_name, buffer_pool from user_segments where buffer_pool = 'KEEP';
drop table T_6;


--7.Создайте таблицу, которая будут кэшироваться в пуле default. Продемонстрируйте сегмент таблицы. 
create table T_61 (x int) cache;
insert into T_61 values (1);
commit;

select * from user_segments where segment_name like '%T_61%';

drop table T_61;
--8.Найдите размер буфера журналов повтора.
show parameter log_buffer;

--9.Найдите 10 самых больших объектов в разделяемом пуле.
select pool, name, bytes from v$sgastat where pool = 'shared pool' order by bytes desc
fetch first 10 rows only;

--10.Найдите размер свободной памяти в большом пуле.
select pool, name, bytes from v$sgastat where pool = 'large pool' and name = 'free memory';

--11.Получите перечень текущих соединений с инстансом. 
select * from v$session;

--12.Определите режимы текущих соединений с инстансом (dedicated, shared).
select username, server from v$session where username is not null;


--13.*Найдите самые часто используемые объекты в базе данных.
select name, type, executions from v$db_object_cache order by executions desc;
--V$DB_OBJECT_CACHE displays database objects that are cached in the library cache. Objects include tables, indexes, clusters, synonym definitions, PL/SQL procedures and packages, and triggers.

