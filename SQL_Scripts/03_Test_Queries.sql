USE DWH;
GO

-- Test 1: Check table counts
SELECT 
    'DimCustomer' as TableName, COUNT(*) as RecordCount FROM DimCustomer
UNION ALL
SELECT 'DimAccount', COUNT(*) FROM DimAccount
UNION ALL
SELECT 'DimBranch', COUNT(*) FROM DimBranch
UNION ALL
SELECT 'FactTransaction', COUNT(*) FROM FactTransaction;

-- Test 2: Check data quality - no duplicates in FactTransaction
SELECT TransactionID, COUNT(*) as DuplicateCount
FROM FactTransaction
GROUP BY TransactionID
HAVING COUNT(*) > 1;

-- Test 3: Test Stored Procedures
-- DailyTransaction Test
EXEC DailyTransaction @start_date = '2024-01-18', @end_date = '2024-01-22';

-- BalancePerCustomer Test
EXEC BalancePerCustomer @name = 'Shelly';

-- Test 4: Check foreign key relationships
SELECT 
    OBJECT_NAME(fk.parent_object_id) AS TableName,
    COL_NAME(fkc.parent_object_id, fkc.parent_column_id) AS ColumnName,
    OBJECT_NAME(fk.referenced_object_id) AS ReferenceTableName,
    COL_NAME(fkc.referenced_object_id, fkc.referenced_column_id) AS ReferenceColumnName
FROM sys.foreign_keys fk
INNER JOIN sys.foreign_key_columns fkc ON fk.object_id = fkc.constraint_object_id
WHERE OBJECT_NAME(fk.parent_object_id) IN ('FactTransaction');

-- Test 5: Sample data from each table
SELECT TOP 5 * FROM DimCustomer;
SELECT TOP 5 * FROM DimAccount;
SELECT TOP 5 * FROM DimBranch;
SELECT TOP 10 * FROM FactTransaction ORDER BY TransactionDate DESC;