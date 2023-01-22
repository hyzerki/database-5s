--1.Получите полный список фоновых процессов. 
select name, description from v$bgprocess;

--2.Определите фоновые процессы, которые запущены и работают в настоящий момент.
select name, description from v$bgprocess where paddr != hextoraw('00');

--3.Определите, сколько процессов DBWn работает в настоящий момент.
show parameter db_writer_processes; 

--4.Получите перечень текущих соединений с экземпляром.
--5.Определите режимы этих соединений.
--9.Получите перечень текущих соединений с инстансом. (dedicated, shared). 
select username, server from v$session where username is not null;
select * from v$session;
select * from v$process;
select v$session.username, v$session.server, v$process.pname, v$process.program 
from v$session join v$process on v$session.paddr = v$process.addr
where v$session.username is not null;

--6.Определите сервисы (точки подключения экземпляра).
select * from v$services;  

--7.Получите известные вам параметры диспетчера и их значений.
show parameter dispatcher;

--8.Укажите в списке Windows-сервисов сервис, реализующий процесс LISTENER.
--tnslsnr

--10.Продемонстрируйте и поясните содержимое файла LISTENER.ORA. 
--"/opt/oracle/oradata/dbconfig/ORCL/listener.ora" --конфигурационный файл программы listener, считывается при старте listener (указывает хост, порт, по которым подключаемся)

--11.Запустите утилиту lsnrctl и поясните ее основные команды. 
--start
--stop
--status - (READY, UNKNOWN)
--services
--servacls - get the service ACLs information --access control lists
--version
--reload - reload the parameter files and SIDs
--save_config - saves configuration changes to parameter file
--trace -set tracing to the specified level (USER | ADMIN | SUPPORT | OFF)
--quit, exit

--12.Получите список служб инстанса, обслуживаемых процессом LISTENER. 
--lsnrctl - services

select pname, program from v$process where background is null order by pname;
