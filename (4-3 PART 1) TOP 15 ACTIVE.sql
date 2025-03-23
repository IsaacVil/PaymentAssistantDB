-- LISTAR EL TOP 15 DE USUARIOS MAS ACTIVOS EN ESTE CASO NOSOTROS TOMAMOS COMO ACTIVIDAD QUIENES USAN MAS NUESTRO SISTEMA DE TRANSACCIONES, ENTONCES ENTRE MAS TRANSACCIONES ES MAS ACTIVO
DROP PROCEDURE IF EXISTS Top15ActiveUsers;
DELIMITER //
CREATE PROCEDURE Top15ActiveUsers()
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
		Transacciones_Totales DESC
	LIMIT 15;
END// 
DELIMITER ;
CALL Top15ActiveUsers();