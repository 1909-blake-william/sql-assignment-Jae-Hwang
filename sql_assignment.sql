-- 1.0 Setting up Oracle Chinook
-- In this section you will begin the process of working with the Oracle Chinook database
-- Task – Open the Chinook_Oracle.sql file and execute the scripts within.
-- 2.0 SQL Queries
-- In this section you will be performing various queries against the Oracle Chinook database.
-- 2.1 SELECT
-- Task – Select all records from the Employee table.
SELECT * FROM employee;
-- Task – Select all records from the Employee table where last name is King.
SELECT * FROM employee WHERE lastname = 'King';
-- Task – Select all records from the Employee table where first name is Andrew and REPORTSTO is NULL.
SELECT * FROM employee WHERE firstname = 'Andrew' AND REPORTSTO IS NULL;
-- 2.2 ORDER BY
-- Task – Select all albums in Album table and sort result set in descending order by title.
SELECT * FROM album ORDER BY title;
-- Task – Select first name from Customer and sort result set in ascending order by city
SELECT firstname FROM Customer ORDER BY city;
-- 2.3 INSERT INTO
-- Task – Insert two new records into Genre table
INSERT INTO Genre (GenreId, Name) VALUES (26, 'Oppra');
INSERT INTO Genre (GenreId, Name) VALUES (27, 'Opeeera');
-- Task – Insert two new records into Employee table
INSERT INTO Employee (EmployeeId, LastName, FirstName, Title, ReportsTo, BirthDate, HireDate, Address, City, State, Country, PostalCode, Phone, Fax, Email) 
    VALUES (9, 'Hwang', 'Jae', 'IT Staff', 8, TO_DATE('1995-3-18 00:00:00','yyyy-mm-dd hh24:mi:ss'), TO_DATE('2004-5-4 00:00:00','yyyy-mm-dd hh24:mi:ss'), '12000 Some St', 'City', 'VA', 'USA', '11032', '+1 (122) 123-5223', '+1 (403) 467-8772', 'jaeh@chinookcorp.com');
INSERT INTO Employee (EmployeeId, LastName, FirstName, Title, ReportsTo, BirthDate, HireDate, Address, City, State, Country, PostalCode, Phone, Fax, Email) 
    VALUES (10, 'David', 'Qua', 'IT Staff', 9, TO_DATE('1900-1-1 00:00:00','yyyy-mm-dd hh24:mi:ss'), TO_DATE('2004-10-4 00:00:00','yyyy-mm-dd hh24:mi:ss'), '12010 That St', 'City', 'VA', 'USA', '11032', '+1 (112) 112-3351', '+1 (403) 467-8772', 'davidq@chinookcorp.com');
-- Task – Insert two new records into Customer table
INSERT INTO Customer (CustomerId, FirstName, LastName, Address, City, Country, PostalCode, Phone, Email, SupportRepId) 
    VALUES (60, 'Hee', 'Haa', '3,Some Road', 'Bangalore', 'India', '560011', '+91 080 22289919', 'heehaa@yahoo.in', 3);
INSERT INTO Customer (CustomerId, FirstName, LastName, Address, City, Country, PostalCode, Phone, Email, SupportRepId) 
    VALUES (61, 'Gru', 'Bav', '31,That Road', 'Bangalore', 'India', '160011', '+91 080 22281919', 'grubav@yahoo.in', 3);
-- 2.4 UPDATE
-- Task – Update Aaron Mitchell in Customer table to Robert Walter
UPDATE Customer 
    SET FirstName = 'Robert', LastName = 'Walter' 
    WHERE FirstName = 'Aaron', LastName = 'Mitchell';
-- Task – Update name of artist in the Artist table “Creedence Clearwater Revival” to “CCR”
UPDATE Artist
    SET name = 'CCR'
    WHERE = 'Creedence Clearwater Revival';
-- 2.5 LIKE
-- Task – Select all invoices with a billing address like “T%”
SELECT * FROM invoice
    WHERE BillingAddress LIKE('T%');
-- 2.6 BETWEEN
-- Task – Select all invoices that have a total between 15 and 50
SELECT * FROM invoice
    WHERE total BETWEEN 15 AND 50;
-- Task – Select all employees hired between 1st of June 2003 and 1st of March 2004
SELECT * FROM employee
    WHERE hireDate 
    BETWEEN TO_DATE('2003-6-1 00:00:00','yyyy-mm-dd hh24:mi:ss') AND TO_DATE('2004-3-1 00:00:00','yyyy-mm-dd hh24:mi:ss')
-- 2.7 DELETE
-- Task – Delete a record in Customer table where the name is Robert Walter (There may be constraints that rely on this, find out how to resolve them).
ALTER TABLE Invoice DROP CONSTRAINT FK_InvoiceCustomerId;

ALTER TABLE Invoice ADD CONSTRAINT FK_InvoiceCustomerId
    FOREIGN KEY (CustomerId) REFERENCES Customer (CustomerId) ON DELETE CASCADE;

ALTER TABLE InvoiceLine DROP CONSTRAINT FK_InvoiceLineInvoiceId;

ALTER TABLE InvoiceLine ADD CONSTRAINT FK_InvoiceLineInvoiceId
    FOREIGN KEY (InvoiceId) REFERENCES Invoice (InvoiceId) ON DELETE CASCADE;

DELETE FROM customer
    WHERE  firstname = 'Robert' AND lastname = 'Walter';
-- 3.0 SQL Functions
-- In this section you will be using the Oracle system functions, as well as your own functions, to perform various actions against the database
-- 3.1 System Defined Functions
-- Task – Create a function that returns the current time.
CREATE OR REPLACE FUNCTION get_current_time
    RETURN VARCHAR2
IS
    cur_time VARCHAR2(20);
BEGIN
    SELECT to_char(sysdate,'HH24:MI:SS') "NOW" INTO cur_time FROM dual;
    RETURN cur_time;
END;
-- Task – create a function that returns the length of a mediatype from the mediatype table
CREATE OR REPLACE FUNCTION get_length_mediatype
(
    input_id NUMBER
)
    RETURN NUMBER
IS
    return_num NUMBER;
BEGIN
    SELECT LENGTH((SELECT name FROM mediatype WHERE mediatypeid = input_id)) INTO return_num FROM dual;
    RETURN return_num;
END;
/
-- 3.2 System Defined Aggregate Functions
-- Task – Create a function that returns the average total of all invoices
CREATE OR REPLACE FUNCTION average_total
    RETURN NUMBER
IS
    return_num NUMBER;
BEGIN
    SELECT (SELECT AVG(total) FROM invoice) INTO return_num FROM dual;
    RETURN return_num;
END;
-- Task – Create a function that returns the most expensive track
CREATE OR REPLACE FUNCTION most_expensive
    RETURN SYS_REFCURSOR
IS
    return_cursor SYS_REFCURSOR;
BEGIN
    OPEN return_cursor FOR SELECT * FROM track WHERE unitprice = (SELECT MAX(unitprice) FROM track);
    RETURN return_cursor;
END; 
-- 3.3 User Defined Scalar Functions
-- Task – Create a function that returns the average price of invoiceline items in the invoiceline table
CREATE OR REPLACE FUNCTION average_invoiceline
    RETURN NUMBER
IS
    return_num NUMBER;
BEGIN
    SELECT (SELECT AVG(unitprice) FROM invoiceline) INTO return_num FROM dual;
    RETURN return_num;
END;
-- 3.4 User Defined Table Valued Functions
-- Task – Create a function that returns all employees who are born after 1968.
CREATE OR REPLACE FUNCTION born_after_sixeight
    RETURN SYS_REFCURSOR
IS
    return_cursor SYS_REFCURSOR;
BEGIN
    OPEN return_cursor FOR SELECT * FROM employee WHERE BirthDate > TO_DATE('1968-01-01', 'yyyy-mm-dd');
END;
-- 4.0 Stored Procedures
--  In this section you will be creating and executing stored procedures. You will be creating various types of stored procedures that take input and output parameters.
-- 4.1 Basic Stored Procedure
-- Task – Create a stored procedure that selects the first and last names of all the employees.
CREATE OR REPLACE PROCEDURE names_of_all_employees 
(
    return_cursor OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN return_cursor FOR SELECT firstname, lastname FROM employee;
END;
/
-- 4.2 Stored Procedure Input Parameters
-- Task – Create a stored procedure that updates the personal information of an employee.
CREATE OR REPLACE PROCEDURE update_personal_info
(

)
IS
BEGIN
    
END;
/
-- Task – Create a stored procedure that returns the managers of an employee.
CREATE OR REPLACE PROCEDURE managers_of_employee
(
    input_id IN NUMBER,
    return_cursor OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN return_cursor FOR SELECT * FROM employee
        WHERE employeeId = (SELECT reportsto FROM employee WHERE employeeid = input_id);
END;
/

-- 4.3 Stored Procedure Output Parameters
-- Task – Create a stored procedure that returns the name and company of a customer.
CREATE OR REPLACE PROCEDURE name_company_customer
(
    input_id IN NUMBER,
    return_cursor OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN return_cursor FOR SELECT firstname, lastname, company FROM customer
        WHERE customerid = input_id;
END;
/
-- 6.0 Triggers
-- In this section you will create various kinds of triggers that work when certain DML statements are executed on a table.
-- 6.1 AFTER/FOR
-- Task - Create an after insert trigger on the employee table fired after a new record is inserted into the table.
CREATE OR REPLACE TRIGGER employee_insert_trigger
AFTER INSERT ON employee
FOR EACH ROW
BEGIN
    IF INSERTING THEN
                
    END IF;
END;
/
-- Task – Create an after update trigger on the album table that fires after a row is update in the table
CREATE OR REPLACE TRIGGER album_update_trigger
AFTER UPDATE ON album
FOR EACH ROW
BEGIN
    IF UPDATING THEN

    END IF;
END;
/
-- Task – Create an after delete trigger on the customer table that fires after a row is deleted from the table.
CREATE OR REPLACE TRIGGER customer_delete_trigger
AFTER UPDATE ON customer
FOR EACH ROW
BEGIN
    IF DELETING THEN

    END IF;
END;
/
-- Task – Create a trigger that restricts the deletion of any invoice that is priced over 50 dollars.
CREATE OR REPLACE TRIGGER invoice_delete_trigger
AFTER UPDATE ON invoice
FOR EACH ROW
BEGIN
    IF UPDATING THEN

    END IF;
END;
/
-- 7.0 JOINS
-- In this section you will be working with combing various tables through the use of joins. You will work with outer, inner, right, left, cross, and self joins.
-- 7.1 INNER
-- Task – Create an inner join that joins customers and orders and specifies the name of the customer and the invoiceId.
SELECT firstname, lastname, invoiceid FROM customer
    INNER JOIN invoice USING (customerid);
-- 7.2 OUTER
-- Task – Create an outer join that joins the customer and invoice table, specifying the CustomerId, firstname, lastname, invoiceId, and total.
SELECT CustomerId, firstname, lastname, invoiceId, total FROM customer
    OUTER JOIN invoice USING (customerid);
-- 7.3 RIGHT
-- Task – Create a right join that joins album and artist specifying artist name and title.
SELECT name, title FROM album
    RIGHT JOIN artist USING (artistid);
-- 7.4 CROSS
-- Task – Create a cross join that joins album and artist and sorts by artist name in ascending order.
SELECT * FROM album, artist ORDER BY name ASC;
-- 7.5 SELF
-- Task – Perform a self-join on the employee table, joining on the reportsto column.
SELECT * FROM employee e
    JOIN employee r on e.reportsto = r.employeeid; 