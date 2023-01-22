-- 9
create table MNS_t( 
    x number(3) unique,
    s varchar(50)
);
commit;

-- 11
insert into MNS_t(x,s) values 
(1,'Ïåğâûé');
commit;
insert into MNS_t(x,s) values 
(2,'Âòîğîé');
commit;
insert into MNS_t(x,s) values 
(3,'Òğåòèé');
commit;

-- 12
update MNS_t set s = 'UPDATE!' where x = 2 or x = 3;
commit;

-- 13
select sum(x) from MNS_t where x > 1 and x <= 3;

-- 14
delete MNS_t where x = 2;
commit;

-- 15
create table MNS_t1(
outer_x number(3),
val varchar(50),
constraint fk_x
foreign key (outer_x)
references MNS_t(x)
);
commit;

insert into MNS_t1(outer_x,val) values 
(1,'Ïåğâûé2');
commit;
insert into MNS_t1(outer_x,val) values 
(3,'Âòîğîé2');
commit;
insert into MNS_t1(outer_x,val) values 
(3,'Òğåòèé2');
commit;

-- 16
select * from MNS_t, MNS_t1 where MNS_t.x = MNS_t1.outer_x;

select * from MNS_t t left join MNS_t1 t1 on t.x = t1.outer_x;

select * from MNS_t t right join MNS_t1 t1 on t.x = t1.outer_x;

-- 18
drop table MNS_t1;
commit;

drop table MNS_t;
commit;