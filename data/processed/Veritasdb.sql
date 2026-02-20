-- Transformation in SQL
-- Data Quality check 

SELECT * FROM veritasdb.accountinfo;
SELECT * from accountinfo;
SELECT * from customerinfo;


-- Select Account info
SELECT CustomerId, Balance
FROM accountinfo
LIMIT 10;

-- Task 1 Check for Duplicate in Customer Info
SELECT CustomerId, count(CustomerId) as cnt
from customerinfo
group by CustomerId
having count(CustomerId) > 1;

-- Task 1: Check for Duplicate in Account info
SELECT CustomerId, count(CustomerId)
from accountinfo
group by CustomerId
having count(CustomerId) > 1;

-- Task 2: Check for Null Values
SELECT * FROM customerinfo WHERE CustomerId IS NULL;
SELECT * FROM accountinfo WHERE CustomerId IS NULL;

SELECT 
case when CustomerId is null then 1 else 0 end
from customerinfo;

-- Task 1: Check for null value in Customer Info
SELECT
case when CustomerId is null then 1 else 0 end,
case when LastName is null then 1 else 0 end,
case when Country is null then 1 else 0 end,
case when Gender is null then 1 else 0 end,
case when Age is null then 1 else 0 end
from customerinfo;

-- Task 1: Check for null values in customerinfo
SELECT * FROM customerinfo
WHERE CustomerId IS NULL
   OR LastName IS NULL
   OR Country IS NULL
   OR Gender IS NULL
   OR Age IS NULL;
   
-- Task 2: Check for null values in Account Info
SELECT * FROM accountinfo
WHERE CustomerId IS NULL
   OR CreditScore IS NULL
   OR Tenure IS NULL
   OR Balance IS NULL
   OR Products IS NULL
    OR CreditCard IS NULL
     OR ActiveMember IS NULL
      OR Exited IS NULL;

-- Task 3: Check for outlier
SELECT min(CreditScore) as min_credit, max(CreditScore) as max_credit, avg(CreditScore) as avg_credit
from accountinfo;

SELECT min(Age) as min_age, max(Age) as max_age, avg(Age) as avg_age
from customerinfo;

-- Task 4: Check for negative account balance
SELECT CustomerId, Balance
FROM accountinfo
WHERE Balance < 0;

SELECT CustomerId, Balance
FROM accountinfo
WHERE Balance = 0;

-- Task 5 Preliminary EDA
-- No of Records
SELECT count(*) from customerinfo;
-- Total number of customer is 10,000

SELECT count(*) from accountinfo;
-- Total number of customer is 10,000

-- No of Customers in each Country
SELECT Country, count(Country) as No_of_Customer
from customerinfo
group by Country;
-- Result: United Kingdom  5014, France 2477 and Germany 2500

-- Distribution of Gender
SELECT Gender, count(CustomerId) as Count_of_Customer
from customerinfo
group by Gender;
-- Result: Male 5660, Female: 4340

-- Churn Distribution
SELECT Exited, count(CustomerId) as Exited_Customer
from accountinfo
group by Exited;
-- Result:  Exited(0): 8615, Exited(1) 1385

-- Active Distribution
SELECT ActiveMember, count(CustomerId) as Active_Members
from accountinfo
group by ActiveMember;
-- Result: Active_Member(1): 5151, Active_member(0): 4849


-- Column Derivation

ALTER TABLE customerinfo
ADD COLUMN AgeGroup VARCHAR(25)
GENERATED ALWAYS AS (
    CASE 
        WHEN Age BETWEEN 18 AND 35 THEN 'Young Adult'
        WHEN Age BETWEEN 36 AND 45 THEN 'Middle-Aged Adult'
        WHEN Age BETWEEN 46 AND 55 THEN 'Pre-Older Adults'
        WHEN Age BETWEEN 56 AND 65 THEN 'Older Adults'
        ELSE 'Older Adults'
    END
) STORED;

-- Alter Account Table
ALTER TABLE accountinfo
    ADD COLUMN ChurnStatus VARCHAR(40),
    ADD COLUMN ActiveStatus VARCHAR(40),
    ADD COLUMN BalanceCategory VARCHAR(40),
    ADD COLUMN CreditScoreCategory VARCHAR(40),
    ADD COLUMN TenorCategory VARCHAR(40),
    ADD COLUMN ProductCategory VARCHAR(40);
    
-- Inserting data into new derived columns
SET SQL_SAFE_UPDATES = 0;

UPDATE accountinfo
SET 
    ChurnStatus =
        CASE 
            WHEN Exited = 1 THEN 'Churned'
            WHEN Exited = 0 THEN 'Not Churned'
            ELSE 'Unknown'
        END,
    ActiveStatus =
        CASE 
            WHEN ActiveMember = 1 THEN 'Active'
            WHEN ActiveMember = 0 THEN 'Inactive'
            ELSE 'Unknown'
        END,
    BalanceCategory =
        CASE 
            WHEN Balance <= 30000 THEN 'Very Low'
            WHEN Balance BETWEEN 30001 AND 50000 THEN 'Low'
            WHEN Balance BETWEEN 50001 AND 80000 THEN 'Mid'
            ELSE 'High'
        END,
    CreditScoreCategory =
        CASE 
            WHEN CreditScore <= 580 THEN 'Poor'
            WHEN CreditScore BETWEEN 581 AND 669 THEN 'Fair'
            WHEN CreditScore BETWEEN 670 AND 739 THEN 'Good'
            WHEN CreditScore BETWEEN 740 AND 799 THEN 'Very Good'
            WHEN CreditScore BETWEEN 800 AND 850 THEN 'Excellent'
            ELSE 'Out of Range'
        END,
    TenorCategory =
        CASE 
            WHEN Tenure <= 2 THEN 'New'
            WHEN Tenure BETWEEN 3 AND 5 THEN 'Established'
            ELSE 'Loyal'
        END,
    ProductCategory =
        CASE 
            WHEN Products <= 1 THEN 'Low Engagement'
            WHEN Products = 2 THEN 'Moderate'
            ELSE 'High Engagement'
        END;

SET SQL_SAFE_UPDATES = 1;

-- Create View
CREATE VIEW CustomerDetails AS
SELECT
    a.*,
    c.LastName,
    c.Country,
    c.Gender,
    c.Age,
    c.AgeGroup
FROM accountinfo AS a
LEFT JOIN customerinfo AS c
    ON a.CustomerId = c.CustomerId;
    
SELECt * from CustomerDetails;

-- Segmentation Table

-- Min and max Credit score
-- Check for Negative balance

-- Create View: Churn Risk Level
CREATE VIEW ChurnRiskLevel AS
SELECT
    CustomerId,
    Country,
    AgeGroup,
    BalanceCategory,
    CreditScoreCategory,
    TenorCategory,
    ProductCategory,
    ActiveStatus,
    ChurnStatus,
    CASE
        WHEN CreditScoreCategory IN ('Poor', 'Fair')
             AND BalanceCategory = 'Very Low'
             AND ProductCategory = 'Low Engagement'
             AND TenorCategory = 'New'
        THEN 'High Risk'

        WHEN (
                CreditScoreCategory IN ('Poor', 'Fair')
                AND BalanceCategory IN ('Very Low', 'Low')
             )
             OR (
                CreditScoreCategory IN ('Poor', 'Fair')
                AND ProductCategory = 'Low Engagement'
             )
             OR (
                BalanceCategory IN ('Very Low', 'Low')
                AND ProductCategory = 'Low Engagement'
             )
        THEN 'Elevated Risk'

        WHEN ProductCategory = 'Moderate'
             OR TenorCategory = 'Established'
        THEN 'Medium Risk'

        ELSE 'Low Risk'
    END AS ChurnRisk
FROM CustomerDetails;

SELECT * from ChurnRiskLevel;

-- Deep Dive Analysis
-- Number of churned customers in each country
SELECT 
    Country,
    COUNT(CustomerId) AS No_of_Customers
FROM CustomerDetails
WHERE ChurnStatus = 'Churned'
GROUP BY Country
ORDER BY No_of_Customers DESC;

-- Top 5 countries by number of churned customers
SELECT 
    Country,
    COUNT(CustomerId) AS No_of_Customers
FROM CustomerDetails
WHERE ChurnStatus = 'Churned'
GROUP BY Country
ORDER BY No_of_Customers DESC
LIMIT 5;

-- No_of Customer in United Kingdom: 498
-- No_of Customer in Germany: 493
-- No_of Customer in France: 434

--- Number of churned customers by Country and Gender
SELECT 
    Country,
    Gender,
    COUNT(CustomerId) AS No_of_Churned_Customers
FROM CustomerDetails
WHERE ChurnStatus = 'Churned'
GROUP BY Country, Gender
ORDER BY Country, Gender;

-- Result
-- France	Male	250
-- Germany	Female	210
-- Germany	Male	243
-- United Kingdom	Female	224
-- United Kingdom	Male	274

--- Number of churned customers by Country and Gender

SELECT *
FROM (
    SELECT 
        Country,
        Gender,
        COUNT(CustomerId) AS No_of_Churned_Customers,
        ROW_NUMBER() OVER (
            PARTITION BY Country 
            ORDER BY COUNT(CustomerId) DESC
        ) AS rn
    FROM CustomerDetails
    WHERE ChurnStatus = 'Churned'
    GROUP BY Country, Gender
) t
WHERE rn = 1;

-- France	Male	250	1
-- Germany	Male	243	1
-- United Kingdom	Male	274	1

-- Total Churn Customer
SELECT 
    COUNT(CustomerId) AS Total_Customers,
    SUM(CASE WHEN ChurnStatus = 'Churned' THEN 1 ELSE 0 END) AS No_Of_Churned
FROM CustomerDetails;

-- Total Customer= 10000, Number of Churned = 1385



-- Overall churn rate (%)
SELECT 
    ROUND(
        SUM(CASE WHEN ChurnStatus = 'Churned' THEN 1 ELSE 0 END) 
        / COUNT(*) * 100,
        2
    ) AS Overall_Churn_Rate_Percent
FROM CustomerDetails;

-- Churn Rate is 13.85%



-- Customer Lifetime Value Proxy
ALTER TABLE accountinfo
ADD COLUMN EstimatedValue DECIMAL(12,2)
GENERATED ALWAYS AS (Balance * Tenure) STORED;

SELECT 
    CustomerId,
    Balance,
    Tenure,
    CASE
        WHEN Balance * Tenure < 100000 THEN 'Low Value'
        WHEN Balance * Tenure BETWEEN 100000 AND 500000 THEN 'Medium Value'
        ELSE 'High Value'
    END AS ValueCategory
FROM accountinfo;


CREATE OR REPLACE VIEW CustomerDetails AS
SELECT
    a.*,
    c.LastName,
    c.Country,
    c.Gender,
    c.Age,
    c.AgeGroup,
    CASE
        WHEN a.Balance * a.Tenure < 100000 THEN 'Low Value'
        WHEN a.Balance * a.Tenure BETWEEN 100000 AND 500000 THEN 'Medium Value'
        ELSE 'High Value'
    END AS ValueCategory
FROM accountinfo a
LEFT JOIN customerinfo c
ON a.CustomerId = c.CustomerId;


-- Add as a generated column
ALTER TABLE accountinfo
ADD COLUMN ValueCategory VARCHAR(20)
GENERATED ALWAYS AS (
    CASE
        WHEN Balance * Tenure < 100000 THEN 'Low Value'
        WHEN Balance * Tenure BETWEEN 100000 AND 500000 THEN 'Medium Value'
        ELSE 'High Value'
    END
) STORED;

-- EngagementScore + RiskScore to Your View
CREATE OR REPLACE VIEW churnrisklevel AS
SELECT
    CustomerId,
    Country,
    AgeGroup,
    BalanceCategory,
    CreditScoreCategory,
    TenorCategory,
    ProductCategory,
    ActiveStatus,
    ChurnStatus,

    -- Engagement Score
    (
        (Products * 2) +
        (CASE WHEN ActiveMember = 1 THEN 3 ELSE 0 END) +
        Tenure
    ) AS EngagementScore,

    -- Risk Score
    (
        (CASE WHEN CreditScore < 600 THEN 2 ELSE 0 END) +
        (CASE WHEN Balance < 50000 THEN 2 ELSE 0 END) +
        (CASE WHEN ActiveMember = 0 THEN 3 ELSE 0 END) +
        (CASE WHEN Products <= 1 THEN 2 ELSE 0 END)
    ) AS RiskScore,

    CASE
        WHEN CreditScoreCategory IN ('Poor', 'Fair')
             AND BalanceCategory = 'Very Low'
             AND ProductCategory = 'Low Engagement'
             AND TenorCategory = 'New'
        THEN 'High Risk'

        WHEN (
                CreditScoreCategory IN ('Poor', 'Fair')
                AND BalanceCategory IN ('Very Low', 'Low')
             )
             OR (
                CreditScoreCategory IN ('Poor', 'Fair')
                AND ProductCategory = 'Low Engagement'
             )
             OR (
                BalanceCategory IN ('Very Low', 'Low')
                AND ProductCategory = 'Low Engagement'
             )
        THEN 'Elevated Risk'

        WHEN ProductCategory = 'Moderate'
             OR TenorCategory = 'Established'
        THEN 'Medium Risk'

        ELSE 'Low Risk'
    END AS ChurnRisk

FROM customerdetails;

-- Checking once more
SELECT * from accountinfo;
SELECT * from customerinfo;
SELECT * from customerdetails;
SELECT * from churnrisklevel;
SELECT * FROM ChurnRiskLevel LIMIT 10;












