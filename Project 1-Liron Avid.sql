--Name:Liron Avid
--Date:23.4.2023
--Project_1

--creating new database
USE master

CREATE DATABASE Project_1
GO
USE Project_1

--Creating the TABLES in the DATABASE. First the the tables without Foreign Keys.
--creating TABLE 'SalesTerritory'
Create table SalesTerritory
(
TerritoryID int Constraint SalesTerritory_TerritoryID_PK Primary Key,
Name nvarchar(50) Not Null,
CountryRegionCode nvarchar(3) Not Null,
[Group] nvarchar(50) Not Null,
SalesYTD money Not Null,
SalesLastYear money Not Null,
CostYTD money Not Null,
CostLastYear money Not Null,
ModifiedDate datetime Not Null,
Constraint SalesTerritory_Name_ck check (len(Name)>=2),
Constraint SalesTerritory_Group_ck check (len([Group])>=2)
)

--creating TABLE 'CreditCard'
Create table CreditCard
(
CreditCardID int Constraint CreditCard_CreditCardID_PK Primary Key,
CardType nvarchar(50) Not Null,
CardNumber nvarchar(25) Not Null,
ExpMonth tinyint Not Null,
ExpYear smallint Not Null,
ModifiedDate datetime Not Null,
Constraint CreditCard_Cardnumber_ck check (len(CardNumber)=14),
Constraint CreditCard_Cardnumber_uk unique (CardNumber),
Constraint CreditCard_ExpMonth_ck check (ExpMonth Between 1 AND 12),
Constraint CreditCard_ExpYear_ck check (ExpYear Like '20__')
)

--creating TABLE 'Addres'
Create table Address
(
AddressID int Constraint Address_AddressID_PK Primary Key,
AddressLine1 nvarchar(60) Not Null,
AddressLine2 nvarchar(65) ,
City nvarchar(30) Not Null,
StateProvinceID int Not Null,
PostalCode nvarchar(15) Not Null,
ModifiedDate datetime Not Null,
Constraint Address_AddressLine1_ck check (len(AddressLine1)>=2),
Constraint Address_City_ck check (len(City)>=2)
)

--creating TABLE 'ShipMethod'
Create table ShipMethod
(
ShipMethodID int Constraint ShipMethod_ShipMethodID_PK Primary Key,
Name nvarchar(50) Not Null,
ShipBase money Not Null,
ShipRate money Not Null,
ModifiedDate datetime Not Null,
Constraint ShipMethod_Name_ck check (len(Name)>=2)
)

--creating TABLE 'CurrencytRate'
Create table CurrencytRate
(
CurrencytRateID int Constraint CurrencytRate_CurrencytRateID_PK Primary Key,
CurrencytRateDate datetime Not Null,
FromCurrencyCode nchar(3) Not Null,
ToCurrencyCode nchar(3) Not Null,
AverageRate money Not Null,
EndOfDayRate money Not Null,
ModifiedDate datetime Not Null,
)

-- Creating TABLE 'SpecialOfferProducte'
Create table SpecialOfferProduct
(
SpecialOfferID int,
ProductID int,
ModifiedDate datetime Not Null,
 Constraint SpecialOfferProduct_SpecialOfferProductID_PK Primary Key (SpecialOfferID,ProductID)
)

--Creating the tables *With* Foreign Keys
--Creating TABLE 'SalesPerson' with Foregin Key to the table 'SalesTerritory'

Create table SalesPerson
(
BusinessEntityID int Constraint SalesPerson_BusinessEntityID_PK Primary Key,
TerritoryID int,
SalesQuota money,
Bonus money Not Null,
CommissionPct smallmoney Not Null,
SalesYTD money Not Null,
SalesLastYear money Not Null,
ModifiedDate datetime Not Null,
constraint SalesPerson_TerritoryID_fk Foreign key (TerritoryID) REFERENCES SalesTerritory(TerritoryID),
)

--Creating TABLE 'Customer' with Foregin Key to the table 'SalesTerritory'

Create table Customer
(
CustomerID int Constraint Customer_CustomerID_PK Primary Key,
PersonID int,
StoreID int,
TerritoryID int,
ModifiedDate datetime Not Null,
constraint Customer_TerritoryID_fk Foreign key (TerritoryID) REFERENCES SalesTerritory(TerritoryID),
)


/* Creating TABLE 'SalesOrderHeader' with Foregin Keys to the tables:
'Customer','SalesPerson','SalesTerritory','Address','ShipMethode','CreditCard','CurrencyRate'
*/

Create table SalesOrderHeader
(
SalesOrderID int Constraint SalesOrderHeader_SalesOrderHeaderID_PK Primary Key,
RevisionNumber tinyint Not Null,
OrderDate datetime Not Null,
DueDate datetime Not Null,
ShipDate datetime,
Status tinyint,
OnlineOrderFlag bit Not Null,
SalesOrderNumber nvarchar(25) Not Null,
PurchaseOrderNumber nvarchar(25),
AccountNumber nvarchar(15),
CustomerID int Not Null,
SalesPersonID int,
TerritoryID int,
BillToAddressID int Not Null,
ShipToAddressID int Not Null,
ShipMethodID int Not Null,
CreditCardID int,
CreditCardApprovalCode varchar(15),
CurrencytRateID int,
SubTotal money Not Null,
TaxAmt  money Not Null,
Freight  money Not Null,

constraint SalesOrderHeader_CustomerID_fk Foreign key (CustomerID) REFERENCES Customer(CustomerID),
constraint SalesOrderHeader_SalesPersonID_fk Foreign key (SalesPersonID) REFERENCES SalesPerson(BusinessEntityID),
constraint SalesOrderHeader_TerritoryID_fk Foreign key (TerritoryID) REFERENCES SalesTerritory(TerritoryID),
constraint SalesOrderHeader_ShipToAddressID_fk Foreign key (ShipToAddressID) REFERENCES Address(AddressID),
constraint SalesOrderHeader_ShipMethodID_fk Foreign key (ShipMethodID) REFERENCES ShipMethod(ShipMethodID),
constraint SalesOrderHeader_CreditCardID_fk Foreign key (CreditCardID) REFERENCES CreditCard(CreditCardID),
constraint SalesOrderHeader_CurrencytRateID_fk Foreign key (CurrencytRateID) REFERENCES CurrencytRate(CurrencytRateID),


)

--Creating TABLE 'SalesOrderDetail' with Foregin Key to the tables 'SalesOrderHeader','SpecialOfferProducte'

Create table SalesOrderDetail
(
SalesOrderID int,
SalesOrderDetailID int,
CarrierTrackingNumber nvarchar(25),
OrderQty smallint Not Null,
ProducteID int Not Null,
SpecialOfferID int Not Null,
UnitPrice money  Not Null,
UnitPriceDiscount money  Not Null,
ModifiedDate datetime Not Null,
 constraint SalesOrderDetail_SalesOrderIDSalesOrderDetailID_PK Primary Key (SalesOrderID,SalesOrderDetailID),
 constraint SalesOrderDetail_SalesOrderID_fk Foreign key (SalesOrderID) REFERENCES SalesOrderHeader(SalesOrderID),
 constraint SalesOrderDetail_SpecialOfferIDProducteID_fk Foreign key (SpecialOfferID,ProducteID) REFERENCES SpecialOfferProduct(SpecialOfferID,ProductID),

)

-- inserting data from Temporery tables to created Tables

insert into SalesTerritory(TerritoryID,Name,CountryRegionCode,[Group] ,SalesYTD,SalesLastYear,CostYTD,CostLastYear,ModifiedDate)
Select TerritoryID,Name,CountryRegionCode,[Group],SalesYTD,SalesLastYear,CostYTD,CostLastYear,ModifiedDate
From TempSalesTerritory

insert into CreditCard(CreditCardID,CardType,CardNumber,ExpMonth,ExpYear,ModifiedDate)
Select CreditCardID,CardType,CardNumber,ExpMonth,ExpYear,ModifiedDate
From TempCreditCard

insert into Address(AddressID,AddressLine1,AddressLine2,City,StateProvinceID,PostalCode,ModifiedDate)
Select AddressID ,AddressLine1,AddressLine2,City,StateProvinceID,PostalCode,ModifiedDate 
From TempAddress 

insert into ShipMethod(ShipMethodID,Name,ShipBase,ShipRate,ModifiedDate)
Select ShipMethodID,Name,ShipBase,ShipRate,ModifiedDate
From TempShipMethod

insert into CurrencytRate(CurrencytRateID,CurrencytRateDate,FromCurrencyCode,ToCurrencyCode,AverageRate,EndOfDayRate,ModifiedDate)
Select CurrencyRateID,CurrencyRateDate,FromCurrencyCode,ToCurrencyCode,AverageRate,EndOfDayRate,ModifiedDate
From TempCurremcyRate

insert into SpecialOfferProduct(SpecialOfferID,ProductID,ModifiedDate)
Select SpecialOfferID,ProductID,ModifiedDate
From TempSpecialOfferProduct

insert into SalesPerson(BusinessEntityID,TerritoryID,SalesQuota,Bonus,CommissionPct,SalesYTD,SalesLastYear,ModifiedDate)
Select BusinessEntityID,TerritoryID,SalesQuota,Bonus,CommissionPct,SalesYTD,SalesLastYear,ModifiedDate
From TempSalesPerson


insert into Customer(CustomerID,PersonID,StoreID,TerritoryID,ModifiedDate)
Select CustomerID,PersonID,StoreID,TerritoryID,ModifiedDate
From Tempcustomer


insert into SalesOrderHeader(SalesOrderID,RevisionNumber,OrderDate,DueDate,ShipDate,Status,OnlineOrderFlag,SalesOrderNumber,PurchaseOrderNumber,AccountNumber,CustomerID,SalesPersonID,TerritoryID,BillToAddressID,ShipToAddressID,ShipMethodID,CreditCardID,CreditCardApprovalCode,SubTotal,TaxAmt,Freight)
Select SalesOrderID,RevisionNumber,OrderDate,DueDate,ShipDate,Status,OnlineOrderFlag,SalesOrderNumber,PurchaseOrderNumber,AccountNumber,CustomerID,SalesPersonID,TerritoryID,BillToAddressID,ShipToAddressID,ShipMethodID,CreditCardID,CreditCardApprovalCode,SubTotal,TaxAmt,Freight
From TempSalesOrderHeader

insert into SalesOrderDetail(SalesOrderID,SalesOrderDetailID,CarrierTrackingNumber,OrderQty,ProducteID,SpecialOfferID,UnitPrice,UnitPriceDiscount,ModifiedDate)
Select SalesOrderID,SalesOrderDetailID,CarrierTrackingNumber,OrderQty,ProductID,SpecialOfferID,UnitPrice,UnitPriceDiscount,ModifiedDate
From TempSalesOrderDetail