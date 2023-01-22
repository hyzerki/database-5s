--1. 
select * from user_sys_privs;

--2.�������� ������������������ S1 (SEQUENCE), �� ���������� ����������������: ��������� �������� 1000; ���������� 10; ��� ������������ ��������; ��� ������������� ��������;
--�� �����������; �������� �� ���������� � ������; ���������� �������� �� �������������. �������� ��������� �������� ������������������. �������� ������� �������� ������������������.
create sequence S1
increment by 10
start with 1000
nomaxvalue
nominvalue
nocycle 
nocache --������� �������� ������������������ ����� ��������� � ������ ��� �������� �������, 20def
noorder; 

select S1.nextval from dual;
select S1.currval from dual;

drop sequence S1;
--3. �������� ������������������ S2 (SEQUENCE), �� ���������� ����������������: ��������� �������� 10; 
-- ���������� 10; ������������ �������� 100; 
create sequence S2
increment by 10
start with 10
maxvalue 100
nocycle;

select S2.nextval from dual;
select S2.currval from dual;

drop sequence S2;
--5. �������� ������������������ S3 (SEQUENCE), �� ���������� ����������������: ��������� �������� 10; 
--���������� -10; ����������� �������� -100; �� �����������; ������������� ���������� ��������. 
--�������� ��� �������� ������������������. ����������� �������� ��������, ������ ������������ ��������.
create sequence S3
increment by -10
start with 10
minvalue -100
maxvalue 10
nocycle
order;

select S3.nextval from dual;
select S3.currval from dual;

drop sequence S3;
--6. �������� ������������������ S4 (SEQUENCE), �� ���������� ����������������: ��������� �������� 1; ���������� 1; 
-- ����������� �������� 10; �����������; ���������� � ������ 5 ��������; ���������� �������� �� �������������. 
-- ����������������� ����������� ��������� �������� ������������������� S4.
create sequence S4
increment by 1
start with 1
maxvalue 10
cycle
cache 5
noorder;

select S4.nextval from dual;
select S4.currval from dual;

drop sequence S4;
--7. �������� ������ ���� ������������������� � ������� ���� ������, ���������� ������� �������� ������������ XXX.
select * from sys.user_sequences
select * from sys.all_sequences where sequence_owner like('SYS');

--8. �������� ������� T1, ������� ������� N1, N2, N3, N4, ���� NUMBER (20), ���������� � ������������� � �������� ���� 
-- KEEP. � ������� ��������� INSERT �������� 7 �����, �������� �������� ��� �������� ������ ������������� � ������� 
-- ������������������� S1, S2, S3, S4.
create table T1 (n1 number(20), n2 number(20), n3 number(20), n4 number(20)) 
cache storage(buffer_pool keep);
--select * from user_segments where buffer_pool = 'KEEP';


declare i integer :=0;
begin
while i<7 LOOP
insert into T1 values (S1.nextval, S2.currval, S3.currval, S4.nextval);
i := i+1;
end loop;
end;
commit;

select * from T1;


--9.�������� ������� ABC, ������� hash-��� (������ 200) � ���������� 2 ����: X�(NUMBER (10)), V (VARCHAR2(12)).
create cluster ABC (x number(10), v varchar(12)) hashkeys 200; --������������ ���������� ���������� ���-��������, ������� ����� ���� ������������� ���-��������

--10.�������� ������� A, ������� ������� XA (NUMBER (10)) � VA (VARCHAR2(12)), ������������� �������� ABC, � ����� ��� ���� ������������ �������.
create table A (XA number(10), VA varchar(12), PA varchar(10)) cluster ABC(XA, VA); 

--11. �������� ������� B, ������� ������� XB (NUMBER (10)) � VB (VARCHAR2(12)), ������������� �������� ABC, � ����� ��� ���� ������������ �������.
create table B (XB number(10), VB varchar(12), PB varchar(10)) cluster ABC(XB, VB); 

--12. �������� ������� �, ������� ������� X� (NUMBER (10)) � V� (VARCHAR2(12)), ������������� �������� ABC, � ����� ��� ���� ������������ �������.
create table C (XC number(10), VC varchar(12), PC varchar(10)) cluster ABC(XC, VC); 

--13. ������� ��������� ������� � ������� � �������������� ������� Oracle.
select * from all_clusters;
select * from all_tables where table_name in ('A', 'B', 'C');
select * from user_segments;

--14.�������� ������� ������� ��� ������� XXX.� � ����������������� ��� ����������.
create synonym CTable for C;
select * from CTable;

--15.�������� ��������� ������� ��� ������� XXX.B � ����������������� ��� ����������.
create public synonym BTable for B;
select * from BTable;

--16.�������� ��� ������������ ������� A � B (� ��������� � ������� �������), 
--��������� �� �������, �������� ������������� V1, ���������� �� SELECT... FOR A inner join B. 
--����������������� ��� �����������������.
create table A1(x integer primary key, s varchar2(50));
create table B1(y integer primary key, x integer, s varchar2(50), constraint FK_AB foreign key (x) references A1(x));

declare 
    i integer :=0; 
    j integer :=40;
begin
while i<40 LOOP
insert into A1 (x, s) values (i, 'A');
insert into B1 (y, x, s) values (j, i, 'B');
i := i+1;
j := j-1;
end loop;
end;

commit;

select * from A1;
select * from B1;

create view V1(a1x, a1s, b1y, b1s) as select A1.x, A1.s, B1.y, B1.s from A1 inner join B1 on A1.x = B1.x;
select * from V1;

--17.�� ������ ������ A � B �������� ����������������� ������������� MV, ������� ����� ������������� 
--���������� 2 ������. ����������������� ��� �����������������.
create materialized view MV(a1x, a1s, b1y, b1s)
refresh on demand 
start with sysdate next (sysdate + numtodsinterval(2,'minute'))
as select A1.x, A1.s, B1.y, B1.s from A1 inner join B1 on A1.x = B1.x;
select count(*) from MV;
select count(*) from A1 inner join B1 on A1.x = B1.x;

declare 
    i integer :=55; 
    j integer :=50;
begin
while i<60 LOOP
insert into A1 (x, s) values (i, 'A');
insert into B1 (y, x, s) values (j, i, 'B');
i := i+1;
j := j-1;
end loop;
end;

commit;

