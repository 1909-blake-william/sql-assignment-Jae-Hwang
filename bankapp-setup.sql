DROP USER bank_app CASCADE;
CREATE USER bank_app
IDENTIFIED BY bankpass
DEFAULT TABLESPACE users
TEMPORARY TABLESPACE temp
QUOTA 10M ON users;
GRANT CONNECT TO bank_app;
GRANT RESOURCE TO bank_app;
GRANT CREATE SESSION TO bank_app;
GRANT CREATE TABLE TO bank_app;
GRANT CREATE VIEW TO bank_app;
conn bank_app/bankpass;

/************************************
Tables and sequences
************************************/
CREATE SEQUENCE bank_users_id_seq;
CREATE TABLE bank_users (
    user_id INT PRIMARY KEY,
    username VARCHAR2(20) UNIQUE NOT NULL,
    password VARCHAR2(20) NOT NULL,
    permis VARCHAR2(10) DEFAULT 'user' NOT NULL
);

CREATE SEQUENCE bank_accounts_id_seq;
CREATE TABLE bank_accounts (
    account_id INT PRIMARY KEY,
    user_id INT REFERENCES bank_users(user_id),
    balance INT DEFAULT 0
);

CREATE SEQUENCE transactions_id_seq;
CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY,
    account_id INT REFERENCES bank_accounts(account_id),
    amount INT NOT NULL,
    runningBalance INT DEFAULT 0
);

/*******************************************************
Triggers
*******************************************************/
CREATE OR REPLACE TRIGGER update_bal
BEFORE INSERT ON transactions
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        UPDATE bank_accounts 
            SET balance = (balance + :new.amount)
            WHERE :new.account_id = bank_accounts.account_id;
        SELECT balance INTO :new.runningBalance FROM bank_accounts
            WHERE :new.account_id = bank_accounts.account_id;
    END IF;
END;
/
/*******************************************************/

/*******************************************************
Example Data
*******************************************************/
---- users ----
INSERT INTO bank_users (user_id, username, password, permis)
    VALUES (BANK_USERS_ID_SEQ.NEXTVAL, 'Admin', 'admi', 'Admin');

INSERT INTO bank_users (user_id, username, password)
    VALUES (BANK_USERS_ID_SEQ.NEXTVAL, 'Lettuce', 'lett');

INSERT INTO bank_users (user_id, username, password)
    VALUES (BANK_USERS_ID_SEQ.NEXTVAL, 'Tomato', 'toma');

INSERT INTO bank_users (user_id, username, password)
    VALUES (BANK_USERS_ID_SEQ.NEXTVAL, 'Onion', 'Onio');

---- accounts ----
INSERT INTO bank_accounts (account_id, user_id)
    VALUES (BANK_ACCOUNTS_ID_SEQ.NEXTVAL, 1);

INSERT INTO bank_accounts (account_id, user_id)
    VALUES (BANK_ACCOUNTS_ID_SEQ.NEXTVAL, 1);

INSERT INTO bank_accounts (account_id, user_id)
    VALUES (BANK_ACCOUNTS_ID_SEQ.NEXTVAL, 2);

INSERT INTO bank_accounts (account_id, user_id)
    VALUES (BANK_ACCOUNTS_ID_SEQ.NEXTVAL, 3);

INSERT INTO bank_accounts (account_id, user_id)
    VALUES (BANK_ACCOUNTS_ID_SEQ.NEXTVAL, 3);

---- transactions ----
INSERT INTO transactions (transaction_id, account_id, amount)
    VALUES (TRANSACTIONS_ID_SEQ.NEXTVAL, 1, 100);

INSERT INTO transactions (transaction_id, account_id, amount)
    VALUES (TRANSACTIONS_ID_SEQ.NEXTVAL, 1, 100);

INSERT INTO transactions (transaction_id, account_id, amount)
    VALUES (TRANSACTIONS_ID_SEQ.NEXTVAL, 1, 100);

INSERT INTO transactions (transaction_id, account_id, amount)
    VALUES (TRANSACTIONS_ID_SEQ.NEXTVAL, 2, 300);

INSERT INTO transactions (transaction_id, account_id, amount)
    VALUES (TRANSACTIONS_ID_SEQ.NEXTVAL, 2, -200);

INSERT INTO transactions (transaction_id, account_id, amount)
    VALUES (TRANSACTIONS_ID_SEQ.NEXTVAL, 2, 300);

INSERT INTO transactions (transaction_id, account_id, amount)
    VALUES (TRANSACTIONS_ID_SEQ.NEXTVAL, 3, 1000);

INSERT INTO transactions (transaction_id, account_id, amount)
    VALUES (TRANSACTIONS_ID_SEQ.NEXTVAL, 4, 300);

INSERT INTO transactions (transaction_id, account_id, amount)
    VALUES (TRANSACTIONS_ID_SEQ.NEXTVAL, 4, -300);

INSERT INTO transactions (transaction_id, account_id, amount)
    VALUES (TRANSACTIONS_ID_SEQ.NEXTVAL, 4, 400);

INSERT INTO transactions (transaction_id, account_id, amount)
    VALUES (TRANSACTIONS_ID_SEQ.NEXTVAL, 4, -700);

commit;

/**  Example Queries**/
/************************************************************************************************
SELECT * FROM bank_users;

SELECT * FROM bank_accounts;

SELECT * FROM transactions ORDER BY transaction_id DESC;

SELECT * FROM bank_users
    INNER JOIN bank_accounts ON bank_users.user_id = bank_accounts.user_id
    INNER JOIN transactions ON bank_accounts.account_id = transactions.account;
************************************************************************************************/