select bookname from book where price >= (select avg(price) from book);

select name from customer where custid in (select custid from orders);
select name from customer, orders where customer.custid = orders.custid group by customer.name;

select name from customer where custid in (select custid from orders where bookid in (select bookid from book where publisher = '이상미디어'));

create table NewBook (
bookname    varchar2(20) not null,
publisher   varchar2(20) unique,
price   number default 10000 check(price >= 1000),
primary key (bookname, publisher));

create table NewCustomer (
custid  number primary key,
name    varchar2(40),
address varchar2(40),
phone   varchar2(30));

CREATE TABLE NewOrders (
orderid NUMBER,
custid  NUMBER NOT NULL,
bookid  NUMBER NOT NULL,
saleprice   NUMBER,
orderdate   DATE,
PRIMARY KEY(orderid),
FOREIGN KEY(custid) REFERENCES NewCustomer(custid) ON DELETE CASCADE);

ALTER TABLE NewBook ADD isbn VARCHAR2(13);
ALTER TABLE NewBook MODIFY isbn NUMBER;
ALTER TABLE NewBook DROP COLUMN isbn;
ALTER TABLE NewBook MODIFY bookname NUMBER NOT NULL;

DROP TABLE NewBook;

DROP TABLE NewOrders;
DROP TABLE NewCustomer;

ALTER TABLE NewBook DROP PRIMARY KEY;
ALTER TABLE NewBook ADD bookid NUMBER NOT NULL;
ALTER TABLE NewBook ADD PRIMARY KEY(bookid);


INSERT INTO Book(bookid, bookname, publisher, price)
VALUES (11, '스포츠 의학', '한솔의학서적', 90000);

INSERT INTO Book (bookid, bookname, publisher, price)
VALUES (12, '스포츠 의학2', '한솔의학서적', NULL);

INSERT INTO Book SELECT * FROM Imported_Book ;

UPDATE Book SET bookname = '스포츠 의학1' WHERE bookid = 11;

DELETE FROM Book WHERE bookid = 12;

SELECT ROUND (6, -1) FROM DUAL;

SELECT ABS(-37) as A, ABS(25) as B FROM DUAL;
SELECT CEIL(2.94) FROM Dual;
SELECT FLOOR(3.14) FROM Dual;
SELECT LOG(10, 100) FROM Dual;
SELECT POWER(2, 5) FROM Dual;
SELECT SQRT(65536) FROM Dual;
SELECT SIGN(-2) FROM Dual;

SELECT bookid, REPLACE(bookname, '축구', '스포츠'), publisher, price FROM Book;

SELECT bookname, LENGTH(bookname) 글자수 FROM Book;

SELECT SUBSTR(name, 1, 1), COUNT(*) FROM Customer GROUP BY SUBSTR(name, 1, 1);

SELECT TO_DATE('2020-07-17', 'yyyy-mm-dd') +30 AFTER, TO_DATE('2020-07-17', 'yyyy-mm-dd') -30 BEFORE FROM Dual;

SELECT orderid 주문번호, custid 회원번호, orderdate 주문일 FROM orders;

SELECT orderid 주문번호, TO_CHAR(orderdate, 'yyyy-mm-dd') 주문일, custid 고객번호, bookid 도서번호 FROM Orders WHERE orderdate = '2014-07-07';

SELECT TO_CHAR(SYSDATE, 'yyyy-mm-dd dy hh24:mi:ss') "현재 시간" FROM Dual;

CREATE TABLE Mybook (
bookid  NUMBER,
price   NUMBER);

INSERT INTO Mybook VALUES (1, 10000);
INSERT INTO Mybook VALUES (2, 20000);
INSERT INTO Mybook VALUES (3, NULL);

SELECT * FROM Mybook;

SELECT price + 100 FROM Mybook WHERE bookid = 3;

SELECT * FROM Mybook WHERE price IS NULL;

SELECT * FROM Mybook WHERE price IS NOT NULL;

SELECT name 이름, NVL(phone, '연락처없음') FROM Customer;

SELECT custid, name, phone FROM Customer WHERE ROWNUM <= 3 ORDER BY name;

SELECT c.name, (SELECT SUM(o.saleprice) FROM orders o where c.custid = o.custid) sumprice FROM customer c;

ALTER TABLE orders ADD bookname VARCHAR(40);
UPDATE orders SET bookname = (SELECT bookname FROM Book WHERE orders.bookid = book.bookid);
SELECT * FROM orders;

SELECT (SELECT name FROM customer c WHERE c.custid = o.custid) name, SUM(saleprice) total FROM orders o WHERE o.custid<=2 GROUP BY o.custid;

SELECT custid, name FROM customer c WHERE custid <= 2;
SELECT c.name name, SUM(o.saleprice) total FROM orders o, (SELECT custid, name FROM customer WHERE custid <= 2) c WHERE c.custid = o.custid GROUP BY c.name;

SELECT orderid, saleprice FROM Orders WHERE saleprice > SOME (SELECT saleprice FROM Orders WHERE custid='3');

SELECT orderid, saleprice FROM Orders WHERE saleprice <= (SELECT AVG(saleprice) FROM orders);

SELECT o1.orderid 주문번호, o1.custid 고객번호, o1.saleprice 금액 FROM Orders o1 WHERE o1.saleprice > (SELECT AVG(saleprice) FROM Orders o2 WHERE o1.custid = o2.custid);

SELECT SUM(o.saleprice) 총판매액 FROM Orders o WHERE o.custid IN (SELECT c.custid FROM customer c WHERE c.address LIKE ('%대한민국%'));

SELECT orderid, saleprice FROM orders WHERE saleprice > ALL (SELECT saleprice FROM orders WHERE custid = '3');
SELECT orderid, saleprice FROM Orders WHERE saleprice > (SELECT MAX(saleprice) FROM Orders WHERE custid = '3');

SELECT SUM(o.saleprice) total FROM Orders o WHERE EXISTS (SELECT * FROM Customer c WHERE c.address LIKE '%대한민국%' AND c.custid = o.custid);

CREATE VIEW vw_Customer AS SELECT * FROM Customer WHERE address LIKE '%대한민국%';

SELECT * FROM vw_Customer;

CREATE VIEW vw_Order (orderid, custid, name, bookid, bookname, saleprice, orderdate) AS SELECT od.orderid, od.custid, cs.name, od.bookid, bk.bookname, od.saleprice, od.orderdate 
FROM Orders od, Customer cs, Book bk WHERE od.custid=cs.custid AND od.bookid=bk.bookid;

SELECT name, orderid, bookname, saleprice FROM vw_Order WHERE name='김연아';

CREATE OR REPLACE VIEW vw_Customer (custid, name, address) AS SELECT custid, name, address FROM Customer WHERE address LIKE '%영국%';

SELECT * FROM vw_Customer;

DROP VIEW vw_Customer;

CREATE INDEX ix_Book ON Book (bookname);

CREATE INDEX ix_Book2 ON Book (publisher, price);

SELECT * FROM Book WHERE publisher='대한미디어' AND price>=30000;

ALTER INDEX ix_Book REBUILD;

SELECT * FROM Book WHERE price>=33000;

DROP INDEX ix_Book;

EXEC InsertBook (13, '스포츠과학', '마당과학서적', 25000);
SELECT * FROM book;

EXEC BookInsertOrUpdate(15, '스포츠 즐거움', '마당과학서적', 25000);
SELECT * FROM Book;

EXEC BookInsertOrUpdate(15, '스포츠 즐거움', '마당과학서적', 20000);
SELECT * FROM Book;

SET SERVEROUTPUT ON;

EXEC Interest;

CREATE TABLE Book_log (
    bookid_l NUMBER,
    bookname_l VARCHAR2(40),
    publisher_l VARCHAR2(40),
    price_l NUMBER);
    
INSERT INTO Book VALUES(14, '스포츠 과학 1', '이상미디어', 25000);
SELECT * FROM Book WHERE bookid = '14';
SELECT * FROM Book_log WHERE bookid_l = '14';

SELECT custid, orderid, saleprice, fnc_Interest(saleprice) interest FROM Orders;