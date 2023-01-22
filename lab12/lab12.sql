--1.Добавьте в таблицу TEACHERS два столбца Birthday и Salary, заполните их значениями.
alter table teacher add (birthday date, salary int);
select * from teacher;
update teacher set birthday = SYSDATE;
update teacher set birthday = TO_DATE('04-11-2021') where PULPIT like ('%ИСиТ%');
update teacher set birthday = TO_DATE('03-11-2021') where PULPIT like ('%ОВ%');
update teacher set birthday = TO_DATE('02-11-2021') where PULPIT like ('%ЛУ%');
update teacher set birthday = TO_DATE('01-12-2021') where PULPIT like ('%ПОиСОИ%');
update teacher set birthday = TO_DATE('06-09-2002') where PULPIT like ('%ЭТиМ%');
update teacher set birthday = TO_DATE('26-05-2002') where PULPIT like ('%ОХ%');

update teacher set salary = 1000;
update teacher set salary = 1500 where PULPIT like ('%ИСиТ%');
update teacher set salary = 600 where PULPIT like ('%ОВ%');
update teacher set salary = 800 where PULPIT like ('%ЛУ%');
update teacher set salary = 300 where PULPIT like ('%ПОиСОИ%');
update teacher set salary = 560 where PULPIT like ('%ЭТиМ%');
update teacher set salary = 500 where PULPIT like ('%ОХ%');
update teacher set salary = 2500 where TEACHER like ('%?%');
commit;

--2.Получите список преподавателей в виде Фамилия И.О.
declare
    cursor curs_teacher is select teacher_name from teacher;
    m_teacher_name  teacher.teacher_name%type;
    idx int;
begin
    open curs_teacher;
    loop
        fetch curs_teacher into m_teacher_name;
        idx:=instr(m_teacher_name, ' ');
        dbms_output.put_line(substr(m_teacher_name, 1, idx) ||
                             substr(m_teacher_name, idx+1, 1) || '.' ||  
                             substr(m_teacher_name, instr(m_teacher_name, ' ', idx+1) +1, 1) || '.' || 
                             ' ----- ' ||m_teacher_name);
    exit when curs_teacher%notfound;
    end loop;
    close curs_teacher;
exception
    when others
    then dbms_output.put_line(sqlerrm ||' ('|| sqlcode  ||')');
end;

--3.Получите список преподавателей, родившихся в понедельник.
select * from teacher where to_char((birthday), 'd', 'NLS_DATE_LANGUAGE = RUSSIAN') = 2; --вторник

--4.Создайте представление, в котором поместите список преподавателей, которые родились в следующем месяце.
drop view teachers4;
create view teachers4 as select teacher_name, birthday from teacher 
where extract(month from birthday) = extract(month from (ADD_MONTHS(SYSDATE, 1)));
select * from teachers4;

select (ADD_MONTHS(SYSDATE, 2)) from dual;

--5.Создайте представление, в котором поместите количество преподавателей, которые родились в каждом месяце.
create view teachers5 as 
select count(*) as count, extract(month from birthday) as month 
from teacher group by (extract(month from birthday));
select * from teachers5;

--6.Создать курсор и вывести список преподавателей, у которых в следующем году юбилей.
declare
    cursor curs_teacher6 is select * from teacher;
    m_teacher teacher%rowtype;
    nextyear int := extract(year from current_date) + 1;
begin
    open curs_teacher6;
    loop
        fetch curs_teacher6 into m_teacher;
        if (mod(nextyear - extract(year from m_teacher.birthday), 10) = 0) 
        then dbms_output.put_line(m_teacher.teacher_name || '-' || m_teacher.birthday);
        end if;
    exit when curs_teacher6%notfound;
    end loop;
    close curs_teacher6;
exception
    when others
    then dbms_output.put_line(sqlerrm ||' ('|| sqlcode  ||')');
end;


--7.Создать курсор и вывести среднюю заработную плату по кафедрам с округлением вниз до целых, вывести средние итоговые значения для каждого факультета и для всех факультетов в целом
declare
    cursor curs_salary7 is
    select floor(avg(teacher.salary)), nvl(teacher.pulpit, 'Average'), nvl(pulpit.faculty, 'Average')
    from teacher inner join pulpit on teacher.pulpit = pulpit.pulpit
    group by rollup(pulpit.faculty,  teacher.pulpit);
    
    m_avg_salary teacher.salary%type;
    m_pulpit varchar(200);
    m_faculty varchar(200);
begin
    null;
    open curs_salary7;
    loop
         fetch curs_salary7 into m_avg_salary, m_pulpit, m_faculty;
         dbms_output.put_line(curs_salary7%rowcount || chr(9) || m_avg_salary|| ' ' ||chr(9)||  m_faculty || ' ' || m_pulpit);
    exit when curs_salary7%notfound;
    end loop;
exception
    when others
    then dbms_output.put_line(sqlerrm ||' ('|| sqlcode  ||')');
end;


--8.Создайте собственный тип PL/SQL-записи (record) и продемонстрируйте работу с ним. Продемонстрируйте работу с вложенными записями. Продемонстрируйте и объясните операцию присвоения.
declare 
    type address8 is record
    (
        street varchar2(30):='Sverdlova'
    );
    type student8 is record
    (
        name varchar2(30):='Zinovich Lizaveta',
        mark int := 9,
        address address8
    );
    t1 student8;
begin 
    dbms_output.put_line(t1.name ||' '|| t1.mark ||' '|| t1.address.street);
    t1.name:= 'Zinovich Anastasia';
    t1.mark := 10;
    dbms_output.put_line(t1.name||' '|| t1.mark ||' ' || t1.address.street);
end;

