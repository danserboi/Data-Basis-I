spool d:\spool_bd\spool_bd_lab11_17may2021.lst
set lines 120
set pages 100
select to_char(sysdate, 'dd-mm-yyyy hh:mi:ss') from dual;
insert into login_lab_bd values( 'Serboi Florea-Dan', '335CB', 'Lab11', user, sysdate, null, null);
select * from login_lab_bd;
