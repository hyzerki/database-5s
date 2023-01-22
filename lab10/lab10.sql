--1.������������ ���������� ��������� ���� PL/SQL (��), �� ���������� ����������. 
begin
    null;
end;

--2.������������ ��, ��������� �Hello World!�. ��������� ��� � SQLDev � SQL+.
set serveroutput on --sql plus ����, ��������� ���� /

begin
    dbms_output.put_line('Hello world!');
end;

--3.����������������� ������ ���������� � ���������� ������� sqlerrm, sqlcode.
declare
    a number(3) := 1;
    b number(3) := 0;
    c number(10, 2);
begin
    c := a/b;
    dbms_output.put_line('c = ' || c);
exception
    when others
    then dbms_output.put_line('Exception: code ' || sqlcode || ', message ' || sqlerrm);
end;

--4.������������ ��������� ����. ����������������� ������� ��������� ���������� �� ��������� ������.
declare
    a number(3) := 1;
    b number(3) := 0;
    c number(10, 2);
begin
    dbms_output.put_line('a = ' || a || ', b = ' || b);
    begin
        c := a/b;
        exception
        when others
        then dbms_output.put_line('Exception: code ' || sqlcode || ', message ' || sqlerrm);
    end;
    dbms_output.put_line('c = ' || c);
end;

--5.��������, ����� ���� �������������� ����������� �������������� � ������ ������.
show parameter plsql_warnings;
select name, value from v$parameter where name = 'plsql_warnings';
select dbms_warning.get_warning_setting_string from dual; --Returns the entire warning string for the current session

--6.������������ ������, ����������� ����������� ��� ����������� PL/SQL.
select keyword from v$reserved_words where length = 1;

--7.������������ ������, ����������� ����������� ��� �������� �����  PL/SQL.
select keyword from v$reserved_words where length > 1 order by keyword;

--8.������������ ������, ����������� ����������� ��� ��������� Oracle Server, ��������� � PL/SQL. ����������� ��� �� ��������� � ������� SQL+-������� show.
select * from v$parameter where name like('%plsql%');
show parameter plsql;

--9.������������ ��������� ����, ��������������� (��������� � �������� ��������� ����� ����������):
declare
    --10.���������� � ������������� ����� number-����������;
    n1 number(3):= 10;
    n2 number(3):= 3;
     --11.�������������� �������� ��� ����� ������ number-����������, ������� ������� � ��������;
    sumnumber number(10,2);     
    difnumber number(10,2); 
    mulnumber number(10,2);    
    divnumber number(10,2);    
    modnumber number(10,2);
    --12.���������� � ������������� number-���������� � ������������� ������;
    n3 number(10,2) := 1.234;
    n4 number(10,2) := 56.78;
    --13.���������� � ������������� number-���������� � ������������� ������ � ������������� ��������� (����������);
    n5 number(9, -11):= 12.234567;
    --14.���������� � ������������� BINARY_FLOAT-����������;
    bf1 binary_float := 123456789.12345678911;
    --15.���������� � ������������� BINARY_DOUBLE-����������;
    bd1 binary_double := 123456789.12345678911;
    --16.���������� number-���������� � ������ � ����������� ������� E (������� 10) ��� �������������/����������;
    n7 number(32, 10) := 12345E-10;
    --17.���������� � ������������� BOOLEAN-����������. 
    b1 boolean := true; 
    b2 boolean := false;
begin
    sumnumber := n1+n2;         dbms_output.put_line('sumnumber = ' || sumnumber);
    difnumber := n1-n2;         dbms_output.put_line('difnumber = ' || difnumber);
    mulnumber := n1*n2;         dbms_output.put_line('mulnumber = ' || mulnumber);
    divnumber := n1/n2;         dbms_output.put_line('divnumber = ' || divnumber);
    modnumber := mod(n1,n2);    dbms_output.put_line('modnumber = ' || modnumber);

    dbms_output.put_line('n3 = ' || n3);
    dbms_output.put_line('n4 = ' || n4);    
    dbms_output.put_line('n5 = ' || n5);
    dbms_output.put_line('bf1 = ' || bf1);
    dbms_output.put_line('bd1 = ' || bd1);
    dbms_output.put_line('n7 = ' || n7);
    
    if b1       
        then dbms_output.put_line('true'); 
    else 
        dbms_output.put_line('false');
    end if;
    if b2       
        then dbms_output.put_line('true');  
    else 
        dbms_output.put_line('false');  
    end if;
end;

--18.������������ ��������� ���� PL/SQL ���������� ���������� �������� (VARCHAR2, CHAR, NUMBER). �����������������  ��������� �������� �����������.  
declare
    vc21 constant varchar2(15) := 'VARCHAR2';
    c1 constant char(15) := 'char';
    n1 constant number(3) := 7;
begin
    dbms_output.put_line('const vc21 = '|| vc21);   
    dbms_output.put_line('const c1 = '|| c1);   
    dbms_output.put_line('const n1 = '|| n1);   
    vc21 := '2rahcrav';
    c1 := 'rahc';
    n1 := 10;
exception 
    when others
    then dbms_output.put_line('error = '|| sqlerrm);
end;

--19.������������ ��, ���������� ���������� � ������ %TYPE. ����������������� �������� �����.
--20.������������ ��, ���������� ���������� � ������ %ROWTYPE. ����������������� �������� �����.
declare
    fsubject subject.subject%type;
    fpulpit  pulpit.pulpit%type;
    ffaculty_rec faculty%rowtype;
begin
    fsubject := '���';
    fpulpit := '����';
    ffaculty_rec.faculty := '����';
    ffaculty_rec.faculty_name := '��������� ������������� ���� � ����������';
    dbms_output.put_line(fsubject);
    dbms_output.put_line(fpulpit);
    dbms_output.put_line(rtrim(ffaculty_rec.faculty) || ':' || ffaculty_rec.faculty_name);
exception
    when others
    then dbms_output.put_line('error = '|| sqlerrm);
end;


--21.������������ ��, ��������������� ��� ��������� ����������� ��������� IF.
declare
    c number(3) := 15;
begin
    if 8 > c        
        then dbms_output.put_line('8 > '|| c);  
    end if;
    
    if 8 > c        
        then dbms_output.put_line('8 > '|| c);  
    else 
        dbms_output.put_line('8 > '|| c);  
    end if;
    
    if 8 > c        
        then dbms_output.put_line('8 > '|| c);  
    elsif 8 = c     
        then dbms_output.put_line('8 = ' || c);
    elsif 10 > c     
        then dbms_output.put_line('10 > ' || c);
    elsif 10 = c     
        then dbms_output.put_line('10 = ' || c);
    else 
        dbms_output.put_line('10 < ' || c);
    end if;
end;

--23.������������ ��, ��������������� ������ ��������� CASE.
declare
  x number := 17;
begin
  case x
    when 1 then dbms_output.put_line('1');
    when 7 then dbms_output.put_line('7');
    when 17 then dbms_output.put_line('17');
  end case;
  case
      when 8 > x    then dbms_output.put_line('8 > '||x);
      when 8 = x    then dbms_output.put_line('8 = '||x);
      when 12 = x   then dbms_output.put_line('12 = '||x);
      when x between 13 and 20 then dbms_output.put_line('13 <= ' ||x || ' <= 20');
      else dbms_output.put_line('else');
  end case;
end;

--24.������������ ��, ��������������� ������ ��������� LOOP.
declare
    x number :=0;
begin
    loop 
        x:=x+1;
        dbms_output.put_line(x);
    exit when x>5;
  end loop;
end;

--25.������������ ��, ��������������� ������ ��������� WHILE.
declare
    x number :=5;
begin
    while (x>0)
      loop x:=x-1;
      dbms_output.put_line(x);
    end loop;
end;

--26.������������ ��, ��������������� ������ ��������� FOR.
declare
    x number :=0;
begin
    for k in 1..5
    loop 
        dbms_output.put_line(k); 
    end loop;
end;
