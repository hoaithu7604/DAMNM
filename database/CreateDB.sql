IF NOT EXISTS (SELECT name FROM master.sys.databases WHERE name = N'OnlineShop')
Begin
	CREATE DATABASE OnlineShop;
	Print 'Database created successfully';
End

IF EXISTS (SELECT name FROM master.sys.databases WHERE name = N'OnlineShop')
Begin
	BEGIN TRANSACTION

	IF NOT EXISTS (SELECT 1 FROM [INFORMATION_SCHEMA].[TABLES] WHERE [TABLE_NAME] = N'Roles')
	BEGIN
		CREATE TABLE dbo.Roles (
		  Id uniqueidentifier NOT NULL,
		  Name nvarchar(256) NOT NULL,
		  CONSTRAINT PK_Roles PRIMARY KEY (Id)
		)
		PRINT 'Roles CREATE TABLE'
	END
	
	IF NOT EXISTS (SELECT 1 FROM [INFORMATION_SCHEMA].[TABLES] WHERE [TABLE_NAME] = N'Customers')
	BEGIN
		CREATE TABLE dbo.Customers (
		  Id uniqueidentifier NOT NULL,
		  Name nvarchar(100) NULL,
		  CONSTRAINT PK_Customer PRIMARY KEY (Id)
		)
		PRINT 'Customers CREATE TABLE'
	END

	IF NOT EXISTS (SELECT 1 FROM [INFORMATION_SCHEMA].[TABLES] WHERE [TABLE_NAME] = N'Employee')
	BEGIN
		CREATE TABLE dbo.Employee (
		  Id uniqueidentifier NOT NULL,
		  Name nvarchar(256) NOT NULL,
		  RoleId uniqueidentifier NULL,
		  CONSTRAINT PK_Employee PRIMARY KEY (Id),
		  CONSTRAINT FK_Employee_Role FOREIGN KEY (RoleId) REFERENCES dbo.Roles(Id),
		)
		PRINT 'Employee CREATE TABLE'
	END

	IF NOT EXISTS (SELECT 1 FROM [INFORMATION_SCHEMA].[TABLES] WHERE [TABLE_NAME] = N'Order')
	BEGIN
		CREATE TABLE dbo.Orders (
		  Id uniqueidentifier NOT NULL,
		  OwnerId uniqueidentifier NULL,
		  CONSTRAINT PK_Order PRIMARY KEY (Id),
		  CONSTRAINT FK_Order_Customer FOREIGN KEY (OwnerId) REFERENCES dbo.Customers (Id)
		)
		PRINT 'Orders CREATE TABLE'
	END
	
	IF NOT EXISTS (SELECT 1 FROM [INFORMATION_SCHEMA].[TABLES] WHERE [TABLE_NAME] = N'OrderHistory')
	BEGIN
		CREATE TABLE dbo.OrderHistory (
		  Id uniqueidentifier NOT NULL,
		  OrderId uniqueidentifier NOT NULL,
		  EmployeeId uniqueidentifier NULL,
		  TransitionTime datetime NULL,
		  [Order] bigint IDENTITY,
		  TransitionTimeForSort AS (coalesce([TransitionTime],CONVERT([datetime],'9999-12-31',(20)))),
		  InitialState nvarchar(1024) NOT NULL,
		  DestinationState nvarchar(1024) NOT NULL,
		  Command nvarchar(1024) NOT NULL,
		  CONSTRAINT PK_OrderHistory PRIMARY KEY (Id),
		  CONSTRAINT FK_OrderHistory_Order FOREIGN KEY (OrderId) REFERENCES dbo.Orders (Id) ON DELETE CASCADE ON UPDATE CASCADE,
		  CONSTRAINT FK_OrderHistory_Employee FOREIGN KEY (EmployeeId) REFERENCES dbo.Employee (Id)
		)
		PRINT 'OrderHistory CREATE TABLE'
	END

	COMMIT TRANSACTION
End