-- PART 1 - Data Engineering

CREATE TABLE departments (
    dept_no VARCHAR   NOT NULL,
    dept_name VARCHAR   NOT NULL,
    PRIMARY KEY (dept_no)
);


CREATE TABLE titles (
    title_id VARCHAR   NOT NULL,
    title VARCHAR   NOT NULL,
    PRIMARY KEY (title_id)
);


CREATE TABLE employees (
    emp_no INT   NOT NULL,
    emp_title_id VARCHAR NOT NULL,
    birth_date DATE   NOT NULL,
    first_name VARCHAR   NOT NULL,
    last_name VARCHAR   NOT NULL,
    sex VARCHAR   NOT NULL,
    hire_date DATE   NOT NULL,
    FOREIGN KEY (emp_title_id) REFERENCES titles (title_id),
    PRIMARY KEY (emp_no)
);

ALTER DATABASE employee_db SET datestyle TO "ISO, MDY";

-- DROP TABLE employees CASCADE;
-- ALTER TABLE employees ALTER COLUMN hire_date TYPE timestamp USING hire_date::date;


-- junction table
CREATE TABLE dept_emp (
    emp_no INT   NOT NULL,
    dept_no VARCHAR   NOT NULL,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
    FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY (emp_no, dept_no)
);


CREATE TABLE dept_manager (
    dept_no VARCHAR  NOT NULL,
    emp_no INT  NOT NULL,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
    FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY (emp_no, dept_no)
);


CREATE TABLE salaries (
    emp_no INT   NOT NULL,
    salary INT   NOT NULL,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_no)
);

---------------------------------------------------------------------------------------

-- PART 2 (DATA_ANALYSIS)

-- 1. List the employee number, last name, first name, sex, and salary of each employee.
select e.emp_no, e.last_name, e.first_name, e.sex, s.salary
from employees as e
left join salaries as s
on e.emp_no = s.emp_no
order by e.emp_no;

-- 2. List the first name, last name and hire date for the employees who were hired in 1986.
select e.last_name, e.first_name, e.hire_date
from employees as e
WHERE hire_date >= '1986-01-01' AND hire_date <= '1986-12-31'
order by e.hire_date, e.last_name;

--WHERE hire_date BETWEEN '1986-01-01' AND '1986-12-31';
--WHERE EXTRACT(YEAR FROM hire_date) = '1986';
--WHERE hire_date >= to_date('1986', 'YYYY') AND hire_date < to_date('1987', 'YYYY');


-- 3. List the manager of each department along with their department number,
-- department name, employee number, last name and first name.
select d.dept_no, d.dept_name, e.emp_no, e.last_name, e.first_name
from dept_manager as dm 
inner join departments as d on dm.dept_no = d.dept_no
inner join employees as e on e.emp_no = dm.emp_no;


-- 4. List the department number for each employee along with that employee's
-- employee number, last name, first name and department name.
select  e.emp_no, e.last_name, e.first_name, d.dept_name, d.dept_no
from dept_emp as de
inner join departments as d on de.dept_no = d.dept_no
inner join employees as e on e.emp_no = de.emp_no
order by de.emp_no, d.dept_no;


-- 5. List first name, last name, and sex of each employee whose first name is 
-- Hercules and whose last name begins with letter B.
select e.first_name, e.last_name, e.sex
from employees as e
where e.first_name = 'Hercules' and e.last_name like 'B%';


-- 6. List each employee in the sales department, including their employee number,
-- last name, and first name.
select  e.emp_no, e.last_name, e.first_name, d.dept_name
from departments as d
inner join dept_emp as de on d.dept_no = de.dept_no
inner join employees as e on de.emp_no = e.emp_no
where d.dept_name = 'Sales';


-- 7. List each employee in the Sales and Development departments, including their 
-- employee number, last name, first name, and department name.
select  e.emp_no, e.last_name, e.first_name, d.dept_name
from departments as d
inner join dept_emp as de on d.dept_no = de.dept_no
inner join employees as e on de.emp_no = e.emp_no
where d.dept_name in ('Sales', 'Development') ;


-- 8. List the frequency counts, in descending order, of all the employee last names 
-- (that is, how many employees share each last name).
select e.last_name, count(*) as freq_counts
from employees as e
group by e.last_name
order by freq_counts DESC;






