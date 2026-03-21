CREATE TABLE IF NOT EXISTS `customer` (
  `customer_id` int AUTO_INCREMENT  PRIMARY KEY,
  `customer_name` varchar(100) NOT NULL,
  `customer_email` varchar(100) NOT NULL,
  `customer_mobile_number` varchar(20) NOT NULL,
  `created_at` date ,
  `created_by` varchar(20) ,
  `updated_at` date DEFAULT NULL,
    `updated_by` varchar(20) DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS `accounts` (
   `customer_id` int NOT NULL,
  `account_id` int NOT NULL,
  `account_number` int AUTO_INCREMENT  PRIMARY KEY,
  `account_type` varchar(100) NOT NULL,
  `branch_address` varchar(200) NOT NULL,
  `created_at` date ,
  `created_by` varchar(20) ,
  `updated_at` date DEFAULT NULL,
   `updated_by` varchar(20) DEFAULT NULL
);