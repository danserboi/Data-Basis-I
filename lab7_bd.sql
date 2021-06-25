-- Test 2: JOIN-uri, UNION, functii SQL
-- 2 metode solicitate. Variatii metode: tipuri de join, functii, variatiile disponibile si pt testul 1

--- test 2, exemplu subiect
-- Sa se scrie o cerere SQL care face o lista cu toti angajatii care au acelasi departament cu cel al  sefului direct
-- si au venit in companie in anul 1981.  Lista se ordoneaza dupa numele subalternilor.
-- Den depart   Nume angajat   Data angajat   Nume sef   Data sef
-- Se se rezolve folosind doua metode distincte de join.


------------------------------
-- Functii de conversie
------------------------------
-- TO_CHAR(expr[,format[,’nlsparams’]])	face conversia lui expr (care poate avea tipul fie numeric, fie dată) la VARCHAR2
-- TO_DATE(expr[,format[,’nlsparams’]])	face conversia lui expr (cu tipul CHAR sau VARCHAR2) în formatul DATE
-- TO_NUMBER(expr [,format[,’nlsparams’]])	face conversia lui expr la o valoare de tip NUMBER

-- important: TO_CHAR POATE FI FOLOSIT CA SI VARIATIE LA EXTRACT ( YEAR/MONTH/DAY FROM...)




------------------------------
-- Functii diverse: NVL, DECODE, CASE
------------------------------
-- DECODE(expr, search_1, result_1, search_2, result_2, …, search_n, result_n, default) – compară expr cu fiecare valoare
-- search_i și întoarce valoarea result_i dacă expr este egală cu valoarea search_i, dacă nu găsește nicio egalitate întoarce
-- valoarea default (i=1..n).
-- expr – poate din orice tip de dată
-- search_i – este de același tip ca expr
-- result_i – este valoarea întoarsă și poate fi de orice tip
-- default – este de același tip ca result_i
-- functie de  if-then-else.

-- Sa se calculeze, pentru fiecare angajat din SALES, o prima de 200 pentru toti care au EMPNO par si de 300 pentru ceilalti
SELECT A.ENAME, A.EMPNO, DECODE(MOD(EMPNO, 2), 0, 200, 300) PRIMA
FROM EMP A, DEPT B
WHERE
A.DEPTNO=B.DEPTNO
AND
B.DNAME='SALES';

-- Sa se selecteze toti angajatii ce primesc un comision si au gradul salarial > 1, afisand si un indicator
-- cu privire la venitul lor (BUN, FOARTE BUN)
-- Daca venitul unui angajat este <=2500, atunci venitul este BUN. Daca venitul este > 2500,
-- atunci venitul este FOARTE BUN
-- Lista va fi afisata sub forma:
-- ANGAJAT  COMISION  GRAD SALARIAL VENIT     CALIFICATIV VENIT

SELECT A.ENAME ANGAJAT, NVL(A.COMM, 0) COMISION, B.GRADE GRAD_SALARIAL, A.SAL+ NVL(A.COMM, 0) VENIT,
       decode (sign(A.SAL+ NVL(A.COMM, 0)-2500), -1, 'BUN', 'FOARTE BUN')
FROM EMP A, SALGRADE B
WHERE
A.SAL BETWEEN B.LOSAL AND B.HISAL
AND
NVL(A.COMM, 0) >0
and
b.grade>1;

-- Instrucținea CASE poate fi folosită în clauza SELECT sau WHERE. Are doua forme:
-- CASE expr
-- WHEN value1 THEN statements_1
-- WHEN value2 THEN statements_2
-- ...
-- [ELSE statements_k]
-- END

-- Sa se traduca in limba romana joburile angajatilor din EMP
select ename, job,
       case job
         when 'SALESMAN' then 'VANZATOR'
         when 'CLERK' then 'FUNCTIONAR'
         when 'ANALYST' then 'ANALIST'
         when 'MANAGER' then 'DIRECTOR'
         else 'PRESEDINTE'
       end Traducere
from emp;


SELECT A.ENAME ANGAJAT, NVL(A.COMM, 0) COMISION, B.GRADE GRAD_SALARIAL, A.SAL+ NVL(A.COMM, 0) VENIT,
      case sign(A.SAL+ NVL(A.COMM, 0)-2500)
        when -1  then 'BUN'
        else 'FOARTE BUN'
      end "Apreciere venit"
FROM EMP A, SALGRADE B
WHERE
A.SAL BETWEEN B.LOSAL AND B.HISAL
AND
NVL(A.COMM, 0) >0
and
b.grade>1;


--- CASE
-- WHEN expr_1 THEN statements_1
-- WHEN expr_2 THEN statements_2
-- ...
-- [ELSE statements_k]
-- END
-- expr_i – reprezintă expresia care se va evalua
-- statements_i – reprezintă valoarea care se va returna pentru expr_i

-- Sa se afiseze, pentru toti angajatii departamentului RESEARCH, o lista care sa contina o apreciere a vechimii angajatului.
-- Aprecierea vechimii se va face astfel :
--	Daca au venit in firma inainte de 31 decembrie 1980, atunci vechime=’FOARTE VECHI’
--	Daca au venit in firma intre anii 1981 si 1986, atunci vechime=’VECHI’
--	Daca au venit in firma dupa 1986, atunci vechime=’RECENT’
select a.ename Nume_angajat, a.sal Salariu,
case when extract( YEAR from a.hiredate)<= 1980 THEN 'FOARTE VECHI'
     WHEN extract( YEAR from a.hiredate) BETWEEN 1981 AND 1986 then 'VECHI'
     WHEN extract( YEAR from a.hiredate)>= 1987 THEN 'RECENT' END Apreciere_vechime
from emp a, dept b
where
a.deptno=b.deptno
and
b.dname='RESEARCH';


------------------------------
---- Funcții de grup
------------------------------
-- principalele: SUM, COUNT, MAX, MIN, AVG
-- returneaza un rezultat pentru un grup de inregistrari
-- HAVING - filtreaza la nivel de blocuri

-- salariul maxim din firma
SELECT MAX(SAL) FROM EMP;

-- SA SE AFLE SALARIUL MAXIM DIN DEPARTAMENTUL SALES

SELECT MAX(A.SAL)
FROM EMP A, DEPT B
WHERE
A.DEPTNO=B.DEPTNO
AND
B.DNAME='SALES';


-- Sa se afiseze pentru fiecare departament: denumirea, numarul de angajati

-- TOTI ANGAJATII --> DENUMIREA DEPARTAMENTULUI (14 INREG)
SELECT D.DNAME
FROM DEPT D JOIN EMP A ON D.DEPTNO=A.DEPTNO;

-- GRUPEZ ANGAJATII DUPA CRITERIUL DIN CLAUZA GROUP BY --> DENUMIREA DEPARTAMENTELOR (3 INREG)
SELECT D.DNAME
FROM DEPT D JOIN EMP A ON D.DEPTNO=A.DEPTNO
GROUP BY D.DNAME;

-- APLICAREA FUNCTIEI DE GRUP PE FIECARE GRUP CREAT DE GROUP BY
SELECT D.DNAME, COUNT(*) "NR ANGAJATI"
FROM DEPT D JOIN EMP A ON D.DEPTNO=A.DEPTNO
GROUP BY D.DNAME;

-- APLICAREA FUNCTIEI DE GRUP PE FIECARE GRUP CREAT DE GROUP BY. FILTRARE LA NIVEL DE GRUP
SELECT D.DNAME, COUNT(*) "NR ANGAJATI"
FROM DEPT D JOIN EMP A ON D.DEPTNO=A.DEPTNO
GROUP BY D.DNAME
HAVING COUNT(*)>4;

-- Sa se afiseze pentru fiecare grad salarial, cati angajati din SALES au salariul in acel grad salarial
-- Se vor afisa doar gradele cu mai mult de un angajat
SELECT C.GRADE, COUNT(*)
FROM EMP A JOIN DEPT B ON A.DEPTNO=B.DEPTNO JOIN SALGRADE C ON A.SAL BETWEEN C.LOSAL AND C.HISAL
WHERE
B.DNAME='SALES'
GROUP BY C.GRADE
HAVING COUNT(*) >1 ;

-- O lista de premiere a angajatilor:
--   a) Angajatii care au primit comision primesc o prima egala cu salariul mediu pe companie;
--   b) Angajatii care nu au primit comision primesc o prima egala cu salariul minim pe companie;
--   c) Presedintele si directorii (JOB= Manager) nu primesc prima.
-- Salariile si prima se afiseaza fara zecimale.

select b.dname den_dep, a.ename nume_ang, a.job, a.comm comision,
min(c.sal) salariu_min_com, trunc( avg(c.sal)) salariu_mediu_com,
trunc(decode(a.job, 'MANAGER', 0, 'PRESIDENT', 0,
decode(nvl(a.comm, 0), 0, min(c.sal), avg(c.sal)))) prima
from emp a, dept b, emp c
where a.deptno = b.deptno
group by b.dname, a.ename, a.comm, a.job;


-- Exemplu subiect test 2
-- Să se selecteze, pentru fiecare angajat ce nu il are ca sef pe KING si care castiga mai mult (venitul) decat seful său:
-- numele angajatului, denumirea departamentului din care face parte, data angajarii,
-- numele șefului său, denumirea departamentului din care face parte șeful său, data angajării șefului.
-- Nu se va afisa angajatul SCOTT.
-- Veți efectua cerinta în cel putin 2 moduri.

-- JOIN ANGAJAT DEPT ...