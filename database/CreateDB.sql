IF NOT EXISTS (SELECT name FROM master.sys.databases WHERE name = N'OnlineShop')
Begin
	CREATE DATABASE OnlineShop;
	Print 'Database created successfully';
End
