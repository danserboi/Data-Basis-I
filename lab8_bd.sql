--- test 2: exemple subiecte
-- JOIN 2 metode. JOIN ON, JOIN WHERE

-- Afisati, pentru fiecare angajat venit in firma la o diferenta de cel putin 2 luni fata de seful sau, urmatoarele
-- - numele angajatului precedat de ###,
-- - numele sefului angajatului, scris cu litere mici,
-- - prima zi din anul in care s-a angajat,
-- - urmatoarea zi de marti dupa data din care s-a angajat seful sau.
-- Antetul listei este urmatorul:
-- Nume ang *, Nume sef, Prima zi, Zi marti
-- Se se rezolve prin doua metode distincte folosind  JOIN-uri si functii SQL.


-- Sa se afiseze toti angajatii departamentelor RESEARCH sau SALES, care s-au angajat cu cel putin 3 luni dupa seful lor direct,
-- afisand, pentru fiecare angajat, numarul de luni ce au trecut de la angajarea sefului pana s-au angajat ei, precum si
-- o traducere a deenumirii departamentului (CERCETARE sau VANZARI). Se va afisa o lista cu antetul:
-- Nume_angajat, Nume_sef, Data_ang_angajat, Data_ang_sef, Nr_luni_dupa_sef (valoare intreaga), Traducere departament
-- Se se rezolve prin doua metode distincte folosind UNION, JOIN-uri si functii SQL.

select a.ename Nume_angajat, sef.ename Nume_angajat, a.hiredate Data_ang_angajat,
       sef.hiredate Data_ang_sef, floor(months_between(a.hiredate, sef.hiredate)) Nr_luni_dupa_sef,
      'CERCETARE' "Traducere departament"
from emp a, dept sales, emp sef
where
a.deptno=sales.deptno
and
sales.dname='RESEARCH'
and
a.mgr=sef.empno
and
a.mgr is not null
and
months_between(a.hiredate, sef.hiredate)>=3
UNION
select a.ename Nume_angajat, sef.ename Nume_angajat, a.hiredate Data_ang_angajat,
       sef.hiredate Data_ang_sef, floor(months_between(a.hiredate, sef.hiredate)) Nr_luni_dupa_sef,
      'VANZARI' "Traducere departament"
from emp a, dept sales, emp sef
where
a.deptno=sales.deptno
and
sales.dname='SALES'
and
a.mgr=sef.empno
and
a.mgr is not null
and
months_between(a.hiredate, sef.hiredate)>=3;

------------------------------
--- SUBCERERI ----
------------------------------
-- Subcererile sunt cereri SQL incluse ??n clauzele SELECT, FROM, WHERE, HAVING ??i ORDER BY ale altei cereri numit??
-- ??i cerere principal??.

-- Subcereri necorelate: rezultatul subcererii nu este condi??ionat de valorile din cererea principal??
-- Subcereri corelate: rezultatul subcererii este condi??ionat de valorile din cererea principal??

-- Subcererea trebuie s?? fie inclus?? ??ntre paranteze;
-- Pentru cazurile ??n care subcererea se afl?? ??n clauza WHERE, sau HAVING, aceasta trebuie s?? fie ??n
-- partea dreapt?? a condi??iei;
-- Subcererile nu pot fi ordonate, deci nu con??in clauza ORDER BY
-- Clauza ORDER BY apare la sf??r??itul cererii principale.


--------------------------------
-- Subcereri necorelate ??n clauza WHERE
--------------------------------
-- Subcererile necorelate sunt subcereri care nu au o leg??tur?? de asociere ??ntre expresiile
-- cererii exterioare ??i cele ale cererii interioare.

-- Sa se selecteze, prin JOIN si prin SUBCERERE, pentru fiecare angajat care nu e in SALES
-- care castiga (VENIT) mai mult decat MARTIN: NUMELE, DENUMIREA DEPARTAMENTULUI, venitul sau
-- JOIN
SELECT A.ENAME, B.DNAME, A.SAL + NVL(A.COMM, 0) VENIT
FROM EMP A, DEPT B, EMP MARTIN
where
 A.DEPTNO=B.DEPTNO
 AND
 B.DNAME NOT LIKE 'SALES'
 AND
 MARTIN.ENAME='MARTIN'
 AND
 A.SAL  + NVL(A.COMM, 0) > MARTIN.SAL + NVL(MARTIN.SAL, 0);

 select martin.sal+nvl(martin.comm, 0)
      from emp martin
      where
         martin.ename like 'MARTIN'
    ;

SELECT A.ENAME, B.DNAME, A.SAL + NVL(A.COMM, 0) VENIT
FROM EMP A, DEPT B
where
 A.DEPTNO=B.DEPTNO
 AND
 B.DNAME NOT LIKE 'SALES'
 AND
 A.SAL  + NVL(A.COMM, 0) >
    (
      select martin.sal+nvl(martin.comm, 0)
      from emp martin
      where
         martin.ename like 'MARTIN'
    );

-- Sa se selecteze angajatul din SALES cu cel mai mare salariu din acest departament

SELECT A.EMPNO, A.SAL, B.DNAME
FROM EMP A JOIN DEPT B ON A.DEPTNO= B.DEPTNO
WHERE
 A.DEPTNO IN (
              SELECT C.DEPTNO
              FROM EMP X JOIN DEPT C ON X.DEPTNO=C.DEPTNO
              WHERE
                C.DNAME='SALES'
            )
AND
A.SAL in (
         SELECT MAX(D.SAL)
         FROM EMP D JOIN DEPT E ON E.DEPTNO=D.DEPTNO
         WHERE
             E.DNAME='SALES'
       );


-- Sa se afiseze, pentru fiecare angajat, ce castiga peste media SALARIILOR din firma: numele, salariul, departamentul

SELECT A.ENAME, A.SAL, B.DNAME
FROM EMP A JOIN DEPT B ON A.DEPTNO=B.DEPTNO
WHERE
A.SAL > (SELECT AVG(C.SAL)
         FROM EMP C);

-- SELECTATI TOTI ANGAJATII CARE AU VENIT IN FIRMA DUPA ALLEN

select a.hiredate "Allen_hiredate"
  from emp a where a.ename = 'ALLEN';

select ename, hiredate
from emp
where hiredate >
  (select hiredate
  from emp where ename = 'ALLEN');

---------------------------------------------
-- Subcereri corelate ??n clauze WHERE
---------------------------------------------
-- Subcererile corelate se execut?? o singur?? dat?? pentru fiecare linie candidat prelucrat?? de cererea principal??.
-- O subcerere corelat?? se join-eaz?? cu cererea exterioar?? prin folosirea unei coloane a cererii exterioare
-- ??n clauza predicatului cererii interioare.

-- Sa se afiseze, pentru fiecare angajat ce castiga peste media departamentului sau: numele, salariul, departamentul

SELECT A.ENAME, A.SAL, B.DNAME
FROM EMP A JOIN DEPT B ON A.DEPTNO=B.DEPTNO
WHERE
A.SAL > (SELECT AVG(C.SAL)
         FROM EMP C
         WHERE
           C.DEPTNO=A.DEPTNO);

-- Sa se selecteze angajatii care au salariul al n-lea din firma

-- angajatul cu salariul maxim
select * from emp a
where
sal in (select max(sal) from emp);

-- angajatul cu al doilea salariu
select * from emp a
where
a.sal = (select max(sal)
         from emp
         where
            sal != (select max(sal) from emp)
       );

-- al 5 lea salariu
SELECT A.ENAME, A.SAL
FROM EMP A
WHERE
 4 = (SELECT COUNT(*)
     FROM EMP B
     WHERE
      B.SAL >A.SAL
     );



-- PRIMII 5
SELECT A.ENAME, A.SAL
FROM EMP A
WHERE
 4 >= (SELECT COUNT(*)
     FROM EMP B
     WHERE
      B.SAL >A.SAL
     );

--- ROWNUM, ORDER BY --> de studiat!

-------------------------------------------
-- Subcereri pe tabel?? temporar?? (??n clauza FROM)
-- Aceste subcereri se ??nt??lnesc ??n cazul ??n care se folose??te o subcerere la nivelul clauzei FROM;
-- ??n clauza FROM se pot folosi doar subcereri necorelate;
-- Corelarea dintre tabele ??i tabelele temporare din clauza FROM se face folosind metode de join.
-------------------------------------------

-- SA SE SELECTEZE, PENTRU FIECARE ANGAJAT: NUMELE, GRADUL SALARIAL, SALARIUL ANGAJATORULUI SI SALARIUL MAXIM DIN FIRMA
SELECT A.ENAME, B.GRADE, A.SAL, C.SALMAX
FROM EMP A, SALGRADE B, (SELECT MAX(SAL) SALMAX FROM EMP) C
WHERE
  A.SAL BETWEEN B.LOSAL AND B.HISAL;

-- SA SE SELECTEZE, PENTRU FIECARE ANGAJAT CE CASTIGA MAI MULT DECAT BLAKE:
-- NUMELE ANGAJATULUI, SALARIUL, SALARIUL LUI BLAKE, DIFERENTA INTRE SALARIUL SAU SI SALARIUL LUI BLAKE, DENUMIREA DEPARTAMENTULUI LUI BLAKE

SELECT A.ENAME, A.SAL, BLAKE.SAL "SALARIU BLAKE", A.SAL-BLAKE.SAL DIFERENTA, BLAKE.DNAME
FROM EMP A, (SELECT B.SAL, C.DNAME
             FROM EMP B JOIN DEPT C ON B.DEPTNO=C.DEPTNO
             WHERE
               B.ENAME='BLAKE'
            ) BLAKE
WHERE
A.SAL >BLAKE.SAL;
