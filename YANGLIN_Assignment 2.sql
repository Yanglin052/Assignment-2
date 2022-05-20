--1. Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables. 
-- Join them and produce a result set similar to the following.
SELECT cr.Name as Country, sp.Name as Province
FROM Person.CountryRegion cr JOIN Person.StateProvince sp ON cr.CountryRegionCode = sp.CountryRegionCode


--2. Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables
-- list the countries filter them by Germany and Canada.Join them and produce a result set similar to the following.
SELECT cr.Name as Country, sp.Name as Province
FROM Person.CountryRegion cr JOIN Person.StateProvince sp ON cr.CountryRegionCode = sp.CountryRegionCode
WHERE cr.Name IN ('Germany','Canada')


--3. List all Products that has been sold at least once in last 25 years.
SELECT DISTINCT p.ProductName
FROM Products p JOIN [Order Details] od ON p.ProductID = od.ProductID
JOIN Orders o ON o.OrderID = od.OrderID
WHERE o.OrderDate BETWEEN '1997-05-19' AND '2022-05-19'


--4. List top 5 locations (Zip Code) where the products sold most in last 25 years.
SELECT TOP 5 o.ShipPostalCode, COUNT(o.OrderID) as OrderNum
FROM Products p JOIN [Order Details] od ON p.ProductID = od.ProductID
JOIN Orders o ON o.OrderID = od.OrderID
WHERE o.OrderDate BETWEEN '1997-05-19' AND '2022-05-19'
GROUP BY o.ShipPostalCode
ORDER BY COUNT(o.OrderID) DESC


--5. List all city names and number of customers in that city.     
SELECT City, COUNT(CustomerID) as CustomerNum
FROM Customers
GROUP BY City


--6. List city names which have more than 2 customers, and number of customers in that city
SELECT City, COUNT(CustomerID) as CustomerNum
FROM Customers
GROUP BY City
HAVING COUNT(CustomerID) > 2


--7. Display the names of all customers along with the count of products they bought
SELECT c.ContactName, SUM(od.Quantity) AS NumOfProducts
FROM Customers c LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
LEFT JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY c.ContactName


--8. Display the customer ids who bought more than 100 Products with count of products.
SELECT c.CustomerID, SUM(od.Quantity) AS NumOfProducts
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY c.CustomerID
HAVING SUM(od.Quantity) > 100


--9. List all of the possible ways that suppliers can ship their products. Display the results as below
SELECT DISTINCT sp.CompanyName as "Supplier Company Name", sh.CompanyName as "Shipping Company Name"
FROM Shippers sh JOIN Orders o ON sh.ShipperID = o.ShipVia
JOIN [Order Details] od ON o.OrderID = od.OrderID
JOIN Products p ON p.ProductID = od.ProductID
JOIN Suppliers sp ON sp.SupplierID = p.SupplierID
ORDER BY sp.CompanyName


--10. Display the products order each day. Show Order date and Product Name.
SELECT DISTINCT o.OrderDate, p.ProductName
FROM Orders o JOIN [Order Details] od ON o.OrderID = od.OrderID
JOIN Products p ON p.ProductID = od.ProductID


--11. Displays pairs of employees who have the same job title.
SELECT DISTINCT e.FirstName + ' ' + e.LastName AS Pair1, m.FirstName + ' ' + m.LastName as Pair2
FROM Employees e JOIN Employees m ON e.Title = m.Title
WHERE e.FirstName != m.FirstName


--12. Display all the Managers who have more than 2 employees reporting to them.
SELECT m.FirstName + ' ' + m.LastName as ManagerName, COUNT(e.FirstName) AS EmployeeNum
FROM Employees e JOIN Employees m ON e.ReportsTo = m.EmployeeID
GROUP BY m.FirstName, m.LastName
HAVING COUNT(e.FirstName) > 2


--13. Display the customers and suppliers by city. The results should have the following columns
SELECT city, ContactName, 'Customer' as Type
FROM Customers
UNION
SELECT city, ContactName, 'Supplier' as Type
FROM Suppliers


--14. List all cities that have both Employees and Customers.
SELECT DISTINCT C.City
FROM Customers C JOIN (SELECT city
FROM Employees) DT ON C.City = DT.City


--15. List all cities that have Customers but no Employee.
--a.Use sub-query
SELECT DISTINCT C.City
FROM Customers C LEFT JOIN 
(SELECT city FROM Employees) DT ON C.City = DT.City
WHERE DT.City IS NULL

--b.Do not use sub-query
SELECT DISTINCT C.City
FROM Customers C LEFT JOIN Employees e ON C.City = e.City
WHERE e.City IS NULL


--16. List all products and their total order quantities throughout all orders.
SELECT p.ProductName, SUM(OD.Quantity) AS TotalQuantities
FROM Products p JOIN [Order Details] od ON p.ProductID = od.ProductID
GROUP BY p.ProductName

--17. List all Customer Cities that have at least two customers.
--a.Use union
SELECT City, COUNT(CustomerID) as CustomerNum
FROM Customers
GROUP BY City
HAVING COUNT(CustomerID) = 2
UNION
SELECT City, COUNT(CustomerID) as CustomerNum
FROM Customers
GROUP BY City
HAVING COUNT(CustomerID) > 2


--b.Use sub-query and no union
SELECT dt.City
FROM (SELECT City, COUNT(CustomerID) as CustomerNum
FROM Customers
GROUP BY City) dt
WHERE CustomerNum >= 2

--18. List all Customer Cities that have ordered at least two different kinds of products.
SELECT c.City, COUNT(p.productid) AS Products
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN [Order Details] od ON o.OrderID = od.OrderID
JOIN Products P ON P.ProductID = OD.ProductID
GROUP BY c.City
HAVING COUNT(p.productid) >= 2


--19. List 5 most popular products, their average price, and the customer city that ordered most quantity of it.
SELECT TOP 5 p.ProductName, SUM(OD.Quantity) AS OrderQuantities, AVG(OD.UnitPrice) AS AvgPrice, c.City
FROM Products p JOIN [Order Details] od ON p.ProductID = od.ProductID
JOIN Orders o ON o.OrderID = od.OrderID
JOIN Customers c ON c.CustomerID = o.CustomerID
GROUP BY p.ProductName, c.City
ORDER BY SUM(OD.Quantity) DESC


--20. List one city, if exists, that is the city from where the employee sold most orders (not the product quantity) is, 
-- and also the city of most total quantity of products ordered from. (tip: join  sub-query)
SELECT *
FROM (SELECT TOP 1 E.City, COUNT(O.OrderID) AS OrderNUM
FROM Employees E JOIN Orders O ON E.EmployeeID = O.EmployeeID
GROUP BY E.City
ORDER BY COUNT(O.OrderID) DESC) DT1 JOIN
(SELECT TOP 1 O.ShipCity, SUM(OD.Quantity) AS ProductQuantities
FROM Orders O JOIN [Order Details] OD ON O.OrderID = OD.OrderID
GROUP BY O.ShipCity
ORDER BY SUM(OD.Quantity) DESC) DT2 ON DT1.City = DT2.ShipCity


--21. How do you remove the duplicates record of a table?
 ROW_NUMBER() AND DELETE