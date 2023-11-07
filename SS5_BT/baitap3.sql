CREATE DATABASE IF NOT EXISTS QuanLySinhVien;
USE QuanLySinhVien;
CREATE TABLE IF NOT EXISTS Students
(
    StudentID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50),
    LastName  VARCHAR(50),
    Age       INT,
    Gender    VARCHAR(10)
);

-- Chèn dữ liệu mẫu
INSERT INTO Students (FirstName, LastName, Age, Gender)
VALUES ('ho', 'tien', 20, 'Male'),
       ('le', 'hung', 22, 'Female'),
       ('bao', 'ngoc', 19, 'Male'),
       ('kim', 'cuc', 21, 'Female');


CREATE TABLE IF NOT EXISTS Classes
(
    ClassID   INT PRIMARY KEY,
    ClassName VARCHAR(50)
);

-- Chèn dữ liệu mẫu
INSERT INTO Classes (ClassID, ClassName)
VALUES (1, 'C0706L'),
       (2, 'C0708G');

CREATE TABLE IF NOT EXISTS ClassStudent
(
    ClassID   INT,
    StudentID INT,
    PRIMARY KEY (ClassID, StudentID),
    FOREIGN KEY (ClassID) REFERENCES Classes (ClassID),
    FOREIGN KEY (StudentID) REFERENCES Students (StudentID)
);

-- Chèn dữ liệu mẫu
INSERT INTO ClassStudent (ClassID, StudentID)
VALUES (1, 1),
       (1, 2),
       (2, 3),
       (2, 4);


CREATE TABLE IF NOT EXISTS Subjects
(
    SubjectID   INT PRIMARY KEY,
    SubjectName VARCHAR(50)
);

-- Chèn dữ liệu mẫu
INSERT INTO Subjects (SubjectID, SubjectName)
VALUES (1, 'Toan'),
       (2, 'ly'),
       (3, 'Hoa');


CREATE TABLE IF NOT EXISTS Marks
(
    MarkID    INT PRIMARY KEY AUTO_INCREMENT,
    StudentID INT,
    SubjectID INT,
    Mark      FLOAT,
    FOREIGN KEY (StudentID) REFERENCES Students (StudentID),
    FOREIGN KEY (SubjectID) REFERENCES Subjects (SubjectID)
);

-- Chèn dữ liệu mẫu
INSERT INTO Marks (StudentID, SubjectID, Mark)
VALUES (1, 1, 8.5),
       (1, 2, 7.0),
       (2, 1, 9.0),
       (2, 2, 8.0),
       (3, 1, 7.5),
       (3, 2, 6.5),
       (4, 1, 8.0),
       (4, 2, 7.5);

-- thực hiện yêu cầu đề bài

-- 1. hiên thi danh sách tất cả học viên
SELECT *
FROM Students;
-- 2. Hien thi danh sach tat ca cac mon hoc
SELECT *
FROM Subjects;
-- 3 Tinh diem trung binh
select StudentID, avg(Mark) as diemTrungBinh
from Marks
group by StudentID;
-- 4 Hien thi mon hoc nao co hoc sinh thi duoc diem cao nhat
SELECT SubjectID, MAX(Mark) AS MaxMark
FROM Marks
GROUP BY SubjectID;

-- 5 Danh so thu tu cua diem theo chieu giam
SELECT MarkID, Mark
from Marks
ORDER BY Mark desc;
-- 6 Thay doi kieu du lieu cua cot SubjectName trong bang Subjects thanh nvarchar(max)
ALTER TABLE Subjects
    MODIFY COLUMN SubjectName VARCHAR(50);

# 7. Cap nhat them dong chu « Day la mon hoc « vao truoc cac ban ghi tren cot SubjectName trong bang Subjects
UPDATE Subjects
SET SubjectName = CONCAT('day la mon hoc: ', SubjectName)
WHERE SubjectID;
select *
from Subjects;

#8 Viet Check Constraint de kiem tra do tuoi nhap vao trong bang Student yeu cau Age >15 va Age < 50
ALTER TABLE Students
 ADD CONSTRAINT CheckAgeRange CHECK (Age > 15 AND Age < 50);
#9 Loai bo tat ca quan he giua cac bang
-- Loại bỏ các khóa ngoại của bảng ClassStudent
ALTER TABLE ClassStudent DROP FOREIGN KEY ClassStudent_ibfk_1;
ALTER TABLE ClassStudent DROP FOREIGN KEY ClassStudent_ibfk_2;

-- Loại bỏ các khóa ngoại của bảng Marks
ALTER TABLE Marks DROP FOREIGN KEY Marks_ibfk_1;
ALTER TABLE Marks DROP FOREIGN KEY Marks_ibfk_2;
# 10.Xoa hoc vien co StudentID la 1
DELETE FROM Students WHERE StudentID = 1;
# 11.Trong bang Student them mot column Status co kieu du lieu la Bit va co gia tri Default la 1

ALTER TABLE Students
    ADD Status BIT DEFAULT 1;
# 12.Cap nhap gia tri Status trong bang Student thanh 0
UPDATE Students
SET Status = 0;