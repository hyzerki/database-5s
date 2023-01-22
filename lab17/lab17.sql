
create table Table14(id number primary key, field nvarchar2(30));
create table Table17(id number primary key, field nvarchar2(30));
declare
    s nvarchar2(30) := 'String number ';
begin
    for x in 11..12
    loop
        insert into table14(id, field) values(x, concat(s, to_char(x)));
    end loop;
    commit;    
end;
create table job_status
(
  status   nvarchar2(50),
  error_message nvarchar2(500),
  datetime date default sysdate
);
select * from Table14;
select * from Table17;
select * from JOB_STATUS;


create or replace procedure procedure17
is
    cursor curs is select * from Table14;
    n Table14%rowtype;
    x number;
begin
    for n in curs
      loop
        insert into Table17(id, field) values(n.id, n.field);
        delete from Table14 where Id = n.Id;
    end loop;
    insert into job_status(status) values ('SUCCESS');
    commit;
exception 
    when others 
    then 
    dbms_output.put_line(sqlerrm);
    insert into job_status (status) values ('FAIL');
end;

-- DBMS_JOB ---------------------------------------------------------------------------------------------------------------------
select * from user_jobs;
select job, what, last_date, last_sec, next_date, next_sec, broken from user_jobs;
select job, broken from user_jobs; --проверить, какие выполняются 
select job_name, session_id, running_instance, elapsed_time, cpu_used from dba_scheduler_running_jobs

-- Create any JOB
declare v_job number;
begin
  SYS.dbms_job.submit(
      job => v_job,
      what => 'BEGIN procedure17(); END;',
      next_date => trunc(sysdate+7) + 3 / 24,       --past 3 hours
      interval => 'trunc(sysdate+7) + 60/86400');   --60 seconds 24*60*60
  commit;
end;

begin
  dbms_job.run(21); -- Запусть принудительно
end;
begin
  dbms_job.broken(21, broken => true); -- Приостановить/Возобновить
end;
begin
  dbms_job.remove(1); -- Удалить задание
end;


-- DBMS_SHEDULER ---------------------------------------------------------------------------------------------------------------------
select * from user_scheduler_programs where program_name like('%PROGRAM%');
select * from user_scheduler_schedules where schedule_NAME like('%SCHEDULE%');
select * from user_scheduler_jobs where JOB_NAME like('%SCHEDULE%');
select job_name, job_type, job_action, start_date, repeat_interval, next_run_date, enabled 
from user_scheduler_jobs where JOB_NAME like('%SCHEDULE%');

begin
  dbms_scheduler.create_schedule(
      schedule_name => 'SCHEDULE17',
      start_date => sysdate,
      repeat_interval => 'FREQ=WEEKLY;',
      comments => 'No comments'
  );
end;
begin
  dbms_scheduler.create_program(
      program_name => 'Program17',
      program_type => 'STORED_PROCEDURE',
      program_action => 'procedure17',
      number_of_arguments => 0,
      enabled => true,
      comments => 'No comments'
  );
end;
begin
  dbms_scheduler.create_job(
      job_name => 'ScheduleJOB17',
      program_name => 'Program17',
      schedule_name => 'SCHEDULE17',
      enabled => true
  );
end;

begin
    dbms_scheduler.run_job('ScheduleJOB17');
end;
begin
    dbms_scheduler.drop_job('ScheduleJOB17', true);
end;
begin
    dbms_scheduler.disable('ScheduleJOB17');
end;
begin
    dbms_scheduler.enable('ScheduleJOB17');
end;
