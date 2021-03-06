desc dept
desc emp
desc salgrade

SELECT EMPNO, ENAME, SAL, DEPTNO
FROM EMP
WHERE SAL > 1400
order by sal desc, ename;

-- departamentele situate in CHICAGO
SELECT * FROM DEPT
WHERE LOC LIKE 'CHI%';

-- angajatii care au sef pe angajatul cu id-ul 7902 si apoi 7910, ordonate dupa salariu, descendent
SELECT * FROM EMP
WHERE
MGR = 7902
ORDER BY SAL DESC;

SELECT * FROM EMP
WHERE
MGR = 7910
ORDER BY SAL DESC;

SELECT * FROM EMP
WHERE
SAL > &salariu;

CREATE TABLE ANGAJATI_PESTE1000
AS
SELECT ENAME, EMPNO, SAL FROM EMP
WHERE
SAL > &salariu;

select * from ANGAJATI_PESTE1000;

drop table ANGAJATI_PESTE1000;

SELECT * FROM DEPT
WHERE DEPTNO > 20;

CREATE TABLE DEPT_PESTE20
AS
SELECT DNAME, LOC FROM DEPT
WHERE
DEPTNO > 20;

CREATE TABLE GRADE_PESTE3
AS
SELECT GRADE, LOSAL FROM salgrade
WHERE
GRADE > 3;

DROP TABLE GRADE_PESTE3;

DROP TABLE DEPT_PESTE20;

-- Comparatie pe date. Selectati angajatii ce au venit in firma dupa data de 01-martie-1981
SELECT *
FROM EMP
WHERE
HIREDATE > TO_DATE('01-03-1981', 'DD-MM-YYYY');

-- Angajatii veniti in firma in data de 17 dec 1980
select * from emp where to_char(hiredate, 'DD-MM-YYYY') = '17-12-1980';

-- angajatii cu salarii intre 1200 si 2200
SELECT * FROM EMP
WHERE
SAL >= 1200
AND
SAL <= 2200;

SELECT * FROM EMP
WHERE
SAL BETWEEN 1200 AND 2200;

SELECT * FROM EMP
WHERE
HIREDATE BETWEEN TO_DATE('02-04-1981', 'DD-MM-YYYY') AND TO_DATE('02-12-1981', 'DD-MM-YYYY');

SELECT * FROM EMP
WHERE
TO_CHAR(HIREDATE, 'YYYYMMDD') BETWEEN '19810402' AND '19811202';

-- NULE
SELECT * FROM EMP WHERE COMM = NULL;

SELECT * FROM EMP WHERE COMM IS NULL;

SELECT * FROM EMP WHERE COMM IS NOT NULL AND COMM > 0;

-- LIKE
SELECT * FROM EMP WHERE ENAME LIKE '%AR%';

-- VALORI PE COLOANE
SELECT 1, ENAME FROM EMP;
SELECT 'AZI ESTE DATA' || SYSDATE || ' SI ANGAJATUL SE NUMESTE' || ENAME FROM EMP;

-- ANGAJATII CARE FAC PARTE DIN DEP CU LOCATIA IN CHICAGO
SELECT EMPNO, SAL, EMP.ENAME
FROM EMP, DEPT
WHERE
EMP.DEPTNO = DEPT.DEPTNO
AND
DEPT.LOC='CHICAGO';