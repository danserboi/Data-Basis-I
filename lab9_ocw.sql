-- Subcereri pe clauza HAVING
-- Ex. 1. Să se determine care departament are cei mai mulți angajați pe aceeași funcție.

-- Metoda 1
SELECT d.den_dep, a.functie, COUNT(a.id_ang) nr_ang
FROM angajati a
NATURAL JOIN departamente d
GROUP BY d.den_dep, a.functie
HAVING COUNT(a.id_ang) = (SELECT MAX(COUNT(id_ang))
                          FROM angajati
                          GROUP BY id_dep, functie);

-- Metoda 2

-- Pasul 1
SELECT MAX((SELECT (COUNT(id_ang))
            FROM angajati
            WHERE id_dep = s.id_dep AND functie = s.functie
            GROUP BY id_dep, functie)) max_count
FROM angajati s;

-- Pasul 2
SELECT d.den_dep, a.functie, COUNT(a.id_ang) nr_ang
FROM angajati a
NATURAL JOIN departamente d
GROUP BY d.den_dep, a.functie
HAVING COUNT(a.id_ang) = (SELECT MAX((SELECT (COUNT(id_ang))
                                      FROM angajati
                                      WHERE id_dep = s.id_dep AND functie = s.functie
                                      GROUP BY id_dep, functie)) max_count
                          FROM angajati s);


-- Ex. 2. Să se determine angajații care au comisionul maxim
-- pentru un departament introdus de la tastatură.
define id_dep = 30
SELECT d.den_dep, a.nume, a.functie, a.comision
FROM angajati a INNER JOIN departamente d ON a.id_dep = d.id_dep
GROUP BY d.den_dep, a.nume, a.functie, a.comision
HAVING MAX(a.comision) IN (SELECT MAX(comision)
                           FROM angajati
                           WHERE id_dep=&id_dep
                           GROUP BY id_dep)
ORDER BY 2;

-- Ex. 3. Să se afle ce angajat are salariul maxim în firmă
SELECT a.nume, a.functie, a.data_ang, a.salariu
FROM angajati a,
    (SELECT id_dep, MAX(salariu) sal_MAX_dep
     FROM angajati GROUP BY id_dep) b
GROUP BY a.nume,
         a.functie,
         a.data_ang,
         a.salariu
HAVING a.salariu = MAX(b.sal_MAX_dep)
ORDER BY a.nume;

-- Subcereri pe clauza SELECT
-- Ex. 4. Să se afișeze șefii angajaților din departamentul 20.
SELECT nume Nume_Ang, (SELECT nume FROM angajati WHERE id_ang = a.id_sef) Nume_Sef
FROM angajati a
WHERE id_dep = 20
ORDER BY nume;

-- Subcereri pe clauza ORDER BY
-- Ex. 5. Să se facă o listă cu angajații din departamentele 10 și 20,
-- ordonați descrescător după numărul de angajați din fiecare departament.
SELECT id_dep, nume, functie
FROM angajati a
WHERE id_dep IN (10, 20)
ORDER BY (SELECT count(*)
          FROM angajati b
          WHERE a.id_dep = b.id_dep) DESC;

-- Operatori în subcereri
-- Operatorii SOME(ANY) și ALL sunt folosiți în subcereri care întorc mai multe linii
-- și sunt folosiți împreună cu operatorii logici în clauzele WHERE și HAVING;
-- Ex. 6. Să se afle care sunt angajații care au salariul mai mare
-- decât salariul cel mai mic pentru funcția de SALESMAN.
SELECT id_dep, nume, functie, salariu
FROM angajati
WHERE salariu > SOME(SELECT DISTINCT salariu
                     FROM angajati
                     WHERE functie = 'SALESMAN')
ORDER BY id_dep, nume;

-- Ex. 7. Să se afle care sunt angajații care au salariul mai mare decât
-- salariul cel mai mare pentru funcția de SALESMAN.
SELECT id_dep, nume, functie, salariu
FROM angajati
WHERE salariu >= ALL(SELECT DISTINCT salariu
                     FROM angajati
                     WHERE functie = 'SALESMAN')
ORDER BY id_dep, nume;

-- Ex. 8. Să se determine departamentele care au cel puțin un angajat.
SELECT d.id_dep, d.den_dep
FROM departamente d
WHERE EXISTS(SELECT nume
             FROM angajati
             WHERE id_dep=d.id_dep)
ORDER BY id_dep;

-- Ex. 9. Să se determine care angajați nu au șef.
SELECT id_dep, id_ang, nume, functie, id_sef
FROM angajati a
WHERE NOT EXISTS(SELECT id_sef FROM angajati WHERE id_ang = a.id_sef)
ORDER BY id_dep;

-- Ex 10. Dacă ex. 9 se rescrie astfel încât cererea să folosească NOT IN
-- în loc de NOT EXISTS, atunci cererea nu va returna nimic.
SELECT id_dep, id_ang, nume, functie, id_sef
FROM angajati a
WHERE id_sef NOT IN(SELECT DISTINCT id_sef FROM angajati)
ORDER BY id_dep;
