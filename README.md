# 🏦 Banking Microservices System

A production-inspired **Banking Microservices Application** built with **Spring Boot** and **Spring Cloud**. The system is decomposed into independent, loosely-coupled services for Accounts, Loans, and Cards — each with its own database, independently deployable, and communicating through a centralized API Gateway. The entire platform is containerized using **Docker**.

## 🏗️ Architecture Overview

```
                        ┌─────────────────────────────────┐
                        │         Client / Browser         │
                        └────────────────┬────────────────┘
                                         │
                                         ▼
                        ┌─────────────────────────────────┐
                        │        API Gateway               │
                        │    (Spring Cloud Gateway)        │
                        │    Routes + Load Balancing       │
                        └────┬──────────┬──────────┬───────┘
                             │          │          │
               ┌─────────────▼─┐  ┌────▼──────┐  ┌▼────────────┐
               │  Accounts      │  │  Loans    │  │   Cards     │
               │  Service       │  │  Service  │  │   Service   │
               │  :8080         │  │  :8090    │  │  :9000      │
               └──────┬─────────┘  └────┬──────┘  └─────┬───────┘
                      │                 │                │
               ┌──────▼──┐        ┌─────▼──┐      ┌─────▼──┐
               │  MySQL  │        │  MySQL │      │  MySQL │
               │accounts │        │ loans  │      │  cards │
               └─────────┘        └────────┘      └────────┘

                        ┌─────────────────────────────────┐
                        │       Eureka Server              │
                        │    (Service Discovery)           │
                        │  All services register here      │
                        └─────────────────────────────────┘

                        ┌─────────────────────────────────┐
                        │       Config Server              │
                        │  Centralized config for all      │
                        │  services (Git-backed)           │
                        └─────────────────────────────────┘
```

---

## 🛠️ Tech Stack

| Layer               | Technology                           |
|---------------------|--------------------------------------|
| Language            | Java 17+                             |
| Framework           | Spring Boot 3.x                      |
| Microservices       | Spring Cloud                         |
| API Gateway         | Spring Cloud Gateway                 |
| Service Discovery   | Netflix Eureka (Spring Cloud)        |
| Config Management   | Spring Cloud Config Server           |
| Database            | MySQL (per service)                  |
| ORM                 | Spring Data JPA / Hibernate          |
| Containerization    | Docker & Docker Compose              |
| Build Tool          | Maven                                |

---

## 📁 Project Structure

```
banking-microservices/
│
├── accounts-service/            # Manages customer accounts
│   ├── src/
│   ├── Dockerfile
│   └── pom.xml
│
├── loans-service/               # Manages customer loans
│   ├── src/
│   ├── Dockerfile
│   └── pom.xml
│
├── cards-service/               # Manages customer cards
│   ├── src/
│   ├── Dockerfile
│   └── pom.xml
│
├── gateway-server/              # API Gateway — single entry point
│   ├── src/
│   ├── Dockerfile
│   └── pom.xml
│
├── config-server/               # Centralized config for all services
│   ├── src/
│   ├── Dockerfile
│   └── pom.xml
│
├── docker-compose.yml           # Orchestrates all services + databases
└── .gitignore
```

---

## 🔍 Services Breakdown

### 1. 🧾 Accounts Service — `:8080`
Manages core banking customer accounts.
- Create, update, fetch, and delete customer accounts
- Stores customer profile and linked account details
- Own isolated MySQL schema: `accountsdb`

### 2. 💳 Cards Service — `:9000`
Handles customer debit/credit card management.
- Issue new cards linked to customers
- Fetch, update, and delete card records
- Track card limits and card types
- Own isolated MySQL schema: `cardsdb`

### 3. 🏦 Loans Service — `:8090`
Processes and tracks customer loans.
- Create and manage loan records per customer
- Fetch outstanding loan details
- Own isolated MySQL schema: `loansdb`

### 4. 🌐 API Gateway — `:8072`
Single entry point for all incoming client requests.
- Routes requests to the appropriate downstream service
- Integrates with Eureka for dynamic service resolution
- Handles cross-cutting concerns (logging, headers, filters)

### 5. ⚙️ Config Server — `:8071`
Centralized configuration management for all microservices.
- Serves environment-specific configs (`dev`, `prod`)
- Git-backed config repository
- All services fetch their configuration on startup — no local config needed

---

## 🐳 Docker & Docker Compose

The entire platform starts with a **single command** — no manual service startup needed:

```bash
docker-compose up --build
```

### Containers started by Docker Compose

| Container        | Port  | Description                   |
|------------------|-------|-------------------------------|
| config-server    | 8071  | Config Server                 |
| gateway-server   | 8072  | API Gateway                   |
| accounts-service | 8080  | Accounts Microservice         |
| loans-service    | 8090  | Loans Microservice            |
| cards-service    | 9000  | Cards Microservice            |
| mysql-accounts   | 3306  | MySQL DB for Accounts         |
| mysql-loans      | 3307  | MySQL DB for Loans            |
| mysql-cards      | 3308  | MySQL DB for Cards            |

> ⚠️ Config Server starts first. All other services depend on it being healthy before they boot.

---

## ⚙️ Getting Started

### Prerequisites

- Java 17+
- Maven 3.8+
- Docker & Docker Compose

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/banking-microservices.git
cd banking-microservices
```

### 2. Run Everything with Docker Compose *(Recommended)*

```bash
docker-compose up --build
```

All services, databases, and infrastructure start automatically in the correct order.

### 3. Run Locally Without Docker

Start services **in this exact order** to respect startup dependencies:

```bash
# 1. Config Server  (must be first)
cd config-server && mvn spring-boot:run

# 2. API Gateway
cd gateway-server && mvn spring-boot:run

# 3. Business Services (any order)
cd accounts-service && mvn spring-boot:run
cd loans-service    && mvn spring-boot:run
cd cards-service    && mvn spring-boot:run
```

---

## 📡 API Endpoints (via Gateway)

All requests go through the **API Gateway at `http://localhost:8072`**

### Accounts
| Method | Endpoint                          | Description           |
|--------|-----------------------------------|-----------------------|
| POST   | `/eazybank/accounts/create`       | Create new account    |
| GET    | `/eazybank/accounts/fetch`        | Fetch account details |
| PUT    | `/eazybank/accounts/update`       | Update account        |
| DELETE | `/eazybank/accounts/delete`       | Delete account        |

### Loans
| Method | Endpoint                        | Description           |
|--------|---------------------------------|-----------------------|
| POST   | `/eazybank/loans/create`        | Create new loan       |
| GET    | `/eazybank/loans/fetch`         | Fetch loan details    |
| PUT    | `/eazybank/loans/update`        | Update loan           |
| DELETE | `/eazybank/loans/delete`        | Delete loan           |

### Cards
| Method | Endpoint                        | Description           |
|--------|---------------------------------|-----------------------|
| POST   | `/eazybank/cards/create`        | Issue new card        |
| GET    | `/eazybank/cards/fetch`         | Fetch card details    |
| PUT    | `/eazybank/cards/update`        | Update card           |
| DELETE | `/eazybank/cards/delete`        | Delete card           |

> ⚠️ Exact paths depend on your `@RequestMapping` definitions and Gateway route configuration.

---

## 🔑 Key Design Patterns Applied

| Pattern                         | Where Applied                                        |
|---------------------------------|------------------------------------------------------|
| **Database per Service**        | Each microservice owns its isolated MySQL schema     |
| **API Gateway Pattern**         | Spring Cloud Gateway routes all external traffic     |
| **Externalized Configuration**  | Config Server manages all service configs centrally  |
| **Service Discovery**           | Eureka lets services find each other dynamically     |
| **Single Responsibility**       | Each service owns exactly one bounded business domain|
| **Containerization**            | Docker ensures consistent environments everywhere    |

---

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature`
3. Commit your changes: `git commit -m "Add your feature"`
4. Push to the branch: `git push origin feature/your-feature`
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

> Built with ❤️ using Spring Boot & Spring Cloud — Banking Microservices
