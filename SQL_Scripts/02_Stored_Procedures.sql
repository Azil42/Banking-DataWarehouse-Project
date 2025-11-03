CREATE PROCEDURE DailyTransaction
    @start_date DATE,
    @end_date DATE
AS
BEGIN
    SELECT 
        CAST(TransactionDate AS DATE) as Date,
        COUNT(TransactionKey) as TotalTransactions,
        SUM(Amount) as TotalAmount
    FROM FactTransaction
    WHERE CAST(TransactionDate AS DATE) BETWEEN @start_date AND @end_date
    GROUP BY CAST(TransactionDate AS DATE)
    ORDER BY Date;
END;
GO

CREATE PROCEDURE BalancePerCustomer
    @name VARCHAR(100)
AS
BEGIN
    SELECT 
        dc.CustomerName,
        da.AccountType,
        da.Balance,
        (da.Balance + 
            ISNULL(SUM(CASE 
                WHEN ft.TransactionType = 'Deposit' THEN ft.Amount 
                ELSE -ft.Amount 
            END), 0)
        ) as CurrentBalance
    FROM DimCustomer dc
    JOIN DimAccount da ON dc.CustomerID = da.CustomerID
    LEFT JOIN FactTransaction ft ON da.AccountKey = ft.AccountKey
    WHERE dc.CustomerName LIKE '%' + @name + '%'
        AND da.Status = 'active'
    GROUP BY dc.CustomerName, da.AccountType, da.Balance
    ORDER BY dc.CustomerName, da.AccountType;
END;
GO