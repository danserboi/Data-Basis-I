-- Pentru angajatii care au gradul salarial gradul 1 sau 3, sa se calculeze suma veniturilor lunare si numarul de angajuti pentru grupul format din grad salarial, nume departament si nume functie.

-- Sa se afiseze doar liniile unde suma veniturilor lunare este mai mica sau egala cu 3500.

-- Venitul lunar se calculeaza ca suma dintre salariu si comision.

-- Afisati:

-- - gradul salarial

-- - numele departamentului

-- - numele functiei

-- - numarul de angajati

-- - suma veniturilor lunare

-- Ordonati dupa gradul salarial si numele departamentului

-- Traduceti numele departamentului in limba romana

-- Afisati suma veniturilor lunare folosind formatul  $999999.99

-- Sa se rezolve prin doua metode distincte folosind diverse functii SQL.

-- Pentru testare se va utiliza baza de date a userului scott, formata din tabelele EMP, DEPT si SALGRADE.

-- VARIANTA 1
SELECT GRD.GRADE "gradul salarial",
    case DEP.DNAME
        when 'ACCOUNTING' then 'CONTABILITATE'
        when 'RESEARCH' then 'CERCETARE'
        when 'SALES' then 'VANZARI'
        when 'OPERATIONS' then 'OPERATIUNI'
    end "numele departamentului",
    ANG.JOB "numele functiei",
    count(*) "numarul de angajati",
    to_char (SUM(ANG.SAL + NVL(ANG.COMM, 0)), '$999999.99') "suma veniturilor lunare"
FROM EMP ANG JOIN DEPT DEP ON ANG.DEPTNO=DEP.DEPTNO JOIN SALGRADE GRD ON ANG.SAL BETWEEN GRD.LOSAL AND GRD.HISAL
WHERE
(GRD.GRADE = 1 OR GRD.GRADE = 3)
GROUP BY GRD.GRADE, DEP.DNAME, ANG.JOB
HAVING SUM(ANG.SAL + NVL(ANG.COMM, 0)) <= 3500
ORDER BY GRD.GRADE, DEP.DNAME;

-- VARIANTA 2
SELECT GRD.GRADE "gradul salarial",
    DECODE(DEP.DNAME,
        'ACCOUNTING', 'CONTABILITATE',
        'RESEARCH', 'CERCETARE',
        'SALES', 'VANZARI',
        'OPERATIONS', 'OPERATIUNI') "numele departamentului",
    ANG.JOB "numele functiei",
    count(*) "numarul de angajati",
    to_char (SUM(ANG.SAL + NVL(ANG.COMM, 0)), '$999999.99') "suma veniturilor lunare"
FROM EMP ANG, DEPT DEP, SALGRADE GRD
WHERE
GRD.GRADE IN (1,3)
AND
ANG.DEPTNO=DEP.DEPTNO
AND
ANG.SAL BETWEEN GRD.LOSAL AND GRD.HISAL
GROUP BY GRD.GRADE, DEP.DNAME, ANG.JOB
HAVING SUM(ANG.SAL + NVL(ANG.COMM, 0)) <= 3500
ORDER BY GRD.GRADE, DEP.DNAME;