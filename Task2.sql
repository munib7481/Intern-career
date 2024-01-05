-- TASK02 QUESTION 1
 -- Database Design:
-- Design a normalized database schema for a given scenario, focusing on table
-- structures, relationships, and constraints.
-- Implement primary keys, foreign keys, and appropriate indexing.
-- Create Author table
use task2;
CREATE TABLE Author(
    AuthorID INT PRIMARY KEY,
    AuthorName VARCHAR(100) NOT NULL
);

-- Create Genre table
CREATE TABLE Genre (
    GenreID INT PRIMARY KEY,
    GenreName VARCHAR(50) NOT NULL
);

-- Create Publisher table
CREATE TABLE Publisher (
    PublisherID INT PRIMARY KEY,
    PublisherName VARCHAR(100) NOT NULL
);

-- Create Book table
CREATE TABLE Book (
    BookID INT PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    ISBN VARCHAR(13) NOT NULL,
    PublishedYear INT,
    PublisherID INT,
    GenreID INT,
    FOREIGN KEY (PublisherID) REFERENCES Publisher(PublisherID),
    FOREIGN KEY (GenreID) REFERENCES Genre(GenreID)
);

-- Create AuthorBook table for many-to-many relationship
CREATE TABLE AuthorBook (
    AuthorID INT,
    BookID INT,
    PRIMARY KEY (AuthorID, BookID),
    FOREIGN KEY (AuthorID) REFERENCES Author(AuthorID),
    FOREIGN KEY (BookID) REFERENCES Book(BookID)
);

-- Create Member table
CREATE TABLE Member (
    MemberID INT PRIMARY KEY,
    MemberName VARCHAR(100) NOT NULL
);

-- Create Checkout table to track book checkouts
CREATE TABLE Checkout (
    CheckoutID INT PRIMARY KEY,
    MemberID INT,
    BookID INT,
    CheckoutDate DATE NOT NULL,
    ReturnDate DATE,
    FOREIGN KEY (MemberID) REFERENCES Member(MemberID),
    FOREIGN KEY (BookID) REFERENCES Book(BookID)
);

-- Indexing
CREATE INDEX idx_publisher_id ON Book (PublisherID);
CREATE INDEX idx_genre_id ON Book (GenreID);
CREATE INDEX idx_author_id ON AuthorBook (AuthorID);
CREATE INDEX idx_checkout_date ON Checkout (CheckoutDate);

-- TASK02 QUESTION02

-- Query Optimization:
-- Write and optimize SQL queries to ensure efficient data retrieval.
-- Analyze query execution plans, identify bottlenecks, and refactor queries for
-- better performance.
-- Optimize: Use JOINs to retrieve data from multiple tables in a single query
SELECT 
    Book.Title,
    Author.AuthorName,
    Genre.GenreName,
    Book.PublishedYear
FROM Book
JOIN AuthorBook ON Book.BookID = AuthorBook.BookID
JOIN Author ON AuthorBook.AuthorID = Author.AuthorID
JOIN Genre ON Book.GenreID = Genre.GenreID;

-- Optimize: Use LEFT JOIN to include all books, even those not checked out
SELECT 
    Book.Title,
    COUNT(Checkout.CheckoutID) AS Checkouts
FROM Book
LEFT JOIN Checkout ON Book.BookID = Checkout.BookID
GROUP BY Book.Title;

-- Optimize: Use JOINs and WHERE clause to filter results efficiently
SELECT 
    Member.MemberName,
    Checkout.CheckoutDate,
    Checkout.ReturnDate
FROM Member
JOIN Checkout ON Member.MemberID = Checkout.MemberID
WHERE Checkout.BookID = (SELECT BookID FROM Book WHERE Title = 'YourBookTitle');


-- Optimize: Use JOINs and GROUP BY for aggregate calculations
SELECT 
    Publisher.PublisherName,
    COUNT(Book.BookID) AS TotalBooks
FROM Publisher
JOIN Book ON Publisher.PublisherID = Book.PublisherID
GROUP BY Publisher.PublisherName;

-- Optimize: Use an index on PublishedYear column for faster filtering
SELECT 
    Title,
    PublishedYear
FROM Book
WHERE PublishedYear = 2022;

-- Optimize: Use HAVING clause to filter results after grouping
SELECT 
    Author.AuthorName,
    COUNT(AuthorBook.BookID) AS TotalBooks
FROM Author
JOIN AuthorBook ON Author.AuthorID = AuthorBook.AuthorID
GROUP BY Author.AuthorName
HAVING TotalBooks > 5;

-- TASK02 QUESTION# 03
-- Query Optimization:
-- Write and optimize SQL queries to ensure efficient data retrieval.
-- Analyze query execution plans, identify bottlenecks, and refactor queries for
-- better performance.

-- Create a clustered index on the primary key of the Book table
-- create CLUSTERED INDEX idx_book_id ON Book(BookID);

-- Create a clustered index on the primary key of the Book table
-- CREATE CLUSTERED INDEX idx_book_id ON Book(BookID);
-- Create a non-clustered index on the foreign key in the Checkout table
-- CREATE NONCLUSTERED INDEX idx_checkout_book_id ON Checkout(BookID);



-- Check if BookID is a primary key
SHOW INDEX FROM Book WHERE Key_name = 'PRIMARY';

-- BookID is already a primary key,skip creating a clustered index explicitly.

-- TASK02 QUESTION 04
-- Normalization and Denormalization:
-- Understand the concepts of normalization and denormalization and apply
-- them appropriately in database design.
-- Evaluate trade-offs between normalization levels for performance and data
-- integrity.
-- Retrieve books with author and genre information
SELECT Book.Title, Author.AuthorName, Genre.GenreName
FROM Book
JOIN Author ON Book.AuthorID = Author.AuthorID
JOIN Genre ON Book.GenreID = Genre.GenreID;

CREATE TABLE DenormalizedBook (
    BookID INT PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    ISBN VARCHAR(13) NOT NULL,
    PublishedYear INT,
    AuthorName VARCHAR(100) NOT NULL,
    GenreName VARCHAR(50) NOT NULL
);
-- Retrieve books with denormalized author and genre information
SELECT BookID, Title, ISBN, PublishedYear, AuthorName, GenreName
FROM DenormalizedBook;

-- 5. Performance Monitoring:
-- - Use SQL profiling tools to monitor database performance.
-- - Identify and resolve issues related to locking, blocking, or slow queries.
SET GLOBAL general_log = 1;
SET GLOBAL general_log_file = '/path/to/general.log';
-- 2. SHOW PROCESSLIST:
-- The SHOW PROCESSLIST command displays information about the current threads executing within the server.
SHOW PROCESSLIST;
-- 3. EXPLAIN Statement:
-- Use the EXPLAIN statement to analyze and optimize the execution plan of a query.
EXPLAIN SELECT * FROM task2.author;
-- MySQL Enterprise Monitor:
-- MySQL Enterprise Monitor is a commercial tool that provides a comprehensive solution for MySQL performance monitoring.








