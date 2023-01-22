--select * from USER_SYS_PRIVS;
--1.������������ ��������� ���������  GET_TEACHERS (PCODE TEACHER.PULPIT%TYPE) 
--��������� ������ �������� ������ �������������� �� ������� TEACHER (� ����������� ��������� �����), ���������� �� ������� �������� ����� � ���������. ������������ ��������� ���� � ����������������� ���������� ���������.
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
  get_teachers('������');
end;


--���������� ��� - �������� ���������
--���� - �������, ������� �����������
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
    if (curs_1%rowcount = 0) then dbms_output.put_line('������ ���������� ���'); end if;
    end loop;
    close curs_1;
end;
begin
  delete_fac('���1');
end;



--1.������������ ��������� ���������  GET_TEACHERS (PCODE TEACHER.PULPIT%TYPE) 
--��������� ������ �������� ������ �������������� �� ������� TEACHER (� ����������� ��������� �����), ���������� �� ������� �������� ����� � ���������. ������������ ��������� ���� � ����������������� ���������� ���������.
select * from faculty;
select * from pulpit;
declare procedure get_f(pcode faculty.faculty%type) 
is
    fcount number;
begin
    select count(*) into fcount from faculty where faculty = pcode;

    if (fcount = 0) then dbms_output.put_line('������ ���������� ���');  end if;
  
        begin
        update pulpit set faculty = '���' where pulpit.faculty = pcode;
            delete from faculty where faculty = pcode;    
        end;
end;
begin
  get_f('����');
end;









--2-3.������������ ��������� ������� GET_NUM_TEACHERS (PCODE TEACHER.PULPIT%TYPE) RETURN NUMBER
--������� ������ �������� ���������� �������������� �� ������� TEACHER, ���������� �� ������� �������� ����� � ���������. ������������ ��������� ���� � ����������������� ���������� ���������.
declare function get_num_teachers(pcode teacher.pulpit%type) return number
is
    teachersCount number;
begin
    select count(*) into teachersCount from teacher where pulpit = pcode;
    return teachersCount;
end;
begin
    dbms_output.put_line('���������� �������������� �� ������� ����: '|| get_num_teachers('����'));
end; 


--4.������������ ���������: GET_TEACHERS (FCODE FACULTY.FACULTY%TYPE)
--��������� ������ �������� ������ �������������� �� ������� TEACHER (� ����������� ��������� �����), ���������� �� ����������, �������� ����� � ���������. ������������ ��������� ���� � ����������������� ���������� ���������.
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
  get_teachers('���');
end; 
    

--GET_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE)- ������ ��������� �� ������� SUBJECT, ������������ �� ��������, �������� ����� ������� � ���������. ������������ ��������� ���� � ����������������� ���������� ���������.
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
  get_subjects('������');
end;

--5.������������ ��������� ������� GET_NUM_TEACHERS (FCODE FACULTY.FACULTY%TYPE) RETURN NUMBER
--������� ������ �������� ���������� �������������� �� ������� TEACHER, ���������� �� ����������, �������� ����� � ���������. ������������ ��������� ���� � ����������������� ���������� ���������.
declare function get_num_teachers(fcode faculty.faculty%type) return number
is
    teachersCount number;
begin
    select count(*) into teachersCount from teacher join pulpit on teacher.pulpit = pulpit.pulpit where faculty = fcode;
    return teachersCount;
end;
begin
    dbms_output.put_line('���������� �������������� �� ���������� ���: ' || get_num_teachers('���'));
end;


--GET_NUM_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE) RETURN NUMBER ������� ������ �������� ���������� ��������� �� ������� SUBJECT, ������������ �� ��������, �������� ����� ������� ���������. 
--������������ ��������� ���� � ����������������� ���������� ���������. 
declare function get_num_subjects(pcode subject.pulpit%type) return number 
is
    subjectsCount number;
begin
    select count(*) into subjectsCount from subject where subject.pulpit = pcode;
    return subjectsCount;
end;
begin
    dbms_output.put_line('���������� ��������� �� ������� ����: '|| get_num_subjects('������'));
end;


--6.������������ ����� TEACHERS, ���������� ��������� � �������:
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



--7.������������ ��������� ���� � ����������������� ���������� �������� � ������� ������ TEACHERS.
begin
    teachers.get_teachers('���');
    teachers.get_subjects('������');
    dbms_output.put_line('���������� �������������� �� ���������� ���: ' || teachers.get_num_teachers('���'));
    dbms_output.put_line('���������� ��������� �� ������� ����: '|| teachers.get_num_subjects('������'));
end;
    
    
    
