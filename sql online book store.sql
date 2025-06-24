-- Create database
CREATE DATABASE OnlineBookstore;

USE OnlineBookstore;

CREATE TABLE Books(
Book_ID int not null primary key,
Title  Varchar(100),
Author Varchar(50),
Genre Varchar(50),
Published_Year int,
Price numeric(10,2),
Stock int
);


CREATE TABLE Customers (
    Customer_ID INT NOT NULL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(50),
    Phone VARCHAR(50),
    City VARCHAR(30),
    Country VARCHAR(30)
);

CREATE TABLE Orders (
    Order_ID INT NOT NULL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers (Customer_ID),
    Book_ID INT REFERENCES Books (Book_ID),
    Order_Date DATETIME,
    Quantity INT,
    Total_Amount NUMERIC(10 , 2 )
);

ALTER TABLE orders
ADD CONSTRAINT fk_orders_customer
FOREIGN KEY (Customer_ID) REFERENCES customers(Customer_ID);


ALTER TABLE orders
ADD CONSTRAINT fk_orders_book
FOREIGN KEY (Book_ID)
REFERENCES books(Book_ID);



-- 1)Retrive all books in the "Fiction" genre:
SELECT * FROM Books
WHERE GENRE = "Fiction";

-- 2)Find books published after the year 1950:
SELECT * FROM Books
WHERE Published_Year > 1950;

-- 3)List all the customers from Canada:
SELECT* FROM Customers
where country= "Canada";

-- 4)Show orders placed in November 2023:
SELECT * FROM Orders
WHERE Order_Date LIKE "2023-11%";

-- 5)Retrive the total stock of books available:
SELECT sum(Stock) AS total_stock
FROM Books;

-- 6) Find the details of the most expensive books:
SELECT 
    *
FROM
    Books
ORDER BY Price DESC
LIMIT 1;
 
--  7) Show all customers who ordered more than 1 quantity of a book:
SELECT * FROM Orders 
WHERE Quantity >1;

-- 8) Retrive  all orders where the total amount exceeds $20:
SELECT * FROM Orders 
WHERE Total_Amount > "20$";


-- 9) List all genre available in the Books table:
SELECT  DISTINCT Genre FROM Books;


-- 10)Find the books with lowest stock:
SELECT 
    *
FROM
    Books
ORDER BY Stock 
LIMIT 1;


-- 11)Calculate the total revenue generated from all orders;
	SELECT 
    SUM(Total_Amount) AS Total_Revenue
FROM
    Orders;
    
--     Advance Questions:
-- 1)Retrive the total number of books sold for each genre:
SELECT 
    b.Genre, SUM(o.Quantity) AS Total_Book_Sold
FROM
    Books as b
        JOIN
    Orders as o ON b.book_id = o.book_id
GROUP BY b.Genre;


-- 2)Find the average price of books in the "fantasy" genre:
SELECT 
    AVG(Price) AS Average_Price
FROM
    Books
WHERE
    Genre = 'Fantasy';
    
--     3) List the customers who have placed at least 2 orders:
SELECT 
    Customer_ID, COUNT(Order_ID) AS Order_Count
FROM
    Orders
GROUP BY Customer_ID
HAVING COUNT(Order_ID) >= 2;


--  4)-- List the customers name, customer id who have placed at least 2 orders:
SELECT 
    c.Name, o.customer_id, COUNT(o.Order_Id) AS Order_Count
FROM
    Customers AS c
        JOIN
    Orders AS o ON c.Customer_ID = o.Customer_ID
GROUP BY o.customer_id , c.Name
HAVING COUNT(o.Order_id) >= 2
ORDER BY Order_Count DESC;

-- 5) Find the most frequently ordered book:
SELECT 
    Book_Id, COUNT(Order_id) AS Order_Count
FROM
    Orders
GROUP BY Book_Id
ORDER BY Order_Count DESC
LIMIT 1
;

-- 6) Find the most frequently ordered book name along with  Book id:
SELECT 
    b.Title, o.Book_Id, COUNT(o.Order_id) AS Order_Count
FROM
    Books AS b
        JOIN
    Orders AS o ON b.Book_Id = o.Book_Id
GROUP BY b.Title , o.Book_Id
ORDER BY Order_Count DESC ;

-- 7)Show the top 3 most expensive books "Fantasy"
SELECT 
    *
FROM
    Books
WHERE
    Genre = 'Fantasy'
ORDER BY Price DESC
LIMIT 3;

-- 8)Retrive the total quantity of books sold by each author:
SELECT 
    b.Author, SUM(o.Quantity) AS Total_Quantity
FROM
    Books AS b
        JOIN
    Orders AS o ON b.Book_Id = o.Book_Id
GROUP BY b.Author
ORDER BY Total_Quantity DESC ;

-- 9) List the cities wher customers who spent over $300 located:
SELECT 
   DISTINCT c.City, o.Total_Amount
FROM
    Customers AS c
        JOIN
    Orders AS o ON c.Customer_Id = o.Customer_Id
WHERE
    o.Total_Amount > '300';
    
--     10)Find the customer who spent the most on orders:
SELECT 
    c.Name, c.Customer_Id, SUM(o.Total_Amount) AS Total_spend
FROM
    Customers AS c
        JOIN
    Orders AS o ON c.Customer_Id = o.Customer_Id
GROUP BY c.Name , c.Customer_Id
ORDER BY Total_spend DESC
LIMIT 1;

-- 11)Calculate the stock remaining after fulfillinng all orders;
SELECT 
    b.book_id,
    b.title,
    b.stock,
    COALESCE(SUM(o.quantity), 0) AS Order_quantity,
    b.stock - COALESCE(SUM(o.quantity),0) AS Stock_Left
FROM
    books AS b
        LEFT JOIN
    Orders AS o ON b.book_id = o.book_id
GROUP BY b.book_id
Order by b.stock desc;