conn isit311/isit311
EXPLAIN PLAN FOR
SELECT P_NAME, PS_AVAILQTY, P_BRAND
FROM PART JOIN PARTSUPP
          ON P_PARTKEY = PS_PARTKEY
WHERE PS_AVAILQTY > 280 ;

@D:\SIM\UOW\Teaching\SCIT\CSCI317\Tutorial\showplan

set echo on

EXPLAIN PLAN FOR
SELECT L_TAX, L_QUANTITY, L_PARTKEY
FROM LINEITEM
WHERE L_TAX = 0.2 AND L_DISCOUNT = 0.1 ;

@D:\SIM\UOW\Teaching\SCIT\CSCI317\Tutorial\showplan

set echo on

EXPLAIN PLAN FOR
SELECT O_CUSTKEY, C_NAME, SUM(O_TOTALPRICE)
FROM ORDERS JOIN CUSTOMER
            ON O_CUSTKEY = C_CUSTKEY
GROUP BY O_CUSTKEY, C_NAME;

@D:\SIM\UOW\Teaching\SCIT\CSCI317\Tutorial\showplan

EXPLAIN PLAN FOR
SELECT C_CUSTKEY, C_NAME, C_ADDRESS
FROM CUSTOMER
WHERE C_CUSTKEY NOT IN ( SELECT O_CUSTKEY
                         FROM ORDERS );
@D:\SIM\UOW\Teaching\SCIT\CSCI317\Tutorial\showplan

set echo on

EXPLAIN PLAN FOR
SELECT P_NAME, S_NAME, S_PHONE
FROM PART JOIN PARTSUPP
          ON P_PARTKEY = PS_PARTKEY
          JOIN SUPPLIER
          ON S_SUPPKEY = PS_SUPPKEY;

@D:\SIM\UOW\Teaching\SCIT\CSCI317\Tutorial\showplan

-- Create the requuired indexes
CREATE INDEX IDX1 ON PARTSUPP(PS_AVAILQTY,PS_PARTKEY);
CREATE INDEX IDX2 ON  LINEITEM(L_TAX,L_DISCOUNT,L_QUANTITY,L_PARTKEY);
CREATE INDEX IDX3 ON ORDERS(O_CUSTKEY,O_TOTALPRICE);
CREATE INDEX IDX4 ON ORDERS(O_CUSTKEY);
CREATE INDEX IDX5 ON PART(P_PARTKEY,P_NAME);

--
EXPLAIN PLAN FOR
SELECT P_NAME, PS_AVAILQTY, P_BRAND
FROM PART JOIN PARTSUPP
          ON P_PARTKEY = PS_PARTKEY
WHERE PS_AVAILQTY > 280 ;

@D:\SIM\UOW\Teaching\SCIT\CSCI317\Tutorial\showplan

set echo on

EXPLAIN PLAN FOR
SELECT L_TAX, L_QUANTITY, L_PARTKEY
FROM LINEITEM
WHERE L_TAX = 0.2 AND L_DISCOUNT = 0.1 ;

@D:\SIM\UOW\Teaching\SCIT\CSCI317\Tutorial\showplan

set echo on

EXPLAIN PLAN FOR
SELECT O_CUSTKEY, C_NAME, SUM(O_TOTALPRICE)
FROM ORDERS JOIN CUSTOMER
            ON O_CUSTKEY = C_CUSTKEY
GROUP BY O_CUSTKEY, C_NAME;

@D:\SIM\UOW\Teaching\SCIT\CSCI317\Tutorial\showplan

EXPLAIN PLAN FOR
SELECT C_CUSTKEY, C_NAME, C_ADDRESS
FROM CUSTOMER
WHERE C_CUSTKEY NOT IN ( SELECT O_CUSTKEY
                         FROM ORDERS );
@D:\SIM\UOW\Teaching\SCIT\CSCI317\Tutorial\showplan

set echo on

EXPLAIN PLAN FOR
SELECT P_NAME, S_NAME, S_PHONE
FROM PART JOIN PARTSUPP
          ON P_PARTKEY = PS_PARTKEY
          JOIN SUPPLIER
          ON S_SUPPKEY = PS_SUPPKEY;

@D:\SIM\UOW\Teaching\SCIT\CSCI317\Tutorial\showplan


-- Clean up
DROP INDEX IDX1;
DROP INDEX IDX2;
DROP INDEX IDX3;
DROP INDEX IDX4;
DROP INDEX IDX5;