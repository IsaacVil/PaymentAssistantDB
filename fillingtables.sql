DROP PROCEDURE IF EXISTS insertusers;
DROP PROCEDURE IF EXISTS insertmodules;
DROP PROCEDURE IF EXISTS insertplan;
DROP PROCEDURE IF EXISTS insertsplanprices;
DROP PROCEDURE IF EXISTS insertcurrencies;
DROP PROCEDURE IF EXISTS insertsubscriptions;
DROP PROCEDURE IF EXISTS insertschedules;
DROP PROCEDURE IF EXISTS insertschedulesdetails;
DROP PROCEDURE IF EXISTS insert_exchangerates;
DROP PROCEDURE IF EXISTS insertpaymentmethods;
DROP PROCEDURE IF EXISTS insertavailablemethods;
DROP PROCEDURE IF EXISTS insertpayments;
DROP PROCEDURE IF EXISTS inserttransactiontypes;
DROP PROCEDURE IF EXISTS inserttransactionsubtypes;
DROP PROCEDURE IF EXISTS inserttransactions;
-- INSERT USERS ------------------------------------------------------------------------------------------------------------------------
DELIMITER //
CREATE PROCEDURE insertusers()
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE num_users INT DEFAULT 50; 
	DECLARE nombreusado VARCHAR(45);
	DECLARE apellidousado VARCHAR(45);
    DECLARE enablebit BIT; 
    DECLARE verifiedbit BIT;
    CREATE TEMPORARY TABLE nombres (nombre VARCHAR(45));
    CREATE TEMPORARY TABLE apellidos (apellido VARCHAR(45));
    
    INSERT INTO nombres (nombre)
    VALUES
        ('Isaac'),('Carlos'),('David'),('Pedro'),('Juan'),('María'),('Ana'),('José'),('Roberto'),('Miguel'),('Arturo'),('Rodrigo'),('Kevin'),('José'),('Samuel'),('Viviana'),('Sofia'),('Lucia'),('Martina'),('Pabla'),('Christopher'),('Adriana'),('Anthony'),('Walter'),('Bruce'),('Carmela');
        
    INSERT INTO apellidos (apellido)
    VALUES
        ('Villalobos'),('López'),('González'),('Pérez'),('Rodríguez'),('Hernández'),('Martínez'),('Sánchez'),('Ramírez'),('Fernández'),('Cheng'),('Johnson'),('Bonilla'),('Castillo'),('Moltisanti'),('La_Cerva'),('Soprano'),('White'),('Wayne'),('Gualtieri');
        
    WHILE i < num_users DO
        SELECT nombre INTO nombreusado FROM nombres ORDER BY RAND() LIMIT 1;
        SELECT apellido INTO apellidousado FROM apellidos ORDER BY RAND() LIMIT 1;
        SET enablebit = IF(RAND() < 0.3, 0, 1); 
        SET verifiedbit = IF(RAND() < 0.3, 0, 1);
        INSERT INTO `PayAssistantDB`.`paya_users` 
        (`username`, `email`, `password`, `fname`, `lname`, `phone`, `enable`, `verified`, `creationdate`, `lastlogin`) 
        VALUES 
        (CONCAT(nombreusado, '_', apellidousado, FLOOR(RAND()*500)), 
        CONCAT(nombreusado, apellidousado, FLOOR(RAND() * 2280), '@gmail.com'),
        AES_ENCRYPT('ContraseñaSuperSecreta', 'jK3+5wGgL7eA1TRUQUITOPARACONTRASEÑASxT9KzLdq4YfX8jNwB9V'), 
        nombreusado, apellidousado, CONCAT(FLOOR(RAND() * 100000000), '') , enablebit, verifiedbit, 
        DATE_SUB(CURDATE(), INTERVAL FLOOR(RAND() * (720 - 180 + 1)) + 180 DAY) + INTERVAL FLOOR(RAND() * 60) MINUTE + INTERVAL FLOOR(RAND() * 60) SECOND,
        DATE_SUB(CURDATE(), INTERVAL FLOOR(RAND() * 180) DAY) + INTERVAL FLOOR(RAND() * 60) MINUTE + INTERVAL FLOOR(RAND() * 60) SECOND);
        SET i = i + 1;
    END WHILE;
    DROP TEMPORARY TABLE IF EXISTS nombres;
    DROP TEMPORARY TABLE IF EXISTS apellidos;
END //
DELIMITER ;
CALL insertusers();
SELECT * FROM paya_users;
-- INSERT MODULES ------------------------------------------------------------------------------------------------------------------------
DELIMITER //
CREATE PROCEDURE insertmodules()
BEGIN
    INSERT INTO `PayAssistantDB`.`paya_modules` 
    (name) 
    VALUES 
    ('Permission Settings'), ('Payment Method Settings'), ('Billing Management'), ('Activity Logs'), ('User Management'), ('AI Chat Assistant');
END //
DELIMITER ;
CALL insertmodules();
SELECT * FROM paya_modules;
-- INSERT CURRENCIES --------------------------------------------------------------------------------------------------------------------------
select * from paya_currencies;
DELIMITER //
CREATE PROCEDURE insertcurrencies()
BEGIN
        INSERT INTO `PayAssistantDB`.`paya_currencies` 
        (`name`, `acronym`, `country`, `symbol`)
        VALUES 
		('United States Dollar', 'USD', 'United States', '$'),
		('Euro', 'EUR', 'European Union', '€'),
		('British Pound', 'GBP', 'United Kingdom', '£'),
		('Japanese Yen', 'JPY', 'Japan', '¥'),
		('Swiss Franc', 'CHF', 'Switzerland', 'Fr'),
		('Canadian Dollar', 'CAD', 'Canada', 'C$'),
		('Australian Dollar', 'AUD', 'Australia', 'A$'),
		('Indian Rupee', 'INR', 'India', '₹'),
		('Chinese Yuan', 'CNY', 'China', '¥'),
		('Brazilian Real', 'BRL', 'Brazil', 'R$'),
        ('Costa Rican Colon', 'CRC', 'Costa Rica', '₡');
END //
DELIMITER ;
CALL insertcurrencies();
SELECT * FROM paya_currencies;
-- INSERT EXCHANGERATE --------------------------------------------------------------------------------------------------------------------------
DELIMITER //
CREATE PROCEDURE insert_exchangerates()
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE numcurrencies INT;
    DECLARE currency_source_id INT;
    DECLARE currency_destiny_id INT;
    DECLARE start_date DATETIME;
    DECLARE end_date DATETIME;
    DECLARE current_rate BIT;
    SELECT COUNT(*) INTO numcurrencies FROM `PayAssistantDB`.`paya_currencies`;
    WHILE i < (numcurrencies * (numcurrencies - 1)) DO
        -- Seleccionar la moneda fuente (source) de la tabla de currencies
        SELECT `currencyid` INTO currency_source_id FROM `PayAssistantDB`.`paya_currencies`
        ORDER BY RAND() LIMIT 1;
        -- Seleccionar la moneda destino (destiny) de la tabla de currencies (debe ser distinta de la fuente)
        SELECT `currencyid` INTO currency_destiny_id FROM `PayAssistantDB`.`paya_currencies`
        WHERE `currencyid` != currency_source_id ORDER BY RAND() LIMIT 1;
        SET start_date = DATE_SUB(CURDATE(), INTERVAL FLOOR(RAND() * 365) DAY);
        SET end_date = DATE_ADD(start_date, INTERVAL FLOOR(RAND() * 30) DAY);
        SET current_rate = IF(RAND() < 0.5, 1, 0);  
        INSERT INTO `PayAssistantDB`.`paya_exchangerates` 
        (`startdate`, `enddate`, `exchangerate`, `currentexchangerate`, `currencyidsource`, `currencyiddestiny`)
        VALUES
        (start_date, end_date, ROUND((RAND() * 4.9) + 0.7, 4), current_rate, currency_source_id, currency_destiny_id);
        SET i = i + 1;
    END WHILE;
END //
DELIMITER ;
CALL insert_exchangerates();
SELECT * FROM paya_exchangerates;
-- INSERT SUBSCRIPTIONS ------------------------------------------------------------------------------------------------------------------------
DELIMITER //
CREATE PROCEDURE insertsubscriptions()
BEGIN
        INSERT INTO `PayAssistantDB`.`paya_subscriptions` 
        (`description`, `logoURL`, `startdate`, `enddate`, `autorenew`)
        VALUES 
		('No Schedual Limitations', 'https://example.com/logo1.png', '2024-03-15 12:40:00', '2025-03-15 00:00:00', 1),
		('Premium Subscription', 'https://example.com/logo2.png', '2024-04-10 10:30:00', '2025-04-10 00:00:00', 0),
		('Exclusive Deals', 'https://example.com/logo3.png', '2024-05-05 00:40:00', '2025-05-05 00:00:00', 1),
		('VIP Benefits', 'https://example.com/logo4.png', '2024-06-20 06:20:00', '2025-06-20 00:00:00', 0),
		('Special Discounts', 'https://example.com/logo5.png', '2024-07-25 10:03:00', '2025-07-25 00:00:00', 1),
		('Exclusive Content Access', 'https://example.com/logo6.png', '2024-08-13 01:01:10', '2025-08-13 00:00:00', 0),
		('Anual Subscription', 'https://example.com/logo7.png', '2024-09-30 20:03:00', '2025-09-30 00:00:00', 1),
		('Premium Bank Plan', 'https://example.com/logo8.png', '2024-10-05 20:00:02', '2025-10-05 00:00:00', 0),
		('Unlimited Transcriptions', 'https://example.com/logo9.png', '2024-11-18 02:33:00', '2025-11-18 00:00:00', 1),
		('NO ADS', 'https://example.com/logo10.png', '2024-12-02 00:00:00', '2025-12-02 06:30:00', 0);
END //
DELIMITER ;
CALL insertsubscriptions();
SELECT * FROM paya_subscriptions;
-- INSERT SCHEDULES ------------------------------------------------------------------------------------------------------------------------
DELIMITER //
CREATE PROCEDURE insertschedules()
BEGIN
        INSERT INTO `PayAssistantDB`.`paya_schedules` 
        (`name`, `recurrencytype`, `repeat`, `endtype`, `repetitions`, `enddate`)
        VALUES 
		('Schedule 1', 'DAILY', 1, 'DATE', 45, '2025-03-10 14:32:53'),
		('Schedule 2', 'WEEKLY', 0, 'REPETITIONS', 10, '2025-06-15 18:47:21'),
		('Schedule 4', 'YEARLY', 1, 'DATE', 20, '2025-04-07 11:45:30'),
		('Schedule 5', 'CUSTOM', 0, 'REPETITIONS', 15, '2025-09-12 20:59:04');
        INSERT INTO `PayAssistantDB`.`paya_schedules` 
        (`name`, `recurrencytype`, `repeat`, `endtype`, `repetitions`)
        VALUES 
        ('Schedule 3', 'MONTHLY', 1, 'NEVER', 0);
END //
DELIMITER ;
CALL insertschedules();
SELECT * FROM paya_schedules;
-- INSERT SCHEDULES DETAILS------------------------------------------------------------------------------------------------------------------------
DELIMITER //
CREATE PROCEDURE insertschedulesdetails()
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE random_scheduleid INT;
    DECLARE deletedbit BIT;
    WHILE i < 20 DO
        SELECT scheduleid INTO random_scheduleid 
        FROM `PayAssistantDB`.`paya_schedules` 
        ORDER BY RAND() 
        LIMIT 1;
        SET deletedbit = IF(RAND() < 0.3, 0, 1); 
        INSERT INTO `PayAssistantDB`.`paya_scheduledetails` 
        (`deleted`, `basedate`, `datepart`, `lastexecution`, `nextexecution`, `scheduleid`)
        VALUES
        (deletedbit, DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 365) DAY), IF(FLOOR(RAND() * 2) = 0, 'MM', 'YY'), DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 30) DAY),
        DATE_ADD(NOW(), INTERVAL FLOOR(RAND() * 30) DAY), random_scheduleid);
        SET i = i + 1;
    END WHILE;
END //
DELIMITER ;
CALL insertschedulesdetails();
SELECT * FROM paya_scheduledetails;
-- INSERT PLAN PRICES ------------------------------------------------------------------------------------------------------------------------
DELIMITER //
CREATE PROCEDURE insertsplanprices()
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE random_subscriptionid INT;
    DECLARE random_currencyid INT;
    DECLARE random_scheduledetailsid INT;
    DECLARE random_amount DECIMAL(10,2);
    DECLARE random_current BIT(1);
    DECLARE random_postdate DATETIME;
    DECLARE random_enddate DATETIME;
    WHILE i < 20 DO
        SELECT subscriptionid INTO random_subscriptionid FROM `PayAssistantDB`.`paya_subscriptions` ORDER BY RAND() LIMIT 1;
        SELECT currencyid INTO random_currencyid FROM `PayAssistantDB`.`paya_currencies` ORDER BY RAND() LIMIT 1;
        SELECT scheduledetailsid INTO random_scheduledetailsid FROM `PayAssistantDB`.`paya_scheduledetails` ORDER BY RAND() LIMIT 1;
        SET random_amount = ROUND((FLOOR(RAND() * 1000) + 10), 2); 
        SET random_current = FLOOR(RAND() * 2); 
        SET random_postdate = DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 30) DAY);
        SET random_enddate = DATE_ADD(random_postdate, INTERVAL FLOOR(RAND() * 30) + 1 DAY);
        INSERT INTO `PayAssistantDB`.`paya_planprices` 
        (`amount`, `current`, `subscriptionid`, `scheduledetailsid`, `currencyid`, `postdate`, `enddate`)
        VALUES
        (random_amount, random_current, random_subscriptionid, random_scheduledetailsid, random_currencyid, random_postdate, random_enddate);
        SET i = i + 1;
    END WHILE;
END //
DELIMITER ;
CALL insertsplanprices();
SELECT * FROM paya_planprices;
-- INSERT PLANS ------------------------------------------------------------------------------------------------------------------------
DELIMITER //
CREATE PROCEDURE insertplan()
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE plansselled INT DEFAULT 100;
    DECLARE user_id INT;
    DECLARE creation_date DATETIME;
    DECLARE plan_price_id INT;
    DECLARE random_date DATETIME;
	DECLARE enablebit BIT;
    WHILE i < plansselled DO
        SELECT `userid`, `creationdate` INTO user_id, creation_date
        FROM `PayAssistantDB`.`paya_users` ORDER BY RAND() LIMIT 1;
        SET random_date = DATE_ADD(creation_date, INTERVAL FLOOR(RAND() * (UNIX_TIMESTAMP(NOW()) - UNIX_TIMESTAMP(creation_date))) SECOND);
        SET enablebit = IF(RAND() < 0.3, 0, 1); 
        SELECT `planpriceid` INTO plan_price_id FROM `PayAssistantDB`.`paya_planprices` ORDER BY RAND() LIMIT 1;
        INSERT INTO `PayAssistantDB`.`paya_plans` 
        (`adquisition`, `enabled`, `userid`, `planpriceid`)
        VALUES 
        (random_date, enablebit, user_id, plan_price_id);
        SET i = i + 1;
    END WHILE;
END //
DELIMITER ;
CALL insertplan();
SELECT * FROM paya_plans;
-- INSERT PAYMENT METHODS ------------------------------------------------------------------------------------------------------------------------
DELIMITER //
CREATE PROCEDURE insertpaymentmethods()
BEGIN
        INSERT INTO `PayAssistantDB`.`paya_paymentmethods` 
        (`name`, `apiurl`, `secretkey`, `key`, `logoiconurl`, `enable`)
        VALUES 
        ('PayPal', 'https://api.paypal.com/v1/payments/payment', 
         SHA2('Llavesecretisima', 256), 
         SHA2('llavenotansecretisima', 256), 
         'https://www.paypalobjects.com/webstatic/mktg/logo/pp_cc_mark_111x69.jpg', 1),
         
        ('Stripe', 'https://api.stripe.com/v1/charges', 
         SHA2('Llavesecretisima', 256), 
         SHA2('llavenotansecretisima', 256), 
         'https://stripe.com/img/v3/home/twitter.png', 1),
         
        ('Banco Nacional de Costa Rica', 'https://api.bncr.fi.cr/v1/transactions', 
         SHA2('Llavesecretisima', 256), 
         SHA2('llavenotansecretisima', 256), 
         'https://www.bncr.fi.cr/images/bncr-logo.svg', 0),
         
        ('Banco de Costa Rica', 'https://api.bancobcr.com/v1/transactions', 
         SHA2('Llavesecretisima', 256), 
         SHA2('llavenotansecretisima', 256), 
         'https://www.bancobcr.com/images/logo-bcr.svg', 1),
         
        ('Scotiabank Costa Rica', 'https://api.scotiabank.cr/v1/transactions', 
         SHA2('Llavesecretisima', 256), 
         SHA2('llavenotansecretisima', 256), 
         'https://www.scotiabank.com.cr/content/dam/scotiabank/cr/images/logo.svg', 1),
         
        ('BAC Credomatic', 'https://api.baccredomatic.com/v1/transactions', 
         SHA2('Llavesecretisima', 256), 
         SHA2('llavenotansecretisima', 256), 
         'https://www.baccredomatic.com/wcm/connect/bac/web/cr/brand/logo/bac_credomatic.png', 1),
         
        ('Promerica', 'https://api.promerica.cr/v1/transactions', 
         SHA2('Llavesecretisima', 256), 
         SHA2('llavenotansecretisima', 256), 
         'https://www.bancopromerica.com/images/logo_promerica.svg', 1),
         
        ('Venmo', 'https://api.venmo.com/v1/payments', 
         SHA2('Llavesecretisima', 256), 
         SHA2('llavenotansecretisima', 256), 
         'https://upload.wikimedia.org/wikipedia/commons/a/a7/Venmo_logo_2018.svg', 0),
         
        ('Apple Pay', 'https://api.applepay.com/v1/payments', 
         SHA2('Llavesecretisima', 256), 
         SHA2('llavenotansecretisima', 256), 
         'https://upload.wikimedia.org/wikipedia/commons/a/a6/Apple_Pay_logo.svg', 1),
         
        ('Google Pay', 'https://api.google.com/pay/v1/transactions', 
         SHA2('Llavesecretisima', 256), 
         SHA2('llavenotansecretisima', 256), 
         'https://upload.wikimedia.org/wikipedia/commons/1/19/Google_Pay_logo.png', 1);
END //
DELIMITER ;
CALL insertpaymentmethods();
SELECT * FROM paya_paymentmethods;
-- INSERT AVAILABLE METHODS (metodos que tiene el usuario, cuentas en los bancos del payment methods)------------------------------------------------------------------------------------------------------------------------
DELIMITER //
CREATE PROCEDURE insertavailablemethods()
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE num_elements INT DEFAULT 100;
    DECLARE random_userid INT;
    DECLARE random_paymentmethodsid INT;
    DECLARE random_token VARBINARY(250);
    DECLARE exp_token_date DATETIME;
    DECLARE random_enable BIT;
    DECLARE random_name VARCHAR(45);
    WHILE i < num_elements DO
        SELECT `userid` INTO random_userid FROM `PayAssistantDB`.`paya_users` ORDER BY RAND() LIMIT 1;
        SELECT `paymentmethodsid` INTO random_paymentmethodsid FROM `PayAssistantDB`.`paya_paymentmethods` ORDER BY RAND() LIMIT 1;
        SET random_token = sha2(CONCAT('token_api_supersecret_num_', FLOOR(RAND() * 100000000)), 256);  -- SHA256
        SET exp_token_date = DATE_ADD(CURDATE(), INTERVAL FLOOR(RAND() * 365) DAY);
        SET random_enable = IF(RAND() < 0.6, 1, 0);
        SET random_name = CONCAT('PaymentMethod_', FLOOR(RAND() * 100));
        INSERT INTO `PayAssistantDB`.`paya_availablemethods`
        (`name`, `apiurl`, `token`, `expTokenDate`, `enable`, `userid`, `paymentmethodsid`)
        VALUES 
        (random_name, 'https://api.com/exampleapiforeveryone', random_token, exp_token_date, random_enable, random_userid, random_paymentmethodsid);
        SET i = i + 1;
    END WHILE;
END //
DELIMITER ;
CALL insertavailablemethods();
SELECT * FROM paya_availablemethods;
-- INSERT PAYMENTS ------------------------------------------------------------------------------------------------------------------------
DELIMITER //
CREATE PROCEDURE insertpayments()
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE random_amount DECIMAL(10, 6);
    DECLARE random_realamount DECIMAL(10, 6);
    DECLARE random_discountporcent INT;
    DECLARE random_currency VARCHAR(20);
    DECLARE random_result VARCHAR(10);
    DECLARE random_auth VARCHAR(100);
    DECLARE random_reference VARCHAR(100);
    DECLARE random_chargetoken VARCHAR(100);
    DECLARE random_description VARCHAR(100) DEFAULT 'this is a test of filling tables';
    DECLARE random_error VARCHAR(100);
    DECLARE random_date DATETIME;
    DECLARE checksums VARBINARY(250);
    DECLARE random_paymentmethodsid INT;
    DECLARE random_availablemethodsid INT;

    WHILE i < 1000 DO
        SET random_amount = ROUND(RAND() * 1000, 6);
        SET random_realamount = ROUND(RAND() * 1000, 6);
        SET random_discountporcent = FLOOR(RAND() * 22);
        SET random_currency = 'USD'; 
        SET random_auth = sha2(CONCAT('auth_code_', FLOOR(RAND() * 1000000)), 256);
        SET random_reference = CONCAT('REF', FLOOR(RAND() * 100000));
        SET random_chargetoken = sha2(CONCAT('chargetoken_', FLOOR(RAND() * 1000000)), 256);
        SET random_error = IF(RAND() < 0.8, '', 'Error Message'); 
        SET random_date = DATE_ADD(CURDATE(), INTERVAL FLOOR(RAND() * 365) DAY);
        SET random_result = IF(random_error IS NULL, 'Success', 'Error');

        SELECT `paymentmethodsid` INTO random_paymentmethodsid FROM `PayAssistantDB`.`paya_paymentmethods` ORDER BY RAND() LIMIT 1;
        SELECT `availablemethodsid` INTO random_availablemethodsid FROM `PayAssistantDB`.`paya_availablemethods` ORDER BY RAND() LIMIT 1;

        SET checksums = sha2(CONCAT(random_amount, random_realamount, random_discountporcent, random_currency, random_result, random_auth, random_reference, random_chargetoken, random_description, 
            IFNULL(random_error, ''), 'Esto es para que no sepan como fue encriptado',random_date, random_paymentmethodsid, random_availablemethodsid), 256);

        INSERT INTO `PayAssistantDB`.`paya_payments`
        (`amount`, `realamount`, `discountporcent`, `currency`, `result`, `auth`, `reference`, `chargetoken`, `description`, `error`, `date`, `checksum`, `paymentmethodsid`, `availablemethodsid`)
        VALUES 
        (random_amount, random_realamount, random_discountporcent, random_currency, random_result, random_auth, random_reference, random_chargetoken, random_description, random_error, random_date, checksums, random_paymentmethodsid, random_availablemethodsid);
        SET i = i + 1;
    END WHILE;
END //
DELIMITER ;
CALL insertpayments();
SELECT * FROM paya_payments;
-- INSERT TRANSACTIONS TYPES ------------------------------------------------------------------------------------------------------------------------
DELIMITER //
CREATE PROCEDURE inserttransactiontypes()
BEGIN
        INSERT INTO `PayAssistantDB`.`paya_transactiontypes` 
        (`name`)
        VALUES 
        ('Debit'), ('Credit'),('Refund');
END //
DELIMITER ;
CALL inserttransactiontypes();
SELECT * FROM paya_transactiontypes;
-- INSERT TRANSACTIONS SUBTYPES ------------------------------------------------------------------------------------------------------------------------
DELIMITER //
CREATE PROCEDURE inserttransactionsubtypes()
BEGIN
        INSERT INTO `PayAssistantDB`.`paya_transactionsubtypes` 
        (`name`)
        VALUES 
        ('Subscription Cancelation'),('Subscription Payment'),('Gift'),('Mortgage Payment');
END //
DELIMITER ;
CALL inserttransactionsubtypes();
SELECT * FROM paya_transactionsubtypes;
-- INSERT TRANSACTIONS  ------------------------------------------------------------------------------------------------------------------------
DELIMITER //
CREATE PROCEDURE inserttransactions()
Begin
	DECLARE i INT DEFAULT 1;
	DECLARE cantidaddepayments INT;
    DECLARE availablemethodsid1 INT;
	DECLARE user1id INT;
    DECLARE amount1 DECIMAL(10,6);
    DECLARE description1 VARCHAR(100);
    DECLARE reference1 VARCHAR(100);
    DECLARE datetime1 DATETIME;
    DECLARE checksum1 VARBINARY(250);
	DECLARE transactionsubtypeid1 INT;
    DECLARE transactiontypeid1 INT;
	DECLARE exchangerateid1 INT;
    DECLARE currencyid1 INT;
    DECLARE paymentsid1 INT;
    SELECT COUNT(*) INTO cantidaddepayments FROM paya_payments;
	WHILE i <= cantidaddepayments DO
        SELECT  `paymentsid`,`description`, `reference`, `date`, `checksum`, `availablemethodsid`, `amount` INTO paymentsid1, description1, reference1, datetime1, checksum1, availablemethodsid1 ,amount1 FROM `PayAssistantDB`.`paya_payments` WHERE `paymentsid` = i;
        SELECT `userid` INTO user1id FROM `PayAssistantDB`.`paya_availablemethods` WHERE `availablemethodsid` = availablemethodsid1;
        SELECT `transactionsubtypeid` INTO transactionsubtypeid1 FROM `PayAssistantDB`.`paya_transactionsubtypes` ORDER BY RAND() LIMIT 1;
        SELECT `transactiontypeid` INTO transactiontypeid1 FROM `PayAssistantDB`.`paya_transactiontypes` ORDER BY RAND() LIMIT 1;
        SELECT `currencyid` INTO currencyid1 FROM `PayAssistantDB`.`paya_currencies` ORDER BY RAND() LIMIT 1;
        SELECT `exchangerateid` INTO exchangerateid1 FROM `PayAssistantDB`.`paya_exchangerates` WHERE `currencyidsource` = currencyid1 ORDER BY RAND() LIMIT 1;
		INSERT INTO `PayAssistantDB`.`paya_transactions`
		(`name`, `amount`, `description`, `reference`, `datetime`, `officetime`, `checksum`, `transactionsubtypeid`, `transactiontypeid`, `exchangerateid`, `currencyid`, `paymentsid`, `userid`)
		VALUES
		(CONCAT('transaction_', i), amount1, description1, reference1, datetime1, datetime1, checksum1, transactionsubtypeid1, transactiontypeid1, exchangerateid1, currencyid1, paymentsid1, user1id);
		SET i = i + 1;
    END WHILE;
END// 
DELIMITER ;
CALL inserttransactions();
SELECT * FROM paya_transactions;

-- INSERT LANGUAGES  ------------------------------------------------------------------------------------------------------------------------
DELIMITER //
CREATE PROCEDURE insertlanguages()
BEGIN
    INSERT INTO `PayAssistantDB`.`paya_languages` 
    (`languagename`, `enable`, `culture`)
    VALUES 
    ('English', 1, 'en-US'),
    ('Spanish', 1, 'es-ES'),
    ('French', 1, 'fr-FR'),
    ('German', 1, 'de-DE'),
    ('Chinese', 1, 'zh-CN'),
    ('Japanese', 1, 'ja-JP'),
    ('Portuguese', 1, 'pt-BR'),
    ('Italian', 1, 'it-IT'),
    ('Russian', 1, 'ru-RU'),
    ('Arabic', 1, 'ar-SA');
END //
DELIMITER ;
CALL insertlanguages();
SELECT * FROM paya_languages;

-- SET FOREIGN_KEY_CHECKS = 0;
-- TRUNCATE TABLE paya_users;
-- TRUNCATE TABLE paya_modules;
-- TRUNCATE TABLE paya_plans;
-- TRUNCATE TABLE paya_planprices;
-- TRUNCATE TABLE paya_subscriptions;
-- TRUNCATE TABLE paya_schedules;
-- TRUNCATE TABLE paya_scheduledetails;
-- TRUNCATE TABLE paya_currencies;
-- TRUNCATE TABLE paya_exchangerates;
-- TRUNCATE TABLE paya_paymentmethods;
-- TRUNCATE TABLE paya_availablemethods;
-- TRUNCATE TABLE paya_payments;
-- TRUNCATE TABLE paya_transactiontypes;
-- TRUNCATE TABLE paya_transactionsubtypes;
-- TRUNCATE TABLE paya_transactions;
-- SET FOREIGN_KEY_CHECKS = 1;

-- SELECT * from paya_users;
-- SELECT COUNT(*) AS enables_en_1 FROM paya_users WHERE enable = 1;
-- TRUNCATE TABLE paya_users;
-- TRUNCATE TABLE paya_modules;
-- TRUNCATE TABLE paya_scheduledetails;