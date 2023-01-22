--1.Разработайте простейший анонимный блок PL/SQL (АБ), не содержащий операторов. 
begin
    null;
end;

--2.Разработайте АБ, выводящий «Hello World!». Выполните его в SQLDev и SQL+.
set serveroutput on --sql plus тоже, завершить ввод /

begin
    dbms_output.put_line('Hello world!');
end;

--3.Продемонстрируйте работу исключения и встроенных функций sqlerrm, sqlcode.
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

--4.Разработайте вложенный блок. Продемонстрируйте принцип обработки исключений во вложенных блоках.
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

--5.Выясните, какие типы предупреждения компилятора поддерживаются в данный момент.
show parameter plsql_warnings;
select name, value from v$parameter where name = 'plsql_warnings';
select dbms_warning.get_warning_setting_string from dual; --Returns the entire warning string for the current session

--6.Разработайте скрипт, позволяющий просмотреть все спецсимволы PL/SQL.
select keyword from v$reserved_words where length = 1;

--7.Разработайте скрипт, позволяющий просмотреть все ключевые слова  PL/SQL.
select keyword from v$reserved_words where length > 1 order by keyword;

--8.Разработайте скрипт, позволяющий просмотреть все параметры Oracle Server, связанные с PL/SQL. Просмотрите эти же параметры с помощью SQL+-команды show.
select * from v$parameter where name like('%plsql%');
show parameter plsql;

--9.Разработайте анонимный блок, демонстрирующий (выводящий в выходной серверный поток результаты):
declare
    --10.объявление и инициализацию целых number-переменных;
    n1 number(3):= 10;
    n2 number(3):= 3;
     --11.арифметические действия над двумя целыми number-переменных, включая деление с остатком;
    sumnumber number(10,2);     
    difnumber number(10,2); 
    mulnumber number(10,2);    
    divnumber number(10,2);    
    modnumber number(10,2);
    --12.объявление и инициализацию number-переменных с фиксированной точкой;
    n3 number(10,2) := 1.234;
    n4 number(10,2) := 56.78;
    --13.объявление и инициализацию number-переменных с фиксированной точкой и отрицательным масштабом (округление);
    n5 number(9, -11):= 12.234567;
    --14.объявление и инициализацию BINARY_FLOAT-переменной;
    bf1 binary_float := 123456789.12345678911;
    --15.объявление и инициализацию BINARY_DOUBLE-переменной;
    bd1 binary_double := 123456789.12345678911;
    --16.объявление number-переменных с точкой и применением символа E (степень 10) при инициализации/присвоении;
    n7 number(32, 10) := 12345E-10;
    --17.объявление и инициализацию BOOLEAN-переменных. 
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

--18.Разработайте анонимный блок PL/SQL содержащий объявление констант (VARCHAR2, CHAR, NUMBER). Продемонстрируйте  возможные операции константами.  
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

--19.Разработайте АБ, содержащий объявления с опцией %TYPE. Продемонстрируйте действие опции.
--20.Разработайте АБ, содержащий объявления с опцией %ROWTYPE. Продемонстрируйте действие опции.
declare
    fsubject subject.subject%type;
    fpulpit  pulpit.pulpit%type;
    ffaculty_rec faculty%rowtype;
begin
    fsubject := 'ПИС';
    fpulpit := 'ИСиТ';
    ffaculty_rec.faculty := 'ИДиП';
    ffaculty_rec.faculty_name := 'Факультет издательского дела и полиграфии';
    dbms_output.put_line(fsubject);
    dbms_output.put_line(fpulpit);
    dbms_output.put_line(rtrim(ffaculty_rec.faculty) || ':' || ffaculty_rec.faculty_name);
exception
    when others
    then dbms_output.put_line('error = '|| sqlerrm);
end;


--21.Разработайте АБ, демонстрирующий все возможные конструкции оператора IF.
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

--23.Разработайте АБ, демонстрирующий работу оператора CASE.
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

--24.Разработайте АБ, демонстрирующий работу оператора LOOP.
declare
    x number :=0;
begin
    loop 
        x:=x+1;
        dbms_output.put_line(x);
    exit when x>5;
  end loop;
end;

--25.Разработайте АБ, демонстрирующий работу оператора WHILE.
declare
    x number :=5;
begin
    while (x>0)
      loop x:=x-1;
      dbms_output.put_line(x);
    end loop;
end;

--26.Разработайте АБ, демонстрирующий работу оператора FOR.
declare
    x number :=0;
begin
    for k in 1..5
    loop 
        dbms_output.put_line(k); 
    end loop;
end;
