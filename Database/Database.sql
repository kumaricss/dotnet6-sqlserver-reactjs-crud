-- Install and configure Microsoft SQL Server
-- Install SSMS for connectig of Microsoft SQL Server DB using GUI
-- Install sqlcmd for connectig of Microsoft SQL Server DB using CMD/Terminal


-- Create the Database in Microsoft SQL Server
CREATE DATABASE testdb;

-- Create the Department table
USE testdb;
GO

CREATE TABLE users (
  id              INT           NOT NULL    IDENTITY    PRIMARY KEY,
  first_name      VARCHAR(100)  NOT NULL,
  last_name       VARCHAR(100),
  email           VARCHAR(100)  NOT NULL,
);

-- Install SSMS tool and Ensure SQL Server Uses Mixed Authentication

Run in SSMS (login as admin):

SELECT SERVERPROPERTY('IsIntegratedSecurityOnly');


1 → Windows Auth only ❌

0 → Mixed Mode enabled ✅

👉 If not enabled:

SSMS → Server → Properties → Security

Select SQL Server and Windows Authentication mode

Restart SQL Server service


-- Create SQL Login User (Username + Password)
CREATE LOGIN app_user
WITH PASSWORD = 'StrongP@ssw0rd!',
     CHECK_POLICY = ON,
     CHECK_EXPIRATION = ON;


-- Create Database User & Grant Permissions
USE testdb;
GO

CREATE USER app_user FOR LOGIN app_user;
GO

-- Minimum permissions (recommended)
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::dbo TO app_user;
GO


👉 Or full control (not recommended for prod):

ALTER ROLE db_owner ADD MEMBER app_user;


// For named instance:
"ConnectionStrings": {
  "ApiDatabase": "Server=localhost\\SQL2022;Database=YourDatabaseName;User Id=app_user;Password=StrongP@ssw0rd!;"
  OR
  "DefaultConnection": "Server=localhost\\SQLEXPRESS;Database=StudentDB;Trusted_Connection=True; Encrypt=False;TrustServerCertificate=true;"
}



// For port:
"ConnectionStrings": {
  "ApiDatabase": "Data Source=localhost,1433;Initial Catalog=testdb;User Id=app_user;Password=StrongP@ssw0rd!;Encrypt=False;TrustServerCertificate=True;"
}

###############################################################################################
-- for trouble shooting 
// check if 1433 port is listing
netstat -ano | findstr 1433

// check if you are able to connect through CMD/Terminal
C:\Windows\System32>sqlcmd -S localhost,1433 -U app_user -P StrongP@ssw0rd!
1> SELECT name FROM sys.databases;
2> GO
name
--------------------------------------------------------------------------------------------------------------------------------
master
tempdb
model
msdb
DWDiagnostics
DWConfiguration
DWQueue
testdb

(8 rows affected)
1> USE testdb;
2> GO
Changed database context to 'testdb'.
1> SELECT name FROM sys.tables;
2> GO
name
--------------------------------------------------------------------------------------------------------------------------------
users

(1 rows affected)
1> USE testdb;
2> Go
Changed database context to 'testdb'.
1> SELECT * FROM dbo.users;
2> GO
id          first_name                                                                                           last_name                                                                                            email                  
----------- ---------------------------------------------------------------------------------------------------- ---------------------------------------------------------------------------------------------------- ----------------------------------------------------------------------------------------------------
          1 kumar                                                                                                jella                                                                                                k.jella@gmail.com  
          2 Sravan                                                                                               Nampalli                                                                                             s.nampalli@gmail.com
          3 Balaji                                                                                               Mudavath                                                                                             b.mudavath@gmail.com

(3 rows affected)