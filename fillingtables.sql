DROP PROCEDURE IF EXISTS insertusers;
DROP PROCEDURE IF EXISTS insertmodules;
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
DELIMITER // ;
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
-- INSERT PLANS ------------------------------------------------------------------------------------------------------------------------

-- SELECT * from paya_users;
-- SELECT COUNT(*) AS enables_en_1 FROM paya_users WHERE enable = 1;
-- TRUNCATE TABLE paya_users;
-- TRUNCATE TABLE paya_modules;