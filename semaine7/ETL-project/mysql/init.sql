-- Création de la base de données
CREATE DATABASE IF NOT EXISTS superstore;
USE superstore;

-- Table Customers
CREATE TABLE Customers
(
    CustomerID   VARCHAR(50) PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    Segment      VARCHAR(50)
);

-- Table Products
CREATE TABLE Products
(
    ProductID   VARCHAR(50) PRIMARY KEY,
    ProductName VARCHAR(255) NOT NULL,
    Category    VARCHAR(50),
    SubCategory VARCHAR(50)
);

-- Table Locations, state, region
CREATE TABLE Address
(
    LocationID VARCHAR(50) PRIMARY KEY,
    City       VARCHAR(100),
    State      VARCHAR(50),
    PostalCode VARCHAR(20),
    Region     VARCHAR(50)
);


CREATE TABLE State
(
    State VARCHAR(50)
);

CREATE TABLE Region
(
    Region VARCHAR(50)
);

-- Table SalesTeams
CREATE TABLE SalesTeams
(
    SalesTeamID      INT AUTO_INCREMENT PRIMARY KEY,
    SalesTeam        VARCHAR(100),
    SalesTeamManager VARCHAR(100)
);

-- Table salesDept
CREATE TABLE SalesDept
(
    SalesReprID  INT AUTO_INCREMENT PRIMARY KEY,
    SalesRepName VARCHAR(100)
);

-- Table Orders
CREATE TABLE Orders
(
    OrderID     VARCHAR(50) PRIMARY KEY,
    CustomerID  VARCHAR(50),
    OrderDate   DATE,
    ShipDate    DATE,
    ShipMode    VARCHAR(50),
    Sales       FLOAT,
    Quantity    INT,
    Discount    FLOAT,
    Profit      FLOAT,
    SalesReprID INT,
    LocationID  VARCHAR(50),
    SalesTeamID INT,
    FOREIGN KEY (SalesReprID) REFERENCES SalesDept (Salesreprid),
    FOREIGN KEY (CustomerID) REFERENCES Customers (CustomerID),
    FOREIGN KEY (LocationID) REFERENCES Address (LocationID),
    FOREIGN KEY (SalesTeamID) REFERENCES SalesTeams (SalesTeamID)
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
LOAD DATA INFILE "/var/lib/mysql-files/superstorerawdata_corrected.csv"
    INTO TABLE import_csv
    FIELDS TERMINATED BY ','
    LINES TERMINATED BY '\r\n'
    IGNORE 1 ROWS;