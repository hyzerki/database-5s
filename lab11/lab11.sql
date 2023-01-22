--1 ������������ ��, ��������������� ������ ��������� SELECT � ������ ��������. 
set serveroutput on;

declare
    faculty_rec faculty%rowtype;
begin
    select * into faculty_rec from faculty where faculty = '���';
    dbms_output.put_line(faculty_rec.faculty ||' '||faculty_rec.faculty_name);
exception
    when others
    then dbms_output.put_line(sqlerrm);
end;

describe faculty;

--2.������������ ��, ��������������� ������ ��������� SELECT � �������� ������ ��������. 
-- ����������� ����������� WHEN OTHERS ������ ���������� � ���������� ������� SQLERRM, 
-- SQLCODE ��� ���������������� �������� �������. 
declare
    faculty_rec faculty%rowtype;
begin
    select * into faculty_rec from faculty;
    dbms_output.put_line(faculty_rec.faculty ||' '||faculty_rec.faculty_name);
exception
    when others
    then dbms_output.put_line(sqlerrm ||' ('|| sqlcode  ||')');
end;

--3. ������������ ��, ��������������� ������ ����������� WHEN TO_MANY_ROWS ������ ���������� 
--��� ���������������� �������� �������. 
declare
    faculty_rec faculty%rowtype;
begin
    select * into faculty_rec from faculty;
    dbms_output.put_line(faculty_rec.faculty ||' '||faculty_rec.faculty_name);
exception
    when TOO_MANY_ROWS
    then dbms_output.put_line('TOO_MANY_ROWS: ' || sqlerrm ||' ('|| sqlcode  ||')');
end;

--4.������������ ��, ��������������� ������������� � ��������� ���������� NO_DATA_FOUND.
-- ������������ ��, ��������������� ���������� ��������� �������� �������.
declare
    b1 boolean;
    b2 boolean;
    b3 boolean;
    n  pls_integer;
    faculty_rec faculty%rowtype;
begin
    select * into faculty_rec from faculty where faculty = '���';
    --select * into faculty_rec from faculty where faculty = '���'; --������������ ���������
    b1 := sql%found;
    b2 := sql%isopen;
    b3 := sql%notfound;
    n := sql%rowcount;
    dbms_output.put_line(faculty_rec.faculty ||' '||faculty_rec.faculty_name);
    if b1 then dbms_output.put_line('b1 = true'); else dbms_output.put_line('b1 = false'); end if;
    if b2 then dbms_output.put_line('b2 = true'); else dbms_output.put_line('b2 = false'); end if;
    if b3 then dbms_output.put_line('b3 = true'); else dbms_output.put_line('b3 = false'); end if;
    dbms_output.put_line('rowcount = ' || n);
exception
    when NO_DATA_FOUND
    then dbms_output.put_line('NO_DATA_FOUND: ' || sqlerrm ||' ('|| sqlcode  ||')');
end;

--5.������������ ��, ��������������� ���������� ��������� UPDATE ��������� � ����������� COMMIT/ROLLBACK.
declare
    n  pls_integer;
begin
    update auditorium set auditorium = '43331',
                          auditorium_name = '4-1',
                          auditorium_capacity = 90,
                          auditorium_type = '��'
                    where auditorium ='4111-1';  
    --rollback
    n := sql%rowcount;
    dbms_output.put_line('n = ' || n);
    rollback;
    --commit;
exception
    when others
    then dbms_output.put_line(sqlerrm ||' ('|| sqlcode  ||')');
end;

select * from auditorium

--6. ����������������� �������� UPDATE, ���������� ��������� ����������� � ���� ������. ����������� ��������� ����������.
begin
update auditorium set auditorium = '314-1',
                      auditorium_name = '314-1',
                      auditorium_capacity = 90,
                      auditorium_type = 90
                where auditorium = '314-1'; 
commit;
exception
    when others
    then dbms_output.put_line(sqlerrm ||' ('|| sqlcode  ||')');
end;

select * from auditorium;

--7.������������ ��, ��������������� ���������� ��������� INSERT ��������� � ����������� COMMIT/ROLLBACK.
--8. ����������������� �������� INSERT, ���������� ��������� ����������� � ���� ������. ����������� ��������� ����������.
declare
    b1 boolean;
    b2 boolean;
    b3 boolean;
    n  pls_integer;
begin
    insert into auditorium(auditorium, auditorium_name, auditorium_capacity, auditorium_type)
    --values ('100-1', '100-1', 15, '��-�');
    values ('101-1', '101-1', 15, '��-�');
    b1 := sql%found;
    b2 := sql%isopen;
    b3 := sql%notfound;
    n := sql%rowcount;
    if b1 then dbms_output.put_line('b1 = true'); else dbms_output.put_line('b1 = false'); end if;
    if b2 then dbms_output.put_line('b2 = true'); else dbms_output.put_line('b2 = false'); end if;
    if b3 then dbms_output.put_line('b3 = true'); else dbms_output.put_line('b3 = false'); end if;
    dbms_output.put_line('rowcount = ' || n);
--commit;

exception
    when others
    then 
    rollback;
    dbms_output.put_line(sqlerrm ||' ('|| sqlcode  ||')');
end;

select * from auditorium;

--9. ������������ ��, ��������������� ���������� ��������� DELETE ��������� � ����������� COMMIT/ROLLBACK.
--10.����������������� �������� DELETE, ���������� ��������� ����������� � ���� ������. ����������� ��������� ����������.
declare
    b1 boolean;
    b2 boolean;
    b3 boolean;
    n  pls_integer;
begin
    delete auditorium where auditorium = '100-1';
    --delete auditorium where auditorium = 0; --10 - constraint
    b1 := sql%found;
    b2 := sql%isopen;
    b3 := sql%notfound;
    n := sql%rowcount;
    if b1 then dbms_output.put_line('b1 = true'); else dbms_output.put_line('b1 = false'); end if;
    if b2 then dbms_output.put_line('b2 = true'); else dbms_output.put_line('b2 = false'); end if;
    if b3 then dbms_output.put_line('b3 = true'); else dbms_output.put_line('b3 = false'); end if;
    dbms_output.put_line('rowcount = ' || n);
--commit;

exception
    when others
    then
    rollback;
    dbms_output.put_line(sqlerrm ||' ('|| sqlcode  ||')');
end;

--11.�������� ��������� ����, ��������������� ������� TEACHER � ����������� ������ ������� LOOP-�����. 
--��������� ������ ������ ���� �������� � ����������, ����������� � ����������� ����� %TYPE.
declare
    cursor curs_teacher is select teacher, teacher_name, pulpit from teacher;
    m_teacher       teacher.teacher%type;
    m_teacher_name  teacher.teacher_name%type;
    m_pulpit        teacher.pulpit%type;
begin
    open curs_teacher;
    loop
        fetch curs_teacher into m_teacher, m_teacher_name, m_pulpit;
    exit when curs_teacher%notfound;
    dbms_output.put_line( ' ' || chr(9)|| curs_teacher%rowcount || chr(9) ||' ' || rtrim(m_teacher) || chr(9) ||' '|| rtrim(m_teacher_name) ||' ' || m_pulpit );
    end loop;
    close curs_teacher;
exception
    when others
    then dbms_output.put_line(sqlerrm ||' ('|| sqlcode  ||')');
end;

--12.�������� ��, ��������������� ������� SUBJECT � ����������� ������ ������� � WHILE-�����. 
--��������� ������ ������ ���� �������� � ������ (RECORD), ����������� � ����������� ����� %ROWTYPE.
declare
    cursor curs_subject is select subject, subject_name, pulpit from subject;
    rec_subject subject%rowtype;
begin
    open curs_subject;
    fetch curs_subject into rec_subject;
    while curs_subject%found
    loop
        dbms_output.put_line( ' ' || curs_subject%rowcount ||' '  || rtrim(rec_subject.subject) || chr(9) || (rec_subject.subject_name) ||' ' || rec_subject.pulpit );
        fetch curs_subject into rec_subject;
    end loop;
    close curs_subject;
exception
    when others
    then dbms_output.put_line(sqlerrm ||' ('|| sqlcode  ||')');
end;

--13. �������� ��, ��������������� ��� ������� (������� PULPIT) � ������� ���� �������������� (TEACHER) �����������, 
--���������� (JOIN) PULPIT � TEACHER � � ����������� ������ ������� � FOR-�����.
declare
    cursor curs_pulpit is select pulpit.pulpit, teacher.teacher_name
    from pulpit inner join teacher on pulpit.pulpit = teacher.pulpit;
    rec_pulpit curs_pulpit%rowtype;
begin
    for rec_pulpit in curs_pulpit
    loop
        dbms_output.put_line(curs_pulpit%rowcount||' '|| chr(9) || rtrim(rec_pulpit.pulpit) ||' ' || chr(9) || rec_pulpit.teacher_name);
    end loop;
exception
    when others
    then dbms_output.put_line(sqlerrm ||' ('|| sqlcode  ||')');
end;


--14. �������� ��, ��������������� ��������� ������ ���������: ��� ��������� (������� AUDITORIUM) � ������������ ������ 
-- 20, �� 21-30, �� 31-60, �� 61 �� 80, �� 81 � ����. ��������� ������ � ����������� � ��� ������� ����������� ����� 
-- �� ������� �������.
declare
    cursor curs_auditorium (capacity_from auditorium.auditorium%type, capacity_to auditorium.auditorium%type) is 
    select auditorium, auditorium_capacity from auditorium 
    where auditorium_capacity >= capacity_from and auditorium_capacity <= capacity_to;
    
    aum auditorium.auditorium%type;
    cty auditorium.auditorium_capacity%type;
begin
    dbms_output.put_line('< 20');
    for aum in curs_auditorium(0, 20)
    loop dbms_output.put_line(aum.auditorium||' '||aum.auditorium_capacity); end loop;

    dbms_output.put_line('21 - 30');
    for aum in curs_auditorium(21,30) 
    loop dbms_output.put_line(aum.auditorium||' '||aum.auditorium_capacity);  end loop;

    dbms_output.put_line('31 - 60');
    for aum in curs_auditorium(31,60)
    loop dbms_output.put_line(aum.auditorium||' '||aum.auditorium_capacity);  end loop;

    dbms_output.put_line('61 - 80');
    for aum in curs_auditorium(61,80)
    loop dbms_output.put_line(aum.auditorium||' '||aum.auditorium_capacity); end loop;

    dbms_output.put_line('81 - 100');
    for aum in curs_auditorium(81, 100)
    loop dbms_output.put_line(aum.auditorium||' '||aum.auditorium_capacity);  end loop;
exception
    when others 
    then dbms_output.put_line(sqlerrm ||' ('|| sqlcode  ||')');
end;


--15.�������� A�. �������� ��������� ���������� � ������� ���������� ���� refcursor. ����������������� �� ���������� ��� ������� c �����������. 
variable x refcursor;
declare 
    type teacher_name_type is ref cursor return teacher%rowtype;
    xcurs teacher_name_type;
begin
    open xcurs for select * from teacher;
    :x := xcurs;
exception
    when others 
    then dbms_output.put_line(sqlerrm ||' ('|| sqlcode  ||')');
end;

print x;


--16. �������� A�. ����������������� ������� ��������� ���������
declare 
    cursor curs_aut 
    is select auditorium_type,
        cursor (select auditorium from auditorium aum where aut.auditorium_type = aum.auditorium_type)
        from auditorium_type aut;
    curs_aum sys_refcursor;
    aut auditorium_type.auditorium_type%type;
    txt varchar2(1000);
    aum auditorium.auditorium%type;
begin
    open curs_aut;
    fetch curs_aut into aut, curs_aum;
    while(curs_aut%found)
    loop
        txt := rtrim(aut)|| ':';
        loop
            fetch curs_aum into aum;
        exit when curs_aum%notfound;
            txt := txt||','||rtrim(aum);
        end loop;
        dbms_output.put_line(txt);
        fetch curs_aut into aut, curs_aum;
    end loop;
    close curs_aut;
exception
    when others
    then dbms_output.put_line(sqlerrm ||' ('|| sqlcode  ||')');
end;


--17.�������� A�. ��������� ����������� ���� ��������� (������� AUDITORIUM) ������������ �� 40 �� 80 �� 10%. 
--����������� ����� ������ � �����������, ���� FOR, ����������� UPDATE CURRENT OF. 
declare 
    cursor cursor_17 (capacity_from auditorium.auditorium%type, capacity_to auditorium.auditorium%type)
    is select auditorium, auditorium_capacity from auditorium
    where auditorium_capacity >=capacity_from and AUDITORIUM_CAPACITY <= capacity_to for update;
    
    m_auditorium auditorium.auditorium%type;
    m_capacity auditorium.auditorium_capacity%type;
begin
    open cursor_17(40,80);
    fetch cursor_17 into m_auditorium, m_capacity;
    while(cursor_17%found)
    loop
        m_capacity := m_capacity * 0.9;
        update auditorium
        set auditorium_capacity = m_capacity where current of cursor_17;
        dbms_output.put_line(m_auditorium ||' '|| m_capacity);
        fetch cursor_17 into m_auditorium, m_capacity;
    end loop;
    close cursor_17;
    rollback;
exception
    when others
    then dbms_output.put_line(sqlerrm ||' ('|| sqlcode  ||')');
end;

select * from auditorium;


--18. �������� A�. ������� ��� ��������� (������� AUDITORIUM) ������������ �� 0 �� 20. 
--����������� ����� ������ � �����������, ���� WHILE, ����������� UPDATE CURRENT OF.
declare 
    cursor cursor_18(capacity_from auditorium.auditorium%type, capacity_to auditorium.auditorium%type)
    is select auditorium.auditorium, auditorium.auditorium_capacity from auditorium
    where auditorium_capacity between capacity_from and capacity_to for update;
      
    m_auditorium auditorium.auditorium%type;
    m_capacity auditorium.auditorium_capacity%type;
begin
    open cursor_18(0,20);
    fetch cursor_18 into m_auditorium, m_capacity;
    while(cursor_18%found)
      loop
          delete auditorium where current of cursor_18;
          fetch cursor_18 into m_auditorium, m_capacity;
      end loop;
    close cursor_18;
      
    for a in cursor_18(0, 90) 
    loop dbms_output.put_line(a.auditorium||' '||a.auditorium_capacity); end loop; 
    rollback;
end;
select * from auditorium;

--19.�������� A�. ����������������� ���������� ������������� ROWID � ���������� UPDATE � DELETE. 
declare
    cursor curs_auditorium (capacity auditorium.auditorium%type) is 
    select auditorium, auditorium_capacity, rowid from auditorium 
    where auditorium_capacity >= capacity for update;
begin
    for xxx in curs_auditorium(30)
    loop
        case
            when xxx.auditorium_capacity >=90
                then delete auditorium  where rowid = xxx.rowid;
            when xxx.auditorium_capacity >=30
                then update auditorium set auditorium_capacity = auditorium_capacity + 3  where rowid = xxx.rowid;
        end case;
    end loop;
    for yyy in curs_auditorium(30)
    loop
        dbms_output.put_line(curs_auditorium%rowcount||' '|| yyy.auditorium||' '||yyy.auditorium_capacity);
    end loop; 
    rollback;
exception
    when others
    then dbms_output.put_line(sqlerrm ||' ('|| sqlcode  ||')');
end;

--20.������������ � ����� ����� ���� �������������� (TEACHER), �������� �������� �� ��� (�������� ������ ������ -------------). 
declare
    cursor curs_teacher is select teacher_name from teacher;
    m_teacher_name teacher.teacher_name%type;
begin
    open curs_teacher;
    loop
        fetch curs_teacher into m_teacher_name;
        dbms_output.put_line(m_teacher_name);
        if (curs_teacher%rowcount mod 3 = 0) then dbms_output.put_line('-----------------------------------'); end if;
    exit when curs_teacher%notfound;
    end loop;
    close curs_teacher;
exception
    when others
    then dbms_output.put_line(sqlerrm ||' ('|| sqlcode  ||')');
end;
