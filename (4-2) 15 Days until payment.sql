-- LISTAR
DROP PROCEDURE IF EXISTS NearPaymentsina15daysWindow;
DELIMITER //
CREATE PROCEDURE NearPaymentsina15daysWindow()
Begin
	SELECT 
		plans.userid AS id_usuario, users.fname AS Nombre, users.lname AS Apellido, users.email AS Email, 
        SUM(planprices.amount) AS Pagos_Total,  DATEDIFF(MIN(scheduledetails.nextexecution), NOW()) AS Dias_Hasta_El_Sgte_Pago,
		MIN(scheduledetails.nextexecution) AS Pago_Mas_Cercano
	FROM 
		PayAssistantDB.paya_scheduledetails AS scheduledetails
	JOIN 
		PayAssistantDB.paya_schedules AS schedules ON scheduledetails.scheduleid = schedules.scheduleid
	JOIN 
		PayAssistantDB.paya_planprices AS planprices ON planprices.scheduledetailsid = scheduledetails.scheduledetailsid
	JOIN 
		PayAssistantDB.paya_plans AS plans ON plans.planpriceid = planprices.planpriceid
	JOIN 
		PayAssistantDB.paya_users AS users ON plans.userid = users.userid
	WHERE 
		scheduledetails.deleted = 0  AND (scheduledetails.nextexecution BETWEEN NOW() AND DATE_ADD(NOW(), INTERVAL 15 DAY)) AND planprices.current = 1 AND plans.enabled = 1 
	GROUP BY 
		plans.userid
	ORDER BY 
		plans.userid ASC; 
END// 
DELIMITER ;
CALL NearPaymentsina15daysWindow();