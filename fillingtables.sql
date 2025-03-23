DROP PROCEDURE IF EXISTS insertusers;
DROP PROCEDURE IF EXISTS insertmodules;
DROP PROCEDURE IF EXISTS insertplan;
DROP PROCEDURE IF EXISTS insertcurrencies;
DROP PROCEDURE IF EXISTS insertsubscriptions;
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
		('Brazilian Real', 'BRL', 'Brazil', 'R$');
END //
DELIMITER ;
CALL insertcurrencies();
SELECT * FROM paya_currencies;
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

-- INSERT PLANS ------------------------------------------------------------------------------------------------------------------------
DELIMITER //
CREATE PROCEDURE insertplan()
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE plansselled INT DEFAULT 100;
    DECLARE user_id INT;
    DECLARE creation_date DATETIME;
    DECLARE plan_price_id INT DEFAULT 1; -- CAMBIARLOOOOOOOOOOOOOO
    DECLARE random_date DATETIME;
	DECLARE enablebit BIT;
    
    WHILE i < plansselled DO
        SELECT `userid`, `creationdate` INTO user_id, creation_date
        FROM `PayAssistantDB`.`paya_users` ORDER BY RAND() LIMIT 1;
        SET random_date = DATE_ADD(creation_date, INTERVAL FLOOR(RAND() * (UNIX_TIMESTAMP(NOW()) - UNIX_TIMESTAMP(creation_date))) SECOND);
        SET enablebit = IF(RAND() < 0.3, 0, 1); 
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



-- SELECT * from paya_users;
-- SELECT COUNT(*) AS enables_en_1 FROM paya_users WHERE enable = 1;
-- TRUNCATE TABLE paya_users;
-- TRUNCATE TABLE paya_modules;