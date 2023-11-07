CREATE DATABASE IF NOT EXISTS QuanLyBanHang;
USE QuanLyBanHang;

CREATE TABLE IF NOT EXISTS Customer
(
    cID  INT PRIMARY KEY,
    Name VARCHAR(25),
    cAge TINYINT
);

INSERT INTO Customer (cID, Name, cAge)
VALUES (1, 'Minh Quan', 10),
       (2, 'Ngoc Oanh', 20),
       (3, 'Hong Ha', 50);

CREATE TABLE IF NOT EXISTS Orders
(
    oID   INT PRIMARY KEY,
    oDate DATE,
    cID   INT,
    FOREIGN KEY (cID) REFERENCES Customer (cID)
);

-- Chèn dữ liệu mẫu
INSERT INTO Orders (oID, oDate, cID)
VALUES (101, '2023-11-01', 1),
       (102, '2023-11-02', 2),
       (103, '2023-11-03', 3);



CREATE TABLE IF NOT EXISTS Product
(
    pID    INT PRIMARY KEY,
    pName  VARCHAR(50),
    pPrice DECIMAL(10, 2)
);

-- Chèn dữ liệu mẫu
INSERT INTO Product (pID, pName, pPrice)
VALUES (1, 'Máy giặt', 1000),
       (2, 'Tủ lạnh', 1500),
       (3, 'Bếp điện', 800);



CREATE TABLE IF NOT EXISTS OrderDetail
(
    oID   INT,
    pID   INT,
    odQty INT,
    PRIMARY KEY (oID, pID),
    FOREIGN KEY (oID) REFERENCES Orders (oID),
    FOREIGN KEY (pID) REFERENCES Product (pID)
);

-- Chèn dữ liệu mẫu
INSERT INTO OrderDetail (oID, pID, odQty)
VALUES (101, 1, 2),
       (101, 2, 1),
       (102, 1, 3),
       (103, 3, 2);

-- các câu truy vấn:
SELECT Orders.oID, oDate, SUM(pPrice * odQty) AS oPrice
FROM Orders
         JOIN OrderDetail ON Orders.oID = OrderDetail.oID
         JOIN Product ON OrderDetail.pID = Product.pID
GROUP BY oID, oDate
ORDER BY oDate DESC;

-- hien thi tên san phẩm , giá của phẩm cao nhất
SELECT pName, pPrice
FROM Product
where pPrice = (SELECT MAX(pPrice) FROM Product);


-- danh sách khách hàng đã mua hàng và sp đã mua
SELECT o.oID, c.Name, p.pName, od.odQty
FROM Customer c
         JOIN Orders o ON c.cID = o.cID
         JOIN OrderDetail od ON o.oID = od.oID
         JOIN Product p ON od.pID = p.pID;

-- danh sách khách hàng ko mua hàng và sp đã mua
SELECT o.oID, c.Name
FROM Customer c
         left join Orders o ON c.cID = o.cID
         left join OrderDetail od ON o.oID = od.oID
where o.oID is null;

-- chi tiết của từng khóa đơn
SELECT Orders.oID, oDate,OrderDetail.odQty, Product.pName,Product.pPrice
FROM Orders
         JOIN OrderDetail ON Orders.oID = OrderDetail.oID
         JOIN Product ON OrderDetail.pID = Product.pID;
--
SELECT Orders.oID, oDate, SUM(pPrice * odQty) AS Totall
FROM Orders
         JOIN OrderDetail ON Orders.oID = OrderDetail.oID
         JOIN Product ON OrderDetail.pID = Product.pID
GROUP BY oID, oDate
ORDER BY oDate DESC;
