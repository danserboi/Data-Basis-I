select RPAD(nume, 10, '*') EX_RPAD from angajati where id_dep = 10;

select nume, data_ang, ADD_MONTHS(data_ang, 3) data_mod
    from angajati
    where id_dep = 10;

select nume, data_ang, LAST_DAY(data_ang) ultima_zi
    from angajati
    where id_dep = 10;

select NEXT_DAY('24-MAR-2014', 'MONDAY') urm_luni
    from dual;

select nume, data_ang,
    MONTHS_BETWEEN('01-JAN-2014', data_ang) luni_vechime1,
    MONTHS_BETWEEN(data_ang, '01-JAN-2014') luni_vechime2
from angajati
where id_dep = 10;

select
    data_ang,
    ROUND(data_ang, 'YEAR') rot_an
from angajati
where id_ang = 7369;

select
    data_ang,
    ROUND(data_ang, 'MONTH') rot_luna
from angajati
where id_ang = 7369;

select
    data_ang,
    TRUNC(data_ang, 'YEAR') trunc_an
from angajati
where id_ang = 7369;

select
    data_ang,
    TRUNC(data_ang, 'MONTH') rot_luna
from angajati
where id_ang = 7369;

select SYSDATE from dual;

--extrag ziua
select EXTRACT(DAY from sysdate) from dual;

--extrag luna
select EXTRACT(MONTH from sysdate) from dual;

--extrag ziua
select EXTRACT(YEAR from sysdate) from dual;

select
    data_ang,
    data_ang + 7,
    data_ang - 7,
    sysdate - data_ang
from angajati
where data_ang like '%JUN%';

--schimbam formatul la nivel de sesiune
--in DD-MM-YYYY
alter session set NLS_DATE_FORMAT='DD-MM-YYYY';
select sysdate from dual;

--schimbam formatul la nivel de sesiune
--in DD-MM-YYYY HH24:MI:SS
alter session set NLS_DATE_FORMAT='DD-MM-YYYY HH24:MI:SS';
select sysdate from dual;

--schimbam formatul la nivel de sesiune
--in DAY MONTH YEAR
alter session set NLS_DATE_FORMAT='DD-MONTH-YYYY';
select sysdate from dual;
SELECT replace(sysdate, ' ', '') from dual;