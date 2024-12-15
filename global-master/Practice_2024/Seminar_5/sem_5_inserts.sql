CREATE SCHEMA IF NOT EXISTS sem_5;

-- Оконные функции и CTE

DROP TABLE IF EXISTS sem_5.product_groups CASCADE;

CREATE TABLE sem_5.product_groups (
	group_id serial PRIMARY KEY,
	group_name VARCHAR (255) NOT NULL
);

DROP TABLE IF EXISTS sem_5.products;

CREATE TABLE sem_5.products (
	product_id serial PRIMARY KEY,
	product_name VARCHAR (255) NOT NULL,
	price DECIMAL (11, 2),
	group_id INT NOT NULL,
	FOREIGN KEY (group_id) REFERENCES sem_5.product_groups (group_id)
);

INSERT INTO sem_5.product_groups (group_name)
VALUES
	('Smartphone'),
	('Laptop'),
	('Tablet'),
    ('Camera'),
	('Audio Devices'),
	('Wearable'),
	('Gaming Console'),
	('Printer'),
	('Appliances'),
	('Furniture'),
	('Outdoor Gear'),
	('Fitness Equipment'),
	('Home Decor'),
	('Books');

INSERT INTO sem_5.products (product_name, group_id,price)
VALUES
	('Microsoft Lumia', 1, 200),
	('HTC One', 1, 400),
	('Nexus', 1, 500),
	('iPhone', 1, 900),
	('HP Elite', 2, 1200),
	('Lenovo Thinkpad', 2, 700),
	('Sony VAIO', 2, 700),
	('Dell Vostro', 2, 800),
	('iPad', 3, 700),
	('Kindle Fire', 3, 150),
	('Samsung Galaxy Tab', 3, 200),
    ('Nikon DSLR', 4, 800),
	('Canon PowerShot', 4, 400),
	('Sony Alpha', 4, 1200),
	('Bose Headphones', 5, 300),
	('JBL Speaker', 5, 150),
	('Apple AirPods', 5, 200),
	('Fitbit', 6, 100),
	('Apple Watch', 6, 400),
	('PlayStation 5', 7, 500),
	('Xbox Series X', 7, 450),
	('HP LaserJet', 8, 300),
	('Epson Inkjet', 8, 150),
    ('Refrigerator', 9, 1200),
	('Washing Machine', 9, 800),
	('Sofa Set', 10, 1000),
	('Dining Table', 10, 600),
	('Camping Tent', 11, 150),
	('Hiking Backpack', 11, 80),
	('Treadmill', 12, 500),
	('Yoga Mat', 12, 30),
	('Wall Clock', 13, 50),
	('Table Lamp', 13, 40),
	('Cooking Books Set', 14, 80),
	('History Books Collection', 14, 120),
    ('Samsung Fridge', 9, 1000),
	('LG Washer', 9, 700),
	('Leather Sofa', 10, 1200),
	('Coffee Table', 10, 300),
	('Sleeping Bag', 11, 50),
	('Portable Grill', 11, 80),
	('Elliptical Trainer', 12, 600),
	('Resistance Bands Set', 12, 40),
	('Wall Art Painting', 13, 120),
	('Floor Lamp', 13, 70),
	('Healthy Cooking Recipe Book', 14, 35),
	('Science Fiction Novels Collection', 14, 150),
    ('Robot Vacuum Cleaner', 9, 300),
	('Smart Microwave', 9, 150),
	('L-Shaped Sectional Sofa', 10, 1500),
	('Bookshelf', 10, 200),
	('Camping Stove', 11, 70),
	('Sleeping Pad', 11, 40),
	('Stationary Bike', 12, 450),
	('Dumbbell Set', 12, 120),
	('Mirror Wall Decor', 13, 80),
	('Ceiling Fan', 13, 100),
	('Vegetarian Cookbook', 14, 25),
	('Mystery Thriller Novels Collection', 14, 180),
    ('Samsung Galaxy S21', 1, 800),
	('Google Pixel 6', 1, 900),
	('OnePlus 9', 1, 700),
	('Xiaomi Mi 11', 1, 600),
    ('Asus ROG Strix', 2, 1500),
	('Acer Swift', 2, 800),
	('Dell XPS', 2, 1200),
	('Lenovo Yoga', 2, 1000),
    ('Samsung Galaxy Tab S7', 3, 800),
	('Apple iPad Pro', 3, 1000),
	('Amazon Fire HD', 3, 150),
	('Lenovo Tab P11', 3, 300),
    ('Canon EOS R5', 4, 3000),
	('Nikon Z6', 4, 2000),
	('Sony A7III', 4, 2500),
	('Fujifilm X-T4', 4, 1800),
    ('Sennheiser HD 660S', 5, 500),
	('Bose QuietComfort 45', 5, 350),
	('Sony WH-1000XM4', 5, 400),
	('JBL Flip 5', 5, 100),
    ('Fitbit Versa 3', 6, 200),
	('Garmin Venu', 6, 300),
	('Apple Watch SE', 6, 250),
	('Samsung Galaxy Fit 2', 6, 80),
    ('HP Pavilion', 7, 800),
	('Dell Inspiron', 7, 700),
	('Acer Aspire', 7, 600),
	('Lenovo Legion', 7, 1000),
    ('PlayStation 5 Pro', 8, 600),
	('Xbox Series X Pro', 8, 550),
	('Nintendo Switch OLED', 8, 400),
	('PC Gaming Setup', 8, 1200);
	

-- Рекурсия

DROP TABLE IF EXISTS sem_5.employees;

CREATE TABLE sem_5.employees (
	employee_id serial PRIMARY KEY,
	full_name VARCHAR NOT NULL,
	manager_id INT
);

INSERT INTO sem_5.employees (
	employee_id,
	full_name,
	manager_id
)
VALUES
	(1, 'Michael North', NULL),
	(2, 'Megan Berry', 1),
	(3, 'Sarah Berry', 1),
	(4, 'Zoe Black', 1),
	(5, 'Tim James', 1),
	(6, 'Bella Tucker', 2),
	(7, 'Ryan Metcalfe', 2),
	(8, 'Max Mills', 2),
	(9, 'Benjamin Glover', 2),
	(10, 'Carolyn Henderson', 3),
	(11, 'Nicola Kelly', 3),
	(12, 'Alexandra Climo', 3),
	(13, 'Dominic King', 3),
	(14, 'Leonard Gray', 4),
	(15, 'Eric Rampling', 4),
	(16, 'Piers Paige', 7),
	(17, 'Ryan Henderson', 7),
	(18, 'Frank Tucker', 8),
	(19, 'Nathan Ferguson', 8),
	(20, 'Kevin Rampling', 8);
