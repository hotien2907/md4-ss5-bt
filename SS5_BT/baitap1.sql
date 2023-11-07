CREATE DATABASE IF NOT EXISTS demoDB;
USE demoDB;
create table Products
(

    Id                 INT PRIMARY KEY AUTO_INCREMENT,
    productCode        VARCHAR(50),
    productName        VARCHAR(100),
    productPrice       FLOAT,
    productAmount      INT,
    productDescription TEXT,
    productStatus      BOOLEAN

);
INSERT INTO Products (productCode, productName, productPrice, productAmount, productDescription, productStatus)
VALUES ('P001', 'Product 1', 3, 5, 'Description1', true),
       ('P002', 'Product 2', 5, 7, 'Description2', true),
       ('P003', 'Product 3', 6, 4, 'Description 3', false);

create unique index idx_productPrice on products (productCode);
create index idx_productName_productPrice on products (productName, productPrice);

EXPLAIN
SELECT *
FROM Products
WHERE id = 1;

create view ProductInfo as
select productCode, productName, productPrice, productStatus
from products;
select * from ProductInfo;
 -- sửa view
 ALTER VIEW ProductInfo AS SELECT * FROM Products;
-- xoa view
 DROP VIEW IF EXISTS ProductInfo;


-- lấy ra tất ca sản phẩm
DELIMITER //
CREATE PROCEDURE getAllProduct()
begin
select * from  products;
end
//DELIMITER ;

call getAllProduct();

-- them mới sản phẩm
DELIMITER //
CREATE PROCEDURE addProduct(IN productCode varchar(50),productName varchar(50),productPrice float,productAmount int,productDescription TEXT,productStatus BOOLEAN )
begin

insert into Products(productCode,productName,productPrice,productAmount,productDescription,productStatus)
VALUES (productCode,productName,productPrice,productAmount,productDescription,productStatus);
end
//DELIMITER ;

call addProduct('p0000x','product4',5,6,'productDescription5',true);


-- UPDATE sản pham
DELIMITER //
CREATE PROCEDURE UpdateProductById(
    IN p_id INT,
    IN p_productCode VARCHAR(50),
    IN p_productName VARCHAR(100),
    IN p_productPrice FLOAT,
    IN p_productAmount INT,
    IN p_productDescription TEXT,
    IN p_productStatus BOOLEAN
)
BEGIN
    UPDATE Products
    SET productCode = p_productCode,
        productName = p_productName,
        productPrice = p_productPrice,
        productAmount = p_productAmount,
        productDescription = p_productDescription,
        productStatus = p_productStatus
    WHERE Id = p_id;
END //
DELIMITER ;

Call UpdateProductById (2,'exx','productUpdate',5,5,'Description',true);


-- Store procedure xoá sản phẩm theo id
DELIMITER //
CREATE PROCEDURE DeleteProductById(
    IN p_id INT
)
BEGIN
    DELETE FROM Products WHERE Id = p_id;
END //
DELIMITER ;
call DeleteProductById(3);