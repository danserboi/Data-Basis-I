
-- SYS.DUAL
SELECT SYSDATE FROM SYS.DUAL;
select 'A inceput laboratorul nr 6' from sys.dual;


---------------------------------------------------------------
-- Funcții pentru valori numerice -----------------------------
---------------------------------------------------------------
-- FLOOR(n)	returnează cel mai mare întreg⇐n
-- CEIL(n)
-- MOD(m,n)	returnează restul împărțirii lui m la n
-- ROUND(n[, m])	returnează n rotunjit astfel: m zecimale dacă m>0, 0 dacă m este omis, m cifre înainte de virgulă dacă m<0
-- TRUNC(n[, m])	returnează n trunchiat astfel: m zecimale dacă m>0, 0 dacă m este omis, m cifre înainte de virgulă dacă m<0

-- ANGAJATII CARE AU ID-ul NUMAR PAR
SELECT ENAME, EMPNO
FROM EMP
WHERE
 MOD(EMPNO, 2)=0;

SELECT ENAME, SAL, SAL/3 "Salariul impartit la 3", floor(SAL/3) "Valoare nr intregi", round(SAL/3, -2) "Valoare rotunjita la sute",
       round(SAL/3, 2) "Valoare rotunjita la sutimi"
FROM EMP;


-- Creati o lista in care sa fie calculata o prima pentru angajatii care nu primesc comision, nu au functia de manager, si s-au angajat inainte de ALLEN.
-- Prima este calculata ca fiind 23% din venitul lunar al angajatului, in valoare rotunjita la intregi.
-- Veti afisa Angajatul, Functia, Comisionul, Data angajare, Data angajare Allen, Prima
-- Rezolvati prin 4 metode cerinta.

SELECT A.ENAME Angajatul, A.JOB Functia, A.COMM Comisionul, A.HIREDATE "Data angajare", ALLEN.HIREDATE "Data angajare Allen",
       round((A.SAL + NVL(A.COMM, 0))*0.23) Prima
FROM EMP A, EMP ALLEN
WHERE
  ALLEN.ENAME='ALLEN'
  AND
  NVL(A.COMM, 0)=0
  AND
  A.JOB!='MANAGER'
  AND
  A.HIREDATE < ALLEN.HIREDATE;


SELECT A.ENAME Angajatul, A.JOB Functia, A.COMM Comisionul, A.HIREDATE "Data angajare", ALLEN.HIREDATE "Data angajare Allen",
       round((A.SAL + A.COMM)*0.23) Prima
FROM EMP A JOIN EMP ALLEN ON ALLEN.ENAME='ALLEN'
WHERE
  (A.COMM IS NULL OR (A.COMM IS NOT NULL AND A.COMM=0) )
  AND
  A.JOB!='MANAGER'
  AND
  A.HIREDATE < ALLEN.HIREDATE;



SELECT A.ENAME Angajatul, A.JOB Functia, A.COMM Comisionul, A.HIREDATE "Data angajare", ALLEN.HIREDATE, round((A.SAL + nvl(A.COMM, 0))*0.23) Prima
FROM EMP A JOIN EMP ALLEN ON ALLEN.ENAME='ALLEN'
WHERE
  (A.COMM IS NULL OR (A.COMM IS NOT NULL AND A.COMM=0) )
  AND
  A.JOB NOT LIKE 'MANAGER'
  AND
  A.HIREDATE < ALLEN.HIREDATE;


---------------------------------------------------------------
-- Funcții pentru șiruri de caractere -------------------------
---------------------------------------------------------------
--Funcție	Descriere funcție
-- CONCAT(str1, str2)	returnează concatenarea lui str1 cu str2 ECHIVALENT CU ||
-- REPLACE(str, strOld, strNew)	înlocuiește în șirul de caractere str subșirul de caractere strOld cu subșirul de caractere strNew
-- TRANSLATE(str1, from_str, to_str)	înlocuiește în șirul de caractere str1 toate aparițiile caracterelor din form_str cu caracterul corespondent din to_str (înlocuirea se face caracter cu caracter)
-- SUBSTR(str, m[, n])	returnează n caractere din str începând cu poziția m
-- LENGTH(str)	returnează lungimea șirului de caractere str


SELECT A.ENAME, B.LOC, REPLACE(A.ENAME, 'AR', 'XY') Replace, TRANSLATE (A.ENAME, 'AR', 'XY') Translate
FROM EMP A JOIN DEPT B ON A.DEPTNO=B.DEPTNO
WHERE
SAL >1000;


SELECT A.ENAME, B.LOC, REPLACE(A.ENAME, 'AR', 'XY') Replace, TRANSLATE (A.ENAME, 'AR', 'X') "Translate cu reducere R"
FROM EMP A JOIN DEPT B ON A.DEPTNO=B.DEPTNO
WHERE
SAL >1000;

-- Sa se selecteze numarul de aparitii ale ultimelor 2 litere din numele angajatului care se regasesc in jobul angajatului, exact in ordinea respectiva.

SELECT ENAME, JOB,
       substr(ENAME,-2) "Ultimele doua litere",
       replace(JOB,substr(ENAME,-2),'') "JOB fara cele doua litere",
       length(replace(JOB,substr(ENAME,-2),'')) "Sir JOB ramas",
      (length(JOB)-length(replace(JOB,substr(ENAME,-2),'')))/2  Nr_aparitii
FROM EMP
WHERE (length(JOB)-length(replace(JOB,substr(ENAME,-2),'')))/2 != 0;

--- Selectati toti angajatii din departamentele cu denumirea diferita de o valoare citita de la tastatura, angajati care contin, in numele lor, litera C
-- si care nu primesc comision. Numele angajatului se va concatena cu denumirea departamentului sau intr-un sir in forma
-- 'Angajatul ENAME este in departamentul DNAME ' si se va afisa alaturi de SAL si comision, in valori rotunjite la zeci
-- Se va rezolva in 4 moduri




---------------------------------------------------------------
-- Funcții pentru date calendaristice -------------------------
---------------------------------------------------------------
-- SYSDATE
--LAST_DAY(date)	returnează data ultimei zile din luna cuprinsă în date
--NEXT_DAY(date, str)	returnează data următoarei zile din săptămână dată de str, după data date
--ADD_MONTHS(date, n)	returnează o dată prin adăugarea a n luni la date
-- DATA1-DATA2 = nr de zile (cu valori zecimale)
--MONTHS_BETWEEN(date1, date2)	returnează numărul de luni (și fracțiuni de luni) cuprinse între date1 și date2.
--  Dacă date1>=date2 rezultatul va fi pozitiv, altfel negativ
-- EXTRACT(part FROM date)	extrage partea part din dată date, returnează o valoare numerică



SELECT EXTRACT(YEAR from sysdate), EXTRACT(MONTH from sysdate), EXTRACT(DAY from sysdate) FROM sys.dual;


SELECT NEXT_DAY(SYSDATE, 'THURSDAY') "Urmatoarea joi", LAST_DAY(SYSDATE) "Ultima zi din luna" from sys.dual;

-- schimbarea formatului implicit de data
ALTER SESSION SET NLS_DATE_FORMAT = "DD-MM-YYYY"

-- operatori + si -: data + numar – adună un număr de zile la dată, returnând tot o dată calendaristică ;


-- Faceti o lista cu data testarii angajatilor din departamentul SALES. Testarea va avea loc dupa 2 luni de la angajare, in ultima zi din saptamana respectiva.
-- Se va afisa Numele angajatului Departamentul Data angajarii Data testarii

SELECT ENAME "Numele angajatului", DNAME Departamentul, HIREDATE "Data angajarii", next_day(add_months(hiredate,2), 'SUNDAY') "Data testarii"
from  EMP, DEPT
where emp.deptno = dept.deptno
      and
      dept.dname='SALES';


--  Selectati angajatii care au litera E in interiorul numelui, afisand numele angajatului intre caracterul '=', vechimea in ani rotunjita la intreg,
-- si salariul formatat la un sir de 6 caractere, umplut dinspre stinga cu caracterul 'X'   (de ex. XX5000): Nume formatat, Vechime ani, Sal formatat
SELECT concat(concat('=',ENAME),'=') as "Nume formatat",
       round(months_between(SYSDATE,HIREDATE)/12) as "Vechime ani",
       lpad(SAL, 6, 'X') as "Salariu formatat"
FROM EMP
WHERE instr(ENAME,'E') > 1 ;


SELECT '='|| ENAME|| '=' as "Nume formatat",
       round((SYSDATE-HIREDATE)/365) as "Vechime ani",
       lpad(SAL, 6, 'X') as "Salariu formatat"
FROM EMP
WHERE ENAME like '%E%';


select distinct MGR from EMP;


-- Selectati numele sefilor tuturor angajatilor care nu fac parte dintr-un departament citit de la tastatura si care au un venit mai mare decit BLAKE.
-- Veti afisa si o valoare medie dintre salariu si comision, pentru fiecare angajat, rotunjita
-- Nu afisati duplicate.
-- Se va rezolva in 4 moduri
