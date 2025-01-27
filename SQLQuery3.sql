-- 1. Display the Department id, name, and the name of its manager.
SELECT 
    Departments.Dnum AS Department_Id, 
    Departments.Dname AS Department_Name, 
    CONCAT(Employee.Fname, ' ', Employee.Lname) AS Manager_Name
FROM 
    Departments
JOIN 
    Employee
ON 
    Departments.MGRSSN = Employee.SSN;

-- 2. Display the full data about all the dependents associated with the name of the employee they depend on.
SELECT 
    Dependent.*, 
    CONCAT(Employee.Fname, ' ', Employee.Lname) AS Employee_Name
FROM 
    Dependent
JOIN 
    Employee
ON 
    Dependent.ESSN = Employee.SSN;

-- 3. Display the full data of the projects with a name starting with the "A" letter.
SELECT *
FROM Project
WHERE Pname LIKE 'A%';

-- 4. Display all the employees in department 30 whose salary is between 1000 and 2000 LE monthly.
SELECT *
FROM Employee
WHERE Dno = 30 AND Salary BETWEEN 1000 AND 2000;

-- 5. Retrieve the names of all employees in department 10 who work more than or equal to 10 hours per week on the "AL Rabwah" project.
SELECT 
    CONCAT(Employee.Fname, ' ', Employee.Lname) AS Employee_Name
FROM 
    Employee
JOIN 
    Works_for
ON 
    Employee.SSN = Works_for.ESSN
JOIN 
    Project
ON 
    Works_for.Pno = Project.Pnumber
WHERE 
    Employee.Dno = 10 
    AND Project.Pname = 'AL Rabwah'
    AND Works_for.Hours >= 10;

-- 6. For each project located in Ramallah, find the project number, the controlling department name, the department manager's last name, address, and birthdate.
SELECT 
    Project.Pnumber AS Project_Number, 
    Departments.Dname AS Department_Name, 
    Employee.Lname AS Manager_Last_Name, 
    Employee.Address AS Manager_Address, 
    Employee.Bdate AS Manager_Birthdate
FROM 
    Project
JOIN 
    Departments
ON 
    Project.Dnum = Departments.Dnum
JOIN 
    Employee
ON 
    Departments.MGRSSN = Employee.SSN
WHERE 
    Project.Plocation = 'Ramallah';

-- 7. Display all data of the managers.
SELECT *
FROM Employee
WHERE SSN IN (SELECT MGRSSN FROM Departments);

-- 8. Display the Id, name, and location of the projects in Ramallah or Nablus city.
SELECT 
    Pnumber AS Project_Id, 
    Pname AS Project_Name, 
    Plocation AS Location1
FROM 
    Project
WHERE 
    Plocation IN ('Ramallah', 'Nablus');

-- 9. For each project, list the project name and the total hours per week (for all employees) spent on that project.
SELECT 
    Project.Pname AS Project_Name, 
    SUM(Works_for.Hours) AS Total_Hours
FROM 
    Project
JOIN 
    Works_for
ON 
    Project.Pnumber = Works_for.Pno
GROUP BY 
    Project.Pname;

-- 10. For each department, retrieve the department name and the maximum, minimum, and average salary of its employees.
SELECT 
    Departments.Dname AS Department_Name, 
    MAX(Employee.Salary) AS Max_Salary, 
    MIN(Employee.Salary) AS Min_Salary, 
    AVG(Employee.Salary) AS Avg_Salary
FROM 
    Departments
JOIN 
    Employee
ON 
    Departments.Dnum = Employee.Dno
GROUP BY 
    Departments.Dname;

-- 11. For each department-- if its average salary is less than the average salary of all employees-- display its number, name, and number of its employees.
WITH DepartmentAvg AS (
    SELECT 
        Dno, 
        AVG(Salary) AS Avg_Dept_Salary, 
        COUNT(SSN) AS Employee_Count
    FROM 
        Employee
    GROUP BY 
        Dno
),
AllEmployeesAvg AS (
    SELECT 
        AVG(Salary) AS Avg_All_Salary
    FROM 
        Employee
)
SELECT 
    Departments.Dnum AS Department_Id, 
    Departments.Dname AS Department_Name, 
    DepartmentAvg.Employee_Count
FROM 
    Departments
JOIN 
    DepartmentAvg
ON 
    Departments.Dnum = DepartmentAvg.Dno
CROSS JOIN 
    AllEmployeesAvg
WHERE 
    DepartmentAvg.Avg_Dept_Salary < AllEmployeesAvg.Avg_All_Salary;

SELECT 
    Departments.Dnum AS Department_Id, 
    Departments.Dname AS Department_Name, 
    COUNT(Employee.SSN) AS Employee_Count
FROM 
    Departments
JOIN 
    Employee
ON 
    Departments.Dnum = Employee.Dno
GROUP BY 
    Departments.Dnum, 
    Departments.Dname
HAVING 
    AVG(Employee.Salary) < (SELECT AVG(Salary) FROM Employee);
