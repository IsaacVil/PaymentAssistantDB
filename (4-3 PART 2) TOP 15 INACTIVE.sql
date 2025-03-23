-- LISTAR EL TOP 15 DE USUARIOS MENOS ACTIVOS EN ESTE CASO NOSOTROS TOMAMOS COMO ACTIVIDAD QUIENES USAN MAS NUESTRO SISTEMA DE TRANSACCIONES, ENTONCES ENTRE MENOS TRANSACCIONES ES MAS INACTIVO
DROP PROCEDURE IF EXISTS Top15InactiveUsers;
DELIMITER //
CREATE PROCEDURE Top15InactiveUsers()
Begin
	SELECT 
		transactions.userid AS id_usuario,
		users.fname AS Nombre,
		users.lname AS Apellido,
		COUNT(transactions.transactionid) AS Transacciones_Totales
	FROM 
		PayAssistantDB.paya_transactions AS transactions
	JOIN 
		PayAssistantDB.paya_users AS users ON transactions.userid = users.userid
	GROUP BY 
		transactions.userid
	ORDER BY 
		Transacciones_Totales ASC
	LIMIT 15;
END// 
DELIMITER ;
CALL Top15InactiveUsers();