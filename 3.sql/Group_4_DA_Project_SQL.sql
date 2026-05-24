select * from Inventory
---------------------------------------------------
--Find Products with 10 discount--
select * from Inventory where Discount > 10
----------------------------------------------------
--Total Revenue--
SELECT 
    ROUND(SUM(Units_Sold * Price),2) AS Total_Revenue
FROM Inventory;
------------------------------------------------------------
--Revenue by Product Category--
SELECT 
    Category,
    ROUND(SUM(Units_Sold * Price),2) AS Revenue
FROM Inventory
GROUP BY Category
ORDER BY Revenue DESC;
---------------------------------------------------------------
--Top 10 Best Selling Products--
SELECT TOP 10
    Product_ID,
    SUM(Units_Sold) AS Total_Units_Sold
FROM Inventory
GROUP BY Product_ID
ORDER BY Total_Units_Sold DESC
;
-------------------------------------------------------------------
--Region-wise Sales Performance--
SELECT 
    Region,
    ROUND(SUM(Units_Sold * Price),2) AS Revenue
FROM Inventory
GROUP BY Region
ORDER BY Revenue DESC;
----------------------------------------------------------------------
--Average Inventory by Category--
SELECT 
    Category,
    ROUND(AVG(Inventory_Level),2) AS Avg_Inventory
FROM Inventory
GROUP BY Category;
-------------------------------------------------------------------------
--Products with Low Inventory--
SELECT 
    Product_ID,
    Category,
    Inventory_Level
FROM Inventory
WHERE Inventory_Level <= 50
ORDER BY Inventory_Level;
-------------------------------------------------------------------------
--Impact of Discounts on Sales--
SELECT 
    Discount,
    ROUND(AVG(Units_Sold),2) AS Avg_Sales
FROM Inventory
GROUP BY Discount
ORDER BY Discount;
---------------------------------------------------------------------------
--Seasonal Sales Analysis--
SELECT 
    Seasonality,
    ROUND(SUM(Units_Sold * Price),2) AS Revenue
FROM Inventory
GROUP BY Seasonality
ORDER BY Revenue DESC;
-------------------------------------------------------------------------------
--Promotion vs Non-Promotion Sales--
SELECT 
    Holiday_Promotion,
    ROUND(SUM(Units_Sold),2) AS Total_Sales
FROM Inventory
GROUP BY Holiday_Promotion;
-------------------------------------------------------------------------------
--Forecast Accuracy--
SELECT 
    ROUND(
        AVG(
            ABS(Demand_Forecast - Units_Sold)
        ),2
    ) AS Forecast_Error
FROM Inventory;
---------------------------------------------------------------------------------
--Inventory Turnover Ratio--
SELECT 
    Category,
    ROUND(
        SUM(Units_Sold) / AVG(Inventory_Level),
        2
    ) AS Inventory_Turnover
FROM Inventory
GROUP BY Category;
-----------------------------------------------------------------------------------
--Monthly Revenue Trend--
SELECT 
    MONTH([Date]) AS Month_No,
    DATENAME(MONTH, [Date]) AS Month_Name,
    ROUND(SUM(Units_Sold * Price), 2) AS Revenue
FROM Inventory
GROUP BY 
    MONTH([Date]),
    DATENAME(MONTH, [Date])
ORDER BY Month_No;
------------------------------------------------------------------------
--Rank Products by Units Sold within Each Category--
WITH ProductSales AS (
    SELECT
        Category,
        [Product_ID],
        SUM([Units_Sold]) AS Total_Units_Sold
    FROM Inventory
    GROUP BY Category, [Product_ID]
)

SELECT
    Category,
    [Product_ID],
    Total_Units_Sold,
    RANK() OVER (
        PARTITION BY Category
        ORDER BY Total_Units_Sold DESC
    ) AS Sales_Rank
FROM ProductSales;
--------------------------------------------------------------------------
--Running Total of Units Sold by Date--
WITH DailySales AS (
    SELECT
        Date,
        SUM([Units_Sold]) AS Daily_Units_Sold
    FROM Inventory
    GROUP BY Date
)

SELECT
    Date,
    Daily_Units_Sold,
    SUM(Daily_Units_Sold) OVER (
        ORDER BY Date
    ) AS Running_Total_Sales
FROM DailySales;
---------------------------------------------------------------------------------
--Identify Highest Discount Products--
WITH DiscountData AS (
    SELECT
        Category,
        [Product_ID],
        Discount
    FROM Inventory
)

SELECT
    Category,
    [Product_ID],
    Discount,
    DENSE_RANK() OVER (
        PARTITION BY Category
        ORDER BY Discount DESC
    ) AS Discount_Rank
FROM DiscountData;