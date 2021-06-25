-- allias de coloana
select deptno from dept;

select deptno departamentul, dname denumirea, loc from dept;

-- IS NULL si NOT NULL
SELECT ENAME, EMPNO, SAL, COMM
FROM EMP
WHERE
SAL > &&SALARIU
AND
(COMM IS NOT NULL AND COMM > 0);

-- NVL : NVL(a, b) =
-- a, daca a is not null
-- b, daca a is null

SELECT ENAME, EMPNO, SAL, COMM
FROM EMP
WHERE
SAL > &SALARIU
AND
nvl(COMM, 0) > 0;

-- VENITUL ANG = SALARIU + NVL(COMISION) : VENIT = SAL + NVL(COMM, 0)
-- VENIT ANUAL = (VENIT LUNAR * 12)

-- JOIN explicit vs PRODUS CARTEZIAN: Toti salariatii din ACCOUNTING fara comision
select emp.ename, emp.sal, emp.comm, dept.dname
from emp, dept
WHERE
EMP.DEPTNO=DEPT.DEPTNO
AND
dept.dname='ACCOUNTING'
AND
NVL(COMM, 0)=0;

SELECT ENAME, DNAME FROM EMP, DEPT;

-- join ON
select emp.ename Numele, emp.sal + nvl(comm, 0) Venit, dept.dname departament
from emp JOIN dept ON EMP.DEPTNO=DEPT.DEPTNO
WHERE
dept.dname='ACCOUNTING'
AND
NVL(COMM, 0)=0;

-- JOIN natural
select emp.ename Numele, emp.sal + nvl(comm, 0) Venit, dept.dname departament
from emp NATURAL JOIN dept
WHERE
dept.dname='ACCOUNTING'
AND
NVL(COMM, 0)=0;

SELECT ENAME, DNAME FROM EMP NATURAL JOIN DEPT;

-- join intre o tabela si ea insasi. Comparatie intre venitul unui angajat si cel al sefului sau
SELECT A.ENAME, S.ENAME, A.SAL+NVL(A.COMM, 0) VENIT_ANGAJAT, S.SAL+NVL(S.COMM, 0) VENIT_SEF
FROM EMP A, EMP S
WHERE
A.MGR=S.EMPNO
AND
(A.SAL+ NVL(A.COMM, 0))>(S.SAL+ NVL(S.COMM, 0));

-- Sa se selecteze toti angajatii care castiga(venit) mai mult decat o valoare citita de la tastatura si care sunt angajati inainte de sefii lor
SELECT A.ENAME, S.ENAME
FROM EMP A, EMP S
WHERE
A.MGR=S.EMPNO
AND
A.SAL+NVL(A.COMM, 0) > &VENIT_ANG
AND
A.HIREDATE>S.HIREDATE;

-- NON equi join Sa se selecteze, pentru fiecare angajat din dept SALES: numele, denumirea departamentului si gradul salarial
SELECT A.ENAME, B.DNAME, A.SAL, C.GRADE
FROM EMP A, DEPT B, SALGRADE C
WHERE
A.DEPTNO=B.DEPTNO
AND
A.SAL >= C.LOSAL
AND
A.SAL <= C.HISAL
AND
B.DNAME LIKE 'SALES'
ORDER BY 4;

SELECT A.ENAME, B.DNAME, A.SAL, C.GRADE
FROM EMP A JOIN DEPT B ON A.DEPTNO=B.DEPTNO JOIN SALGRADE C ON A.SAL BETWEEN C.LOSAL AND C.HISAL
WHERE
B.DNAME LIKE 'SALES'
ORDER BY 4;

-- UTILIZAND JOIN ON SI USING: Selectati toti angajatii dintr-un departament cu den citita de la tastatura, care au salariul in grad 3:
-- numele, denumirea departamentului, sal, grad salarial
SELECT A.ENAME, B.DNAME, A.SAL, C.GRADE
FROM EMP A JOIN DEPT B ON A.DEPTNO=B.DEPTNO JOIN SALGRADE C ON A.SAL BETWEEN C.LOSAL AND C.HISAL
WHERE
A.DEPTNO>&DEP
AND
C.GRADE=3
ORDER BY 4;

-- OUTER JOIN
SELECT A.DNAME, A.DEPTNO, B.ENAME, B.JOB
FROM DEPT A, EMP b
WHERE
A.DEPTNO=B.DEPTNO(+)
ORDER BY A.DNAME;

SELECT A.DNAME, A.DEPTNO, B.ENAME, B.JOB
FROM DEPT A LEFT OUTER JOIN EMP B
ON
A.DEPTNO=B.DEPTNO
ORDER BY A.DNAME;