--
-- For explanation and annotation of this code
-- see http://www.varlena.com/GeneralBits/26
--
create schema GeneralBits;
set search_path to GeneralBits;

CREATE TABLE department(
    id integer PRIMARY KEY,
    name text);

CREATE TABLE employee(
    id integer primary key,
    name text,
    salary integer,
    departmentid integer REFERENCES department);

INSERT INTO department VALUES (1, 'Management');
INSERT INTO department VALUES (2, 'IT');

INSERT INTO employee VALUES (1, 'John Smith', 30000, 1);
INSERT INTO employee VALUES (2, 'Jane Doe', 50000, 1);
insert INTO employee VALUES (3, 'Fairlie Reese', 63000, 1);
insert INTO employee VALUES (4, 'Jack Jackson', 60000, 2);
insert INTO employee values (5, 'Harold Bibsom', 40000, 2);
insert INTO employee VALUES (6, 'Julio Garcia', 70000, 2);
insert INTO employee VALUES (7, 'Bernice Johnson', 55000, 2);
insert INTO employee values (8, 'Lily Leong', 67000, 2);
insert INTO employee VALUES (9, 'Abby Wood', 57000, 2);
insert INTO employee VALUES (10, 'Jeff Jeffries', 52000, 2);
insert INTO employee VALUES (11, 'Geordie O''Hare', 42000, 2);

CREATE or REPLACE FUNCTION getemployee () RETURNS SETOF text AS '
DECLARE
    myrow RECORD;
    retval text;
BEGIN
    FOR myrow IN SELECT * FROM employee LOOP
        RETURN NEXT myrow.name;
    END LOOP;
    RETURN;
END;
' LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION getemployeedid (integer)
RETURNS SETOF integer AS '
DECLARE
    myrow RECORD;
    retval integer;
BEGIN
    FOR myrow IN SELECT * FROM employee WHERE salary >= $1 LOOP
        RETURN NEXT myrow.departmentid;
    END LOOP;
    RETURN;
END;
' LANGUAGE 'plpgsql';

CREATE TYPE deptavgs AS ( minsal integer, maxsal integer, avgsalary int8);

CREATE OR REPLACE FUNCTION avgdept() RETURNS deptavgs AS
'
DECLARE
    r deptavgs%ROWTYPE;
    dept RECORD;
    bucket int8;
    counter integer;
BEGIN
    bucket   := 0;
    counter  := 0;
    r.maxsal := 0;
    r.minsal := 0;
    FOR dept IN SELECT sum(salary) AS salary, d.id AS department
                    FROM employee e, department d WHERE e.departmentid = d.id
                    GROUP BY department LOOP
        counter := counter + 1;
        bucket  := bucket + dept.salary;
        IF r.maxsal <= dept.salary OR r.maxsal = 0 THEN
            r.maxsal := dept.salary;
        END IF;
        IF r.minsal >= dept.salary OR r.minsal = 0 THEN
            r.minsal := dept.salary;
        END IF;
    END LOOP;

    r.avgsalary := bucket/counter;

    RETURN r;
END
' language 'plpgsql';

CREATE TYPE salavgs AS
    (deptid integer, minsal integer, maxsal integer, avgsalary int8);
CREATE OR REPLACE FUNCTION avgsal() RETURNS SETOF salavgs AS
'
DECLARE
    s salavgs%ROWTYPE;
    salrec RECORD;
    bucket int8;
    counter int;
BEGIN
    bucket   :=0;
    counter  :=0;
    s.maxsal :=0;
    s.minsal :=0;
    s.deptid :=0;
    FOR salrec IN SELECT salary AS salary, d.id AS department
        FROM employee e, department d WHERE e.departmentid = d.id
        ORDER BY d.id LOOP
        IF s.deptid = 0 THEN
            s.deptid := salrec.department;
            s.minsal := salrec.salary;
            s.maxsal := salrec.salary;
            counter  := counter + 1;
            bucket   := bucket + salrec.salary;
        ELSE
            IF s.deptid = salrec.department THEN
                IF s.maxsal <= salrec.salary THEN
                    s.maxsal := salrec.salary;
                END IF;
                IF s.minsal >= salrec.salary THEN
                    s.minsal := salrec.salary;
                END IF;
                counter := counter + 1;
                bucket  := bucket + salrec.salary;
            ELSE
                s.avgsalary := bucket/counter;
                RETURN NEXT s;

                s.deptid := salrec.department;
                s.minsal := salrec.salary;
                s.maxsal := salrec.salary;
                counter  := 1;
                bucket   := salrec.salary;
            END IF;
        END IF;
    END LOOP;
    s.avgsalary := bucket/counter;
    RETURN NEXT s;
    RETURN;
END '
LANGUAGE 'plpgsql' ;


-- =============================
-- Select statements
-- =============================
--
-- All data
--
select e.id as "Emp Id", e.name as "Emp Name", e.salary as "Salary",
        d.id as "Dept Id", d.name as "Dept Name"
from employee e , department d
where e.departmentid = d.id;

--
-- All employee department numbers
--
select * from getemployeedid(0);

--
-- Each row represents on person in the department making over 50000.
-- Equivalent to
--  select d.id, d.name from employees e, department d
--  where e.departmentid = d.id;
--
select id, name from getemployeedid(50000) e, department d where e = id;

--
-- How many employees make over 50000 in each department
--
select count(*), g from getemployeedid(50000) g group by g;

--
-- Department salary averages
--
select * from avgsal();
--
-- Deparment salary averages with Deparment info
--
select d.name, a.minsal, a.maxsal, a.avgsalary
from avgsal() a, department d
where d.id = a.deptid;
