-- EX 1

-- metoda 1
SELECT nume, functie, den_dep
FROM angajati, departamente
WHERE functie = 'ANALYST';

-- metoda 2
SELECT nume, functie, den_dep
FROM angajati
        CROSS JOIN departamente
WHERE functie = 'ANALYST';

-- EX 2

-- metoda 1
-- folosind alias
SELECT
    a.id_dep,
    d.den_dep,
    a.nume,
    a.functie
FROM
    angajati a,
    departamente d
WHERE
    a.id_dep = d.id_dep
    AND a.id_dep = 10
ORDER BY 3;

-- metoda 2
-- folosind numele tabelului
SELECT
    angajati.id_dep,
    departamente.den_dep,
    angajati.nume,
    angajati.functie
FROM
    angajati,
    departamente
WHERE
    angajati.id_dep = departamente.id_dep
    AND angajati.id_dep = 10
ORDER BY 3;

-- metoda 2 varianta 1
SELECT
    a.id_dep,
    d.den_dep,
    a.nume,
    a.functie
FROM
    angajati a
    JOIN departamente d
        ON a.id_dep = d.id_dep
WHERE
    a.id_dep = 10
ORDER BY 3;

-- metoda 2 varianta 2
SELECT
    a.id_dep,
    d.den_dep,
    a.nume,
    a.functie
FROM
    angajati a
    INNER JOIN departamente d
        ON a.id_dep = d.id_dep
WHERE
    a.id_dep = 10
ORDER BY 3;

-- metoda 3 varianta 1
-- folosind using
SELECT
    id_dep,
    d.den_dep,
    a.nume,
    a.functie
FROM
    angajati a
    INNER JOIN departamente d
        USING (id_dep)
WHERE
    id_dep = 10
ORDER BY 3;


-- metoda 3 varianta 2
-- folosind using
SELECT
    id_dep,
    d.den_dep,
    a.nume,
    a.functie
FROM
    angajati a
    JOIN departamente d
        USING (id_dep)
WHERE
    id_dep = 10
ORDER BY 3;

-- Ex 3
SELECT
    id_dep,
    den_dep,
    nume,
    functie
FROM
    angajati
    NATURAL JOIN departamente
WHERE
    id_dep = 10
ORDER BY 3;

-- Ex 4

-- metoda 1
SELECT a.nume, a.salariu, g.grad
FROM angajati a, grila_salariu g
WHERE
    a.salariu BETWEEN g.nivel_inf AND g.nivel_sup
AND a.id_dep = 20;

-- metoda 2 versiunea 1
SELECT a.nume, a.salariu, g.grad
FROM angajati a
    INNER JOIN grila_salariu g
        ON a.salariu BETWEEN g.nivel_inf AND g.nivel_sup
WHERE a.id_dep = 20;

-- Ex 5

-- metoda 1
SELECT a.nume, a.salariu, g.grad, d.den_dep
FROM angajati a, grila_salariu g, departamente d
WHERE
    a.salariu BETWEEN g.nivel_inf AND g.nivel_sup
    AND d.id_dep = a.id_dep
AND a.id_dep = 20
ORDER BY 3, 1;

-- metoda 2 versiunea 1
SELECT a.nume, a.salariu, g.grad, d.den_dep
FROM angajati a
    INNER JOIN grila_salariu g
        ON a.salariu BETWEEN g.nivel_inf AND g.nivel_sup
    INNER JOIN departamente d
        ON d.id_dep = a.id_dep
WHERE a.id_dep = 20
ORDER BY 3, 1;

-- metoda 2 versiunea 2
SELECT a.nume, a.salariu, g.grad, d.den_dep
FROM angajati a
    JOIN departamente d
        ON d.id_dep = a.id_dep
    JOIN grila_salariu g
        ON a.salariu >= g.nivel_inf AND a.salariu <= g.nivel_sup
WHERE a.id_dep = 20
ORDER BY 3, 1;

-- Ex 6

-- metoda 1
SELECT
    a1.nume "Nume Angajat",
    a1.functie "Functie Angajat",
    a2.nume "Nume Sef",
    a2.functie "Functie Sef"
FROM
    angajati a1,
    angajati a2
WHERE
    a1.id_sef = a2.id_ang
    AND a1.id_dep = 10;

-- metoda 2
SELECT
    a1.nume "Nume Angajat",
    a1.functie "Functie Angajat",
    a2.nume "Nume Sef",
    a2.functie "Functie Sef"
FROM
    angajati a1
        INNER JOIN angajati a2
        ON a1.id_sef = a2.id_ang
WHERE
    a1.id_dep = 10;

-- Ex 7

-- metoda 1
SELECT d.id_dep, d.den_dep, a.nume, a.functie
FROM departamente d, angajati a
WHERE d.id_dep = a.id_dep(+)
ORDER BY a.id_dep;

-- metoda 2
SELECT d.id_dep, d.den_dep, a.nume, a.functie
FROM departamente d
    LEFT OUTER JOIN angajati a
        ON d.id_dep = a.id_dep
ORDER BY a.id_dep;

-- Ex 9

SELECT a.nume, a.salariu, g.grad
FROM grila_salariu g
    FULL OUTER JOIN angajati a
        ON a.salariu*2 BETWEEN g.nivel_inf AND g.nivel_sup
ORDER BY a.nume;

-- Ex 10

-- metoda 1
SELECT d.den_dep, a.nume, a.salariu, g.grad
FROM grila_salariu g
    FULL OUTER JOIN angajati a
        RIGHT OUTER JOIN departamente d
            ON d.id_dep = a.id_dep
        ON a.salariu*2 BETWEEN g.nivel_inf AND g.nivel_sup
ORDER BY d.den_dep, a.nume, g.grad;

-- metoda 2
SELECT d.den_dep, a.nume, a.salariu, g.grad
FROM angajati a
    FULL OUTER JOIN grila_salariu g
        ON a.salariu*2 BETWEEN g.nivel_inf AND g.nivel_sup
    FULL OUTER JOIN departamente d
            ON d.id_dep = a.id_dep
ORDER BY d.den_dep, a.nume, g.grad;

-- Ex 11
SELECT id_dep, nume, functie, salariu
FROM angajati
WHERE id_dep = 10
UNION
SELECT id_dep, nume, functie, salariu
FROM angajati
WHERE id_dep = 30;

-- Ex 12
SELECT id_dep, nume, 'are salariul' are, salariu sal_com
FROM angajati
WHERE id_dep = 10
UNION
SELECT id_dep, nume, 'are comisionul' are, comision sal_com
FROM angajati
WHERE id_dep = 30;

-- Ex 13
SELECT functie FROM angajati WHERE id_dep = 10
UNION ALL
SELECT functie FROM angajati WHERE id_dep = 20;

-- Ex 14
SELECT functie, nvl(comision, 0) comision
    FROM angajati WHERE id_dep = 10
INTERSECT
SELECT functie, nvl(comision, 0)
    FROM angajati WHERE id_dep = 20
INTERSECT
SELECT functie, nvl(comision, 0)
    FROM angajati WHERE id_dep = 30;

-- EX 15
SELECT functie
    FROM angajati
    WHERE id_dep = 10
MINUS
SELECT functie
    FROM angajati
    WHERE id_dep = 30;

-- Ex individual
SELECT a.nume, d.id_dep, g.grad, sef.nume "Nume sef", sef.id_dep "Id dep sef", g_sef.grad "Grad sef"
FROM angajati a
    FULL OUTER JOIN grila_salariu g
        ON a.salariu BETWEEN g.nivel_inf AND g.nivel_sup
    FULL OUTER JOIN departamente d
        ON d.id_dep = a.id_dep
    FULL OUTER JOIN angajati sef
        ON a.id_sef = sef.id_ang
    FULL OUTER JOIN grila_salariu g_sef
        ON sef.salariu BETWEEN g_sef.nivel_inf AND g_sef.nivel_sup
ORDER BY d.den_dep, a.nume, g.grad;