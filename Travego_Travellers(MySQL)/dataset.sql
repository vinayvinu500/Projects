##############################Procedure##################################
 /*
	- Creation of the Schema/Database
		- Schema (Approach 1)
		- Database (Approach 2)

	- Creation of the tables
		- Passengers
		- Prices

	- Insert values into the tables
		- Method 1 (Excel <-> Online Sql_converter)
		- Method 2 (Pandas <-> mysql) 

	- Run Sql file in the mysql_community_server(CLI)/ MySQL WorkBench(GUI)
		- Method 1 (CLI)
			- Source /Downloads/C04-Project01-Travego Travelers/task_1.sql # script run into MySQL Command Line (Client)

		- Method 2 (GUI)
			- task_1.sql # script run into MySQL WorkBench
*/
################################################################

/*
-- Approach 1
drop schema if exists `Travego`;

# Create Schema named Travego
CREATE SCHEMA `Travego` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

# Schema
SELECT * FROM INFORMATION_SCHEMA.SCHEMATA;
*/


-- Approach 2
drop database if exists `Travego`;
create database `Travego`;
use `Travego`;

show databases;
show tables;

# Table: Passengers
create table `Travego`.`Passengers`(
	`Passenger_id` int primary key auto_increment,
	`Passenger_name` varchar(20),
	`Category` enum('AC','Non-AC') not null,
	`Gender` enum('F','M') not null,
	`Boarding_City` varchar(20),
	`Destination_City` varchar(20),
	`Distance` int,
	`Bus_Type` enum('Sleeper','Sitting') not null 
);


# Table: Prices
create table `Travego`.`Prices`(
	`id` int primary key auto_increment,
	`Bus_Type` enum('Sleeper','Sitting') not null,
	`Distance` int,
	`Price` int
);

/*
-- Approach 1 => Show columns
SHOW FULL COLUMNS FROM `Travego`.`Passengers`;
SHOW FULL COLUMNS FROM `Travego`.`Prices`;
*/


-- Approach 2 => Show columns
select database();
show tables;
desc `Travego`.`Passengers`;
desc `Travego`.`Prices`;


# Populate Passengers and Prices data
insert into `Travego`.`Passengers` values
	(1, 'Sejal', 'AC', 'F', 'Bengaluru', 'Chennai', 350, 'Sleeper'),
	(2, 'Anmol', 'Non-AC', 'M', 'Mumbai', 'Hyderabad', 700, 'Sitting'),
	(3, 'Pallavi', 'AC', 'F', 'Panaji', 'Bengaluru', 600, 'Sleeper'),
	(4, 'Khusboo', 'AC', 'F', 'Chennai', 'Mumbai', 1500, 'Sleeper'),
	(5, 'Udit', 'Non-AC', 'M', 'Trivandrum', 'Panaji', 1000, 'Sleeper'),
	(6, 'Ankur', 'AC', 'M', 'Nagpur', 'Hyderabad', 500, 'Sitting'),
	(7, 'Hemant', 'Non-AC', 'M', 'Panaji', 'Mumbai', 700, 'Sleeper'),
	(8, 'Manish', 'Non-AC', 'M', 'Hyderabad', 'Bengaluru', 500, 'Sitting'),
	(9, 'Piyush', 'AC', 'M', 'Pune', 'Nagpur', 700, 'Sitting');


insert into `Travego`.`Prices` values
	(1, 'Sleeper', 350, 770),
	(2, 'Sleeper', 500, 1100),
	(3, 'Sleeper', 600, 1320),
	(4, 'Sleeper', 700, 1540),
	(5, 'Sleeper', 1000, 2200),
	(6, 'Sleeper', 1200, 2640),
	(7, 'Sleeper', 1500, 2700),
	(8, 'Sitting', 500, 620),
	(9, 'Sitting', 600, 744),
	(10, 'Sitting', 700, 868),
	(11, 'Sitting', 1000, 1240),
	(12, 'Sitting', 1200, 1488),
	(13, 'Sitting', 1500, 1860);

# Show data
select * from `Travego`.`Passengers`;
select * from `Travego`.`Prices`;
