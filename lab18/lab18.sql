
drop table Table18;
create table Table18(id number, field nvarchar2(30), datefield date);

--Создайте текстовый файл, содержащий данные для импорта (20 строк, содержащий числа, строки и даты). 
--Загрузите данные, соответствующие текущему месяцу, из этого файла в базу данных при помощи SQL*Loader.
--Строки должны быть приведены к виду «Все буквы заглавные», числа округлены до сотых.

--external_table=generate_only
CREATE DIRECTORY EXT_DIR AS '/opt/oracle/18'

CREATE TABLE "EXT_TABLE18" 
(
  "ID" VARCHAR2(255),
  "FIELD" VARCHAR2(255),
  "DATEFIELD" VARCHAR2(255)
)
ORGANIZATION external 
(
  TYPE oracle_loader
  DEFAULT DIRECTORY EXT_DIR
  ACCESS PARAMETERS 
  (
    RECORDS DELIMITED BY NEWLINE CHARACTERSET WE8MSWIN1252
    BADFILE 'EXT_DIR':'file.bad'
    LOGFILE 'EXT_DIR':'loader.log_xt'
    READSIZE 1048576
    FIELDS TERMINATED BY "," OPTIONALLY ENCLOSED BY '"' LDRTRIM 
    REJECT ROWS WITH ALL NULL FIELDS 
    (
      "ID" CHAR(255)
        TERMINATED BY "," OPTIONALLY ENCLOSED BY '"',
      "FIELD" CHAR(255)
        TERMINATED BY "," OPTIONALLY ENCLOSED BY '"',
      "DATEFIELD" CHAR(255)
        TERMINATED BY "," OPTIONALLY ENCLOSED BY '"'
    )
  )
  location 
  (
    'file.txt'
  )
)REJECT LIMIT UNLIMITED

INSERT /*+ append */ INTO TABLE18 
(
  ID,
  FIELD,
  DATEFIELD
)
SELECT 
  round("ID", 2),
  upper("FIELD"),
  to_date("DATEFIELD", 'yyyy-mm-dd')
FROM "EXT_TABLE18"
WHERE to_char(to_date(DATEFIELD, 'yyyy-mm-dd'), 'mm.yyyy') = to_char(sysdate, 'mm.yyyy');

DROP TABLE "EXT_TABLE18"
select * from table18;

--Выгрузить результаты любого SELECT-запроса во внешний файл любым способом.
create or replace procedure to_csv as
  cursor c_data is  select * from table18;
  v_file utl_file.file_type;
begin
  v_file := utl_file.fopen(location     => 'EXT_DIR',
                           filename     => 'csv.txt',  open_mode    => 'w', max_linesize => 32767);
  for cur_rec in c_data loop
    utl_file.put_line(v_file, cur_rec.id    || ',' || cur_rec.field    || ',' || cur_rec.datefield);
  end loop;
  utl_file.fclose(v_file);
  
exception
  when others then
    utl_file.fclose(v_file);
    raise;
end;

begin
    to_csv;
end;

DROP DIRECTORY EXT_DIR


select * from Table18;
drop table Table18;

