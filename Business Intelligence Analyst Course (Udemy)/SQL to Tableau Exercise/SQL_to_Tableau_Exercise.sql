USE employees_mod;
SELECT 
    YEAR(de.from_date) AS calendar_year,
    e.gender,
    COUNT(e.emp_no) AS no_of_emp
FROM
    t_employees e
        JOIN
    t_dept_emp de ON e.emp_no = de.emp_no
WHERE
    YEAR(de.from_date) >= 1990
GROUP BY calendar_year , gender
ORDER BY calendar_year ASC;

    SELECT 
        YEAR(e.hire_date) AS calendar_year
    FROM
        t_employees e
    GROUP BY calendar_year;

SELECT 
    d.dept_name,
    ee.gender,
    dm.emp_no,
    dm.from_date,
    dm.to_date,
    e.calendar_year,
    CASE
        WHEN
            YEAR(dm.from_date) <= e.calendar_year
                AND YEAR(dm.to_date) >= e.calendar_year
        THEN
            '1'
        ELSE 0
    END AS active
FROM
    (SELECT 
        YEAR(hire_date) AS calendar_year
    FROM
        t_employees 
    GROUP BY calendar_year) e
    CROSS JOIN 
    t_dept_manager dm 
    JOIN 
    t_departments d ON dm.dept_no = d.dept_no
    JOIN
    t_employees ee ON ee.emp_no = dm.emp_no
    ORDER BY dm.emp_no, calendar_year;
    

SELECT 
    d.dept_name, e.gender, YEAR(s.from_date) AS calendar_year , ROUND(AVG(s.salary),2) AS salary
FROM
    t_employees e 
    JOIN
    t_dept_emp de ON de.emp_no = e.emp_no
    JOIN
    t_departments d ON de.dept_no = d.dept_no
    JOIN
    t_salaries s ON s.emp_no = e.emp_no
    GROUP BY 
    calendar_year, e.gender, d.dept_name
    HAVING calendar_year <= 2002
    ORDER BY d.dept_name, calendar_year;
    
    
 USE employees_mod;  
 DROP PROCEDURE IF EXISTS salary_average;
CALL employees_mod.salary_average(50000,90000);

DELIMITER $$
CREATE PROCEDURE salary_average(IN min_sal FLOAT, IN max_sal FLOAT)
BEGIN
SELECT 
    d.dept_name, e.gender, ROUND(AVG(s.salary),2) AS salary
FROM
    t_employees e 
    JOIN
    t_dept_emp de ON de.emp_no = e.emp_no
    JOIN
    t_departments d ON de.dept_no = d.dept_no
    JOIN
    t_salaries s ON s.emp_no = e.emp_no
    WHERE salary BETWEEN min_sal AND max_sal
    GROUP BY 
   e.gender, d.dept_no
    
    ORDER BY salary;
    END $$
    DELIMITER ;
    
