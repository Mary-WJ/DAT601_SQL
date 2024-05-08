--DROP TABLE Customer;
CREATE TABLE Customer
(
	CustID		CHAR(10)	NOT NULL PRIMARY KEY,
	CustName	CHAR(50)	NOT NULL,
	CustAddress	CHAR(50)	,
	CustCity	CHAR(50)	,
	CustContact	CHAR(50)	,
	CustPhone	CHAR(15)	,
	CustEmail	CHAR(255)	
);

--DROP TABLE OrderEntry;
CREATE TABLE OrderEntry
(
	OrderID		INTEGER		NOT NULL,
	OrderDate	DATETIME	NOT NULL,
	CustID		CHAR(10)	NOT NULL
);

--DROP TABLE Vendor;
CREATE TABLE Vendor
(
	VendorID		CHAR(10)	NOT NULL PRIMARY KEY,
	VendorName		CHAR(50)	NOT NULL,
	VendorAddress	CHAR(50)	,
	VendorCity		CHAR(50)	,
	VendorPhone		CHAR(15)
);

--DROP TABLE OrderItem;
CREATE TABLE OrderItem
(
	OrderID		INTEGER		NOT NULL PRIMARY KEY,
	OrderItem	INTEGER		NOT NULL,
	ProductID	CHAR(10)	NOT NULL,
	Quantity	INTEGER		NOT NULL,
	ItemPrice	DECIMAL(8,2)NOT NULL
);

--DROP TABLE Product;
CREATE TABLE Product
(
	ProductID		CHAR(10)	NOT NULL PRIMARY KEY,
	VendorID		CHAR(10)	NOT NULL,
	ProductName		CHAR(255)	NOT NULL,
	ProductPrice	DECIMAL(8,2)NOT NULL,
	ProductDesc		VARCHAR(100)		
);


INSERT INTO Customer(CustID,CustName,CustAddress,CustCity,CustPhone,CustContact,CustEmail)
VALUES('1000000001','Village Toys','200 Oak Lane','Wellington','09-389-2356','John Smith','sales@villagetoys.co.nz');

INSERT INTO Customer(CustID,CustName,CustAddress,CustCity,CustPhone,CustContact)
VALUES('1000000002','Kids Place','333 Tahunanui Drive','Nelson','03-545-6333','Michelle Green');

INSERT INTO Customer(CustID,CustName,CustAddress,CustCity,CustPhone,CustContact,CustEmail)
VALUES('1000000003','Fun4All','1 Sunny Place','Nelson','03-548-2285','Jim Jones','jjones@fun4all.co.nz');

INSERT INTO Customer(CustID,CustName,CustAddress,CustCity,CustPhone,CustContact,CustEmail)
VALUES('1000000004','Fun4All','829 Queen Street','Auckland','09-368-7894','Denise L. Stephens','dstephens@fun4all.co.nz');

INSERT INTO Customer(CustID,CustName,CustAddress,CustCity,CustPhone,CustContact)
VALUES('1000000005','The Toy Store','50 Papanui Road','Christchurch','04-345-4545','Kim Howard');


INSERT INTO OrderEntry(OrderID,OrderDate,CustID)
VALUES(20005,'1999/5/1','1000000001');

INSERT INTO OrderEntry(OrderID,OrderDate,CustID)
VALUES(20006,'1999/1/12','1000000003');

INSERT INTO OrderEntry(OrderID,OrderDate,CustID)
VALUES(20007,'1999/1/30','1000000004');

INSERT INTO OrderEntry(OrderID,OrderDate,CustID)
VALUES(20008,'1999/2/3','1000000005');

INSERT INTO OrderEntry(OrderID,OrderDate,CustID)
VALUES(20009, '1999/2/8','1000000001');


INSERT INTO Vendor(VendorID, VendorName, VendorAddress, VendorCity, VendorPhone)
VALUES('BRS01','Bears R Us','123 Main Street','Richmond','03-523-8871');

INSERT INTO Vendor(VendorID, VendorName, VendorAddress, VendorCity, VendorPhone)
VALUES('BRE02','Bear Emporium','500 Park Street','Auckland','06-396-8854');

INSERT INTO Vendor(VendorID, VendorName, VendorAddress, VendorCity, VendorPhone)
VALUES('DLL01','Doll House Inc.','555 High Street','Motueka','03-455-7898');

INSERT INTO Vendor(VendorID, VendorName, VendorAddress, VendorCity, VendorPhone)
VALUES('FRB01','Furball Inc.','1 Clifford Avenue','Nelson','03-546-9978');


INSERT INTO OrderItem(OrderID,OrderItem,ProductID,Quantity,ItemPrice)
VALUES(20005,1,'BR01',100,5.49);

INSERT INTO OrderItem(OrderID,OrderItem,ProductID,Quantity,ItemPrice)
VALUES(20005,2,'BR03',100,10.99);

INSERT INTO OrderItem(OrderID,OrderItem,ProductID,Quantity,ItemPrice)
VALUES(20006,1,'BR01',20,5.99);

INSERT INTO OrderItem(OrderID,OrderItem,ProductID,Quantity,ItemPrice)
VALUES(20006,2,'BR02',10,8.99);

INSERT INTO OrderItem(OrderID,OrderItem,ProductID,Quantity,ItemPrice)
VALUES(20006,3,'BR03',10,11.99);

INSERT INTO OrderItem(OrderID,OrderItem,ProductID,Quantity,ItemPrice)
VALUES(20007,1,'BR03',50,11.49);

INSERT INTO OrderItem(OrderID,OrderItem,ProductID,Quantity,ItemPrice)
VALUES(20007,2,'BNBG01',100,2.99);

INSERT INTO OrderItem(OrderID,OrderItem,ProductID,Quantity,ItemPrice)
VALUES(20007,3,'BNBG02',100,2.99);

INSERT INTO OrderItem(OrderID,OrderItem,ProductID,Quantity,ItemPrice)
VALUES(20007,4,'BNBG03',100,2.99);

INSERT INTO OrderItem(OrderID,OrderItem,ProductID,Quantity,ItemPrice)
VALUES(20007,5,'RGAN01',50,4.49);

INSERT INTO OrderItem(OrderID,OrderItem,ProductID,Quantity,ItemPrice)
VALUES(20008,1,'RGAN01',5,4.99);

INSERT INTO OrderItem(OrderID,OrderItem,ProductID,Quantity,ItemPrice)
VALUES(20008,2,'BR03',5,11.99);

INSERT INTO OrderItem(OrderID,OrderItem,ProductID,Quantity,ItemPrice)
VALUES(20008,3,'BNBG01',10,3.49);

INSERT INTO OrderItem(OrderID,OrderItem,ProductID,Quantity,ItemPrice)
VALUES(20008,4,'BNBG02',10,3.49);

INSERT INTO OrderItem(OrderID,OrderItem,ProductID,Quantity,ItemPrice)
VALUES(20008,5,'BNBG03',10,3.49);

INSERT INTO OrderItem(OrderID,OrderItem,ProductID,Quantity,ItemPrice)
VALUES(20009,1,'BNBG01',250,2.49);

INSERT INTO OrderItem(OrderID,OrderItem,ProductID,Quantity,ItemPrice)
VALUES(20009,2,'BNBG02',250,2.49);

INSERT INTO OrderItem(OrderID,OrderItem,ProductID,Quantity,ItemPrice)
VALUES(20009,3,'BNBG03',250,2.49);


INSERT INTO Product(ProductID, VendorID, ProductName, ProductPrice, ProductDesc)
VALUES('BR01', 'BRS01', '8 inch teddy bear',5.99,'8 inch teddy bear, comes with cap and jacket');

INSERT INTO Product(ProductID, VendorID, ProductName, ProductPrice, ProductDesc)
VALUES('BR02', 'BRS01', '12 inch teddy bear',8.99,'12 inch teddy bear, comes with cap and jacket');

INSERT INTO Product(ProductID, VendorID, ProductName, ProductPrice, ProductDesc)
VALUES('BR03', 'BRS01', '18 inch teddy bear',11.99,'18 inch teddy bear, comes with cap and jacket');

INSERT INTO Product(ProductID, VendorID, ProductName, ProductPrice, ProductDesc)
VALUES('BNBG01', 'DLL01', 'Fish bean bag toy',3.49,'Fish bean bag toy, complete with bean bag worms with which to feed it');

INSERT INTO Product(ProductID, VendorID, ProductName, ProductPrice, ProductDesc)
VALUES('BNBG02', 'DLL01', 'Bird bean bag toy',3.49,'Bird bean bag toy, eggs are not included');

INSERT INTO Product(ProductID, VendorID, ProductName, ProductPrice, ProductDesc)
VALUES('BNBG03', 'DLL01', 'Rabbit bean bag toy',3.49,'Rabbit bean bag toy, comes with bean bag carrots');

INSERT INTO Product(ProductID, VendorID, ProductName, ProductPrice, ProductDesc)
VALUES('RGAN01', 'DLL01', 'Raggedy Ann',4.99,'18 inch Raggedy Ann doll');




--start here

ALTER TABLE OrderEntry
ADD CONSTRAINT FK_OrderEntry_Customer
FOREIGN KEY (CustID) 
REFERENCES Customer (CustID);


ALTER TABLE OrderItem
ADD CONSTRAINT FK_OrderItem_OrderEntry
FOREIGN KEY (OrderID) 
REFERENCES OrderEntry (OrderID);

ALTER TABLE OrderItem
ADD CONSTRAINT FK_OrderItem_Product
FOREIGN KEY (ProductID) 
REFERENCES Product (ProductID);


ALTER TABLE Product
ADD CONSTRAINT FK_Product_Vendor
FOREIGN KEY (VendorID) 
REFERENCES Vendor (VendorID);


--Question 1
SELECT VendorID, ProductName
FROM Product
WHERE VendorID <> 'DLL01';

--question 2
SELECT ProductName, ProductPrice
FROM Product
WHERE ProductPrice BETWEEN 5.00 AND 10.00;

--question 3
SELECT VendorID, ProductName, ProductPrice
FROM Product
WHERE (VendorID = 'DLL01' OR VendorID = 'BRS01') AND ProductPrice >= 10.00;

--question 4
SELECT 
CAST(AVG(ProductPrice) AS DECIMAL(8,4)) AS 'Average Product Price'
FROM Product;


--question 5
SELECT 
COUNT(*) AS TotalCustomers
FROM Customer;

--question 6
SELECT 
COUNT(CustEmail) AS CustomersWithEmail
FROM Customer;

--question 7
SELECT 
COUNT(ProductID) AS ProductTypes,
CAST(MIN(ProductPrice) AS DECIMAL(8,4)) AS MinPrice,
CAST(MAX(ProductPrice) AS DECIMAL(8,4)) AS MaxPrice,
CAST(AVG(ProductPrice) AS DECIMAL(8,4)) AS AvgPrice
FROM Product;


--question 8
SELECT 
v.VendorName, 
p.ProductName, 
p.ProductPrice
FROM Product p, Vendor v
WHERE p.VendorID = v.VendorID;



--question 9
SELECT 
p.ProductName, 
v.VendorName, 
p.ProductPrice,
oi.Quantity
FROM 
OrderItem oi, 
Product p, 
Vendor v
WHERE oi.ProductID = p.ProductID 
AND p.VendorID = v.VendorID 
AND oi.OrderID = 20007;


--question 10
--part 1
SELECT OrderID
FROM OrderItem
WHERE ProductID = 'RGAN01';

--part2
SELECT CustID
FROM OrderEntry
WHERE OrderID IN (
    SELECT OrderID
    FROM OrderItem
    WHERE ProductID = 'RGAN01'
);


SELECT CustName, CustContact
FROM Customer
WHERE CustID IN (
SELECT CustID
FROM OrderEntry
WHERE OrderID IN (
        SELECT OrderID
        FROM OrderItem
        WHERE ProductID = 'RGAN01'
    )
);


SELECT CustName, CustContact
FROM Customer
WHERE 
CustID IN (
SELECT CustID
FROM OrderEntry
WHERE OrderID IN (
      SELECT OrderID
      FROM OrderItem
      WHERE ProductID = 'RGAN01'
    )
);


SELECT CustID, CustName, CustCity
FROM Customer;



SELECT
c.CustName,
c.CustCity,
COUNT(o.OrderID) AS TotalOrders
FROM  Customer c
LEFT JOIN OrderEntry o ON c.CustID = o.CustID
GROUP BY
c.CustName, c.CustCity
ORDER BY
c.CustName;



SELECT CustName, CustContact, CustEmail
FROM Customer
WHERE CustCity IN ('Nelson', 'Wellington')
UNION
SELECT CustName, CustContact, CustEmail
FROM  Customer
WHERE CustName = 'Fun4All'
ORDER BY  CustName, CustContact;





--13 
CREATE VIEW vProductCustomer AS
SELECT
    c.CustName,
    c.CustContact,
    c.CustEmail,
    c.CustCity,
    oe.OrderID,
    oi.ProductID,
    p.ProductName
FROM
    Customer c
JOIN
    OrderEntry oe ON c.CustID = oe.CustID
JOIN
    OrderItem oi ON oe.OrderID = oi.OrderID
JOIN
    Product p ON oi.ProductID = p.ProductID;


SELECT CustName,  CustContact
FROM  vProductCustomer
WHERE  ProductID = 'RGAN01';






--last part

INSERT INTO Customer (CustID, CustName, CustPhone)
VALUES ('1000000006', 'The Toy Emporium', '09-546-8552');




