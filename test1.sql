-- Sa se scrie o cerere SQL care face o lista pentru acordarea unei prime reprezentand un procent din salariul angajatilor care s-au
-- angajat intr-un anumit an si care nu au primit comision.
-- Procentul si anul de angajare se vor introduce de la tastatuta. Coloana Semnatura din lista nu contine date. Salariu_marit =
-- salariu + prima.
-- Pentru testarea solutiilor se va folosi tabela EMP.
-- Sa se rezolve prin cel putin 4 metode distincte folosind cereri cu variabile substituite.
-- Antetul listei este: Nume, Functie, Prima, Salariu, Salariu marit, Semnatura

-- cu &&
SELECT
ename as "Nume",
job as "Functie",
sal*&&procent as "Prima",
sal as "Salariu",
sal+sal*&procent as "Salariu marit",
null as "Semnatura"
FROM emp
WHERE hiredate LIKE '%'||&&an_ang
and (comm = 0 or comm is NULL);

-- cu define
define procent = 0.15
define an_ang = 1981
SELECT
ename as "Nume",
job as "Functie",
sal*&procent as "Prima",
sal as "Salariu",
sal+sal*&procent as "Salariu marit",
null as "Semnatura"
FROM emp
WHERE hiredate LIKE '%'||&an_ang
and (comm = 0 or comm is NULL);

-- cu accept
accept procent char prompt 'Introduceti procent:'
define an_ang char prompt 'Introduceti an angajare:'
SELECT
ename as "Nume",
job as "Functie",
sal*&procent as "Prima",
sal as "Salariu",
sal+sal*&procent as "Salariu marit",
null as "Semnatura"
FROM emp
WHERE hiredate LIKE '%'||&an_ang
and (comm = 0 or comm is NULL);

-- cu not la comm
SELECT
ename as "Nume",
job as "Functie",
sal*&&procent as "Prima",
sal as "Salariu",
sal+sal*&procent as "Salariu marit",
null as "Semnatura"
FROM emp
WHERE hiredate LIKE '%'||&&an_ang
and NOT(comm > 0);