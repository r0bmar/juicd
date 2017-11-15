DROP SCHEMA IF EXISTS Juicd;
DROP SCHEMA IF EXISTS Juicd;
CREATE SCHEMA Juicd;
USE Juicd;

DROP TABLE IF EXISTS `Customer`;
CREATE TABLE `Customer` ( /*Creates table called Customer, with its respective attributes. Primary key is CustomerID*/
  `CustomerID` int(11) NOT NULL,
  `Name` char(35) NOT NULL DEFAULT '',
  `Points` int(8) NOT NULL,
  `Email` varchar(20),
  PRIMARY KEY(`CustomerID`)
  );


DROP TABLE IF EXISTS `Manager`;
CREATE TABLE `Manager` ( /* Creates table called Manager, with its respective attributes. Primary key is ManagerID,*/
  `ManagerID` int(11) NOT NULL,
  `Hours Worked` tinyint(3) NOT NULL,
  `Name` char(35) NOT NULL DEFAULT '',
  PRIMARY KEY(`ManagerID`)
  );
  
  
DROP TABLE IF EXISTS `Employee`;
CREATE TABLE `Employee` ( /*Creates table called Employee, with its respective attributes. Primary key is EmployeeID. Note that I have included a foreign key, ManagerID, in order to encapsulate a one to many relationship. */
  `EmployeeID` int(11) NOT NULL,
  `Name` char(35) NOT NULL DEFAULT '',
  `ManagerID` int(11) NOT NULL,
  `Hours Worked` tinyint(3) NOT NULL,
  `IsFullTime` bool,
   PRIMARY KEY(`EmployeeID`), 
   CONSTRAINT `employee_ibfk_1` FOREIGN KEY (`ManagerID`) REFERENCES `Manager` (`ManagerID`)
  );


DROP TABLE IF EXISTS `Outlet`;
CREATE TABLE `Outlet` ( /*Creates table called Outlet, with its respective attributes. Primary key is Location. Note that I have included a foreign key, ManagerID, in order to encapsulate a one to many relationship. */
  `Location` char(20) NOT NULL DEFAULT '',
  `ManagerID` int(11) NOT NULL,
  PRIMARY KEY(`Location`),
  CONSTRAINT `outlet_ibfk_1` FOREIGN KEY (`ManagerID`) REFERENCES `Manager` (`ManagerID`)
  );
  

DROP TABLE IF EXISTS `WorksAt`;
CREATE TABLE `WorksAt` ( /* Creates a relational table, worksAt, in order to display the two primary keys of the Employee and Outlet tables, as this is a many to many relationship. */
  `EmployeeID` int(11) NOT NULL,
  `Location` char(20) NOT NULL DEFAULT '',
  PRIMARY KEY(`EmployeeID`, `Location`),
  CONSTRAINT `worksat_ibfk_1` FOREIGN KEY (`EmployeeID`) REFERENCES `Employee` (`EmployeeID`),
  CONSTRAINT `worksat_ibfk_2` FOREIGN KEY (`Location`) REFERENCES `Outlet` (`Location`)
  );



DROP TABLE IF EXISTS `NonJuice`;
CREATE TABLE `NonJuice` ( /*Creates table called NonJuice, with its respective attributes. Primary key is NJID. */
  `NJID` int(11) NOT NULL,
  `Price` int(6) NOT NULL,
  `Name` char(20) NOT NULL DEFAULT '',
  PRIMARY KEY(`NJID`)
  );
  
  
DROP TABLE IF EXISTS `Juice`;
CREATE TABLE `Juice` ( /*Creates table called Juice, with its respective attributes. Primary key is JuiceID. */
  `JuiceID` int(11) NOT NULL,
  `Size` tinyint(3) NOT NULL,
  PRIMARY KEY(`JuiceID`)
  );
  

DROP TABLE IF EXISTS `Ingredients`;
CREATE TABLE `Ingredients` (/*Creates table called Ingredients, with its respective attributes. Primary key is IngredientID. */
  `IngredientID` int(11) NOT NULL,
  `Name` char(35) NOT NULL DEFAULT '',
  `Unit Price` float(6) NOT NULL,
  PRIMARY KEY(`IngredientID`)
  );

DROP TABLE IF EXISTS `Contains`;
CREATE TABLE `Contains` (/*Creates a relational table called contains in order to encapsulate a relationship. Foreign keys refer to the primary keys of the two tables Juice and Ingredients. */
  `IngredientID` int(11) NOT NULL,
  `JuiceID` int(11) NOT NULL,
  `Percentage` tinyint(3) NOT NULL,
  PRIMARY KEY(`IngredientID`, `JuiceID`),
  CONSTRAINT `contains_ibfk_1` FOREIGN KEY (`IngredientID`) REFERENCES `Ingredients` (`IngredientID`),
  CONSTRAINT `contains_ibfk_2` FOREIGN KEY (`JuiceID`) REFERENCES `Juice` (`JuiceID`)
  );

DROP TABLE IF EXISTS `Order`;
CREATE TABLE `Order` ( /*Creates a relational table called Order, with its respective attributes. This order relates to 4 tables, namely the customer that orders, the employee that serves, the juice that is contained and the non-juice that is also ordered. */
  `EmployeeID` int(11) NOT NULL,
  `CustomerID` int(11) NOT NULL,
  `NJID` int(11) NOT NULL,
  `JuiceID` int(11) NOT NULL,
  `Date` varchar(10) NOT NULL,
  `Price` float(6) NOT NULL,
  PRIMARY KEY(`EmployeeID`, `CustomerID`, `NJID`, `JuiceID`),
  CONSTRAINT `order_ibfk_1` FOREIGN KEY (`EmployeeID`) REFERENCES `Employee` (`EmployeeID`),
  CONSTRAINT `order_ibfk_2` FOREIGN KEY (`JuiceID`) REFERENCES `Juice` (`JuiceID`),
  CONSTRAINT `order_ibfk_3` FOREIGN KEY (`CustomerID`) REFERENCES `Customer` (`CustomerID`),
  CONSTRAINT `order_ibfk_4` FOREIGN KEY (`NJID`) REFERENCES `NonJuice` (`NJID`)
  );