# PAYMENT ASSISTANT DATA BASE MADE IN MYSQL

## About the Project
This data base proyect was developed as part of the **Data Bases I** course at the **Technological Institute of Costa Rica (TEC).** The project focuses on implementing advanced **Data Bases, Encrypted Payment Storage API's, Subscriptions, Payments, Media Management, AI Utilization**  
The data base was a collaborative effort between **Isaac Villalobos** and **Carlos Ávalos**, showcasing our knowledge in data bases and the application of them in real-world scenarios.  
Any questions or inquiries about the inner workings of the project can be directed to my personal email: IsaacVillalobosB@gmail.com.

## Database creation script link:
<a href="https://github.com/IsaacVil/PaymentAssistantDB/blob/main/createtables.sql" target="_blank">PaymentAssistantDB creation script</a>

## Data filling script link:  
<a href="https://github.com/IsaacVil/PaymentAssistantDB/blob/main/fillingtables.sql" target="_blank">PaymentAssistantDB data filling script</a>

## Query Reports

### 4.1 List all active platform users with full name, email, country of origin, and total subscription payments in colones from 2024 to present (20+ records)
<a href="https://github.com/IsaacVil/PaymentAssistantDB/blob/main/(4-1).sql" target="_blank">Active users with subscription payments query</a>

```sql
SELECT 
    CONCAT(u.fname, ' ', u.lname) AS Full_name, 
    u.email, 
    c.countryname AS Country, 
    ROUND(
        SUM(
            CASE 
                WHEN t.currencyid = 11 
                THEN t.amount -- Check if already in colones
                ELSE t.amount * e.exchangerate -- Convert to colones using exchangerate
            END
        ), 3
    ) AS Total_payments₡ -- Total paid in colones 
FROM 
    PayAssistantDB.paya_users u
    INNER JOIN PayAssistantDB.paya_addressasignations aa ON u.userid = aa.entityid
    INNER JOIN PayAssistantDB.paya_addresses a ON aa.addressid = a.addressid
    INNER JOIN PayAssistantDB.paya_cities ci ON a.cityid = ci.cityid
    INNER JOIN PayAssistantDB.paya_states s ON ci.stateid = s.stateid
    INNER JOIN PayAssistantDB.paya_countries c ON s.paya_countries_countryid = c.countryid
    INNER JOIN PayAssistantDB.paya_transactions t ON u.userid = t.userid
    LEFT JOIN PayAssistantDB.paya_exchangerates e 
        ON t.currencyid = e.currencyidsource 
        AND e.currencyiddestiny = 11 -- 11 is colones ID
        AND e.currentexchangerate = 1 -- Only current rates (active)
WHERE 
    u.enable = 1 -- Active users
    AND t.transactionsubtypeid = 2 -- Subscription Payment type
    AND YEAR(t.datetime) >= 2024 -- Payments since 2024
GROUP BY 
    u.userid, u.fname, u.lname, u.email, c.countryname
ORDER BY 
    Total_payments₡ DESC;
```
### Results Data Table 4.1
| **Nombre_completo**       | **Email**                            | **Pais**   | **Total_de_pagos₡** |
|---------------------|--------------------------------------|---------------|-----------------|
| Christopher Foreman | ChristopherForeman384@gmail.com      | Italy         | 29,510.411      |
| Walter Sánchez      | WalterSánchez1964@gmail.com          | Costa Rica    | 17,847.289      |
| Carlos Wayne        | CarlosWayne231@gmail.com             | Italy         | 14,740.269      |
| Christopher Martinez| ChristopherMartínez1724@gmail.com    | United States | 12,408.282      |
| Rodrigo La_Cerva    | RodrigoLa_Cerva410@gmail.com         | Japan         | 10,329.515      |
| Roberto Cheng       | RobertoCheng2143@gmail.com           | Russia        | 9,646.493       |
| Juan Sánchez        | JuanSánchez193@gmail.com             | France        | 9,525.825       |
| Carlos Wayne        | CarlosWayne1311@gmail.com            | Japan         | 9,390.750       |
| Rodrigo Martinez    | RodrigoMartínez1120@gmail.com        | China         | 9,368.764       |
| Juan Ramírez        | JuanRamírez2144@gmail.com            | Costa Rica    | 8,276.821       |
| Ana Pérez           | AnaPérez568@gmail.com                | Costa Rica    | 7,778.139       |
| Martina Bonilla     | MartinaBonilla420@gmail.com          | United States | 7,133.027       |
| Roberto Pérez       | RobertoPérez1578@gmail.com           | Spain         | 6,919.466       |
| Bruce Cheng         | BruceCheng865@gmail.com              | France        | 6,616.601       |
| Rodrigo Castillo    | RodrigoCastillo389@gmail.com         | Russia        | 6,356.164       |
| David López         | DavidLópez653@gmail.com              | Japan         | 6,037.675       |
| Pabla Johnson       | PablaJohnson274@gmail.com            | Italy         | 5,711.340       |
| José Fernández      | JoséFernández265@gmail.com           | Costa Rica    | 5,581.938       |
| Walter Soprano      | WalterSoprano569@gmail.com           | France        | 5,553.302       |
| Gregory Hernández   | GregoryHernández453@gmail.com        | France        | 5,502.034       |
| Ana Hernández       | AnaHernández1261@gmail.com           | China         | 5,192.073       |
| Chase Murdock       | ChaseMurdock1491@gmail.com           | France        | 3,340.308       |
| Juan Cheng          | JuanCheng829@gmail.com               | Russia        | 2,561.610       |
| David Hernández     | DavidHernández1675@gmail.com         | Russia        | 2,363.015       |
| María Martínez      | MaríaMartínez1869@gmail.com          | Italy         | 1,874.102       |
| Viviana White       | VivianaWhite772@gmail.com            | Italy         | 1,422.002       |
| Jane Villalobos     | JaneVillalobos670@gmail.com          | Russia        | 651.758         |
| Jane Ramírez        | JaneRamírez1327@gmail.com            | China         | 640.563         |
| Ana Moltisanti      | AnaMoltisanti2005@gmail.com          | China         | 527.209         |
| Miguel Johnson      | MiguelJohnson1491@gmail.com          | Italy         | 74.674          |
| Jane Sánchez        | JaneSánchez1231@gmail.com            | Russia        | 63.367          |


### 4.2 List all people with full name and email who have less than 15 days until their next subscription payment (13+ records)
<a href="https://github.com/IsaacVil/PaymentAssistantDB/blob/main/(4-2)%2015%20Days%20until%20payment.sql" target="_blank">Users with upcoming payments in 15 days query</a>

```sql
DROP PROCEDURE IF EXISTS NearPaymentsina15daysWindow;
DELIMITER //
CREATE PROCEDURE NearPaymentsina15daysWindow()
Begin
	SELECT 
		plans.userid AS user_id, 
        users.fname AS First_name, 
        users.lname AS Last_name, 
        users.email AS Email, 
        SUM(planprices.amount) AS Total_payments,  
        DATEDIFF(MIN(scheduledetails.nextexecution), NOW()) AS Days_until_next_payment,
		MIN(scheduledetails.nextexecution) AS Next_payment_date
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
		scheduledetails.deleted = 0 
        AND (scheduledetails.nextexecution BETWEEN NOW() AND DATE_ADD(NOW(), INTERVAL 15 DAY)) 
        AND planprices.current = 1 
        AND plans.enabled = 1 
	GROUP BY 
		plans.userid
	ORDER BY 
		plans.userid ASC; 
END// 
DELIMITER ;
CALL NearPaymentsina15daysWindow();
```
### Results data table 4.2


| id_usuario | Nombre  | Apellido   | Email                        | Pagos_Total | Dias_Hasta_El_Sgte_Pago | Pago_Mas_Cercano        |
|------------|---------|------------|------------------------------|-------------|-------------------------|-------------------------|
| 6          | José    | González   | JoseGonzález372@gmail.com    | 278.00      | 5                       | 2025-03-30 02:18:48     |
| 7          | Pablo   | Rodríguez  | PabloRodríguez391@gmail.com  | 511.00      | 8                       | 2025-04-02 02:18:48     |
| 17         | Jane    | Murdock    | JaneMurdock490@gmail.com     | 976.00      | 1                       | 2025-03-26 02:18:48     |
| 22         | María   | White      | MaríaWhite213@gmail.com      | 465.00      | 10                      | 2025-04-04 02:18:48     |
| 28         | Martina | Soprano    | MartinaSoprano1907@gmail.com | 153.00      | 10                      | 2025-04-04 02:18:48     |
| 29         | Martina | Rodríguez  | MartinaRodríguez556@gmail.com| 330.00      | 8                       | 2025-04-02 02:18:48     |
| 30         | Isaac   | White      | IsaacWhite326@gmail.com      | 252.00      | 1                       | 2025-03-26 02:18:48     |
| 33         | Carmela | La_Cerva   | CarmelaLa_Cerva2107@gmail.com| 807.00      | 9                       | 2025-04-03 02:18:48     |
| 35         | Arturo  | López      | ArturoLópez2112@gmail.com    | 252.00      | 1                       | 2025-03-26 02:18:48     |
| 38         | Matt    | La_Cerva   | MattLa_Cerva910@gmail.com    | 55.00       | 3                       | 2025-03-28 02:18:48     |
| 43         | Carlos  | Murdock    | CarlosMurdock1815@gmail.com  | 291.00      | 14                      | 2025-04-08 02:18:48     |
| 48         | María   | Fernández  | MaríaFernández1504@gmail.com | 22.00       | 3                       | 2025-03-28 02:18:48     |
| 54         | Matt    | Fernández  | MattFernández1547@gmail.com  | 603.00      | 12                      | 2025-04-06 02:18:48     |
| 57         | Miguel  | Villalobos | MiguelVillalobos464@gmail.com| 511.00      | 8                       | 2025-04-02 02:18:48     |
| 59         | José    | Villalobos | JoséVillalobos1897@gmail.com | 628.00      | 5                       | 2025-03-30 02:18:48     |
| 60         | Gregory | Castillo   | GregoryCastillo1082@gmail.com| 278.00      | 5                       | 2025-03-30 02:18:48     |

### 4.3 Ranking of top 15 most active users and top 15 least active users (15 and 15 records)

#### Most active users query:
<a href="https://github.com/IsaacVil/PaymentAssistantDB/blob/main/(4-3%20PART%201)%20TOP%2015%20ACTIVE.sql" target="_blank">Top 15 active users query</a>

```sql
DROP PROCEDURE IF EXISTS Top15ActiveUsers;
DELIMITER //
CREATE PROCEDURE Top15ActiveUsers()
Begin
	SELECT 
		transactions.userid AS user_id,
		users.fname AS First_name,
		users.lname AS Last_name,
		COUNT(transactions.transactionid) AS Total_transactions
	FROM 
		PayAssistantDB.paya_transactions AS transactions
	JOIN 
		PayAssistantDB.paya_users AS users ON transactions.userid = users.userid
	GROUP BY 
		transactions.userid
	ORDER BY 
		Total_transactions DESC
	LIMIT 15;
END// 
DELIMITER ;
CALL Top15ActiveUsers();
```

### Results data table 4.3 Active Users:

| id_usuario | Nombre | Apellido | Transacciones_Totales |
|---------|------------|-----------|--------------------|
| 19      | Christopher | Foreman   | 64                 |
| 23      | Walter     | Sánchez   | 58                 |
| 35      | Christopher | Martínez  | 46                 |
| 18      | Pabla      | Johnson   | 45                 |
| 25      | Rodrigo    | La_Cerva  | 45                 |
| 41      | Carlos     | Wayne     | 42                 |
| 42      | Bruce      | Cheng     | 40                 |
| 37      | Jane       | Soprano   | 38                 |
| 21      | Eric       | Pérez     | 36                 |
| 49      | Sofia      | Sánchez   | 35                 |
| 2       | Roberto    | Cheng     | 34                 |
| 14      | Ana        | Hernández | 31                 |
| 36      | Roberto    | Rodríguez | 29                 |
| 7       | Juan       | Cheng     | 27                 |
| 34      | Rodrigo    | Castillo  | 25                 |

#### Least active users query:
<a href="https://github.com/IsaacVil/PaymentAssistantDB/blob/main/(4-3%20PART%202)%20TOP%2015%20INACTIVE.sql" target="_blank">Top 15 inactive users query</a>

```sql
DROP PROCEDURE IF EXISTS Top15InactiveUsers;
DELIMITER //
CREATE PROCEDURE Top15InactiveUsers()
Begin
	SELECT 
		transactions.userid AS user_id,
		users.fname AS First_name,
		users.lname AS Last_name,
		COUNT(transactions.transactionid) AS Total_transactions
	FROM 
		PayAssistantDB.paya_transactions AS transactions
	JOIN 
		PayAssistantDB.paya_users AS users ON transactions.userid = users.userid
	GROUP BY 
		transactions.userid
	ORDER BY 
		Total_transactions ASC
	LIMIT 15;
END// 
DELIMITER ;
CALL Top15InactiveUsers();
```
### Results data table 4.3 Inactive Users:


| id_usuario | Nombre | Apellido  | Transacciones_Totales |
|---------|------------|------------|--------------------|
| 4       | Carlos     | White      | 5                  |
| 10      | Pedro      | Bonilla    | 6                  |
| 43      | Jane       | Villalobos | 6                  |
| 50      | Viviana    | Rodriguez  | 6                  |
| 27      | Miguel     | Johnson    | 8                  |
| 45      | Jane       | Ramírez    | 9                  |
| 39      | Martina    | Bonilla    | 9                  |
| 8       | David      | Hernández  | 10                 |
| 5       | Roberto    | Gualtieri  | 11                 |
| 12      | Roberto    | Pérez      | 11                 |
| 31      | Carlos     | Wayne      | 11                 |
| 3       | Ana        | Moltisanti | 12                 |
| 13      | Rodrigo    | Cheng      | 12                 |
| 47      | Juan       | Ramírez    | 12                 |
| 32      | Jane       | Sánchez    | 14                 |

### 4.4 Determine which analyses have the most AI failures, ranking each problem by occurrence count within a date range (30+ records)
<a href="https://github.com/IsaacVil/PaymentAssistantDB/blob/main/(4-4).sql" target="_blank">AI failure analysis query</a>

```sql
SELECT 
	aet.eventid, 
    aet.description AS error_description,
    COUNT(ai.interactionid) AS occurrence_ranking
FROM 
    `PayAssistantDB`.`paya_ai_interactions` ai
INNER JOIN 
    `PayAssistantDB`.`paya_aieventtypes` aet ON ai.eventid = aet.eventid
WHERE 
    ai.timestamp BETWEEN '2024-01-01 00:00:00' AND '2024-12-01 23:59:59'
    AND aet.status = 'Failed'  
GROUP BY 
    aet.eventid, aet.description
ORDER BY 
    occurrence_ranking DESC;
```

### Results data table 4.4:

| **eventid** | **descripción_del_error**                           | **ranking_ocurrencias**  |
|------|-----------------------------------------------------|----------------|
| 24     | Fallo en la aplicación de un descuento mencionado por el usuario | 30  |
| 31     | Error en la interpretación de la solicitud de historial de transacciones | 25  |
| 34     | Fallo en la activación de una nueva tarjeta          | 23  |
| 18     | Fallo en la autenticación biométrica adicional requerida | 23  |
| 37     | Error en la interpretación de la solicitud de pago fraccionado | 22  |
| 39     | Error en la interpretación de la solicitud de pago en efectivo | 21  |
| 15     | Error en la interpretación de la dirección de facturación | 21  |
| 17     | Error en la interpretación del código de seguridad de la tarjeta | 21  |
| 25     | Error en la interpretación de la divisa para conversión | 21  |
| 8      | Transacción monetaria fallida debido a un error en la validación de la IA | 20  |
| 12     | Fallo en la conexión con el servidor de procesamiento de pagos | 20  |
| 33     | Error en la interpretación de la solicitud de bloqueo de tarjeta | 20  |
| 32     | Fallo en la generación de la alerta de límite de gasto excedido | 20  |
| 19     | Error en la interpretación de la solicitud de pago recurrente | 20  |
| 41     | Error en la interpretación de la solicitud de pago con criptomonedas | 19  |
| 38     | Fallo en la división del pago entre múltiples cuentas | 19  |
| 27     | Error en la interpretación de la solicitud de pago a un contacto | 18  |
| 23     | Error en la interpretación de la solicitud de límite de gasto | 17  |
| 26     | Fallo en la conversión de moneda debido a tasas no actualizadas | 17  |
| 30     | Fallo en la generación de la alerta de pago atrasado | 17  |
| 13     | Error en la generación del comprobante de pago      | 17  |
| 21     | Error en la interpretación de la solicitud de reembolso | 16  |
| 20     | Fallo en la cancelación de un pago recurrente       | 16  |
| 5      | Autenticación de usuario fallida debido a una voz no reconocida | 16  |
| 29     | Error en la interpretación de la referencia de pago | 15  |
| 40     | Fallo en la generación del código QR para pago      | 15  |
| 9      | Error en la detección de la moneda especificada por el usuario | 15  |
| 35     | Error en la interpretación de la solicitud de cambio de PIN | 15  |
| 28     | Fallo en la verificación del destinatario del pago  | 14  |
| 36     | Fallo en la aplicación de una promoción mencionada por el usuario | 14  |
| 14     | Fallo en la actualización del saldo después del pago | 13  |
| 22     | Fallo en la generación del reporte de transacciones mensuales | 12  |
| 10     | Fallo en la validación de la fecha de pago proporcionada por el usuario | 11  |
| 11     | Error en la interpretación de la descripción del pago | 11  |
| 2      | Procesamiento de pago fallido debido a un error en el reconocimiento de voz | 11  |
| 16     | Fallo en la verificación de la tarjeta de crédito mencionada por el usuario | 7   |

## Entity List
Link: https://github.com/IsaacVil/PaymentAssistantDB/blob/main/DB-PAY-A.pdf
- Roles
  - Permissions
  - Enable
  - Deleted
  - Last Update
- Users
  - Username
  - First Name
  - Last Name
  - Phone
  - Email
  - Password
  - Verified
  - Enable
  - Creation Date
  - Last Login
- Modules
- Plan
  - Price
  - Features
- Subscriptions
  - Price
  - Start Date
  - End Date
  - Auto Renew
  - Enable
- Permissions
- Media
  - Type
    - Name
    - Format Type
  - Status
- Logs
  - Type
  - Source
- Language
- Translations
- Schedule
- Payments
  - Auth (Sms, Email)
  - Amount
  - Discount
  - error
  - description
- Payment Methods
  - Name
  - Api Url
  - Secret Key
  - Key
  - Mask Account
  - Token
  - Expiration Token Date
- Currency
  - name
  - country
  - symbol
- Exchange Rates
- Transactions
  - Reference
  - Amount
  - Date time
  - Office time
  - Description
  - Type (Payment, Refund, ...)
  - Subtypes (Subscriptions, Claim Approve, ...)
- Contact Info
  - Value
  - Last Update
  - Type of Contact
- Bank Connection
- Encrypted Payment Storage API's (Stripe, Worldpay, ...)
- Payment Reminders
  - Date
  - Repeat (Day, Week, Month, Year)
  - Description
- Audio Transcriptions
- Audio
  - Partitions
  - Cue points
  - Transcriptions
- Ai for Audio Processing (AWS Amazon)
- Ai Interaction (OpenAi)
  - Events
  - Data Collection
    - Data type
- Cloud Services for Audio Processing (AWS Amazon, Azure OpenAI)
## Documentation for Reference in the Making of this Data Base
- Stripe was our principal source of inspiration for the payment methods section, we took from stripe the tokenization and the secret key both are really useful at keeping our data base secure and our users safety. (Link: https://docs.stripe.com/api/tokens)
![image](https://github.com/user-attachments/assets/0e5e1788-64af-4602-a4d0-b25417f1f2e6)
- Microsoft Outlook Calendar and Apple Calendar both worked as a reference of a working schedule system for a data base. 
![image](https://github.com/user-attachments/assets/9e1d8c28-fcd0-4138-8a38-c72c662eaff4)
![apple](https://github.com/user-attachments/assets/d30ab0da-9430-46d0-93a4-8c69a0525633)
- From Netflix subscription model we took the way they charge monthly (and have different plans and options for the costumers needs) and their cancelation model and from Office we took the optional yearly subscriptions (less expensive but they have to pay up-front). (links: https://www.netflix.com/, https://www.microsoft.com/en-us/microsoft-365/buy/compare-all-microsoft-365-products?tab=1&OCID=cmmruikv4ct).
![image](https://github.com/user-attachments/assets/59e45e44-7365-42b5-870f-308716247ebb)
![image](https://github.com/user-attachments/assets/9e1f32ba-f744-40fc-9b00-3a79b5a5969f)
- From Instagram, Youtube and Google we took the way the manage the account with an account name, email, password and authentification process.
![image](https://github.com/user-attachments/assets/d095291b-787b-4d1b-bf0c-3fffb0d07f97)
![image](https://github.com/user-attachments/assets/4b82c30f-7fc9-4c9e-b28d-6800ac8337d3)
![image](https://github.com/user-attachments/assets/33de42a9-223e-434a-93bf-e9f2b833f35e)

