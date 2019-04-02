-- !preview conn=DBI::dbConnect(RSQLite::SQLite(), "ex_2019_03_28_sqlite/employees.sqlite")

-- SELECT dept, AVG(salary) FROM employees GROUP BY dept;

SELECT name, email dept, salary - avg_sal AS avg_diff FROM employees NATURAL JOIN (SELECT dept, AVG(salary) AS avg_sal FROM employees GROUP BY dept);