CREATE DATABASE StudentTest;
USE StudentTest;

CREATE TABLE Student
(
    RN   INT PRIMARY KEY,
    Name VARCHAR(50),
    Age  INT
);

CREATE TABLE Test
(
    TestID INT PRIMARY KEY,
    Name   VARCHAR(50)
);

CREATE TABLE StudentTest
(
    RN     INT,
    TestID INT,
    Date   DATE,
    Mark   FLOAT DEFAULT 0,
    PRIMARY KEY (RN, TestID),
    FOREIGN KEY (RN) REFERENCES Student (RN),
    FOREIGN KEY (TestID) REFERENCES Test (TestID)
);
INSERT INTO Student (RN, Name, Age)
VALUES (1, 'Nguyễn Văn A', 25),
       (2, 'Phạm Thị B', 30),
       (3, 'Trần Văn C', 18),
       (4, 'Lê Thị D', 40);

INSERT INTO Test (TestID, Name)
VALUES (101, 'Toán'),
       (102, 'Văn'),
       (103, 'Anh Văn'),
       (104, 'Lịch Sử');

INSERT INTO StudentTest (RN, TestID, Date, Mark)
VALUES (1, 101, '2023-11-05', 8),
       (1, 102, '2023-11-06', 7),
       (2, 101, '2023-11-07', 9),
       (2, 102, '2023-11-08', 8),
       (3, 101, '2023-11-05', 6),
       (3, 102, '2023-11-06', 5),
       (3, 103, '2023-11-07', 6);

# Thêm rang buộc
ALTER TABLE Student
    ADD CONSTRAINT AgeCheck CHECK (Age >= 15 AND Age <= 55);

ALTER TABLE StudentTest
    MODIFY COLUMN Mark FLOAT DEFAULT 0;

ALTER TABLE Test
    ADD CONSTRAINT UniqueName UNIQUE (Name);

ALTER TABLE Test
    ADD CONSTRAINT UniqueName UNIQUE (Name);

ALTER TABLE Test
    DROP CONSTRAINT UniqueName;
# 3.Hiển thị danh sách các học viên đã tham gia thi,
# các môn thi được thi bởi các học viên đó, điểm thi và ngày thi giống như hình sau:
SELECT s.Name AS StudentName, t.Name AS TestName, st.Mark, st.Date
FROM Student s
         JOIN StudentTest st ON s.RN = st.RN
         JOIN Test t ON st.TestID = t.TestID;
# 4.Hiển thị danh sách học viên chưa thi môn nào
# cach1
SELECT s.name
FROM student s
WHERE s.RN NOT IN (SELECT DISTINCT RN FROM StudentTest);
# cách 2
SELECT s.name
FROM student s
         LEFT JOIN StudentTest ST ON s.RN = ST.RN
WHERE ST.RN is null;
# 5.Hiển thị danh sách học viên phải thi lại, môn học và điểm thi:
SELECT s.Name AS StudentName, t.Name AS TestName, st.Mark
FROM Student s
         JOIN StudentTest st ON s.RN = st.RN
         JOIN Test t ON st.TestID = t.TestID
WHERE st.Mark < 8;
# 6 Hiển thị danh sách học viên và điểm trung bình của các môn đã thi:
SELECT s.Name AS StudentName, AVG(st.Mark) AS Average
FROM Student s
         JOIN StudentTest st ON s.RN = st.RN
GROUP BY s.Name
ORDER BY Average DESC;
#7 Hiển thị tên và điểm trung bình của học viên có điểm trung bình cao nhất:
SELECT s.Name AS StudentName, AVG(st.Mark) AS Average
FROM Student s
         JOIN StudentTest st ON s.RN = st.RN
GROUP BY s.Name
HAVING AVG(st.Mark) =
       (SELECT MAX(AvgMark) FROM (SELECT AVG(st2.Mark) AS AvgMark FROM StudentTest st2 GROUP BY st2.RN) AS AvgMarks)
ORDER BY Average DESC;

# 8 Hiển thị điểm cao nhất của từng môn học:
SELECT t.Name AS TestName, MAX(st.Mark) AS MaxMark
FROM Test t
         LEFT JOIN StudentTest st ON t.TestID = st.TestID
GROUP BY t.Name
ORDER BY t.Name;
# 9Hiển thị danh sách tất cả các học viên và môn học đã thi:
SELECT s.Name AS StudentName, t.Name AS TestName
FROM Student s
         CROSS JOIN Test t
         LEFT JOIN StudentTest st ON s.RN = st.RN AND t.TestID = st.TestID;
#10
UPDATE Student
SET Age = Age + 1;
#11-12
ALTER TABLE Student
    ADD Status VARCHAR(10);
UPDATE Student
SET Status =
        CASE
            WHEN Age <= 30 THEN 'Young'
            ELSE 'Old'
            END
WHERE  RN;
SELECT * FROM  Student;
# 13
SELECT s.Name AS StudentName, st.Mark, st.Date
FROM Student s
         JOIN StudentTest st ON s.RN = st.RN
ORDER BY st.Date ASC;
#14
SELECT s.Name AS StudentName, s.Age, AVG(st.Mark) AS diemTrungBinh
FROM Student s
         JOIN StudentTest st ON s.RN = st.RN
GROUP BY s.RN
HAVING s.Name LIKE 'T%' AND AVG(st.Mark) > 4.5;
# 15
SELECT s.RN, s.Name AS StudentName, s.Age, AVG(st.Mark) AS Average,
       RANK() OVER (ORDER BY AVG(st.Mark) DESC) AS Ranking
FROM Student s
         JOIN StudentTest st ON s.RN = st.RN
GROUP BY s.RN
HAVING AVG(st.Mark) = (SELECT MAX(AvgMark) FROM (SELECT AVG(st2.Mark)
    AS AvgMark FROM StudentTest st2 GROUP BY st2.RN) AS AvgMarks);
# 16
ALTER TABLE Student
    MODIFY COLUMN Name NVARCHAR(255);
#17
UPDATE Student
SET Name =
        CASE
            WHEN Age > 20 THEN 'Old ' + Name
            ELSE 'Young ' + Name
            END
WHERE  RN;

select * from  Student;
#18
DELETE FROM Test
WHERE TestID NOT IN (SELECT DISTINCT TestID FROM StudentTest);
#19
DELETE FROM StudentTest
WHERE Mark < 5;