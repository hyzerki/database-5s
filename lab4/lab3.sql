select name,open_mode,con_id from v$pdbs; 
select pdb_name,pdb_id, status from SYS.dba_pdbs;

--2
select * from v$instance

--3
select *from SYS.product_component_version