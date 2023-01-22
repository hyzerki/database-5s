GRANT create view, drop any view
to MNS;
grant all on AUDITORIUM_TYPE to MNS;
set serveroutput on;
--1.Создайте таблицу, имеющую несколько атрибутов, один из которых первичный ключ.
create table Table15(id number primary key, field nvarchar2(30));
drop table Table15;
--2.Заполните таблицу строками (10 шт.).
declare
    s nvarchar2(30) := 'String number ';
begin
    for x in 1..10
    loop
        insert into Table15(id, field) values(x, concat(s, to_char(x)));
    end loop;
    commit;    
end;
select * from AUDIT;
select * from Table15;
 
--3.Создайте BEFORE – триггер уровня оператора на события INSERT, DELETE и UPDATE. 
--4.Этот и все последующие триггеры должны выдавать сообщение на серверную консоль (DMS_OUTPUT) со своим собственным именем. 
create or replace trigger BeforeTrigger
before insert or update or delete on Table15
begin 
    if inserting then 
        dbms_output.put_line('BeforeTrigger Table15 (insert)'); 
        insert into "AUDIT" values(sysdate, 'Insert', 'BeforeTrigger', ' - ');
    elsif updating then 
        dbms_output.put_line('BeforeTrigger Table15 (update)');
        insert into "AUDIT" values(sysdate, 'Update', 'BeforeTrigger', ' - ');
    elsif deleting then 
        dbms_output.put_line('BeforeTrigger Table15 (delete)');
        insert into "AUDIT" values(sysdate, 'Delete', 'BeforeTrigger', ' - ');
    end if;
end;

--5.Создайте BEFORE-триггер уровня строки на события INSERT, DELETE и UPDATE.
--6.Примените предикаты INSERTING, UPDATING и DELETING.
create or replace trigger BeforeTriggerEachRow
before insert or update or delete on Table15 for each row
begin 
    if inserting then 
        dbms_output.put_line('BeforeTriggerEachRow Table15 (insert)'); 
        insert into "AUDIT" values(sysdate, 'Insert', 'BeforeTriggerEachRow', :old.field || ' -> ' || :new.field);
    elsif updating then 
        dbms_output.put_line('BeforeTriggerEachRow Table15 (update)');
        insert into "AUDIT" values(sysdate, 'Update', 'BeforeTriggerEachRow', :old.field || ' -> ' || :new.field);
    elsif deleting then 
        dbms_output.put_line('BeforeTriggerEachRow Table15 (delete)');
        insert into "AUDIT" values(sysdate, 'Delete', 'BeforeTriggerEachRow', :old.field || ' -> ' || :new.field);
    end if;
end;

--7.Разработайте AFTER-триггеры уровня оператора на события INSERT, DELETE и UPDATE.
create or replace trigger AfterTrigger
after insert or update or delete on Table15
begin 
    if inserting then 
        dbms_output.put_line('AfterTrigger Table15 (insert)');  
        insert into "AUDIT" values(sysdate, 'Insert', 'AfterTrigger', ' - ');
    elsif updating then 
        dbms_output.put_line('AfterTrigger Table15 (update)');
        insert into "AUDIT" values(sysdate, 'Update', 'AfterTrigger', ' - ');
    elsif deleting then 
        dbms_output.put_line('AfterTrigger Table15 (delete)');
        insert into "AUDIT" values(sysdate, 'Delete', 'AfterTrigger', ' - ');
    end if;
end;


--8.Разработайте AFTER-триггеры уровня строки на события INSERT, DELETE и UPDATE.
create or replace trigger AfterTriggerEachRow
after insert or update or delete on Table15 for each row
begin 
    if inserting then 
        dbms_output.put_line('AfterTriggerEachRow Table15 (insert)');  
        insert into "AUDIT" values(sysdate, 'Insert', 'AfterTriggerEachRow', :old.field || ' -> ' || :new.field);
    elsif updating then 
        dbms_output.put_line('AfterTriggerEachRow Table15 (update)');
        insert into "AUDIT" values(sysdate, 'Update', 'AfterTriggerEachRow', :old.field || ' -> ' || :new.field);
    elsif deleting then 
        dbms_output.put_line('AfterTriggerEachRow Table15 (delete)');
        insert into "AUDIT" values(sysdate, 'Delete', 'AfterTriggerEachRow', :old.field || ' -> ' || :new.field);
    end if;
end;


--9.Создайте таблицу с именем AUDIT. Таблица должна содержать поля: OperationDate, 
--OperationType (операция вставки, обновления и удаления),
--TriggerName(имя триггера),
--Data (строка с значениями полей до и после операции).
create table "AUDIT"(OperationDate date, OperationType varchar(40), TriggerName varchar(40), Data varchar(40));
select * from "AUDIT";

--10.Измените триггеры таким образом, чтобы они регистрировали все операции с исходной таблицей в таблице AUDIT.
insert into Table15(id, field) values(11, 'String number 11');
insert into Table15(id, field) values(12, 'String number 12');
insert into Table15(id, field) values(13, 'String number 13');
update Table15 set field = 'String number 13' where id = 12;
delete from Table15 where id = 13; 

rollback;
--11.Выполните операцию, нарушающую целостность таблицы по первичному ключу. Выясните, зарегистрировал ли триггер это событие. Объясните результат.
insert into Table15(id, field) values(1, 'field');

--12.Удалите (drop) исходную таблицу. Объясните результат. Добавьте триггер, запрещающий удаление исходной таблицы.
drop table Table15; --Удалились триггеры

create or replace trigger ForbidDropTable15
before drop on schema
begin
    if ora_dict_obj_name = 'TABLE15' then
        raise_application_error (-20000, 'Do not drop table ' || ora_dict_obj_name);
    end if;
end; 


--13.Удалите (drop) таблицу AUDIT. Просмотрите состояние триггеров с помощью SQL-DEVELOPER. Объясните результат. Измените триггеры.
drop table "AUDIT"; --состояние - с крестиком - ссылается на несуществующий объект


--14.Создайте представление над исходной таблицей. Разработайте INSTEADOF INSERT-триггер. Триггер должен добавлять строку в таблицу.
create or replace view Table15View as select * from Table15;

create or replace trigger Table15ViewInsteadOfInsert
instead of insert on Table15View
for each row
begin
    dbms_output.put_line('Table15ViewInsteadOfInsert');
    insert into "AUDIT" values(sysdate, 'Insert', 'Table15ViewInsteadOfInsert', :new.field);
    insert into Table15 values(:new.id, :new.field);
end;

insert into Table15View values(13, '13');
select * from "AUDIT";
rollback;

--15.Продемонстрируйте, в каком порядке выполняются триггеры.