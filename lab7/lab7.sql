--1.�������� ������ ������ ������� ���������. 
select name, description from v$bgprocess;

--2.���������� ������� ��������, ������� �������� � �������� � ��������� ������.
select name, description from v$bgprocess where paddr != hextoraw('00');

--3.����������, ������� ��������� DBWn �������� � ��������� ������.
show parameter db_writer_processes; 

--4.�������� �������� ������� ���������� � �����������.
--5.���������� ������ ���� ����������.
--9.�������� �������� ������� ���������� � ���������. (dedicated, shared). 
select username, server from v$session where username is not null;
select * from v$session;
select * from v$process;
select v$session.username, v$session.server, v$process.pname, v$process.program 
from v$session join v$process on v$session.paddr = v$process.addr
where v$session.username is not null;

--6.���������� ������� (����� ����������� ����������).
select * from v$services;  

--7.�������� ��������� ��� ��������� ���������� � �� ��������.
show parameter dispatcher;

--8.������� � ������ Windows-�������� ������, ����������� ������� LISTENER.
--tnslsnr

--10.����������������� � �������� ���������� ����� LISTENER.ORA. 
--"/opt/oracle/oradata/dbconfig/ORCL/listener.ora" --���������������� ���� ��������� listener, ����������� ��� ������ listener (��������� ����, ����, �� ������� ������������)

--11.��������� ������� lsnrctl � �������� �� �������� �������. 
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

--12.�������� ������ ����� ��������, ������������� ��������� LISTENER. 
--lsnrctl - services

select pname, program from v$process where background is null order by pname;
