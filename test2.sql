-- Sa se afiseze toti angajatii ce au sosit in firma in anul 1981, care au un venit mai mare decat cel al sefului lor, afisand o lista cu antetul :

-- Nume angajat, Den departament, Nume sef, Venit angajat, Venit sef, Ultima zi luna angajare

-- Se se rezolve prin doua metode distincte folosind JOIN-uri si functii SQL.

-- Pentru testare se va utiliza baza de date a userului scott, formata din tabelele EMP, DEPT si SALGRADE.

SELECT
A.ENAME as "Nume angajat",
D.DNAME as "Den departament",
S.ENAME as "Nume sef",
A.SAL+NVL(A.COMM, 0) as "Venit angajat",
S.SAL+NVL(S.COMM, 0) as "Venit sef",
LAST_DAY(A.HIREDATE) as "Ultima zi luna angajare"
FROM EMP A, EMP S, DEPT D
WHERE
A.MGR=S.EMPNO
AND
A.DEPTNO = D.DEPTNO
AND
EXTRACT(YEAR from A.HIREDATE) = 1981
AND
A.SAL+NVL(A.COMM, 0) > S.SAL+NVL(S.COMM, 0);

SELECT
A.ENAME as "Nume angajat",
D.DNAME as "Den departament",
S.ENAME as "Nume sef",
A.SAL+NVL(A.COMM, 0) as "Venit angajat",
S.SAL+NVL(S.COMM, 0) as "Venit sef",
LAST_DAY(A.HIREDATE) as "Ultima zi luna angajare"
FROM EMP A
JOIN EMP S ON
A.MGR=S.EMPNO
JOIN DEPT D ON
A.DEPTNO = D.DEPTNO
WHERE
EXTRACT(YEAR from A.HIREDATE) = 1981
AND
A.SAL+NVL(A.COMM, 0) > S.SAL+NVL(S.COMM, 0);

SELECT
A.ENAME "Nume angajat",
D.DNAME "Den departament",
S.ENAME "Nume sef",
A.SAL+NVL(A.COMM, 0) "Venit angajat",
S.SAL+NVL(S.COMM, 0) "Venit sef",
LAST_DAY(A.HIREDATE) "Ultima zi luna angajare"
FROM EMP A
JOIN DEPT D USING(DEPTNO)
INNER JOIN EMP S ON
A.MGR=S.EMPNO
WHERE
EXTRACT(YEAR from A.HIREDATE) = 1981
AND
A.SAL+NVL(A.COMM, 0) > S.SAL+NVL(S.COMM, 0);