-- Sa se selecteze angajatii care au cele mai mari doua venituri din randul subordonatilor angajatului cu cei mai multi subordonati.  Se va afisa, pentru fiecare angajat o lista cu antetul:

-- Nume, Nume sef, Venit

-- Pentru testare se va utiliza baza de date a userului scott, formata din tabelele EMP, DEPT si SALGRADE.

-- Se vor incarca si rezolvarile etapelor/pasilor intermediari.

-- Pasul 1: numar subordonati pentru fiecare sef
SELECT A.ENAME, COUNT(*)
FROM EMP A JOIN EMP B
ON A.EMPNO=B.MGR
GROUP BY A.ENAME;

-- Pasul 2: angajatul cu cei mai multi subordonati
SELECT A.ENAME
FROM EMP A JOIN EMP B
ON A.EMPNO=B.MGR
GROUP BY A.ENAME
HAVING COUNT(*) = (
                SELECT MAX(COUNT(*))
                FROM EMP C
                GROUP BY C.MGR
);

-- Pas 3: Selectarea primelor doua venituri din randul subordonatilor angajatului cu cei mai multi subordonati
-- Pentru cel cu venitul cel mai mare, numarul angajatilor cu venitul mai mare ca al sau e 0
-- Pentru cel cu al doilea venit, numarul angajatilor cu venitul mai mare ca al sau e 1
SELECT A.ENAME "Nume", B.ENAME "Nume sef", A.SAL + NVL(A.COMM, 0) "Venit"
FROM EMP A JOIN EMP B ON B.EMPNO=A.MGR
WHERE B.ENAME =
(SELECT A.ENAME
FROM EMP A JOIN EMP B
ON A.EMPNO=B.MGR
GROUP BY A.ENAME
HAVING COUNT(*) = (
                SELECT MAX(COUNT(*))
                FROM EMP C
                GROUP BY C.MGR))
AND
1 >= (SELECT COUNT(*)
      FROM EMP E JOIN EMP F ON F.EMPNO=E.MGR
      WHERE F.ENAME =
        (SELECT E.ENAME
        FROM EMP E JOIN EMP F
        ON E.EMPNO=F.MGR
        GROUP BY E.ENAME
        HAVING COUNT(*) = (
                        SELECT MAX(COUNT(*))
                        FROM EMP G
                        GROUP BY G.MGR))
       AND E.SAL + NVL(E.COMM, 0) > A.SAL + NVL(A.COMM, 0)
       );