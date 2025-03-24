SELECT 
	aet.eventid, 
    aet.description AS descripcion_del_error,
    COUNT(ai.interactionid) AS ranking_ocurrencias
FROM 
    `PayAssistantDB`.`paya_ai_interactions` ai
INNER JOIN 
    `PayAssistantDB`.`paya_aieventtypes` aet ON ai.eventid = aet.eventid
WHERE 
    ai.timestamp BETWEEN '2024-01-01 00:00:00' AND '2024-12-01 23:59:59'  -- Rango de un año
    AND aet.status = 'Failed'  
GROUP BY 
    aet.eventid, aet.description
ORDER BY 
    ranking_ocurrencias DESC;