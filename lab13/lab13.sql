--select * from USER_SYS_PRIVS;
--1.Разработайте локальную процедуру  GET_TEACHERS (PCODE TEACHER.PULPIT%TYPE) 
--Процедура должна выводить список преподавателей из таблицы TEACHER (в стандартный серверный вывод), работающих на кафедре заданной кодом в параметре. Разработайте анонимный блок и продемонстрируйте выполнение процедуры.
declare procedure get_teachers(pcode teacher.pulpit%type) 
is
    cursor curs_1 is select * from teacher where pulpit = pcode;
    m_teacher teacher%rowtype;
begin
    open curs_1;
    loop
        fetch curs_1 into m_teacher;
        exit when curs_1%notfound;
        dbms_output.put_line(m_teacher.pulpit ||' ' || m_teacher.teacher_name||' ');
    end loop;
    close curs_1;
end;
begin
  get_teachers('ПОиСОИ');
end;


--факультета нет - показать сообщение
--есть - удалить, кафедры переместить
declare procedure delete_fac(fcode faculty.faculty%type) 
is
    cursor curs_1 is select * from faculty where faculty = fcode;
    m_faculty faculty%rowtype;
begin
    open curs_1;
    loop
        fetch curs_1 into m_faculty;
        exit when curs_1%notfound;
        dbms_output.put_line(m_faculty.faculty);
    if (curs_1%rowcount = 0) then dbms_output.put_line('Такого факультета нет'); end if;
    end loop;
    close curs_1;
end;
begin
  delete_fac('ЛХФ1');
end;



--1.Разработайте локальную процедуру  GET_TEACHERS (PCODE TEACHER.PULPIT%TYPE) 
--Процедура должна выводить список преподавателей из таблицы TEACHER (в стандартный серверный вывод), работающих на кафедре заданной кодом в параметре. Разработайте анонимный блок и продемонстрируйте выполнение процедуры.
select * from faculty;
select * from pulpit;
declare procedure get_f(pcode faculty.faculty%type) 
is
    fcount number;
begin
    select count(*) into fcount from faculty where faculty = pcode;

    if (fcount = 0) then dbms_output.put_line('Такого факультета нет');  end if;
  
        begin
        update pulpit set faculty = 'ТОВ' where pulpit.faculty = pcode;
            delete from faculty where faculty = pcode;    
        end;
end;
begin
  get_f('ХТиТ');
end;









--2-3.Разработайте локальную функцию GET_NUM_TEACHERS (PCODE TEACHER.PULPIT%TYPE) RETURN NUMBER
--Функция должна выводить количество преподавателей из таблицы TEACHER, работающих на кафедре заданной кодом в параметре. Разработайте анонимный блок и продемонстрируйте выполнение процедуры.
declare function get_num_teachers(pcode teacher.pulpit%type) return number
is
    teachersCount number;
begin
    select count(*) into teachersCount from teacher where pulpit = pcode;
    return teachersCount;
end;
begin
    dbms_output.put_line('Количество преподавателей на кафедре ИСиТ: '|| get_num_teachers('ИСиТ'));
end; 


--4.Разработайте процедуры: GET_TEACHERS (FCODE FACULTY.FACULTY%TYPE)
--Процедура должна выводить список преподавателей из таблицы TEACHER (в стандартный серверный вывод), работающих на факультете, заданным кодом в параметре. Разработайте анонимный блок и продемонстрируйте выполнение процедуры.
create or replace procedure get_teachers(fcode faculty.faculty%type)
is
    cursor curs_4 is select teacher_name, faculty from teacher join pulpit on pulpit.pulpit = teacher.pulpit 
    where faculty = fcode;
    m_teacher_name teacher.teacher_name%type;
    m_faculty pulpit.faculty%type;
begin
    open curs_4;
    loop
        fetch curs_4 into m_teacher_name, m_faculty;
        exit when curs_4%notfound;
        dbms_output.put_line(m_faculty || ' ' || m_teacher_name);
    end loop;
    close curs_4;
end;

begin
  get_teachers('ЛХФ');
end; 
    

--GET_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE)- список дисциплин из таблицы SUBJECT, закрепленных за кафедрой, заданной кодом кафедры в параметре. Разработайте анонимный блок и продемонстрируйте выполнение процедуры.
create or replace procedure get_subjects(pcode subject.pulpit%type)
is
    cursor curs_4 is select * from subject where pulpit = pcode;
    m_subject subject%rowtype;
begin
    open curs_4;
    loop
        fetch curs_4 into m_subject;
        exit when curs_4%notfound;
        dbms_output.put_line(m_subject.pulpit || ' ' || m_subject.subject_name);
    end loop;
    close curs_4;
end;

begin
  get_subjects('ПОиСОИ');
end;

--5.Разработайте локальную функцию GET_NUM_TEACHERS (FCODE FACULTY.FACULTY%TYPE) RETURN NUMBER
--Функция должна выводить количество преподавателей из таблицы TEACHER, работающих на факультете, заданным кодом в параметре. Разработайте анонимный блок и продемонстрируйте выполнение процедуры.
declare function get_num_teachers(fcode faculty.faculty%type) return number
is
    teachersCount number;
begin
    select count(*) into teachersCount from teacher join pulpit on teacher.pulpit = pulpit.pulpit where faculty = fcode;
    return teachersCount;
end;
begin
    dbms_output.put_line('Количество преподавателей на факультете ЛХФ: ' || get_num_teachers('ЛХФ'));
end;


--GET_NUM_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE) RETURN NUMBER Функция должна выводить количество дисциплин из таблицы SUBJECT, закрепленных за кафедрой, заданной кодом кафедры параметре. 
--Разработайте анонимный блок и продемонстрируйте выполнение процедуры. 
declare function get_num_subjects(pcode subject.pulpit%type) return number 
is
    subjectsCount number;
begin
    select count(*) into subjectsCount from subject where subject.pulpit = pcode;
    return subjectsCount;
end;
begin
    dbms_output.put_line('Количество предметов на кафедре ИСиТ: '|| get_num_subjects('ПОиСОИ'));
end;


--6.Разработайте пакет TEACHERS, содержащий процедуры и функции:
--GET_TEACHERS (FCODE FACULTY.FACULTY%TYPE)
--GET_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE)
--GET_NUM_TEACHERS (FCODE FACULTY.FACULTY%TYPE) RETURN NUMBER 
--GET_NUM_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE) RETURN NUMBER 
create or replace package teachers is
    procedure get_teachers (fcode faculty.faculty%type);
    procedure get_subjects (pcode subject.pulpit%type);
    function get_num_teachers(fcode faculty.faculty%type) return number;
    function get_num_subjects(pcode subject.pulpit%type) return number;
end teachers;

create or replace package body teachers is
    teachersCount number;
    subjectsCount number;
    
    procedure get_teachers(fcode faculty.faculty%type)
    is
        cursor curs_4 is select teacher_name, faculty from teacher join pulpit on pulpit.pulpit = teacher.pulpit 
        where faculty = fcode;
        m_teacher_name teacher.teacher_name%type;
        m_faculty pulpit.faculty%type;
    begin
        open curs_4;
        loop
            fetch curs_4 into m_teacher_name, m_faculty;
            exit when curs_4%notfound;
            dbms_output.put_line(m_faculty || ' ' || m_teacher_name);
        end loop;
        close curs_4;
    end;
    
    procedure get_subjects(pcode subject.pulpit%type)
    is
        cursor curs_4 is select * from subject where pulpit = pcode;
        m_subject subject%rowtype;
    begin
        open curs_4;
        loop
            fetch curs_4 into m_subject;
            exit when curs_4%notfound;
            dbms_output.put_line(m_subject.pulpit || ' ' || m_subject.subject_name);
        end loop;
        close curs_4;
    end;

    function get_num_teachers(fcode faculty.faculty%type) return number  is 
    begin
        select count(*) into teachersCount from teacher join pulpit on teacher.pulpit = pulpit.pulpit where faculty = fcode;
        return teachersCount;
    end get_num_teachers;

    function get_num_subjects(pcode subject.pulpit%type) return number is  
    begin
        select count(*) into subjectsCount from subject where subject.pulpit = pcode;
        return subjectsCount;
    end get_num_subjects;

    begin
        null;
    exception
    when no_data_found then dbms_output.put_line('Not initialized');
end teachers;



--7.Разработайте анонимный блок и продемонстрируйте выполнение процедур и функций пакета TEACHERS.
begin
    teachers.get_teachers('ЛХФ');
    teachers.get_subjects('ПОиСОИ');
    dbms_output.put_line('Количество преподавателей на факультете ЛХФ: ' || teachers.get_num_teachers('ЛХФ'));
    dbms_output.put_line('Количество предметов на кафедре ИСиТ: '|| teachers.get_num_subjects('ПОиСОИ'));
end;
    
    
    
