-- Crearea unei tabele
create table exemplu
(
    data_implicita date default sysdate,
    numar_implicit number(7,2) default 7.24,
    string_implicit varchar2(5) default 'test',
    operator varchar2(10) default user
);

-- pentru a afla valorile default pe o tabela
select table_name, column_name, data_default
from user_tab_columns
where table_name='EXEMPLU';

drop table exemplu;

-- Ex. 1. Să se creeze o tabelă pentru evindența studentilor.
create table studenti
(
    facultate char(30) default 'Automatica si Calculatoare',
    catedra char(20),
    cnp number(13),
    nume varchar2(30),
    data_nasterii date,
    an_univ number(4) default 2019,
    medie_admitere number(4,2),
    discip_oblig varchar2(20) default 'Matematica',
    discip_opt varchar(20) default 'Fizica',
    operator varchar(20) default user,
    data_op timestamp default sysdate
);

drop table studenti;

-- Crearea unei tabele printr-o cerere select
-- Comanda CREATE TABLE nu conține descrierea structurii tabelare:
-- Ex. 2. Să se creeze o tabelă care va conține veniturile angajațiilor din departamentul 20.
create table dept_20
as
select id_dep, nume, data_ang, salariu + nvl(comision, 0) venit
from angajati
where id_dep = 20;

desc dept_20

drop table dept_20;

-- Comanda CREATE TABLE conține descrierea structurii tabelare:
-- Ex. 3. Să se creeze o tabelă cu o prima de 15% din venitul lunar
-- pentru angajații din departamentul 30.
create table dept_30
(
    id default 30,
    nume not null,
    data_ang,
    prima
)
as
select id_dep, nume, data_ang,
    round(0.15*(salariu + nvl(comision,0)),0)
from angajati
where id_dep = 30;

select * from dept_30;

drop table dept_30;

-- Constrângerea NOT NULL
create table exemplu2
(
    col1 number(2) constraint nn_col1 not null,
    col2 varchar2(20) NOT NULL
);

desc exemplu2

drop table exemplu2;

-- Constrângerea UNIQUE
-- exemplul 1
create table exemplu3
(
    col1 number(2) constraint uq_col1 UNIQUE,
    col2 varchar2(20) UNIQUE
);

desc exemplu3;

drop table exemplu3;

create table exemplu4
(
    col1 number(2),
    col2 varchar2(20),
    constraint uq_col1_a UNIQUE(col1),
    UNIQUE(col2)
);

desc exemplu4

drop table exemplu4;

-- exemplul 2
create table exemplu5
(
    col1 number(2),
    col2 varchar2(20),
    constraint uq_col12 UNIQUE(col1, col2)
);

desc exemplu5

drop table exemplu5;

-- Constrângere PRIMARY KEY
-- Ex. 5. Să se creeze o tabelă pentru a păstra date despre o persoană.
-- Cheia primară să se facă pe seria CI, cod CI și CNP.
create table persoane
(
    nume varchar2(20),
    prenume varchar2(20),
    serie_ci varchar2(2),
    cod_ci number(6),
    cnp number(13),
    constraint pk_persoane primary key(serie_ci, cod_ci, cnp)
);

desc persoane

drop table persoane;

-- Ex. 6. Să se creeze tabela angajați și să se adauge constrângerile
-- de integritate de tip FOREIGN KEY și PRIMARY KEY.
create table angajati2
(
    id_ang number(4)
        constraint pk_id_ang2
        primary key,
    id_sef number(4),
    id_dep number(2)
        constraint fk_id_dep2
        references departamente(id_dep),
    nume varchar2(20),
    functie varchar2(9),
    data_ang date,
    salariu number(7,2),
    comision number(7,2),
    constraint fk_id_sef2
        foreign key(id_sef)
        references angajati2(id_ang)
);

drop table angajati2;

-- Constrângerea CHECK
-- Ex. 7.Să se creeze tabela angajați astfel încât
-- să se verifice dacă salariul este mai mare ca 0,
-- comisionul nu depășeste salariul și numele este scris doar cu litere mari.
create table angajati3
(
    id_ang number(4) constraint pk_id_ang3 primary key,
    nume varchar(10) constraint ck_nume check(nume=upper(nume)),
    functie varchar2(10),
    id_sef number(4) constraint fk_id_sef3 references angajati3(id_ang),
    data_ang date default sysdate,
    salariu number(7,2) constraint nn_salariu not null,
    comision number(7,2),
    id_dep number(2) constraint nn_id_dep3 not null,
    constraint fk_id_dep3 foreign key (id_dep)
        references departamente(id_dep),
    constraint ck_comision check(comision <= salariu)
);

drop table angajati3;

-- Comanda ALTER TABLE
create table example6
(
    colA number(2), col2 number(2), col3 number(2),
    col4 number(2), col5 number(2), col6 number(2),
    col7 number(2), col8 number(2), col9 number(2)
);

-- redenumirea unui tabel
alter table example6 rename to exampleAlter;

-- redenumirea unei coloane
alter table exampleAlter rename column colA to col1;

-- schimbarea tipului unei coloane
alter table exampleAlter modify (col1 varchar2(20));

-- schimbarea tipului mai multor coloane
alter table exampleAlter modify (col2 varchar2(20), col3 date);

-- marcarea unei coloane ca neutilizabila
alter table exampleAlter set unused(col4);

-- marcarea mai multor coloane ca neutilizabile
alter table exampleAlter set unused(col5, col6);

-- stergerea coloanelor unused
alter table exampleAlter drop unused columns;

-- adaugam coloanele din nou - vom avea nevoie de ele
alter table exampleAlter add
(col4 varchar2(20), col5 varchar2(20), col6 varchar2(20));

-- stergerea unei coloane
alter table exampleAlter drop column col7;

-- stergerea mai multor coloane
alter table exampleAlter drop (col8, col9);

-- adaugarea unei constrangeri primary key
alter table exampleAlter add constraint pk_col1_alter primary key (col1);

-- adaugarea unei constrangeri primary key pe mai multe coloane
-- alter table exampleAlter add constraint pk_col12_alter primary key (col1, col2);

-- adaugarea unei constrangeri foreign key
alter table exampleAlter add constraint fk_col21 foreign key (col2)
    references exampleAlter(col1);

-- adaugarea unei constrangeri foreign key pe mai multe coloane
-- alter table exampleAlter add constraint fk_col34_12 foreign key (col3, col4)
--     references exampleAlter(col1, col2);

-- adaugarea unei constrangeri unique
alter table exampleAlter add constraint uq_col3_alter unique(col3);

-- adaugarea unei constrangeri unique pe mai multe coloane
alter table exampleAlter add constraint uq_col45_alter unique(col4, col5);

-- dezactivare constrangeri
alter table exampleAlter disable constraint uq_col3_alter;

-- activare constrangeri
alter table exampleAlter enable constraint uq_col3_alter;

-- stergere constrangeri
alter table exampleAlter drop constraint uq_col3_alter;

drop table exampleAlter;

-- adaugaera unei coloane noi
alter table angajati add venit number(4,3);

alter table angajati add
(vechime number(4), venit_anual number(6,2));

alter table angajati drop column vechime;
alter table angajati drop column venit;

-- Comanda TRUNCATE este folosită pentru golirea unui tabel.
-- Această comandă șterge toate liniile dintr-o tabelă.
-- După ce am dat această comandă, comnda ROLLBACK nu funcționează.
-- Această comandă este mult mai rapidă decât comanda DELETE.

-- truncate table
truncate table example1;

-- VIEW
create or replace view view_dept
    as select id_dep, den_dep from departamente;

select * from view_dept;

insert into view_dept values(80, 'test');

select * from view_dept;

update view_dept set den_dep='HR' where id_dep = 80;

select * from view_dept;

select * from departamente;

delete from view_dept where id_dep = 80;

select * from departamente;

drop view view_dept;