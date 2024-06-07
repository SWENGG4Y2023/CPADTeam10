
# CPAD4Y2024Team10
# SAAS Bases Application – Transport Management

<img  alt="TeamSync" src="https://teamsync.church/mt-content/uploads/2022/01/teamsync-logo-white.png">

## Team Members:
| Team Members      | Student ID   |
|-------------------|--------------|
| :woman: Shravya Shreya | 2021hs70011 |
| :man: Deev Pal         | 2021hs70025 |
| :man: Aryan Saxena     | 2021hs70016 |
| :man: Yash Kanoria     | 2021hs70002 |

## Project Documents :clipboard::

- [Application Document](/TransportManagement.pdf)

# SAAS-Based Transport Management Application

This repository contains the SAAS-Based Transport Management Application, a cloud-based solution designed to streamline operations for transportation companies. The following sections provide an overview of the application's functionalities, technical architecture, development process, and testing strategies.

## 1. Introduction

Transportation companies often face challenges in managing Bilty, Hire Challen, and Invoices. This application aims to automate these tasks and enhance operational efficiency.

## 2. System Functionalities

### Bilty Management
- **Create and manage Bilty documents**: Includes shipment details like origin, destination, goods description, consignee, and consignor information.
- **E-way bill integration**: Ensures seamless compliance with regulatory requirements.

### Hire Challen Management
- **Issue Hire Challens**: Specifies vehicle details, duration, and cost for vehicle hiring.

### Invoice Management
- **Automatic invoice generation**: Based on Bilty and Hire Challen data.
- **Tax calculations and customization**: Allows for different pricing structures.

### Additional Features (Optional)
- **Driver Management**: Tracks driver details, licenses, and job assignments.
- **Fleet Management**: Monitors vehicle location, maintenance schedules, and fuel consumption.
- **Customer Management**: Manages customer information, tracks shipment history, and offers self-service options.

## 3. Technical Architecture

### Frontend Development
- **Framework**: Built using Flutter for a single codebase across Android and iOS platforms.
- **Benefits**: Reduced development time and native-like performance.

### Backend Development
- **Framework**: Developed using Spring Boot for its robust architecture.
- **Features**: Utilizes MVC pattern, dependency injection, and RESTful API development.

### Server Infrastructure
- **Deployment**: Hosted on AWS EC2 instances for scalability and elasticity.
- **Load Balancer**: Distributes traffic efficiently across multiple EC2 instances.

### Database
- **Technology**: Uses MySQL or PostgreSQL stored on AWS RDS.
- **Benefits**: Effective structured data management.

## 4. Entity-Relationship Diagram (ERD)

An ERD visualizes relationships between entities like Customer, Driver, Vehicle, Bilty, Hire Challen, and Invoice. Relationships include:
- One-to-Many between Customer and Bilty/Hire Challen.
- Many-to-One between Bilty and Customer (Consignor and Consignee).
- One-to-One or Optional between Bilty and Hire Challen.
- One-to-One between Invoice and Bilty/Hire Challen.

## 5. Class Diagram

The class diagram showcases backend logic classes with attributes and methods, adhering to object-oriented design principles.

### Customer
- **Attributes**: customerID, name, address, phone, email.
- **Methods**: `getCustomerDetails()`, `updateCustomer()`.

### Driver (Optional)
- **Attributes**: driverID, name, licenseNumber, contactInfo.
- **Methods**: `getDriverDetails()`, `assignDriverToJob()`.

### Vehicle (Optional)
- **Attributes**: vehicleID, registrationNumber, model, capacity.
- **Methods**: `getVehicleDetails()`, `trackVehicleLocation()`.

### Bilty
- **Attributes**: biltyID, customerID (FK), consigneeID (FK), origin, destination, goodsDescription, ewayBillNumber (Optional).
- **Methods**: `createBilty()`, `generateEwayBill()` (Optional).

### Hire Challen
- **Attributes**: challenID, customerID (FK), vehicleID (FK - Optional), startDate, endDate, cost.
- **Methods**: `createHireChallen()`, `assignVehicle()` (Optional).

### Invoice
- **Attributes**: invoiceID, biltyID (FK), challenID (FK - Optional), amount, taxDetails.
- **Methods**: `generateInvoice()`.

## 6. Testing Strategies

### Unit Testing
- **Importance**: Ensures code quality by testing individual classes and functions.
- **Framework**: JUnit for Java.

### Integration Testing
- **Description**: Tests interaction and functionality of different modules.

### System Testing
- **Outline**: Ensures the application meets all functional and non-functional requirements.

### User Acceptance Testing (UAT)
- **Importance**: Gathers feedback from potential users to refine the application before deployment.

## 7. Software Development Life Cycle (SDLC) Model

### Model
- **Chosen Model**: Agile.

### Phases
- **Planning, Requirement Analysis, Design, Development, Testing, Deployment, Maintenance**: Each phase will be applied to the development of the SAAS-Based Application.

## 8. Deployment and Maintenance

### Deployment Process
- **Infrastructure**: AWS with configuration management tools like Chef or Ansible.

### Maintenance Strategy
- **Bugs, Features, Security**: Regular updates to address bugs, implement new features, and ensure security.

## 9. Security Considerations

### Measures
- **Authentication and Access Control**: Implement user authentication and access control mechanisms.
- **Data Encryption**: Encrypt sensitive information.
- **Secure Coding Practices**: Regular vulnerability scanning and compliance with data privacy regulations.



# DATA-FLOW-DIAGRAM

### Level 0 (Context Diagram)
The context diagram shows the overall system and its interactions with external entities.

#### External Entities:
1. Customer
2. Admin (System Administrator)

#### Processes:
1. SAAS-Based Transport Management Application

#### Data Stores:
1. Customer Database
2. Driver Database (Optional)
3. Vehicle Database (Optional)
4. Bilty Database
5. Hire Challen Database
6. Invoice Database

#### Data Flows:
- Customer Data
- Driver Data
- Vehicle Data
- Bilty Details
- Hire Challen Details
- Invoice Details

### Level 1 DFD
The Level 1 DFD provides more detail about the internal processes of the SAAS-Based Transport Management Application.

#### Processes:
1. Manage Customer Information
2. Manage Bilty
3. Manage Hire Challen
4. Manage Invoice
5. (Optional) Manage Driver Information
6. (Optional) Manage Vehicle Information

#### Data Stores:
1. Customer Database
2. Driver Database (Optional)
3. Vehicle Database (Optional)
4. Bilty Database
5. Hire Challen Database
6. Invoice Database

#### Data Flows:
- Customer Information
- Bilty Information
- Hire Challen Information
- Invoice Information
- Driver Information (Optional)
- Vehicle Information (Optional)

Here's a detailed description of each Level 1 process:

1. **Manage Customer Information**
    - Input: Customer Data
    - Output: Customer Information to Customer Database
    - Description: Handles the addition, update, and retrieval of customer information.

2. **Manage Bilty**
    - Input: Bilty Data
    - Output: Bilty Information to Bilty Database, E-way Bill Information
    - Description: Manages Bilty creation and updates, integrates with e-way bill generation.

3. **Manage Hire Challen**
    - Input: Hire Challen Data
    - Output: Hire Challen Information to Hire Challen Database
    - Description: Manages the issuance of Hire Challens with vehicle details, duration, and cost.

4. **Manage Invoice**
    - Input: Bilty Data, Hire Challen Data
    - Output: Invoice Information to Invoice Database
    - Description: Generates invoices based on Bilty and Hire Challen data, includes tax calculations.

5. **(Optional) Manage Driver Information**
    - Input: Driver Data
    - Output: Driver Information to Driver Database
    - Description: Tracks driver details, licenses, and assigns them to jobs.

6. **(Optional) Manage Vehicle Information**
    - Input: Vehicle Data
    - Output: Vehicle Information to Vehicle Database
    - Description: Monitors vehicle location, maintenance schedules, and fuel consumption.

### Data Flow Diagram (Level 1)
The Level 1 DFD for the SAAS-Based Transport Management Application can be illustrated as follows:


                       +---------------------------+
                       |       Customer            |
                       +---------------------------+
                               |        ▲
                               |        |
                               ▼        |
+-----------------+     Customer Data    |
|                 |                      |
| Manage Customer |<----------------------|
|   Information   |                      |
|                 |                      |
+-----------------+                      |
        |                                |
        | Customer Information           |
        ▼                                |
+-----------------+                      |
| Customer        |                      |
| Database        |                      |
+-----------------+                      |
                                         |
                       +-----------------|-------------------------------------+
                       | SAAS-Based Transport Management Application         |
                       |                                                     |
                       |  +------------------+   +----------------------+    |
                       |  | Manage Bilty     |   | Manage Hire Challen  |    |
                       |  +------------------+   +----------------------+    |
                       |        |                          |                  |
                       |        | Bilty Information        | Hire Challen Info|
                       |        ▼                          ▼                  |
                       |  +---------------+         +-----------------+      |
                       |  | Bilty Database|         | Hire Challen    |      |
                       |  +---------------+         | Database        |      |
                       |                            +-----------------+      |
                       |                                                     |
                       |  +------------------+   +----------------------+    |
                       |  | Manage Invoice   |   | Manage Driver Info (Opt)  |
                       |  +------------------+   +----------------------+    |
                       |        |                          |                  |
                       |        | Invoice Information      | Driver Info      |
                       |        ▼                          ▼                  |
                       |  +---------------+         +-----------------+      |
                       |  | Invoice       |         | Driver Database |      |
                       |  | Database      |         +-----------------+      |
                       |  +---------------+                                      |
                       |  +------------------+                                  |
                       |  | Manage Vehicle Info (Optional)                      |
                       |  +------------------+                                  |
                       |        |                                                |
                       |        | Vehicle Information                           |
                       |        ▼                                                |
                       |  +---------------+                                      |
                       |  | Vehicle       |                                      |
                       |  | Database      |                                      |
                       |  +---------------+                                      |
                       +---------------------------------------------------------+

