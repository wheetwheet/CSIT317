SPOOL solution2.lst

SET ECHO ON
SET FEEDBACK ON
SET LINESIZE 300
SET PAGESIZE 300

-- Whitney Chng Yia Qing
-- 6956865
-- Assignment 3 Task 2

connect tpchr/oracle

-- 1 Find all information about the items included in the orders and such that shipment of each item happened on a given day.

EXPLAIN PLAN  FOR
SELECT * 
FROM LINEITEM
WHERE L_SHIPDATE = TO_DATE('01-SEP-1992','DD-MON-YYYY');
@showplan

-- 2 Create partition table PLINEITEM

CREATE TABLE PLINEITEM(
L_ORDERKEY 	NUMBER(12)	NOT NULL,
L_PARTKEY	NUMBER(12)	NOT NULL,
L_SUPPKEY	NUMBER(12)	NOT NULL,
L_LINENUMBER	NUMBER(12)	NOT NULL,
L_QUANTITY	NUMBER(12,2)	NOT NULL,
L_EXTENDEDPRICE NUMBER(12,2)	NOT NULL,
L_DISCOUNT	NUMBER(12,2)	NOT NULL,
L_TAX		NUMBER(12,2)	NOT NULL,
L_RETURNFLAG	CHAR(1)		NOT NULL,
L_LINESTATUS	CHAR(1)		NOT NULL,
L_SHIPDATE	DATE		NOT NULL,
L_COMMITDATE	DATE		NOT NULL,
L_RECEIPTDATE	DATE		NOT NULL,
L_SHIPINSTRUCT	CHAR(25)	NOT NULL,
L_SHIPMODE	CHAR(10)	NOT NULL,
L_COMMENT	VARCHAR(44)	NOT NULL,
	CONSTRAINT PLINEITEM_PKEY PRIMARY KEY (L_ORDERKEY, L_LINENUMBER),
	CONSTRAINT PLINEITEM_FKEY1 FOREIGN kEY (L_ORDERKEY)
		REFERENCES ORDERS(O_ORDERKEY),
	CONSTRAINT PLINEITEM_FKEY2 FOREIGN KEY (L_PARTKEY)
		REFERENCES PART(P_PARTKEY),
	CONSTRAINT PLINEITEM_FKEY3 FOREIGN KEY (L_PARTKEY,L_SUPPKEY)
		REFERENCES PARTSUPP(PS_PARTKEY, PS_SUPPKEY),
	CONSTRAINT PLINEITEM_FKEY4 FOREIGN kEY (L_SUPPKEY)
		REFERENCES SUPPLIER(S_SUPPKEY),
	CONSTRAINT PLINEITEM_CHECK1 CHECK (L_QUANTITY >= 0),
	CONSTRAINT PLINEITEM_CHECK2 CHECK (L_EXTENDEDPRICE >= 0),
	CONSTRAINT PLINEITEM_CHECK3 CHECK (L_TAX >= 0),
	CONSTRAINT PLINEITEM_CHECK4 CHECK (L_DISCOUNT BETWEEN 0.00 AND 1.00))
PARTITION BY RANGE(L_SHIPDATE)
	(PARTITION P92 VALUES LESS THAN (TO_DATE('31-DEC-1992','DD-MON-YYYY') ),
	PARTITION P93 VALUES LESS THAN (TO_DATE('31-DEC-1993','DD-MON-YYYY') ),
	PARTITION P94 VALUES LESS THAN (TO_DATE('31-DEC-1994','DD-MON-YYYY') ),
	PARTITION P95 VALUES LESS THAN (TO_DATE('31-DEC-1995','DD-MON-YYYY') ),
	PARTITION P96 VALUES LESS THAN (TO_DATE('31-DEC-1996','DD-MON-YYYY') ),
	PARTITION P97 VALUES LESS THAN (TO_DATE('31-DEC-1997','DD-MON-YYYY') ),
	PARTITION P98 VALUES LESS THAN (TO_DATE('31-DEC-1998','DD-MON-YYYY') ),
	PARTITION P99 VALUES LESS THAN (TO_DATE('31-DEC-1999','DD-MON-YYYY') ));

INSERT INTO PLINEITEM (SELECT * FROM LINEITEM);
COMMIT;

-- 3 Processing Plan PLINEITEM
EXPLAIN PLAN  FOR
SELECT * 
FROM PLINEITEM
PARTITION(P92)
WHERE L_SHIPDATE = TO_DATE('01-SEP-1992','DD-MON-YYYY');
@showplan

-- 4 Global Partitioned Index
CREATE INDEX GlobalIdx ON PLINEITEM(L_SHIPDATE)
GLOBAL PARTITION BY RANGE(L_SHIPDATE)(
	PARTITION P92 VALUES LESS THAN (TO_DATE('31-DEC-1992', 'DD-MON-YYYY')),
	PARTITION P93 VALUES LESS THAN (TO_DATE('31-DEC-1993', 'DD-MON-YYYY')),
	PARTITION P94 VALUES LESS THAN (TO_DATE('31-DEC-1994', 'DD-MON-YYYY')),
	PARTITION P95 VALUES LESS THAN (TO_DATE('31-DEC-1995', 'DD-MON-YYYY')),
	PARTITION P96 VALUES LESS THAN (TO_DATE('31-DEC-1996', 'DD-MON-YYYY')),
	PARTITION P97 VALUES LESS THAN (TO_DATE('31-DEC-1997', 'DD-MON-YYYY')),
	PARTITION P98 VALUES LESS THAN (TO_DATE('31-DEC-1998', 'DD-MON-YYYY')),
	PARTITION P99 VALUES LESS THAN (MAXVALUE));

-- 5 Processing Plan with Global Index
EXPLAIN PLAN FOR
SELECT * 
FROM PLINEITEM
PARTITION (P92)
WHERE L_SHIPDATE = TO_DATE('01-SEP-1992','DD-MON-YYYY');
@showplan

-- 6 Drop Global Partition Index
DROP INDEX GlobalIdx;

-- 6 Local Partition Index
CREATE INDEX LocalIdx ON PLINEITEM(L_SHIPDATE) LOCAL
(PARTITION P92,
PARTITION P93,
PARTITION P94,
PARTITION P95,
PARTITION P96,
PARTITION P97,
PARTITION P98,
PARTITION P99);

-- 7 Processing Plan Local Index
EXPLAIN PLAN FOR
SELECT * 
FROM PLINEITEM PARTITION (P92)
WHERE L_SHIPDATE = TO_DATE('01-SEP-1992','DD-MON-YYYY');
@showplan

-- 8 Drop PLINEITEM and Local Index
DROP INDEX LocalIdx;
DROP TABLE PLINEITEM PURGE;

SPOOL OFF