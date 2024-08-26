-- Création de la base de données
CREATE DATABASE IF NOT EXISTS Superstore;
USE Superstore;

-- Table Customers
CREATE TABLE IF NOT EXISTS Customers
(
    CustomerID   VARCHAR(50) PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    Segment      VARCHAR(50)
);

-- Table Products
CREATE TABLE IF NOT EXISTS Products
(
    ProductID   VARCHAR(50) PRIMARY KEY,
    ProductName VARCHAR(255) NOT NULL,
    Category    VARCHAR(50),
    SubCategory VARCHAR(50)
);

-- Table Locations, state, region (zipcode could be convert into int)
CREATE TABLE IF NOT EXISTS Address
(
    LocationID VARCHAR(50) PRIMARY KEY,
    City       VARCHAR(100),
    PostalCode VARCHAR(20)
);


CREATE TABLE IF NOT EXISTS State
(
    StateID INT AUTO_INCREMENT PRIMARY KEY,
    State   VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS Region
(
    RegionID INT AUTO_INCREMENT PRIMARY KEY,
    Region   VARCHAR(50)
);

-- Table SalesTeams
CREATE TABLE IF NOT EXISTS SalesTeams
(
    SalesTeamID      INT AUTO_INCREMENT PRIMARY KEY,
    SalesTeam        VARCHAR(100),
    SalesTeamManager VARCHAR(100)
);

-- Table salesDept
CREATE TABLE IF NOT EXISTS SalesDept
(
    SalesReprID  INT AUTO_INCREMENT PRIMARY KEY,
    SalesRepName VARCHAR(100)
);

-- Table Orders
CREATE TABLE IF NOT EXISTS Orders
(
    OrderID   VARCHAR(50) PRIMARY KEY,
    OrderDate DATE,
    ShipDate  DATE,
    ShipMode  VARCHAR(50)
);

-- Table orders_details
CREATE TABLE IF NOT EXISTS Orders_details
(
    Order_details_ID INT AUTO_INCREMENT PRIMARY KEY,
    Sales       FLOAT,
    Quantity    INT,
    Discount    FLOAT,
    Profit      FLOAT,
    OrderID     VARCHAR(50),
    CustomerID  VARCHAR(50),
    ProductID   VARCHAR(50),
    SalesReprID INT,
    SalesTeamID INT,
    LocationID  VARCHAR(50),
    StateID     INT,
    RegionID    INT,
    FOREIGN KEY (OrderID) REFERENCES Orders (OrderID),
    FOREIGN KEY (CustomerID) REFERENCES Customers (CustomerID),
    FOREIGN KEY (ProductID) REFERENCES Products (ProductID),
    FOREIGN KEY (LocationID) REFERENCES Address (LocationID),
    FOREIGN KEY (StateID) REFERENCES State (StateID),
    FOREIGN KEY (RegionID) REFERENCES Region (RegionID),
    FOREIGN KEY (SalesTeamID) REFERENCES SalesTeams (SalesTeamID),
    FOREIGN KEY (SalesReprID) REFERENCES SalesDept (Salesreprid)
);

-- Temporary Table for parsing data
CREATE TABLE import_csv
(
    OrderID          VARCHAR(50),
    OrderDate        DATE,
    ShipDate         DATE,
    ShipMode         VARCHAR(50),
    CustomerID       VARCHAR(50),
    SalesRepr        VARCHAR(50),
    LocationID       VARCHAR(50),
    ProductID        VARCHAR(50),
    Sales            FLOAT,
    Quantity         INT,
    Discount         FLOAT,
    Profit           FLOAT,
    CustomerName     VARCHAR(100),
    Segment          VARCHAR(50),
    ProductName      VARCHAR(255) NOT NULL,
    Category         VARCHAR(50),
    SubCategory      VARCHAR(50),
    SalesTeam        VARCHAR(100),
    SalesTeamManager VARCHAR(100),
    City             VARCHAR(100),
    State            VARCHAR(50),
    PostalCode       VARCHAR(20),
    Region           VARCHAR(50)
);

-- load data into temporary table
LOAD DATA INFILE "/var/lib/mysql-files/data/superstorerawdata_cleaned.csv"
    INTO TABLE import_csv
    FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
    LINES TERMINATED BY '\r\n'
    IGNORE 1 ROWS;

-- Insert data into customer table
INSERT INTO Customers (CustomerID, CustomerName, Segment)
SELECT DISTINCT CustomerID, CustomerName, Segment
FROM import_csv;

-- Insert data into product table
INSERT INTO products (ProductID, ProductName, Category, SubCategory)
SELECT DISTINCT ProductID, ProductName, Category, SubCategory
FROM import_csv;

-- Insert data into address table
INSERT INTO address (LocationID, City, PostalCode)
SELECT DISTINCT LocationID, City, PostalCode
FROM import_csv;

INSERT INTO State(State)
SELECT DISTINCT State
FROM import_csv;

INSERT INTO Region(Region)
SELECT DISTINCT Region
FROM import_csv;

-- Insert data into Sales teams
INSERT INTO SalesTeams (SalesTeam, SalesTeamManager)
SELECT DISTINCT SalesTeam, SalesTeamManager
FROM import_csv;

-- Insert data into sales Dept
INSERT INTO SalesDept(SalesRepName)
SELECT DISTINCT SalesRepr
FROM import_csv;


-- Insert data into orders table
INSERT INTO orders(OrderID, OrderDate, ShipDate, ShipMode)
SELECT DISTINCT OrderID, OrderDate, ShipDate, ShipMode
FROM import_csv;

INSERT INTO Orders_details (Sales, Quantity, Discount, Profit,
                            OrderID,CustomerID, ProductID, SalesReprID, SalesTeamID, LocationID, StateID, RegionID)
SELECT t.Sales,
       t.Quantity,
       t.Discount,
       t.Profit,
       t.OrderID,
       t.CustomerID,
       t.ProductID,
       s.SalesReprID,
       st.SalesTeamID,
       t.LocationID,
       stt.StateID,
       r.RegionID

FROM import_csv t
         JOIN Orders o ON o.OrderID = t.OrderID
         JOIN SalesDept s ON s.SalesRepName = t.SalesRepr
         JOIN State stt ON stt.State = t.State
         JOIN Region r ON r.Region = t.Region
         JOIN SalesTeams st ON st.SalesTeam = t.SalesTeam AND st.SalesTeamManager = t.SalesTeamManager;




