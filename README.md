# PAYMENT ASSISTANT DATA BASE MADE IN MYSQL

## About the Project
This data base proyect was developed as part of the **Data Bases I** course at the **Technological Institute of Costa Rica (TEC).** The project focuses on implementing advanced **Data Bases, Encrypted Payment Storage API's, Subscriptions, Payments, Media Management, AI Utilization**  
The data base was a collaborative effort between **Isaac Villalobos** and **Carlos Ávalos**, showcasing our knowledge in data bases and the application of them in real-world scenarios.  
Any questions or inquiries about the inner workings of the project can be directed to my personal email: IsaacVillalobosB@gmail.com.

## Database creation script link:
<a href="https://github.com/IsaacVil/PaymentAssistantDB/blob/main/createtables.sql" target="_blank">PaymentAssistantDB creation script</a>

### Data filling script link:  
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
```
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

