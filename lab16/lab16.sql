ALTER SESSION SET nls_date_format='dd-mm-yyyy hh24:mi:ss';

--5.	Введите с помощью операторов INSERT данные в таблицы T_RANGE, T_INTERVAL, T_HASH, T_LIST. Данные должны быть такими,
--чтобы они разместились по всем секциям. Продемонстрируйте это с помощью SELECT запроса. 


--6.	Продемонстрируйте для всех таблиц процесс перемещения строк между секциями, при изменении (оператор UPDATE) ключа секционирования.

--1.	Создайте таблицу T_RANGE c диапазонным секционированием. Используйте ключ секционирования типа NUMBER. 
drop table T_Range; 
create table T_Range
(
  id number,
  time_id date
)
partition by range(id)
(
  partition q1 values less than (10),
  partition q2 values less than (30),
  partition q3 values less than (70),
  partition max values less than (maxvalue)
);

insert into T_Range(id, time_id) values(5, '01-01-2021');
insert into T_Range(id, time_id) values(15,'01-02-2021');
insert into T_Range(id, time_id) values(20,'01-03-2021');
insert into T_Range(id, time_id) values(35,'01-04-2021');
insert into T_Range(id, time_id) values(100,'01-05-2021');
commit;

select * from T_Range partition(q1);
select * from T_Range partition(q2);
select * from T_Range partition(q3);
select * from T_Range partition(max);


--select * from T_Range partition for(20);

alter table T_Range enable row movement;
update T_Range partition(q1) set id = id + 100;
select * from T_Range partition(q1);
select * from T_Range partition(max);
rollback;

--2.	Создайте таблицу T_INTERVAL c интервальным секционированием. Используйте ключ секционирования типа DATE.
create table T_Interval
(
  id number,
  time_id date
)
partition by range(time_id) interval (numtoyminterval(1,'month'))
(
  partition i1 values less than (to_date ('01-01-2021', 'dd-mm-yyyy')),
  partition i2 values less than (to_date ('01-06-2021', 'dd-mm-yyyy')),
  partition i3 values less than (to_date ('01-12-2021', 'dd-mm-yyyy'))
);

insert into T_Interval(id, time_id) values(5,'01-01-2021');
insert into T_Interval(id, time_id) values(15,'01-01-2021');
insert into T_Interval(id, time_id) values(18,'01-06-2021');
insert into T_Interval(id, time_id) values(25,'01-06-2021');
insert into T_Interval(id, time_id) values(30,'01-06-2021');
insert into T_Interval(id, time_id) values(45,'01-12-2021');
insert into T_Interval(id, time_id) values(55,'01-12-2021');
insert into T_Interval(id, time_id) values(45,'03-12-2021');
insert into T_Interval(id, time_id) values(55,'03-12-2021');
insert into T_Interval(id, time_id) values(45,'03-12-2020');
insert into T_Interval(id, time_id) values(55,'03-12-2020');
commit;

select * from T_Interval partition(i1);
select * from T_Interval partition(i2);
select * from T_Interval partition(i3);

alter table T_Interval enable row movement;
update T_Interval partition(i1) set time_id = time_id + 90;
select * from T_Interval partition(i1);
select * from T_Interval partition(i2);
select * from T_Interval partition(i3);
rollback;

--3.	Создайте таблицу T_HASH c хэш-секционированием. Используйте ключ секционирования типа VARCHAR2.
drop table T_Hash;
create table T_Hash
(
  key varchar2(50),
  id number
)
partition by hash (key)
(
  partition h1,
  partition h2,
  partition h3,
  partition h4
);
begin
    for x in 1..10
    loop insert into T_Hash(key, id) values(concat('key ', to_char(x)), x); end loop;
end;
commit;
select * from T_Hash partition(h1);
select * from T_Hash partition(h2);
select * from T_Hash partition(h3);
select * from T_Hash partition(h4);

alter table T_Hash enable row movement;
update T_Hash partition(h1) set key='key 500';
rollback;


--4.	Создайте таблицу T_LIST со списочным секционированием. Используйте ключ секционирования типа CHAR.
create table T_List
(
  key char(3)
)
partition by list (key)
(
  partition l1 values ('a'),
  partition l2 values ('b'),
  partition l3 values ('c'),
  partition l4 values (default)
);

insert into  T_List(key) values('a');
insert into  T_List(key) values('b');
insert into  T_List(key) values('c');
insert into  T_List(key) values('a');
insert into  T_List(key) values('b');
insert into  T_List(key) values('a');
insert into  T_List(key) values('q');
insert into  T_List(key) values('w');
insert into  T_List(key) values('e');
commit;
select * from T_List partition (l1);
select * from T_List partition (l2);
select * from T_List partition (l3);
select * from T_List partition (l4);


alter table T_List enable row movement;
update T_List partition(l1) set key='e' where key = 'a';
select * from T_List partition(l1);
select * from T_List partition (l4);

--7.	Для одной из таблиц продемонстрируйте действие оператора ALTER TABLE MERGE.
select * from T_Range partition(q1);
select * from T_Range partition(q2);
alter table T_Range merge partitions q1, q2 into partition q_merged12;
select * from T_Range partition(q_merged12);

--8.	Для одной из таблиц продемонстрируйте действие оператора ALTER TABLE SPLIT.
alter table T_Range split partition q_merged12 into 
(partition q1 values less than (10), partition q2);
select * from user_tab_partitions where table_name like('T_RANGE');

--9.	Для одной из таблиц продемонстрируйте действие оператора ALTER TABLE EXCHANGE.
create table T_List1(key char(3));
alter table T_List exchange partition l4 with table T_List1 without validation;

select * from T_list;
select * from T_list1;

select * from user_segments;
select * from user_objects;

select * from user_part_tables where table_name in('T_HASH', 'T_INTERVAL', 'T_LIST', 'T_RANGE');
select * from user_tables where table_name in('T_HASH', 'T_INTERVAL', 'T_LIST', 'T_RANGE');
select * from user_tab_partitions where table_name in('T_HASH', 'T_INTERVAL', 'T_LIST', 'T_RANGE');


