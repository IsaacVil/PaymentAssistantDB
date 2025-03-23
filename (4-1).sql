SELECT 
    CONCAT(u.fname, ' ', u.lname) AS Nombre_completo, 
    u.email, 
    c.countryname AS Pais, 
    ROUND(
        SUM(
            CASE 
                WHEN t.currencyid = 11 
                THEN t.amount -- Verificar si ya está en colones
                ELSE t.amount * e.exchangerate -- Convertir a colones usando exchangerate
            END
        ), 3
    ) AS Total_de_Pagos₡ -- Total pagado en colones 
FROM 
    PayAssistantDB.paya_users u
    -- Relación con addressasignations para obtener la dirección del usuario
    INNER JOIN PayAssistantDB.paya_addressasignations aa ON u.userid = aa.entityid
    -- Relación con addresses para obtener la ciudad
    INNER JOIN PayAssistantDB.paya_addresses a ON aa.addressid = a.addressid
    -- Relación con cities para obtener el estado
    INNER JOIN PayAssistantDB.paya_cities ci ON a.cityid = ci.cityid
    -- Relación con states para obtener el país
    INNER JOIN PayAssistantDB.paya_states s ON ci.stateid = s.stateid
    -- Finalmente relación con countries para obtener el nombre del país
    INNER JOIN PayAssistantDB.paya_countries c ON s.paya_countries_countryid = c.countryid
    -- Relación con transactions para obtener los pagos por usuario
    INNER JOIN PayAssistantDB.paya_transactions t ON u.userid = t.userid
    -- Relación con exchangerates para convertir montos a colones (solo tasas en current)
    LEFT JOIN PayAssistantDB.paya_exchangerates e 
        ON t.currencyid = e.currencyidsource 
        AND e.currencyiddestiny = 11 -- 11 es el ID de colones
        AND e.currentexchangerate = 1 -- Solo tasas actuales (activas)
WHERE 
    u.enable = 1 -- Usuarios activos
    AND t.transactionsubtypeid = 2 -- Tipo Subscription Payment
    AND YEAR(t.datetime) >= 2024 -- Pagos desde 2024
GROUP BY 
    u.userid, u.fname, u.lname, u.email, c.countryname
ORDER BY 
    Total_de_Pagos₡ DESC; -- Ordenar por total pagado