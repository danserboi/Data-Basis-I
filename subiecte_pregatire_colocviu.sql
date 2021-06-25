-- Subiectul 1 pentru pregatirea colocviului (cu rezolvare propusa):
-- Sa se selecteze, pentru fiecare angajat ce face parte din departamentul cu cei mai putini angajati:
--  Nume angajat, Venit angajat, Denumire departament

-- Nu se va tine cont de departamentul OPERATIONS
-- Se va utiliza baza de date a userului SCOTT, formata din tabelele EMP, DEPT, SALGRADE.

-- Rezolvare in pasi:
-- Aflarea departamentului cu cei mai putini angajati, exceptand OPERATIONS
SELECT A.DEPTNO
FROM EMP A
WHERE
A.DEPTNO !=(SELECT DEPTNO FROM DEPT WHERE DNAME='OPERATIONS')
GROUP BY A.DEPTNO
HAVING COUNT(*) = (SELECT MIN(COUNT(*))
                   FROM EMP B
                   WHERE
                      B.DEPTNO !=(SELECT DEPTNO FROM DEPT WHERE DNAME='OPERATIONS')
                   GROUP BY B.DEPTNO
                   );

-- selectul final
SELECT X.ENAME "Nume angajat", X.SAL + NVL(X.COMM, 0) "Venit angajat", Y.DNAME
FROM EMP X JOIN DEPT Y ON X.DEPTNO=Y.DEPTNO
WHERE
X.DEPTNO IN (
SELECT A.DEPTNO
FROM EMP A
WHERE
A.DEPTNO !=(SELECT DEPTNO FROM DEPT WHERE DNAME='OPERATIONS')
GROUP BY A.DEPTNO
HAVING COUNT(*) = (SELECT MIN(COUNT(*))
                   FROM EMP B
                   WHERE
                      B.DEPTNO !=(SELECT DEPTNO FROM DEPT WHERE DNAME='OPERATIONS')
                   GROUP BY B.DEPTNO
                   )
);


-- -- Subiectul 2 pentru pregatirea colocviului (fara rezolvare propusa):
-- Sa se creeze o tabela denumita ANGAJATI_GRAD_MARE continand primii doi angajati, ca marime a veniturilor lor, ce fac parte din acelasi grad salarial cu ALLEN.

-- Se va afisa : Nume angajat, Venit, Grad salarial
-- Se va utiliza baza de date a userului SCOTT, formata din tabelele EMP, DEPT, SALGRADE.