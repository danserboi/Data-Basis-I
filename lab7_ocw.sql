select to_char (sysdate, 'DD-MM-YYYY') data_curenta
from dual;

select to_date ('15112006', 'DD-MM-YYYY') data_ex
from dual;

select to_char (-10000, '$999999.99MI') valoare
from dual;

select to_number ('$10000.00-', '$999999.99MI') valoare
from dual;

-- EX 1
-- Să se selecteze toți angajații care au venit în firmă în 1982.
select nume, to_char (data_ang, 'dd-mm-yyyy') data_ang
from angajati
where to_char(data_ang, 'YYYY') like '1982';

select nume, to_char (data_ang, 'dd-mm-yyyy') data_ang
from angajati
where to_date (to_char (data_ang, 'YYYY'), 'YYYY') =
    to_date( to_char(1982), 'YYYY');

select nume, to_char (data_ang, 'dd-mm-yyyy') data_ang
from angajati
where to_number (to_char(data_ang, 'YYYY')) = 1982;

-- 123
column numar format 99999
select 123.14 numar from dual;

-- 123.14
column numar format 999.99
select 123.14 numar from dual;

-- $123.14
column numar format $999.99
select 123.14 numar from dual;

-- 00123.14, 06123.14, 00023.14 si 00000.14
column numar format 00999.99
select 123.14 numar from dual;
select 6123.14 numar from dual;
select 23.14 numar from dual;
select 0.14 numar from dual;

-- 123.14 si 0.14
column numar format 9990.99
select 123.14 numar from dual;
select 0.14 numar from dual;

-- 00123.14 si 00000.14
column numar format 09990.99
select 123.14 numar from dual;
select 0.14 numar from dual;

-- 123,123,123.14
column numar format 999,999,999.99
select 123123123.14 numar from dual;

-- 123.14-
column numar format 999.99MI
select -123.14 numar from dual;

-- <123.14> si 123.14
column numar format 999.99PR
select -123.14 numar from dual;
select 123.14 numar from dual;

-- 1.23E+02
column numar format 999.99EEEE
select 123.14 numar from dual;

-- 123.00
column numar format B99999.99
select 123 numar from dual;

-- .14 si 123.10
column numar format 99999D00
select 0.14 numar from dual;
select 123.1 numar from dual;

select greatest(23, 12, 34, 77, 89, 52) gr
from dual;

select least(23, 12, 34, 77, 89, 52) lst
from dual;

select greatest('15-JAN-1985', '10-AUG-2001') gr
from dual;

select least('15-JAN-1985', '10-AUG-2001') lst
from dual;


-- EX 2
-- Să se caluleze o primă pentru angajații din departamentul 20
-- în funcție de jobul angajatului.
select nume, functie, salariu,
    decode (functie, 'MANAGER', salariu*1.25, 'ANALYST', salariu*1.24, salariu/4) prima
from angajati
where id_dep = 20
order by functie;

-- EX 3
-- Să se calculeze o primă în funcție de vechime pentru angajații din departamentul 20.
select nume, functie, salariu,
    to_char (data_ang, 'YYYY') an_ang,
    decode (sign (data_ang - to_date('1-JAN-1982')),
            -1, salariu*1.25,
            salariu*1.10) prima
from angajati
where id_dep = 20
order by functie;

-- CASE
select
    case lower(locatie)
        when 'new york' then 1
        when 'dallas' then 2
        when 'chicago' then 3
        when 'boston' then 4
    end cod_dep
from departamente;

select
    case
        when lower(locatie) = 'new york' then 1
        when id_dep = 20
            or lower(locatie) = 'dallas' then 2
        when lower(locatie) = 'chicago' then 3
        when id_dep = 40 then 4
        else 5
    end cod_dep
from departamente;

select nume
from angajati
where id_ang = (case functie
        when 'SALESMAN' then 7844
        when 'CLERK' then 7900
        when 'ANALYST' then 7902
        else 7839
    end);

select nume
from angajati
where id_ang = (case
        when functie = 'SALESMAN' then 7844
        when functie = 'CLERK' then 7900
        when functie = 'ANALYST' then 7902
        else 7839
    end);

set null NULL
select nume, comision, nvl (comision, 0) nvl_com,
    salariu + comision "Sal + Com",
    salariu + nvl(comision, 0) "sal + NVL_COM"
from angajati
where id_dep = 30;
set null ''

SELECT USER FROM dual;

-- Ex 4.
-- Afișați media salariilor pentru toate valorile din tabel,
-- iar apoi doar pentru salariile distincte.
-- Rezultatul este diferit deoarece există salarii duplicate.
select avg (salariu) salariu from angajati;
select avg (all salariu) salariu from angajati;
select avg (distinct salariu) salariu from angajati;

-- Ex 5. Să se calculeze salariul mediu pentru fiecare departament.
select id_dep, avg(salariu) from angajati
group by id_dep
order by 1;

-- Ex 6. Să se calculeze venitul lunar mediu pentru fiecare departament.
-- Afișati id_dep și venitul lunar doar pentru departamentele
-- care au venitul lunar mediu mai mare de 2000.
-- Pentru a aplica o condiție bazată pe funcții de agregare,
-- folosim HAVING în loc de WHERE.
select id_dep, avg (salariu + nvl (comision, 0))
from angajati
group by id_dep
having avg (salariu + nvl (comision, 0)) > 2000;

-- Ex 7. Să se afișeze numărul angajatilor care au primit salariu pentru fiecare departament.
select id_dep, count(*) nr_ang,
    count(salariu) count,
    count(all salariu) count_all,
    count(distinct salariu) count_distinct
from angajati
group by id_dep
order by 1;

-- Ex 8. Să se afișeze departamentele care au cel puțin două funcții distincte pentru angajați.
select id_dep,
    count (functie) count,
    count (distinct functie) count_distinct
from angajati
group by id_dep
having count (distinct functie) >= 2
order by 1;

-- Ex 9. Să se afișeze salariul minim, maxim și suma salariilor pentru fiecare departament.

select d.den_dep,
    min (a.salariu) sal_min,
    min(distinct a.salariu) sal_min_d,
    max(a.salariu) sal_max,
    max(distinct a.salariu) sal_max_d,
    sum(a.salariu) sal_sum,
    sum(distinct a.salariu) sal_sum_d
from angajati a natural join departamente d
group by d.den_dep
order by d.den_dep;

-- Ex 10. Să se afișeze variația standard și deviația standard a salariilor pentru fiecare departament.
select id_dep,
    variance(salariu) sal_varstd,
    variance (distinct salariu) sal_varstd_d,
    stddev (salariu) sal_devstd,
    stddev (distinct salariu) sal_devstd_d,
    stddev (comision) com_devstd
from angajati
group by id_dep
order by 1;
