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
     


        
        

        

        