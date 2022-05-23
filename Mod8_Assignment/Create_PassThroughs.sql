-- Dim_Location

SELECT 
     DimLocationID
    ,SourceLocationID
    ,PostalCode
    ,Address
    ,City
    ,StateProvince
    ,Country
    ,Customer_Reseller_Store_ID
    
    FROM Dim_Location
    
-- Dim_Store

SELECT     
    DimStoreID
  , DimLocationID
  , SourceStoreID
  , StoreNumber
  , StoreManager
  
  FROM Dim_Store

-- Dim_Reseller

SELECT
    DimResellerID 
    , DimLocationID
    , SourceResellerID
    , ResellerName 
    , ContactName 
    , PhoneNumber 
    , Email 
    
    FROM Dim_Reseller
    
-- Dim_Customer

SELECT 
    DimLocationID  
    , SourceCustomerID 
    , FullName 
    , FirstName 
    , LastName 
    , Gender 
    , EmailAddress
    , PhoneNumber 
    
    FROM Dim_Customer
    
 -- Dim_Product
 SELECT 
    DimProductID
    , SourceProductID
    , SourceProductTypeID
    , SourceProductCategoryID
    , ProductName
    , ProductType
    , ProductCategory
    , ProductRetailPrice
    , ProductWholesalePrice
    , ProductCost
    , ProductRetailProfit
    , ProductWholeSaleUnitProfit
    , ProductRetailProfitMarginUnitPercent
    , ProductWholeSaleProfitMarginUnitPercent
    FROM Dim_Product
 
 -- Fact_ProductSalesTarget
 
 SELECT 
    DimProductID 
    , DimTargetDateID
    , ProductTargetSalesQuantity
    FROM Fact_ProductSalesTarget
 
 -- Fact_SRCSalesTarget
 SELECT 
    DimStoreID
    ,DimResellerID
    ,DimChannelID
    ,DimTargetDateID 
    ,SalesTargetAmount
    
    FROM Fact_SRCSalesTarget
 
 -- Fact_SalesActual
 SELECT 
     DimProductID
    ,DimStoreID
    ,DimResellerID
    ,DimCustomerID
    ,DimChannelID
    ,DimSaleDateID
    ,DimLocationID 
    ,SourceSalesHeaderID
    ,SourceSalesDetailID
    ,SaleAmount
    ,SaleQuantity
    ,SaleUnitPrice
    ,SaleExtendedCost
    ,SaleTotalRetailProfit
    ,SaleTotalWholesaleProfit
   
   FROM Fact_SalesActual