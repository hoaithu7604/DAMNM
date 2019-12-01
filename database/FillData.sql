DELETE FROM Employee
DELETE FROM Roles
DELETE FROM Orders
DELETE FROM Customers

Begin TRANSACTION
	INSERT dbo.Roles(Id, Name) VALUES ('69cb579b-0866-4585-aca8-efe9ef0ce2be','Manager')
	INSERT dbo.Roles(Id, Name) VALUES ('de2e905a-524f-453d-852d-d9b7b7551cb6','DeliveryUnit')
	/* thu 123 Manager */
	INSERT dbo.Employee(Id, Name, RoleId) VALUES ('8d378ebe-0666-46b3-b7ab-1a52480fd12a', N'Thu Nguyen','69cb579b-0866-4585-aca8-efe9ef0ce2be')
	INSERT dbo.Accounts(Id, Username, Password, EmployeeId) VALUES ('f6e34bdf-b769-42dd-a2be-fee67faf9045','thu','123','8d378ebe-0666-46b3-b7ab-1a52480fd12a')
	/* uht 123 Delivery Unit */
	INSERT dbo.Employee(Id, Name, RoleId) VALUES ('b415fbf2-e403-4da1-9967-63ee4ac40efa', N'Thu Nguyen','de2e905a-524f-453d-852d-d9b7b7551cb6')
	INSERT dbo.Accounts(Id, Username, Password, EmployeeId) VALUES ('02a915ac-66df-4d48-9171-b1f59ed34e5c','uht','123','b415fbf2-e403-4da1-9967-63ee4ac40efa')

	INSERT dbo.Customers(Id, Name) VALUES ('e0fca1e6-b6ea-44b1-af68-8e63e125a6bf', N'Thu Nguyen')

	INSERT dbo.Orders(Id, State, OwnerId) VALUES ('44c89831-2409-464d-b28c-87c5ee17fdaa', N'ManagerApproving', 'e0fca1e6-b6ea-44b1-af68-8e63e125a6bf')

Commit TRANSACTION