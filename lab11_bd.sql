-- -- Subiect pentru pregatirea colocviului (fara rezolvare propusa):
-- Sa se creeze o tabela denumita ANGAJATI_GRAD_ALLEN continand primii doi angajati, ca marime a veniturilor lor, ce fac parte din acelasi grad salarial cu ALLEN.

-- Se va afisa : Nume angajat, Venit, Grad salarial
-- Se va utiliza baza de date a userului SCOTT, formata din tabelele EMP, DEPT, SALGRADE.
-- Includeti si selectarea inregistrarilor din tabela creata precum si stergerea tabelei

-- Pas 1: Selectare angajati din acelasi grad salarial cu ALLEN
SELECT A.ENAME "Nume angajat", A.SAL + NVL(A.COMM, 0) Venit, B.GRADE "Grad salarial"
FROM EMP A JOIN SALGRADE B ON A.SAL BETWEEN B.LOSAL AND B.HISAL
WHERE
B.GRADE=( SELECT D.GRADE
          FROM EMP C JOIN SALGRADE D ON C.SAL BETWEEN D.LOSAL AND D.HISAL
          WHERE
            C.ENAME='ALLEN'
        );

-- Pas 2: Selectarea primelor doua venituri din lista de mai sus
-- Pentru cel cu venitul cel mai mare, numarul angajatilor cu venitul mai mare ca al sau e 0
-- Pentru cel cu al doilea venit, numarul angajatilor cu venitul mai mare ca al sau e 1

SELECT A.ENAME "Nume angajat", A.SAL + NVL(A.COMM, 0) Venit, B.GRADE
FROM EMP A JOIN SALGRADE B ON A.SAL BETWEEN B.LOSAL AND B.HISAL
WHERE
B.GRADE=( SELECT D.GRADE
          FROM EMP C JOIN SALGRADE D ON C.SAL BETWEEN D.LOSAL AND D.HISAL
          WHERE
            C.ENAME='ALLEN'
        )
AND
1 >= (SELECT COUNT(*)
      FROM EMP E JOIN SALGRADE F ON E.SAL BETWEEN F.LOSAL AND F.HISAL
      WHERE
          F.GRADE=( SELECT GRADE
          FROM EMP  JOIN SALGRADE  ON SAL BETWEEN LOSAL AND HISAL
          WHERE
            ENAME='ALLEN'
        )
        AND
        E.SAL + NVL(E.COMM, 0) > A.SAL + NVL(A.COMM, 0)
       );

-- Pas 3: Crearea tabelei, select, drop
CREATE TABLE ANGAJATI_GRAD_ALLEN AS
(
SELECT A.ENAME "Nume angajat", A.SAL + NVL(A.COMM, 0) Venit, B.GRADE
FROM EMP A JOIN SALGRADE B ON A.SAL BETWEEN B.LOSAL AND B.HISAL
WHERE
B.GRADE=( SELECT D.GRADE
          FROM EMP C JOIN SALGRADE D ON C.SAL BETWEEN D.LOSAL AND D.HISAL
          WHERE
            C.ENAME='ALLEN'
        )
AND
1 >= (SELECT COUNT(*)
      FROM EMP E JOIN SALGRADE F ON E.SAL BETWEEN F.LOSAL AND F.HISAL
      WHERE
          F.GRADE=( SELECT GRADE
          FROM EMP  JOIN SALGRADE  ON SAL BETWEEN LOSAL AND HISAL
          WHERE
            ENAME='ALLEN'
        )
        AND
        E.SAL + NVL(E.COMM, 0) > A.SAL + NVL(A.COMM, 0)
       )
);

SELECT * FROM ANGAJATI_GRAD_ALLEN;

DROP TABLE ANGAJATI_GRAD_ALLEN;

/*
-------------------------------
-- EXEMPLIFICARE ROLURI, USERI ---
-------------------------------
CONNECT sys as sysdba

-- introducere parola
alter session set "_ORACLE_SCRIPT"=true;

CREATE ROLE rol_contabil;
grant insert, delete, select on scott.emp to rol_contabil;

grant select, insert on scott.dept to rol_contabil;

revoke insert on scott.dept from rol_contabil;

CREATE USER user1 identified by user1;
GRANT CREATE SESSION TO user1;

GRANT rol_contabil to user1;

conn user1/user1

select * from SCOTT.dept;
 insert into SCOTT.dept values (60, 'TEST', 'TESTLOC');

conn sys as sysdba
alter session set "_ORACLE_SCRIPT"=true;
drop user user1;

drop role rol_contabil;


conn scott/tiger
*/
-----------------------------------------
-- Comenzile SQL*Plus
-----------------------------------------


-- Editarea, memorarea ??i executarea comenzilor SQL
-- Efectuarea de calcule, formatarea datelor de ie??ire ??i printarea listelor
-- Listarea structurii obiectelor din baza de date
-- Accesul ??i transferul datelor ??ntre baze de date
-- Interceptarea ??i interpretarea mesajelor de eroare


----------------------------------
-- Comanda SET
----------------------------------
-- Este folosit?? pentru setarea ??i activarea/dezactivarea anumitor parametri specifici sesiunii curente
-- Ace??ti parametri au valori implicite la deschiderea unei sesiuni ??n SQL*Plus, dar sunt situa??ii c??nd unii
-- trebuie modifica??i conform cerin??elor utilizatorului ??i la terminarea sesiunii revin la valorile implicite.

-- FEED[BACK] {6|n|OFF|ON afi??eaz?? num??rul de ??nregistr??ri returnate de un query c??nd sunt returnate cel pu??in n ??nregistr??ri, valoarea implicit?? este 6
-- TIMING on/off afiseaza timpul in care s-a executat o comanda SQL, daca e pusa pe on
-- SPA[CE] n	seteaz?? num??rul de spa??ii dintre coloane in timpul afisarii (valoarea implicit?? este 1, valoarea maxima pentru n este 10)
-- NUM[WIDTH] n	seteaz?? lungimea implicit?? pentru afi??area valorilor numerice, valoarea implicit?? este 10

set timing on
select * from emp, dept;
set timing off

select ename, empno from emp;

set space 6
select ename, empno from emp;
set space 1


----------------------------
-- Formatarea listelor output ale comenzilor SELECT
----------------------------

----------------
-- Comanda COLUMN - este folosit?? pentru definirea ??i formatarea coloanelor de ie??ire.
----------------
-- Parametri:
-- FOR[MAT] format	specific?? formatul de afisare An pentru coloane alfanumerice sau unul din formatele numerice
-- HEA[DING] text	define??te antetul coloanei
-- JUS[TIFY] L[EFT]|C[ENTER]|R[IGHT]	specific?? alinierea antetului (implicit dreapta pentru coloane numerice ??i st??nga pentru celelalte tipuri)
COLUMN SAL FORMAT 00999 HEADING 'Salariu_net'

select ename, sal from emp;

-----------------
--Comenzile TTITLE si BTITLE
-----------------
-- Comanda TTITLE se folose??te pentru formatarea titlui de ??nceput al unui raport.
-- Comanda BTITLE se folose??te pentru formatarea titlui de sf??r??it al unui raport.
-- parametri
-- LEFT 	se pozi??ioneaz?? articolul care urmeaz?? acestei op??iuni ??n partea st??ng?? a liniei. Dac?? nu mai exist?? nicio op??iune de aliniere ??n comand??, toate articolele vor fi aliniate ??n ordinea apari??iei ??n partea st??ng??, altfel se aliniaz?? numai cele care apar pana la urmatoarea op??iune
-- CENTER	??n acest caz, pozi??ionarea se face central ??i se ia ??n calcul lungimea liniei setat?? cu LINESIZE
-- RIGHT	similar cu op??iunea de mai sus, dar pozi??ionarea se face la dreapta
-- BOLD	se specific?? ca afi??area s?? se fac?? folosind caractere ??ngro??ate
-- la final btittle off si ttitle off

ttitle 'Titlu raport sus' center underline

select ename, sal from emp;

ttitle off


------------------------
-- Comenzile BREAK si COMPUTE
-- Comanda BREAK este folosit?? pentru fragmentarea unui raport ??n mai multe segmente
-- Comanda COMPUTE execut?? anumite calcule pe segmentele respective
-- Comanda BREAK (care face o fragmentare) are urm??toarea sintax??:
--BRE[AK] [ON report_element [action [action]]] ???
-- Calculele care se pot face cu comanda COMPUTE sunt:
-- Operatie	Descriere operatie
-- AVG	calcul medie (pentru date de tip number)
-- COU[NT]	num??r?? valorile nenule (pentru orice tip de date)
-- MAX[IMUM]	valoare maxim?? (pentru date de tip number ??i char)
-- MIN[IMUM]	valoare minim?? (pentru date de tip number ??i char)
-- NUM[BER]	num??r?? r??nduri (pentru orice tip de data)
-- STD	calcul devia??ie standard pentru valori nenule (pentru date de tip number)
-- SUM	calcul suma pentru valori nenule (pentru date de tip number)
-- VAR[IANCE]	calcul varia??ie (pentru date de tip number)
--- NU UITATI SA INCLUDETI ORDER BY!!!!

TTITLE right 'Nr. pag' sql.pno center 'Angajati pe departamente'
BTITLE 'Final pagina raport'
COLUMN ENAME format a20 heading 'Nume'
COLUMN SAL heading 'Salariul'

BREAK ON DNAME NODUP ON REPORT
COMPUTE SUM OF SAL ON DNAME SKIP 2 REPORT

SELECT A.ENAME, B.DNAME, A.SAL
FROM EMP A JOIN DEPT B
     ON A.DEPTNO=B.DEPTNO
ORDER BY B.DNAME, A.SAL DESC;



SELECT A.ENAME, B.DNAME, A.SAL
FROM EMP A JOIN DEPT B
     ON A.DEPTNO=B.DEPTNO
ORDER BY B.DNAME, A.SAL DESC;

TTITLE OFF
BTITLE OFF
CLEAR BREAK
CLEAR COMPUTE
CLEAR COLUMNS
