/*
*	Paola Jiron
*	Project 1
*   09/29/2015
*/

/*
	Task 1: Query 1

      Create a Readers, Books, Copies, and LoanList table with proper constraints
      and make sure both primary keys and foreign keys are specified.
      Note:
     (1) If the constrains might be modified in the future, then you should set
        it as table constraints while creating the tables
     (2) You will need to set up the foreign keys by using column constraints if
         the referred column is not a primary key.
*/
CREATE TABLE Readers(
	reader_id integer PRIMARY KEY,
	reader_f text NOT NULL,
	reader_l text NOT NULL,
	date_of_birth date,
	address text,
	phone text	
	);

CREATE TABLE Books(
	book_id integer PRIMARY KEY,
	isbn text UNIQUE,
	title text UNIQUE,
	authors text NOT NULL,
	price numeric CONSTRAINT pricelimit CHECK (price > 0 AND price < 10)
	);

CREATE TABLE Copies(
	isbn text NOT NULL,
	copy_id integer NOT NULL,
	title text NOT NULL,
	PRIMARY KEY(isbn, copy_id),
	FOREIGN KEY(isbn)
	REFERENCES Books(isbn),
	FOREIGN KEY(title)
	REFERENCES Books(title)
	);

CREATE TABLE LoanList(
	isbn text NOT NULL,
	reader_id integer NOT NULL,
	copy_id integer NOT NULL,
	out_date date,
	due_date date,
	in_date date,
	PRIMARY KEY(isbn, copy_id),
	FOREIGN KEY(isbn)
	REFERENCES Books(isbn),	
	FOREIGN KEY(reader_id)
	REFERENCES Readers(reader_id),
	FOREIGN KEY (isbn, copy_id)
	REFERENCES Copies(isbn, copy_id)
	);
/*
	Task 1: Query 2
        Insert the data for each table.
*/
INSERT INTO Readers VALUES
(1, 'Jennifer', 'Stuart', '06/15/1977', '101 S.W. 8 ST.', '305-215-5011'),
(2, 'Alex', 'Weiss', '04/24/1980', '1443 N.W. 7 ST.', '786-289-0000'),
(3, 'David', 'So', '11/08/1990', '3500 W. Flagler ST.', '305-511-1234'),
(4, 'Jack', 'Thomas', '12/05/1987','5637 N.W. 41 ST.', '786-333-4578'),
(5, 'Alexandra', 'Wallace', '08/22/1983','778 S.W. 87 AVE.', '305-451-1459');

INSERT INTO Books VALUES
(1, '0375842209', 'The Book Thief', 'Markus Zusak', 7.73),
(2, '0064407314', 'Monster', 'Walter Dean Myers', 9.00),
(3, '159514188X', 'Thirteen Reasons Why', 'Jay Asher', 8.45),
(4, '014241543X', 'If I Stay', 'Gayle Forman', 8.99),
(5, '0316041459', 'Hate List', 'Jennifer Brown', 8.99);

INSERT INTO Copies VALUES
('0375842209', 1, 'The Book Thief'),
('0375842209', 2, 'The Book Thief'),
('159514188X', 1, 'Thirteen Reasons Why'),
('159514188X', 2, 'Thirteen Reasons Why'),
('159514188X', 3, 'Thirteen Reasons Why'),
('014241543X', 1, 'If I Stay');

INSERT INTO LoanList VALUES
('0375842209', 3, 1, '07/20/2011', '09/04/2011', '08/21/2011'),
('159514188X', 3, 1, '08/20/2011', '10/04/2011', NULL),
('0375842209', 1, 2, '08/14/2011', '09/28/2011', '09/20/2011'),
('014241543X', 5, 1, '08/17/2011', '10/02/2011', NULL),
('159514188X', 1, 3, '09/05/2011', '10/17/2011', NULL);

/*
	Task 2: Query 1
        Insert two more records to table LoanList by using one query.

        NOTE: Provide the correct insert syntax and specify why the error 
              message occurs and how to solve this problem by modifying the
              inserted info.

[WARNING  ] INSERT INTO LoanList (isbn, reader_id, copy_id, out_date, due_date,
             in_date) VALUES
            ('159514188X', 4, 2, '09/01/2011', '09/28/2011', '09/05/2011'),
            ('0375842209', 2, 1, '09/07/2011', '10/19/2011', NULL)
            ERROR:  duplicate key value violates unique constraint "loanlist_pkey"
            
            The error occurs because the copy_id for the insertion of isbn 
            '0375842209' is 1 when that copy is still on the LoanList Table. So for the
            insertion to work without producing an error, the insertion of that particular
            book must happen after the deletion of all the books that have previously 
            been turned in before it is checked out again.
*/

INSERT INTO LoanList VALUES
('159514188X', 4, 2, '09/01/2011', '09/28/2011', '09/05/2011');

/*
	Task 2: Query 2
        Delete the records from the table LoanList where in_date is not Null.
*/
DELETE FROM LoanList WHERE in_date IS NOT NULL;

-- now we can insert book_id '0375842209'

INSERT INTO LoanList VALUES
('0375842209', 2, 1, '09/07/2011', '10/19/2011', NULL);

/* 
	Task 2: Query 3
        Add one column called “num_copies” to the Books table and one column
        called “sex” to the Readers table.
*/
ALTER TABLE Books ADD COLUMN num_copies integer;
ALTER TABLE Readers ADD COLUMN sex text;

UPDATE Books SET num_copies = 2 WHERE book_id = 1;
UPDATE Books SET num_copies = 4 WHERE book_id = 2;
UPDATE Books SET num_copies = 3 WHERE book_id = 3;
UPDATE Books SET num_copies = 2 WHERE book_id = 4;
UPDATE Books SET num_copies = 5 WHERE book_id = 5;

UPDATE Readers SET Sex = 'F' WHERE reader_id = 1;
UPDATE Readers SET Sex = 'F' WHERE reader_id = 2;
UPDATE Readers SET Sex = 'M' WHERE reader_id = 3;
UPDATE Readers SET Sex = 'M' WHERE reader_id = 4;
UPDATE Readers SET Sex = 'F' WHERE reader_id = 5;

/*
	Task 2: Query 4
        Export the LoanList table as Loanlist.csv by using SQL command "COPY".
        
        NOTE: You won’t be able to actually execute the query due to the security 
              concern but please provide the correct syntax.
*/
COPY LoanList TO '/pjiro003/LoanList.csv' WITH DELIMITER '|' CSV HEADER;

/*
	Task 2: Query 5
        Change the check constraint in the table Books to constraint the entire
        price less than 15.
*/
ALTER TABLE Books
	DROP CONSTRAINT pricelimit,	
	ADD CONSTRAINT pricelimit CHECK (price > 0 AND price < 15);