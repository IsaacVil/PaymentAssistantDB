# PAYMENT ASSISTANT DATA BASE MADE IN MYSQL

## About the Project
This data base proyect was developed as part of the **Data Bases I** course at the **Technological Institute of Costa Rica (TEC).** The project focuses on implementing advanced **Data Bases, Encrypted Payment Storage API's, Subscriptions, Payments, Media Management, AI Utilization**  
The data base was a collaborative effort between **Isaac Villalobos** and **Carlos Ávalos**, showcasing our knowledge in data bases and the application of them in real-world scenarios.  
Any questions or inquiries about the inner workings of the project can be directed to my personal email: IsaacVillalobosB@gmail.com.

## Entity List
(Link: https://github.com/IsaacVil/PaymentAssistantDB/blob/main/DB-PAY-A.pdf)
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

