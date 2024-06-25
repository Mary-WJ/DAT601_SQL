USE master;
go
DROP DATABASE IF EXISTS FlightStream
go
CREATE DATABASE FlightStream  
go
USE FlightStream
go
--The above code is needed when creating database



--tables
CREATE TABLE Configuration_Type(
    TypeID INT IDENTITY(1,1) PRIMARY KEY, --Identity(1,1) start at 1 and go up by one
    ConfigurationName VARCHAR(30) NOT NULL,
    ParentConfigurationTypeID INT NULL,
    FOREIGN KEY (ParentConfigurationTypeID) REFERENCES Configuration_Type(TypeID) --self reference
);

CREATE TABLE AccessPrivilege(
    AccessPrivilegeID INT IDENTITY(1,1) PRIMARY KEY,
    PrivilegeLevel VARCHAR(80)
);


CREATE TABLE Staff(
    StaffID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Phone VARCHAR(15) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE Maintenance(
	StaffID INT PRIMARY KEY,
	MaintenanceDate DATE,
	FOREIGN KEY(StaffID) REFERENCES Staff(StaffID)
);

CREATE TABLE Salesperson(
	 StaffID INT PRIMARY KEY,
	 SalesTarget DECIMAL(15,2) NULL,
	 YearsExperience INT NULL,
	 FOREIGN KEY(StaffID) REFERENCES Staff(StaffID)
);

CREATE TABLE AdministrativeExecutives(
  StaffID INT PRIMARY KEY,
  Title VARCHAR(100) NULL,
  FOREIGN KEY (StaffID) REFERENCES Staff(StaffID)
);

CREATE TABLE Supplier(
    SupplierID INT IDENTITY(1,1) PRIMARY KEY,
    SupplierName VARCHAR(100) NOT NULL,
    Phone VARCHAR(15) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    SupplierAddress VARCHAR(255) NOT NULL  --change address to SupplierAddress
);



--dependent tables 
CREATE TABLE DataScoop(
    DataScoopID INT IDENTITY(1,1) PRIMARY KEY,
    CurrentAltitude DECIMAL(10, 2) NOT NULL,
    CurrentLongitude DECIMAL(10, 6) NOT NULL,
    CurrentLatitude DECIMAL(10, 6) NOT NULL,
    LastMaintenanceDate DATE NOT NULL,
    NextMaintenanceDate DATE NOT NULL,
    OnBoardRetentionPeriod INT NOT NULL,
    Configuration_TypeID INT NOT NULL,
    FOREIGN KEY (Configuration_TypeID) REFERENCES Configuration_Type(TypeID)
);


CREATE TABLE DSZone( --change Zone to DSZone due to is keyword)
	ZoneID INT IDENTITY(1,1) NOT NULL PRIMARY KEY, 
	Name VARCHAR(100) NOT NULL, 
	Location VARCHAR(255) NOT NULL, 
    DataScoopID INT,
	FOREIGN KEY(DataScoopID) REFERENCES DataScoop (DataScoopID)
);


CREATE TABLE Part(
    PartNumber INT IDENTITY(1,1) PRIMARY KEY,
    PartName VARCHAR(50) NOT NULL,
    LastMaintenanceDate DATE NOT NULL,
    NextMaintenanceDate DATE NOT NULL,
    DataScoopID INT NOT NULL,
    FOREIGN KEY (DataScoopID) REFERENCES DataScoop(DataScoopID)
);


CREATE TABLE Subscription(  --is a base class for subscription type
	SubscriptionID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	StartDate DATE NOT NULL,
	EndDate DATE NOT NULL,
	SubscriptionFee DECIMAL(8,2) NOT NULL,
	Discount DECIMAL(4,2) NULL,
	SubscriptionName VARCHAR(30) NOT NULL, --this is the type of subscription name
	StaffID INT,
	--AccessPriviledgeID INT, --wrong spelling mistake
	FOREIGN KEY (StaffID) REFERENCES Staff(StaffID), 
	--FOREIGN KEY (AccessPriviledgeID) REFERENCES AccessPrivilege(AccessPrivilegeID) --wrong spelling mistake
);

--Subtype Standard
CREATE TABLE StandardSubscription (
    SubscriptionID INT PRIMARY KEY,
	AccessPrivilegeID INT,
    FOREIGN KEY (SubscriptionID) REFERENCES Subscription(SubscriptionID),
	FOREIGN KEY (AccessPrivilegeID) REFERENCES AccessPrivilege (AccessPrivilegeID)
);

-- Create 'Gold' subtype table
CREATE TABLE GoldSubscription (
    SubscriptionID INT PRIMARY KEY,
	AccessPrivilegeID INT,
    FOREIGN KEY (SubscriptionID) REFERENCES Subscription(SubscriptionID),
	FOREIGN KEY (AccessPrivilegeID) REFERENCES AccessPrivilege (AccessPrivilegeID)
);

-- Create 'Platinum' subtype table
CREATE TABLE PlatinumSubscription (
    SubscriptionID INT PRIMARY KEY,
	AccessPrivilegeID INT,
    FOREIGN KEY (SubscriptionID) REFERENCES Subscription(SubscriptionID),
	FOREIGN KEY (AccessPrivilegeID) REFERENCES AccessPrivilege (AccessPrivilegeID)
);

-- Create 'Super Platinum' subtype table
CREATE TABLE SuperPlatinumSubscription (
    SubscriptionID INT PRIMARY KEY,
	AccessPrivilegeID INT,
    FOREIGN KEY (SubscriptionID) REFERENCES Subscription(SubscriptionID),
	FOREIGN KEY (AccessPrivilegeID) REFERENCES AccessPrivilege (AccessPrivilegeID)
);


CREATE TABLE Subscriber (
    SubscriberID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Phone VARCHAR(15),
    SubscriberAddress VARCHAR(255) NOT NULL, --change address to SubscriberAddress
    StaffID INT,
    SubscriptionID INT,
    FOREIGN KEY (StaffID) REFERENCES Staff(StaffID),
    FOREIGN KEY (SubscriptionID) REFERENCES Subscription(SubscriptionID)
);

CREATE TABLE Account(
    AccountID INT IDENTITY(1,1) PRIMARY KEY,
    CreatedAt DATETIME NOT NULL,
	SubscriberID INT,
	FOREIGN KEY (SubscriberID) REFERENCES Subscriber(SubscriberID)
);


CREATE TABLE VideoStream (
    VideoStreamID INT IDENTITY(1,1) PRIMARY KEY,
    VideoStreamDescription VARCHAR(255), --change description to videostreamDescription
    ZoneID INT,
    AccessPrivilegeID INT,
    FOREIGN KEY (ZoneID) REFERENCES DSZone(ZoneID),
    FOREIGN KEY (AccessPrivilegeID) REFERENCES AccessPrivilege(AccessPrivilegeID)
);


CREATE TABLE SensedData (
    SensedDataID INT IDENTITY(1,1) PRIMARY KEY,
    TimeCollected DATETIME NOT NULL,
    Temperature DECIMAL(6, 2) NOT NULL,
    Humidity DECIMAL(6, 2) NOT NULL,
    AmbientLightStrength DECIMAL(15, 5) NOT NULL,
    OrganicSpectralData DECIMAL(15, 5) NOT NULL,
    Latitude DECIMAL(10, 6) NOT NULL,
    Longitude DECIMAL(10, 6) NOT NULL,
    Altitude DECIMAL(10, 2) NOT NULL,
    ZoneID INT,
    DataScoopID INT,
    FOREIGN KEY (ZoneID) REFERENCES DSZone(ZoneID),
    FOREIGN KEY (DataScoopID) REFERENCES DataScoop(DataScoopID)
);


--linking tables

CREATE TABLE VideoStreamSubscriber (
    VideoStreamID INT NOT NULL,
    SubscriberID INT NOT NULL,
    PRIMARY KEY (VideoStreamID, SubscriberID),
    FOREIGN KEY (VideoStreamID) REFERENCES VideoStream(VideoStreamID),
    FOREIGN KEY (SubscriberID) REFERENCES Subscriber(SubscriberID)
);

CREATE TABLE SubscriptionAccessPrivilege (
    SubscriptionID INT NOT NULL,
    AccessPrivilegeID INT NOT NULL,
    PRIMARY KEY (SubscriptionID, AccessPrivilegeID),
    FOREIGN KEY (SubscriptionID) REFERENCES Subscription(SubscriptionID),
    FOREIGN KEY (AccessPrivilegeID) REFERENCES AccessPrivilege(AccessPrivilegeID)
);


CREATE TABLE ZoneSubscriber (
    ZoneID INT NOT NULL,
    SubscriberID INT NOT NULL,
    PRIMARY KEY (ZoneID, SubscriberID),
    FOREIGN KEY (ZoneID) REFERENCES DSZone(ZoneID),
    FOREIGN KEY (SubscriberID) REFERENCES Subscriber(SubscriberID)
);


CREATE TABLE DataScoopSubscriber (
    DataScoopID INT NOT NULL,
    SubscriberID INT NOT NULL,
    PRIMARY KEY (DataScoopID, SubscriberID),
    FOREIGN KEY (DataScoopID) REFERENCES DataScoop(DataScoopID),
    FOREIGN KEY (SubscriberID) REFERENCES Subscriber(SubscriberID)
);

CREATE TABLE SubscriptionDataScoop (
    SubscriptionID INT NOT NULL,
    DataScoopID INT NOT NULL,
    PRIMARY KEY (SubscriptionID, DataScoopID),
    FOREIGN KEY (SubscriptionID) REFERENCES Subscription(SubscriptionID),
    FOREIGN KEY (DataScoopID) REFERENCES DataScoop(DataScoopID)
);


CREATE TABLE PartSupplier (
    PartNumber INT NOT NULL,
    SupplierID INT NOT NULL,
    PRIMARY KEY (PartNumber, SupplierID),
    FOREIGN KEY (PartNumber) REFERENCES Part(PartNumber),
    FOREIGN KEY (SupplierID) REFERENCES Supplier(SupplierID)
);


CREATE TABLE SubscriptionZone (
    SubscriptionID INT NOT NULL,
    ZoneID INT NOT NULL,
    PRIMARY KEY (SubscriptionID, ZoneID),
    FOREIGN KEY (SubscriptionID) REFERENCES Subscription(SubscriptionID),
    FOREIGN KEY (ZoneID) REFERENCES DSZone(ZoneID)
);

CREATE TABLE SensedDataSubscriber (
    SensedDataID INT NOT NULL,
    SubscriberID INT NOT NULL,
    PRIMARY KEY (SensedDataID, SubscriberID),
    FOREIGN KEY (SensedDataID) REFERENCES SensedData(SensedDataID),
    FOREIGN KEY (SubscriberID) REFERENCES Subscriber(SubscriberID)
);






--RUN from here


--For Configuration_Type table
--populate ConfigurationType table with hierarchy
INSERT INTO Configuration_Type (ConfigurationName, ParentConfigurationTypeID) VALUES ('Jungle', NULL);
INSERT INTO Configuration_Type (ConfigurationName, ParentConfigurationTypeID) VALUES ('Forest', NULL);
INSERT INTO Configuration_Type (ConfigurationName, ParentConfigurationTypeID) VALUES ('Savannahs', NULL);

--Extreme Cold has sub categories
INSERT INTO Configuration_Type (ConfigurationName, ParentConfigurationTypeID) VALUES ('Extreme Cold', NULL);

-- Insert subcategories under Extreme Cold
DECLARE @ParentID INT; --for storing a variable call ParentID
SET @ParentID = (SELECT TypeID FROM Configuration_Type WHERE ConfigurationName = 'Extreme Cold');

INSERT INTO Configuration_Type (ConfigurationName, ParentConfigurationTypeID) VALUES ('Ice and Snow', @ParentID);
INSERT INTO Configuration_Type (ConfigurationName, ParentConfigurationTypeID) VALUES ('Mountain', @ParentID);
INSERT INTO Configuration_Type (ConfigurationName, ParentConfigurationTypeID) VALUES ('Desert', @ParentID);
INSERT INTO Configuration_Type (ConfigurationName, ParentConfigurationTypeID) VALUES ('Urban', @ParentID);


--AccessPrivilege table
INSERT INTO AccessPrivilege (PrivilegeLevel) VALUES ('Standard Video Access');
INSERT INTO AccessPrivilege (PrivilegeLevel) VALUES ('Gold Video Access');
INSERT INTO AccessPrivilege (PrivilegeLevel) VALUES ('Platinum Video Access');
INSERT INTO AccessPrivilege (PrivilegeLevel) VALUES ('Super Platinum Video Access');



--Staff table
insert into Staff (FirstName, LastName, Phone, Email) values ('Caro', 'Fowlestone', '956-818-9126', 'cfowlestone0@163.com');
insert into Staff (FirstName, LastName, Phone, Email) values ('Denney', 'Clayfield', '776-537-9561', 'dclayfield1@cdc.gov');
insert into Staff (FirstName, LastName, Phone, Email) values ('Latashia', 'Clemencon', '244-823-8853', 'lclemencon2@taobao.com');
insert into Staff (FirstName, LastName, Phone, Email) values ('Jori', 'Lehemann', '701-864-1209', 'jlehemann3@senate.gov');
insert into Staff (FirstName, LastName, Phone, Email) values ('Katine', 'Lemonby', '335-371-9039', 'klemonby4@multiply.com');
insert into Staff (FirstName, LastName, Phone, Email) values ('Jemmy', 'Tuley', '360-806-8045', 'jtuley5@phoca.cz');
insert into Staff (FirstName, LastName, Phone, Email) values ('Cloris', 'Yegorshin', '651-838-8151', 'cyegorshin6@accuweather.com');
insert into Staff (FirstName, LastName, Phone, Email) values ('Teddy', 'MacTerlagh', '367-867-3966', 'tmacterlagh7@washington.edu');
insert into Staff (FirstName, LastName, Phone, Email) values ('Nancy', 'Simester', '890-888-2560', 'nsimester8@oracle.com');
insert into Staff (FirstName, LastName, Phone, Email) values ('Broderic', 'Creffeild', '490-743-7873', 'bcreffeild9@nih.gov');

INSERT INTO Maintenance (StaffID, MaintenanceDate)
VALUES 
(1, '2024-03-28'),
(2, '2024-06-29'),
(5, '2024-09-13'),
(7, '2024-08-05');

-- Insert values into Salesperson table
INSERT INTO Salesperson (StaffID, SalesTarget, YearsExperience)
VALUES 
(3, NULL, 10),
(2, 204930.00, 6),
(6, 100000.00, 5),
(8, 34832.00, 9),
(1, NULL, 8);


-- Insert values into AdministrativeExecutives table
INSERT INTO AdministrativeExecutives (StaffID, Title)
VALUES 
(2, 'AdministrativeExecutives'),
(4, 'AdministrativeExecutives'),
(7, 'AdministrativeExecutives');


--Supplier Table
insert into Supplier (SupplierName, Phone, Email, SupplierAddress) values ('Myworks', '460-973-4226', 'afleote0@hubpages.com', '5 Merrick Pass');
insert into Supplier (SupplierName, Phone, Email, SupplierAddress) values ('Trunyx', '357-219-4105', 'tmaultby1@gnu.org', '50768 Memorial Park');
insert into Supplier (SupplierName, Phone, Email, SupplierAddress) values ('Thoughtmix', '254-744-9185', 'ebescoby2@cornell.edu', '34023 Hayes Point');
insert into Supplier (SupplierName, Phone, Email, SupplierAddress) values ('Tekfly', '266-851-2913', 'dburmingham3@wikispaces.com', '86476 Hagan Street');
insert into Supplier (SupplierName, Phone, Email, SupplierAddress) values ('Jayo', '988-425-3161', 'astrothers4@dion.ne.jp', '737 8th Park');
insert into Supplier (SupplierName, Phone, Email, SupplierAddress) values ('Zoomdog', '253-189-0609', 'hbendin5@tmall.com', '88256 Gina Park');
insert into Supplier (SupplierName, Phone, Email, SupplierAddress) values ('Thoughtworks', '143-101-2527', 'rkeri6@e-recht24.de', '36831 Charing Cross Center');
insert into Supplier (SupplierName, Phone, Email, SupplierAddress) values ('Eamia', '786-369-9107', 'jmaddocks7@simplemachines.org', '4790 Eliot Center');
insert into Supplier (SupplierName, Phone, Email, SupplierAddress) values ('Tazz', '472-585-6057', 'mrudwell8@odnoklassniki.ru', '5977 Ridgeway Trail');
insert into Supplier (SupplierName, Phone, Email, SupplierAddress) values ('Edgeclub', '313-574-1095', 'istormes9@xinhuanet.com', '96 Fair Oaks Alley');


--correct the reference name in datascoop
-- Rename the column in DataScoop table
EXEC sp_rename 'DataScoop.Configuration_TypeID', 'TypeID', 'COLUMN';


--DataScoop populate table
-- Insert values into DataScoop table with subcategories and 5-year maintenance difference
INSERT INTO DataScoop (CurrentAltitude, CurrentLongitude, CurrentLatitude, LastMaintenanceDate, NextMaintenanceDate, OnBoardRetentionPeriod, TypeID)
VALUES 
(1000.00, 120.123456, 45.123456, '2024-01-01', DATEADD(YEAR, 5, '2019-01-01'), 30, 1),  -- Jungle
(2000.00, 121.123456, 46.123456, '2015-02-01', DATEADD(YEAR, 5, '2015-02-01'), 30, 8),  -- Forest
(3000.00, 122.123456, 47.123456, '2019-03-01', DATEADD(YEAR, 5, '2019-03-01'), 30, 3),  -- Savannahs
(4000.00, 123.123456, 48.123456, '2018-04-01', DATEADD(YEAR, 5, '2018-04-01'), 30, 4), -- Ice and Snow
(5000.00, 124.123456, 49.123456, '2022-05-01', DATEADD(YEAR, 5, '2022-05-01'), 30, 7), -- Mountain
(6000.00, 125.123456, 50.123456, '2021-06-01', DATEADD(YEAR, 5, '2021-06-01'), 30, 4), -- Desert
(7000.00, 126.123456, 51.123456, '2019-07-01', DATEADD(YEAR, 5, '2019-07-01'), 30, 3); -- Urban

--Alter the first value to change 2019 to 2024 due to incorrect year
SELECT TOP 1 * FROM DataScoop ORDER BY CurrentAltitude, CurrentLongitude, CurrentLatitude;
UPDATE TOP (1) DataScoop
SET 
    LastMaintenanceDate = '2024-01-01',
    NextMaintenanceDate = DATEADD(YEAR, 5, '2024-01-01')
WHERE 
    CurrentAltitude = 1000.00 AND 
    CurrentLongitude = 120.123456 AND 
    CurrentLatitude = 45.123456;






--Subscription table
-- Insert data into Subscription table --id start at 6
INSERT INTO Subscription (StartDate, EndDate, SubscriptionFee, Discount, SubscriptionName, StaffID, AccessPrivilegeID)
VALUES
('2021-03-01', '2026-01-16', 150.00, NULL, 'Standard', 1, 1),
('2020-04-01', '2025-05-18', 230.50, 1.80, 'Gold', 2, 2),
('2019-11-26', '2025-03-26', 300.00, 2.10, 'Platinum', 3, 3),
('2023-01-22', '2027-05-01', 550.00, 0.50, 'Super Platinum', 4, 4),
('2018-05-08', '2024-07-27', 150.00, NULL, 'Standard', 5, 1);

-- Verify the data
SELECT * FROM Subscription;



ALTER TABLE Subscription
ADD AccessPrivilegeID INT;
-- Add foreign key constraint with the correct Name
ALTER TABLE Subscription
ADD CONSTRAINT FK_Subscription_AccessPrivilegeID
FOREIGN KEY (AccessPrivilegeID) REFERENCES AccessPrivilege(AccessPrivilegeID);

UPDATE Subscription
SET AccessPrivilegeID = 1
WHERE SubscriptionName = 'Standard';

UPDATE Subscription
SET AccessPrivilegeID = 2
WHERE SubscriptionName = 'Gold';

UPDATE Subscription
SET AccessPrivilegeID = 3
WHERE SubscriptionName = 'Platinum';

UPDATE Subscription
SET AccessPrivilegeID = 4
WHERE SubscriptionName = 'Super Platinum';





--Here goes Subscriber Table
insert into Subscriber (FirstName, LastName, Email, Phone, SubscriberAddress, StaffID, SubscriptionID) values ('Bell', 'Lambrecht', 'blambrecht0@stumbleupon.com', '989-581-3555', '63 Superior Street', 1, 1);
insert into Subscriber (FirstName, LastName, Email, Phone, SubscriberAddress, StaffID, SubscriptionID) values ('Jehanna', 'Gorling', 'jgorling1@hud.gov', '845-800-2758', '30 Mitchell Pass', 1, 4);
insert into Subscriber (FirstName, LastName, Email, Phone, SubscriberAddress, StaffID, SubscriptionID) values ('Kev', 'Hurd', 'khurd2@topsy.com', '825-102-7625', '32526 Kings Street', 6, 2);
insert into Subscriber (FirstName, LastName, Email, Phone, SubscriberAddress, StaffID, SubscriptionID) values ('Kaila', 'Taborre', 'ktaborre3@privacy.gov.au', '584-809-0389', '1 Gateway Point', 4, 4);
insert into Subscriber (FirstName, LastName, Email, Phone, SubscriberAddress, StaffID, SubscriptionID) values ('Aldric', 'Poolman', 'apoolman4@springer.com', '126-962-4494', '11445 Northview Drive', 5, 2);
insert into Subscriber (FirstName, LastName, Email, Phone, SubscriberAddress, StaffID, SubscriptionID) values ('Suki', 'Antonovic', 'santonovic5@nbcnews.com', '201-256-9555', '7 Chive Parkway', 6, 3);
insert into Subscriber (FirstName, LastName, Email, Phone, SubscriberAddress, StaffID, SubscriptionID) values ('Sybilla', 'Potkin', 'spotkin6@businessweek.com', '380-754-9451', '481 Rieder Crossing', 3, 1);
insert into Subscriber (FirstName, LastName, Email, Phone, SubscriberAddress, StaffID, SubscriptionID) values ('Janel', 'Ghidini', 'jghidini7@elegantthemes.com', '484-141-2640', '4 Troy Road', 8, 3);
insert into Subscriber (FirstName, LastName, Email, Phone, SubscriberAddress, StaffID, SubscriptionID) values ('Dynah', 'Qualtro', 'dqualtro8@nih.gov', '691-327-4874', '4395 Elmside Junction', 9, 4);
insert into Subscriber (FirstName, LastName, Email, Phone, SubscriberAddress, StaffID, SubscriptionID) values ('Merwyn', 'Poker', 'mpoker9@mapquest.com', '487-514-3248', '54304 Cordelia Drive', 10, 2);




-- Insert values into DSZone table
INSERT INTO Part (PartName, LastMaintenanceDate, NextMaintenanceDate, DataScoopID)
VALUES
('PartA', '2024-01-01', DATEADD(YEAR, 5, '2024-01-01'), 1),
('PartB', '2023-02-01', DATEADD(YEAR, 5, '2023-02-01'), 2),
('PartC', '2022-03-01', DATEADD(YEAR, 5, '2022-03-01'), 3),
('PartD', '2021-04-01', DATEADD(YEAR, 5, '2021-04-01'), 3),
('PartE', '2020-05-01', DATEADD(YEAR, 5, '2020-05-01'), 7),
('PartF', '2019-06-01', DATEADD(YEAR, 5, '2019-06-01'), 6),
('PartG', '2018-07-01', DATEADD(YEAR, 5, '2018-07-01'), 4);



--SensedData
INSERT INTO SensedData (TimeCollected, Temperature, Humidity, AmbientLightStrength, OrganicSpectralData, Latitude, Longitude, Altitude, ZoneID, DataScoopID)
VALUES
('2024-01-01 08:00:00', 25.5, 60.0, 15000.12345, 2000.12345, 45.123456, 120.123456, 138.00, 1, 6),
('2024-02-01 09:00:00', 22.5, 55.0, 14000.12345, 1800.12345, 46.123456, 121.123456, 2042.00, 2, 4),
('2024-03-01 10:00:00', 28.0, 65.0, 16000.12345, 2200.12345, 47.123456, 122.123456, 3840.00, 3, 7),
('2024-04-01 11:00:00', 21.0, 50.0, 13000.12345, 1700.12345, 48.123456, 123.123456, 4272.00, 4, 1),
('2024-05-01 12:00:00', 24.0, 58.0, 14500.12345, 1950.12345, 49.123456, 124.123456, 2742.00, 2, 6),
('2024-06-01 13:00:00', 27.0, 62.0, 15500.12345, 2050.12345, 50.123456, 125.123456, 1839.00, 6, 3),
('2024-07-01 14:00:00', 26.5, 59.0, 14800.12345, 1900.12345, 51.123456, 126.123456, 789.00, 3, 1),
('2024-08-01 15:00:00', 23.5, 57.0, 14200.12345, 1850.12345, 52.123456, 127.123456, 3874.00, 1, 2),
('2024-09-01 16:00:00', 29.0, 67.0, 16500.12345, 2250.12345, 53.123456, 128.123456, 9043.00, 2, 5),
('2024-10-01 17:00:00', 22.0, 54.0, 13800.12345, 1750.12345, 54.123456, 129.123456, 1742.00, 7, 3);


--VideoStream
INSERT INTO VideoStream (VideoStreamDescription, ZoneID, AccessPrivilegeID)
VALUES
('Watch the night Stream in the Jungle', 1, 1),
('Cold winter forest', 3, 3),
('Savannahs Stream', 7, 3),
('Ice and Snow Stream plus windy and cold', 4, 2),
('Green Mountain Stream', 5, 1),
('Desert dry Stream', 2, 2),
('Urban Stream', 7, 3),
('Jungle Night Stream', 4, 2),
('Forest Day Stream', 2, 4),
('Savannahs Night Stream', 6, 1);


-- Insert values into SubscriptionAccessPrivilege table
INSERT INTO SubscriptionAccessPrivilege (SubscriptionID, AccessPrivilegeID)
VALUES
(1, 1),
(2, 2),
(1, 3),
(4, 4),
(5, 1);



INSERT INTO VideoStreamSubscriber (VideoStreamID, SubscriberID)
VALUES
(1, 1),
(3, 2),
(8, 2),
(10, 3),
(2, 5),
(6, 10),
(9, 8),
(2, 3),
(1, 9),
(5, 5);


INSERT INTO ZoneSubscriber (ZoneID, SubscriberID)
VALUES
(1, 3),
(5, 9),
(3, 3),
(4, 10),
(5, 2),
(7, 1),
(7, 2);



INSERT INTO DataScoopSubscriber (DataScoopID, SubscriberID)
VALUES
(5, 1),
(2, 5),
(3, 8),
(4, 10),
(1, 5),
(6, 6),
(1, 2);



INSERT INTO SubscriptionDataScoop (SubscriptionID, DataScoopID)
VALUES
(1, 7),
(4, 2),
(3, 4),
(2, 6),
(5, 5),
(1, 1),
(2, 7);


INSERT INTO PartSupplier (PartNumber, SupplierID)
VALUES
(1, 10),
(7, 2),
(3, 9),
(6, 4),
(2, 8),
(1, 6),
(7, 5);


INSERT INTO SubscriptionZone (SubscriptionID, ZoneID)
VALUES
(3, 1),
(2, 4),
(5, 3),
(4, 6),
(3, 5),
(1, 2),
(5, 7);


INSERT INTO SensedDataSubscriber (SensedDataID, SubscriberID)
VALUES
(3, 1),
(2, 8),
(8, 3),
(6, 10),
(5, 9),
(10, 1),
(2, 7),
(9, 2),
(3, 4),
(10, 5);



--transaction one


-- Drop the procedure if it already exists

DROP PROCEDURE IF EXISTS sp_SubscribeNewStandardSubscription;
GO
CREATE PROCEDURE sp_SubscribeNewStandardSubscription
    @SalespersonID INT,
    @Discount DECIMAL(4,2),
    @FirstName VARCHAR(50),
    @LastName VARCHAR(50),
    @Email VARCHAR(100),
    @Phone VARCHAR(15),
    @SubscriberAddress VARCHAR(255),
    @DataScoopID INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @SubscriptionID INT;
    DECLARE @SubscriberID INT;
    DECLARE @StartDate DATE = GETDATE();
    DECLARE @EndDate DATE = DATEADD(YEAR, 1, GETDATE()); -- add endate to a year later
    DECLARE @SubscriptionFee DECIMAL(8,2) = 150.00; -- Standard subscription fee
    DECLARE @SubscriptionName VARCHAR(30) = 'Standard';
    DECLARE @AccessPrivilegeID INT = 1; -- Standard Video Access

    BEGIN TRANSACTION;

    -- Insert into Subscription table
    INSERT INTO Subscription (StartDate, EndDate, SubscriptionFee, Discount, SubscriptionName, StaffID, AccessPrivilegeID)
    VALUES (@StartDate, @EndDate, @SubscriptionFee, @Discount, @SubscriptionName, @SalespersonID, @AccessPrivilegeID);
    SET @SubscriptionID = SCOPE_IDENTITY();

    -- Insert into Subscriber table
    INSERT INTO Subscriber (FirstName, LastName, Email, Phone, SubscriberAddress, StaffID, SubscriptionID)
    VALUES (@FirstName, @LastName, @Email, @Phone, @SubscriberAddress, @SalespersonID, @SubscriptionID);
    SET @SubscriberID = SCOPE_IDENTITY();

    -- Insert into SubscriptionDataScoop linking table update the table
    INSERT INTO SubscriptionDataScoop (SubscriptionID, DataScoopID)
    VALUES (@SubscriptionID, @DataScoopID);

    -- Insert into StandardSubscription table (subclass of Subscription)
    INSERT INTO StandardSubscription (SubscriptionID, AccessPrivilegeID)
    VALUES (@SubscriptionID, @AccessPrivilegeID);

    -- Commit transaction
    COMMIT TRANSACTION;

    -- Return the new SubscriptionID and SubscriberID
    SELECT @SubscriptionID AS SubscriptionID, @SubscriberID AS SubscriberID;
END;
GO

-- Execute the stored procedure with sample data
EXEC sp_SubscribeNewStandardSubscription  -- A salesperson subscribes to a new standard subscription to a DataScoop
    @SalespersonID = 1,
    @Discount = 2.00,
    @FirstName = 'Michael',
    @LastName = 'Scott',
    @Email = 'michael.scott@dundermifflin.com',
    @Phone = '123-456-7890',
    @SubscriberAddress = '1725 Avenue, New York, PA',
    @DataScoopID = 1;


-- Verify the new subscription
SELECT * FROM Subscription WHERE SubscriptionID = (SELECT MAX(SubscriptionID) FROM Subscription);

-- Verify the new subscriber
SELECT * FROM Subscriber WHERE SubscriberID = (SELECT MAX(SubscriberID) FROM Subscriber);

-- Verify the link in SubscriptionDataScoop
SELECT * FROM SubscriptionDataScoop WHERE SubscriptionID = (SELECT MAX(SubscriptionID) FROM Subscription);

-- Verify the link in StandardSubscription
SELECT * FROM StandardSubscription WHERE SubscriptionID = (SELECT MAX(SubscriptionID) FROM Subscription);




--second one
-- Drop the procedure if it already exists
DROP PROCEDURE IF EXISTS sp_GetSubscribersBySalesperson; --sp stands for salesperson
GO

-- Create the stored procedure here as well
CREATE PROCEDURE sp_GetSubscribersBySalesperson
    @SalespersonFirstName VARCHAR(50),
    @SalespersonLastName VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON; --the count isn't returned

    SELECT 
        sub.FirstName AS SubscriberFirstName,
        sub.LastName AS SubscriberLastName,
        sub.SubscriberAddress,
        s.Discount  --subscription
    FROM 
        Subscriber sub
    INNER JOIN 
        Subscription s ON sub.SubscriptionID = s.SubscriptionID
    INNER JOIN 
        Staff st ON s.StaffID = st.StaffID
    WHERE 
        st.FirstName = @SalespersonFirstName AND st.LastName = @SalespersonLastName;
END;
GO

-- Verify the results
EXEC sp_GetSubscribersBySalesperson
    @SalespersonFirstName = 'Caro',
    @SalespersonLastName = 'Fowlestone';



--. Write a query to be used to insert data from a DataScoop to its stored data 
--on the FlightStream database. The transaction receives the DataScoop ID and 
--all the data from a data stream. That is made up of one or more records of 
--Temperature, Humidity, Ambient light strength, and organic spectral data, 
--time, longitude, latitude, and altitude. 

-- Drop the procedure if it already exists
DROP PROCEDURE IF EXISTS InsertSensedData;
GO

-- Create the stored procedure here
CREATE PROCEDURE InsertSensedData
    @DataScoopID INT,
    @TimeCollected DATETIME,
    @Temperature DECIMAL(6, 2),
    @Humidity DECIMAL(5, 2),
    @AmbientLightStrength DECIMAL(15, 5),
    @OrganicSpectralData DECIMAL(15, 5),
    @Latitude DECIMAL(10, 6),
    @Longitude DECIMAL(10, 6),
    @Altitude DECIMAL(10, 2),
    @ZoneID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Insert the data into the SensedData table
    INSERT INTO SensedData (
        TimeCollected,
        Temperature,
        Humidity,
        AmbientLightStrength,
        OrganicSpectralData,
        Latitude,
        Longitude,
        Altitude,
        ZoneID,
        DataScoopID
    ) VALUES (
        @TimeCollected,
        @Temperature,
        @Humidity,
        @AmbientLightStrength,
        @OrganicSpectralData,
        @Latitude,
        @Longitude,
        @Altitude,
        @ZoneID,
        @DataScoopID
    );
 
    SELECT SCOPE_IDENTITY() AS SensedDataID; -- Return the new SensedDataID
END;
GO


EXEC InsertSensedData  --execute with the new data
    @DataScoopID = 1,
    @TimeCollected = '2024-01-01 08:27:39',
    @Temperature = 25.5,
    @Humidity = 60.0,
    @AmbientLightStrength = 15000.12345,
    @OrganicSpectralData = 2000.12345,
    @Latitude = 45.123456,
    @Longitude = -120.123456,
    @Altitude = 1000.00,
    @ZoneID = 5;

-- Verify the new SensedData
SELECT * FROM SensedData WHERE DataScoopID = 1; --return all datascoopid with 1


SELECT * FROM Subscription


 --List the location in latitude, longitude coordinates, of each DataScoop that is 
--currently in a contract. The transaction presents the Contracting 
--organisation's name, a DataScoop ID, a Latitude, and a Longitude. 
SELECT 
    s.SubscriptionName AS ContractingOrganizationName, --callt
    ds.DataScoopID,
    ds.CurrentLatitude AS Latitude,
    ds.CurrentLongitude AS Longitude
FROM 
    Subscription s
INNER JOIN 
    SubscriptionDataScoop sds ON s.SubscriptionID = sds.SubscriptionID
INNER JOIN 
    DataScoop ds ON sds.DataScoopID = ds.DataScoopID
WHERE 
    s.EndDate > GETDATE(); --  active subscriptions but the data populate is all 




--For a contract list all the data collected. The transaction receives the 
--contracting organisation's name and presents for each collected data record, 
--the contracting organisation's name, a DataScoop ID, Temperature, Humidity , 
--Ambient light strength, and organic spectral data.

-- Drop the procedure if it already exists
--idk
DROP PROCEDURE IF EXISTS DataCollectedBySubscription;
GO

CREATE PROCEDURE DataCollectedBySubscription
    @ContractingOrgName VARCHAR(50) --subscriber
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        sub.FirstName + ' ' + sub.LastName AS ContractingOrganizationName,
        sd.DataScoopID,
        se.Temperature,
        se.Humidity,
        se.AmbientLightStrength,
        se.OrganicSpectralData
    FROM 
        Subscriber sub
    INNER JOIN 
        Subscription s ON sub.SubscriptionID = s.SubscriptionID
    INNER JOIN 
        SubscriptionDataScoop sds ON s.SubscriptionID = sds.SubscriptionID
    INNER JOIN 
        DataScoop sd ON sds.DataScoopID = sd.DataScoopID
    INNER JOIN 
        SensedData se ON sd.DataScoopID = se.DataScoopID
    WHERE 
        sub.FirstName + ' ' + sub.LastName = @ContractingOrgName;
END;
GO


SELECT * FROM Subscriber

-- Execute the stored procedure with sample data
EXEC DataCollectedBySubscription
    @ContractingOrgName = 'Michael Scott'; --return all with the name





 --For each DataScoop present the list of subscribers who are viewing a live 3D 
--video stream. The transaction lists DataScoop ID, Subscriber Name, Stream ID.
-- Drop the procedure if it already exists
DROP PROCEDURE IF EXISTS SubscribersViewingLive3DVideoStream;
GO

-- Create the stored procedure
CREATE PROCEDURE SubscribersViewingLive3DVideoStream
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        ds.DataScoopID,
        su.FirstName + ' ' + su.LastName AS SubscriberName,
        vs.VideoStreamID
    FROM 
        DataScoop ds
    INNER JOIN 
        DSZone dz ON ds.DataScoopID = dz.DataScoopID --as there is no datascoopid on the videostream need to join to make to work
    INNER JOIN 
        VideoStream vs ON dz.ZoneID = vs.ZoneID --zone has datascoop
    INNER JOIN 
        VideoStreamSubscriber vss ON vs.VideoStreamID = vss.VideoStreamID
    INNER JOIN 
        Subscriber su ON vss.SubscriberID = su.SubscriberID
    ORDER BY 
        ds.DataScoopID, su.LastName, su.FirstName;
END;
GO

-- Execute the stored procedure
EXEC SubscribersViewingLive3DVideoStream;



SELECT * FROM VideoStreamSubscriber
SELECT * FROM DSZone


--For a given DataScoop list all the suppliers of parts. The transaction receives 
--the DataScoop ID, and presents the Supplier Name and, Part Name. 
-- Drop the procedure if it already exists
DROP PROCEDURE IF EXISTS DataScoopPartsSupplier;
GO
-- Create the stored procedure
CREATE PROCEDURE DataScoopPartsSupplier
    @DataScoopID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        s.SupplierName,
        p.PartName
    FROM 
        Part p
    INNER JOIN 
        PartSupplier ps ON p.PartNumber = ps.PartNumber
    INNER JOIN 
        Supplier s ON ps.SupplierID = s.SupplierID
    WHERE 
        p.DataScoopID = @DataScoopID --receive datascoopid for query
    ORDER BY 
        s.SupplierName, p.PartName;
END;
GO

-- Execute the stored procedure with a sample DataScoopID (change the value as needed)
EXEC DataScoopPartsSupplier @DataScoopID = 1;

SELECT * FROM Supplier;




 --Update the location and Zone of a DataScoop. The transaction receives the 
--DataScoop ID, a location and a Zone expressed as a list of coordinates in 
--latitude, longitude pairs. It updates the location of the DataScoop and its 
--corresponding Zone. (This transaction may require more than one update 
--query.)
-- Drop the procedure if it already exists
DROP PROCEDURE IF EXISTS UpdateDataScoopLocationAndZone;
GO
-- Create the stored procedure
CREATE PROCEDURE UpdateDataScoopLocationAndZone
    @DataScoopID INT,
    @NewLatitude DECIMAL(10, 6), --for new
    @NewLongitude DECIMAL(10, 6), --new
    @NewZoneName VARCHAR(100), --for new
    @NewZoneLocation VARCHAR(255) --for new
AS
BEGIN
    SET NOCOUNT ON;

    -- Update DataScoop
    UPDATE DataScoop
    SET CurrentLatitude = @NewLatitude,
        CurrentLongitude = @NewLongitude
    WHERE DataScoopID = @DataScoopID;

    -- Update zone
    UPDATE DSZone
    SET Name = @NewZoneName,
        Location = @NewZoneLocation
    WHERE DataScoopID = @DataScoopID;

    -- Select the updated one
    SELECT 
        ds.DataScoopID,
        ds.CurrentLatitude,
        ds.CurrentLongitude,
        dz.ZoneID,
        dz.Name AS ZoneName,
        dz.Location AS ZoneLocation
    FROM 
        DataScoop ds
    INNER JOIN 
        DSZone dz ON ds.DataScoopID = dz.DataScoopID
    WHERE 
        ds.DataScoopID = @DataScoopID;
END;
GO

--update the datascoopid equal to 1 to set to new value
EXEC UpdateDataScoopLocationAndZone @DataScoopID = 1, @NewLatitude = 35.123456, @NewLongitude = -120.123456, @NewZoneName = 'New Zone', @NewZoneLocation = 'New Location';



--Delete the data collected for a given Contract. The transaction receives a 
--Contract ID, the data collected for a Contract is deleted. 
--Contract mean Subscription here

-- Drop the procedure if it already exists
DROP PROCEDURE IF EXISTS DeleteDataCollectedBySubscription;
GO
CREATE PROCEDURE DeleteDataCollectedBySubscription
    @SubscriptionID INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION;

    -- Delete from linking tables
    DELETE FROM SubscriptionZone WHERE SubscriptionID = @SubscriptionID;
    DELETE FROM SubscriptionAccessPrivilege WHERE SubscriptionID = @SubscriptionID;
    DELETE FROM SubscriptionDataScoop WHERE SubscriptionID = @SubscriptionID;
    DELETE FROM DataScoopSubscriber WHERE SubscriberID IN (SELECT SubscriberID FROM Subscriber WHERE SubscriptionID = @SubscriptionID);
    DELETE FROM ZoneSubscriber WHERE SubscriberID IN (SELECT SubscriberID FROM Subscriber WHERE SubscriptionID = @SubscriptionID);
    DELETE FROM SensedDataSubscriber WHERE SubscriberID IN (SELECT SubscriberID FROM Subscriber WHERE SubscriptionID = @SubscriptionID);
    DELETE FROM VideoStreamSubscriber WHERE SubscriberID IN (SELECT SubscriberID FROM Subscriber WHERE SubscriptionID = @SubscriptionID);
    DELETE FROM StandardSubscription WHERE SubscriptionID = @SubscriptionID;
    DELETE FROM GoldSubscription WHERE SubscriptionID = @SubscriptionID;
    DELETE FROM PlatinumSubscription WHERE SubscriptionID = @SubscriptionID;
    DELETE FROM SuperPlatinumSubscription WHERE SubscriptionID = @SubscriptionID;

    -- Delete from main tables
    DELETE FROM SensedData WHERE ZoneID IN (SELECT ZoneID FROM DSZone WHERE DataScoopID IN (SELECT DataScoopID FROM SubscriptionDataScoop WHERE SubscriptionID = @SubscriptionID));
    DELETE FROM VideoStream WHERE ZoneID IN (SELECT ZoneID FROM DSZone WHERE DataScoopID IN (SELECT DataScoopID FROM SubscriptionDataScoop WHERE SubscriptionID = @SubscriptionID));
    DELETE FROM DataScoop WHERE DataScoopID IN (SELECT DataScoopID FROM SubscriptionDataScoop WHERE SubscriptionID = @SubscriptionID);
    DELETE FROM Subscriber WHERE SubscriptionID = @SubscriptionID;
    DELETE FROM Subscription WHERE SubscriptionID = @SubscriptionID;

    COMMIT TRANSACTION;
END;
GO





-- Execute the stored procedure with a sample SubscriptionID (change the value as needed)
SELECT * FROM Subscription
EXEC DeleteDataCollectedBySubscription @SubscriptionID = 5; --subscriptionID with 5 is deletefrom all part where it stored
SELECT * FROM Subscription
SELECT * FROM Subscriber





--Write a query that displays the total cost of all parts replaced in maintenance 
--of a DataScoop. The transaction displays the DataScoop ID, Total Cost of 
--replaced parts, for every DataScoop. 
-- Adding Cost column to the Part table
ALTER TABLE Part
ADD Cost DECIMAL(10, 2) NOT NULL DEFAULT 0;

--insert more values with new column cost added
-- Insert some example data including costs
INSERT INTO Part (PartName, LastMaintenanceDate, NextMaintenanceDate, DataScoopID, Cost)
VALUES 
('PartB', '2024-10-24', DATEADD(YEAR,5,'2024-10-24'), 1, 100.00),
('PartC', '2024-02-01', DATEADD(YEAR,5,'2024-02-01'), 1, 150.00),
('PartC', '2022-03-01', DATEADD(YEAR,5,'2022-03-01'), 2, 200.00),
('PartA', '2020-04-13', DATEADD(YEAR,5,'2020-04-13'), 2, 250.00),
('PartG', '2023-08-05', DATEADD(YEAR,5,'2023-08-05'), 3, 300.00);


SELECT * FROM Part

-- Query to display the total cost of all parts replaced in maintenance of a DataScoop
SELECT 
    ds.DataScoopID,
    SUM(p.Cost) AS TotalCostOfReplacedParts --uing sum for adding
FROM 
    DataScoop ds
INNER JOIN 
    Part p ON ds.DataScoopID = p.DataScoopID
GROUP BY 
    ds.DataScoopID;
