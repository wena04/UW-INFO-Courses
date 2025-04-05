-- Author: Anthony Wen
-- INFO 330 AB
DROP DATABASE IF EXISTS aw_charity_db;
CREATE DATABASE aw_charity_db;
GO
USE aw_charity_db;

-- Create a staging table
DROP TABLE IF EXISTS tblStaging
CREATE TABLE tblStaging (
    charity_id INTEGER NOT NULL PRIMARY KEY,
    charity_name VARCHAR(250) NOT NULL,
    charity_mission VARCHAR(MAX) NOT NULL,
    charity_url VARCHAR(100) NOT NULL,
    category_id SMALLINT NOT NULL,
    category_name VARCHAR(150) NOT NULL,
    sub_category VARCHAR(150) NOT NULL,
    work_type VARCHAR(500) NOT NULL,
    charityState VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL,
    latitude DECIMAL NOT NULL,
    longitude DECIMAL NOT NULL,
    minage SMALLINT NOT NULL,
    maxage SMALLINT NOT NULL,
    accountability_score NUMERIC(5,2) NOT NULL,
    financial_score NUMERIC(5,2) NOT NULL,
    overall_score NUMERIC(5,2) NOT NULL,
    total_contributions NUMERIC(15,2) NOT NULL
    );

-- View table structure
SELECT * FROM tblStaging;

-- BULK insert the data into tblStaging
BULK INSERT tblStaging FROM '/Charity_data.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    BATCHSIZE = 25000,
    MAXERRORS = 5
);

-- Examine the file
-- SELECT TOP 10 * FROM tblStaging;

-- Create table for category
-- USE ROW_NUMBER() window function to assign IDs 
DROP TABLE IF EXISTS Categories
SELECT DISTINCT ROW_NUMBER() OVER(ORDER BY category_name) AS category_id, category_name -- assign category_id in alphabetical order
INTO Categories 
FROM tblStaging 
GROUP BY category_id, category_name;

-- view the data from categories
SELECT * FROM Categories;

-- Create a temporary table for subcategory
DROP TABLE IF EXISTS TemSubCategories
SELECT DISTINCT ROW_NUMBER() OVER(ORDER BY sub_category) AS sub_category_id, sub_category -- assign category_id in alphabetical order
INTO Categories 
FROM tblStaging GROUP BY sub_category;

SELECT * FROM TemSubCategories;

-- Create the final subcategory table -- integrate Category_id as FK
SELECT sc.sub_category_id,  c.category_id, sc.sub_category
FROM TemSubCategories sc
JOIN tblStaging s ON sc.sub_category = s.sub_category
JOIN Categories c ON c.category_name = s.category_name
GROUP BY sc.sub_category_id, c.category_id, sc.sub_category;

-- Create table for Locations 
DROP TABLE IF EXISTS Locations;
CREATE TABLE Locations (
    location_id SMALLINT PRIMARY KEY IDENTITY(1,1),
    state VARCHAR(100),
    city VARCHAR(100),
    latitude DECIMAL NOT NULL,
    longitude DECIMAL NOT NULL
);

-- Insert data into Locations
INSERT INTO Locations (state, city, latitude, longitude)
SELECT DISTINCT charityState, city, latitude, longitude
FROM tblStaging;

-- Create table for WorkTypes 
DROP TABLE IF EXISTS WorkTypes;
CREATE TABLE WorkTypes (
    work_type_id SMALLINT PRIMARY KEY IDENTITY(1,1),
    work_type VARCHAR(500)
);

-- Insert data into WorkTypes
INSERT INTO WorkTypes (work_type)
SELECT DISTINCT work_type
FROM tblStaging;

-- Create tables for Charities
DROP TABLE IF EXISTS Charities;
CREATE TABLE Charities (
    charity_id INTEGER PRIMARY KEY IDENTITY(1,1),
    charity_name VARCHAR(250),
    charity_mission VARCHAR(MAX),
    charity_url VARCHAR(100),
    minage SMALLINT,
    maxage SMALLINT,
    location_id SMALLINT,
    work_type_id SMALLINT,
    FOREIGN KEY (location_id) REFERENCES Locations(location_id),
    FOREIGN KEY (work_type_id) REFERENCES WorkTypes(work_type_id)
);

-- Insert data into Charities
SET IDENTITY_INSERT Charities ON;

INSERT INTO Charities (charity_id, charity_name, charity_mission, charity_url, minage, maxage, location_id, work_type_id)
SELECT s.charity_id, s.charity_name, s.charity_mission, s.charity_url, s.minage, s.maxage, l.location_id, w.work_type_id
FROM tblStaging s
JOIN Locations l ON s.charityState = l.state AND s.city = l.city
JOIN WorkTypes w ON s.work_type = w.work_type;

-- Create tables for Scores
DROP TABLE IF EXISTS Scores;
CREATE TABLE Scores (
    scores_id INTEGER PRIMARY KEY IDENTITY(1,1),
    charity_id INTEGER,
    accountability_score NUMERIC(5,2),
    financial_score NUMERIC(5,2),
    overall_score NUMERIC(5,2),
    total_contributions NUMERIC(15,2),
    FOREIGN KEY (charity_id) REFERENCES Charities(charity_id)
);

-- Insert data into Scores
INSERT INTO Scores (charity_id, accountability_score, financial_score, overall_score, total_contributions)
SELECT 
    charity_id,
    accountability_score,
    financial_score,
    overall_score,
    total_contributions
FROM tblStaging;

SELECT * FROM Scores

/* RELATIONAL SCHEMA:

Tables and Columns:
Categories

    category_id (PK): SMALLINT
    category_name: VARCHAR(150)

SubCategories:

    sub_category_id (PK): SMALLINT
    category_id (FK): SMALLINT
    sub_category: VARCHAR(150)

Locations:

    location_id (PK): SMALLINT
    state: VARCHAR(100)
    city: VARCHAR(100)
    latitude: DECIMAL
    longitude: DECIMAL

WorkTypes:

    work_type_id (PK): SMALLINT
    work_type: VARCHAR(500)

Charities:

    charity_id (PK): INTEGER
    charity_name: VARCHAR(250)
    charity_mission: VARCHAR(MAX)
    charity_url: VARCHAR(100)
    minage: SMALLINT
    maxage: SMALLINT
    location_id (FK): SMALLINT
    work_type_id (FK): SMALLINT

Scores:
    scores_id (PK): INTEGER
    charity_id (FK): INTEGER
    accountability_score: NUMERIC(5,2)
    financial_score: NUMERIC(5,2)
    overall_score: NUMERIC(5,2)
    total_contributions: NUMERIC(15,2)

Relationships:

-- Categories:
Primary Key: category_id
Each category can have multiple subcategories.

-- SubCategories:
Primary Key: sub_category_id
Foreign Key: category_id references Categories(category_id)
Each subcategory belongs to one category.

-- Locations:
Primary Key: location_id
Each location can have multiple charities.

-- WorkTypes:
Primary Key: work_type_id
Each work type can be associated with multiple charities.

-- Charities:
Primary Key: charity_id
Foreign Keys: location_id, work_type_id
location_id references Locations(location_id)
work_type_id references WorkTypes(work_type_id)
Each charity has one location and one work type.

-- Scores:
Primary Key: scores_id
Foreign Key: charity_id references Charities(charity_id)
Each charity has one set of scores.

*/





