# PAYMENT ASSISTANT DATA BASE MADE IN MYSQL

## About the Project
This data base proyect was developed as part of the **Data Bases I** course at the **Technological Institute of Costa Rica (TEC).** The project focuses on implementing advanced **Data Bases, OTHER THINGS.**  
The data base was a collaborative effort between **Isaac Villalobos** and **Carlos Ávalos**, showcasing our knowledge in data bases and the application of them in real-world scenarios.  
Any questions or inquiries about the inner workings of the project can be directed to my personal email: IsaacVillalobosB@gmail.com.

## Entity List
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
  - Experation Token Date
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
