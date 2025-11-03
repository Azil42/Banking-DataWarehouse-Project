CREATE DATABASE DWH;
GO

USE DWH;
GO

CREATE TABLE DimAccount (
    AccountKey INT IDENTITY(1,1) PRIMARY KEY,
    AccountID INT,
    CustomerID INT,
    AccountType VARCHAR(50),
    Balance DECIMAL(18,2),
    DateOpened DATE,
    Status VARCHAR(20),
    LoadDate DATETIME DEFAULT GETDATE()
);

CREATE TABLE DimCustomer (
    CustomerKey INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT,
    CustomerName VARCHAR(100),
    Address VARCHAR(200),
    CityName VARCHAR(100),
    StateName VARCHAR(100),
    Age INT,
    Gender VARCHAR(10),
    Email VARCHAR(100),
    LoadDate DATETIME DEFAULT GETDATE()
);

CREATE TABLE DimBranch (
    BranchKey INT IDENTITY(1,1) PRIMARY KEY,
    BranchID INT,
    BranchName VARCHAR(100),
    BranchLocation VARCHAR(200),
    LoadDate DATETIME DEFAULT GETDATE()
);

CREATE TABLE FactTransaction (
    TransactionKey INT IDENTITY(1,1) PRIMARY KEY,
    TransactionID INT,
    AccountKey INT,
    BranchKey INT,
    TransactionDate DATETIME,
    Amount DECIMAL(18,2),
    TransactionType VARCHAR(50),
    LoadDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (AccountKey) REFERENCES DimAccount(AccountKey),
    FOREIGN KEY (BranchKey) REFERENCES DimBranch(BranchKey)
);

CREATE INDEX IX_FactTransaction_Date ON FactTransaction(TransactionDate);
CREATE INDEX IX_FactTransaction_Account ON FactTransaction(AccountKey);

SELECT name FROM sys.databases WHERE name = 'DWH';
