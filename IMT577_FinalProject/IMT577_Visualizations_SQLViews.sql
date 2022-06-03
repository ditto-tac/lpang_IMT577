-- View 1: Target Qty vs. Actual Qty

CREATE OR REPLACE VIEW VIEW_TargetSalesQty

AS

SELECT DISTINCT
    Dim_Product.ProductName,
    Dim_Product.ProductType,
    Dim_Product.ProductCategory,
    Dim_Store.StoreNumber,
    Dim_Channel.ChannelName,
    Dim_Date.Date,
    Dim_Date.Day_Name,
    Dim_Date.US_Holiday_Ind,
    Dim_Date.Month_Name,
    Dim_Date.Fiscal_Quarter,
    Dim_Date.Fiscal_Year,
    Dim_Location.Address,
    Dim_Location.City,
    Dim_Location.StateProvince,
    Dim_Product.ProductRetailPrice,
    Dim_Product.ProductWholesalePrice,
    Dim_Product.ProductCost,
    Fact_ProductSalesTarget.ProductTargetSalesQuantity,
    SUM(Fact_SalesActual.SaleQuantity) as Sum_SalesQuantity,
    AVG(Fact_SalesActual.SaleQuantity) as Avg_SalesQuantity

    FROM Fact_SalesActual
        LEFT JOIN Dim_Product
            ON Dim_Product.DimProductID = Fact_SalesActual.DimProductID
        LEFT JOIN Dim_Store
            ON Dim_Store.DimStoreID = Fact_SalesActual.DimStoreID
        LEFT JOIN Dim_Channel
            ON Dim_Channel.DimChannelID = Fact_SalesActual.DimChannelID
        LEFT JOIN Dim_Date
            ON Dim_Date.Date_PKEY = Fact_SalesActual.DimSaleDateID
        LEFT JOIN Dim_Location
            ON Dim_Location.DimLocationID = Fact_SalesActual.DimLocationID
        LEFT JOIN Fact_ProductSalesTarget
            ON Fact_ProductSalesTarget.DimProductID = Dim_Product.DimProductID
            AND Fact_ProductSalesTarget.DimTargetDateID = Dim_Date.Date_PKEY
            
    WHERE 
        Fact_SalesActual.DimStoreID <> -1
    
    GROUP BY
        Dim_Product.ProductName,
        Dim_Product.ProductType,
        Dim_Product.ProductCategory,
        Dim_Store.StoreNumber,
        Dim_Channel.ChannelName,
        Dim_Date.Date,
        Dim_Date.Day_Name,
        Dim_Date.US_Holiday_Ind,
        Dim_Date.Month_Name,
        Dim_Date.Fiscal_Quarter,
        Dim_Date.Fiscal_Year,
        Dim_Location.Address,
        Dim_Location.City,
        Dim_Location.StateProvince,
        Dim_Product.ProductRetailPrice,
        Dim_Product.ProductWholesalePrice,
        Dim_Product.ProductCost,
        Fact_ProductSalesTarget.ProductTargetSalesQuantity;

-- View 2: Sales Target vs Actual Sales
CREATE OR REPLACE VIEW VIEW_TargetSalesAmt

AS

SELECT DISTINCT
    Dim_Product.ProductName,
    Dim_Product.ProductType,
    Dim_Product.ProductCategory,
    Dim_Store.StoreNumber,
    Dim_Channel.ChannelName,
    Dim_Date.Date,
    Dim_Date.Day_Name,
    Dim_Date.US_Holiday_Ind,
    Dim_Date.Month_Name,
    Dim_Date.Fiscal_Quarter,
    Dim_Date.Fiscal_Year,
    Dim_Location.Address,
    Dim_Location.City,
    Dim_Location.StateProvince,
    Dim_Product.ProductRetailPrice,
    Dim_Product.ProductWholesalePrice,
    Dim_Product.ProductCost,
    Fact_SRCSalesTarget.SalesTargetAmount,
    SUM(Fact_SalesActual.SaleAmount) as SUM_SalesAmount

    FROM Fact_SalesActual
        LEFT JOIN Dim_Product
            ON Dim_Product.DimProductID = Fact_SalesActual.DimProductID
        LEFT JOIN Dim_Store
            ON Dim_Store.DimStoreID = Fact_SalesActual.DimStoreID
        LEFT JOIN Dim_Channel
            ON Dim_Channel.DimChannelID = Fact_SalesActual.DimChannelID
        LEFT JOIN Dim_Date
            ON Dim_Date.Date_PKEY = Fact_SalesActual.DimSaleDateID
        LEFT JOIN Dim_Location
            ON Dim_Location.DimLocationID = Fact_SalesActual.DimLocationID
        LEFT JOIN Fact_SRCSalesTarget
            ON Fact_SRCSalesTarget.DimStoreID = Fact_SalesActual.DimStoreID
            AND Fact_SRCSalesTarget.DimTargetDateID = Fact_SalesActual.DimSaleDateID
            
    WHERE 
        Fact_SRCSalesTarget.DimStoreID <> -1
    
    GROUP BY
      Dim_Product.ProductName,
      Dim_Product.ProductType,
      Dim_Product.ProductCategory,
      Dim_Store.StoreNumber,
      Dim_Channel.ChannelName,
      Dim_Date.Date,
      Dim_Date.Day_Name,
      Dim_Date.US_Holiday_Ind,
      Dim_Date.Month_Name,
      Dim_Date.Fiscal_Quarter,
      Dim_Date.Fiscal_Year,
      Dim_Location.Address,
      Dim_Location.City,
      Dim_Location.StateProvince,
      Dim_Product.ProductRetailPrice,
      Dim_Product.ProductWholesalePrice,
      Dim_Product.ProductCost,
      Fact_SRCSalesTarget.SalesTargetAmount;
      
-- View 3: Annual Bonus
CREATE OR REPLACE VIEW VIEW_CalculatedBonus

AS

SELECT DISTINCT
    Dim_Store.StoreNumber,
    Dim_Date.Date,
    Fact_SRCSalesTarget.SalesTargetAmount,
    Fact_SalesActual.SaleAmount,
    (Fact_SalesActual.SaleAmount)/(Fact_SRCSalesTarget.SalesTargetAmount) as percent_to_goal,
    (2000000/6) as bonus_2013,
    percent_to_goal * bonus_2013 as weighted_total
    
    
    FROM Fact_SalesActual
        INNER JOIN Dim_Date
            ON Fact_SalesActual.DimSaleDateID = Dim_Date.Date_PKEY
        INNER JOIN Dim_Store
            ON Dim_Store.DimStoreID = Fact_SalesActual.DimStoreID
        INNER JOIN Fact_SRCSalesTarget
            ON Fact_SRCSalesTarget.DimStoreID = Fact_SalesActual.DimStoreID
            AND Fact_SRCSalesTarget.DimTargetDateID = Fact_SalesActual.DimSaleDateID
     
     WHERE 
        Dim_Store.StoreNumber <> 'unknown';
     
-- View Target Sales Amount
CREATE OR REPLACE VIEW VIEW_TargetSales

AS

SELECT
    Stage_TargetCRS.Year
    ,Stage_TargetCRS.TargetName
    ,Stage_TargetCRS.TargetSalesAmount
FROM Stage_TargetCRS


-- View Target Quantity
CREATE OR REPLACE VIEW VIEW_TargetQuantity

AS

SELECT
    Dim_Product.ProductType
    ,Dim_Product.ProductCategory
    ,Stage_TargetProduct.Product
    ,Stage_TargetProduct.Year
    ,Stage_TargetProduct.SalesQuantityTarget
FROM Stage_TargetProduct
    INNER JOIN Dim_Product
        ON Dim_Product.DimProductID = Stage_TargetProduct.ProductID


-- View Store Product Sales
CREATE OR REPLACE VIEW VIEW_ProductSales

AS

SELECT 
		Dim_Store.StoreNumber
		,Dim_Product.ProductName
        ,Dim_Date.Date
        ,Dim_Date.Year
		,Dim_Date.Day_Name
        ,Dim_Date.US_Holiday_Ind
        ,Dim_Date.Month_Name
        ,SUM(Fact_SalesActual.Saletotalretailprofit) as SalesProfit
        ,SUM(Fact_SalesActual.SaleQuantity) AS SalesQuantity
        ,SUM(Fact_SalesActual.SaleAmount) AS SalesAmount
    FROM Fact_SalesActual
		INNER JOIN Dim_Store ON Fact_SalesActual.DimStoreID = Dim_Store.DimStoreID
		INNER JOIN Dim_Product ON Fact_SalesActual.DimProductID = Dim_Product.DimProductID
		INNER JOIN Dim_Date ON Fact_SalesActual.DimSaleDateID = Dim_Date.Date_Pkey
    WHERE Dim_Store.StoreNumber <> 'unknown'
	GROUP BY
		Dim_Store.StoreNumber
		,Dim_Product.ProductName
        ,Dim_Date.Date
        ,Dim_Date.Year
		,Dim_Date.Day_Name
        ,Dim_Date.US_Holiday_Ind
        ,Dim_Date.Month_Name
     ORDER BY Dim_Date.Date, Dim_Store.StoreNumber


-- 
SELECT * FROM Fact_ProductSalesTarget
SELECT * FROM Stage_SalesDetail 
SELECT * FROM Dim_Product
SELECT * FROm Fact_SalesActual

SELECT * FROM Fact_SRCSalesTarget

-- View Target Sales Amount
CREATE OR REPLACE VIEW VIEW_TargetSalesAmount
AS
SELECT
    Dim_Store.StoreNumber
    ,Dim_Date.Year
    ,(Fact_SRCSalesTarget.SalesTargetAmount)*365 as TargetAmount
    ,SUM(Fact_SalesActual.SaleAmount) AS SalesAmount
    
    FROM Dim_Date
        LEFT JOIN Fact_SRCSalesTarget
            ON Dim_Date.Date_PKEY = Fact_SRCSalesTarget.DimTargetDateID
        LEFT JOIN Dim_Store
            ON Dim_Store.DimStoreID = Fact_SRCSalesTarget.DimStoreID
        LEFT JOIN Fact_SalesActual
            ON Fact_SalesActual.DimStoreID = Dim_Store.DimStoreID
                AND
                Fact_SalesActual.DimSaleDateID = Dim_Date.Date_PKEY
    WHERE Dim_Store.StoreNumber <> 'unknown'  
    GROUP BY
        Dim_Store.StoreNumber
        ,Dim_Date.Year
        ,TargetAmount
    ORDER BY Dim_Store.StoreNumber

SELECT * FROM Fact_SalesActual

SELECT 
    DimStoreID
    ,SUM(SaleAmount)
    FROM Fact_SalesActual
    GROUP BY
    DimStoreID
    
SELECT * FROM Dim_Store
        
    

        
        

        

        