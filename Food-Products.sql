CREATE DATABASE Food_Products;
USE Food_Products;


-- Manufacturer table 
CREATE TABLE Manufacturer (
    Manufacturer_ID INT AUTO_INCREMENT,
    Manufacturer_Name VARCHAR(100) NOT NULL,
    Address VARCHAR(255) NOT NULL,
    PhoneNumber VARCHAR(15) NOT NULL,
    Email VARCHAR(100) NOT NULL,
    Primary Key(Manufacturer_ID)
);

-- Store table
CREATE TABLE Store (
    Store_Id INT AUTO_INCREMENT,
    Store_Name VARCHAR(100) NOT NULL,
    PhoneNumber VARCHAR(15) NOT NULL,
    Email VARCHAR(100) NOT NULL,
	Primary Key(Store_Id)
);

-- Store_Locations multi-value attribute in Store entity.
CREATE TABLE Store_Locations (
-- multiple locations of the same store have the same Store_Id, but unique Location_Id.
  Store_Id INT NOT NULL, 
  Location_Id INT AUTO_INCREMENT NOT NULL,
  Location_Address VARCHAR(255) NOT NULL,
  Primary Key (Location_Id, Store_Id),
  FOREIGN KEY (Store_Id) REFERENCES Store(Store_Id)
);

-- Product table
CREATE TABLE Product (
    Barcode INT NOT NULL, -- all product barcodes are unique, so this can be the primary key.
    Product_Name VARCHAR(100) NOT NULL, -- it possible for 2 prducts to have same name
    Manufacturer_ID INT NOT NULL,
	Dietary_Preference VARCHAR(30) CHECK (Dietary_Preference IN ('vegan', 'vegetarian', 'halal','kosher')),
	Primary Key(Barcode),
    FOREIGN KEY (Manufacturer_ID) REFERENCES Manufacturer(Manufacturer_ID)
);

-- Ingredient Table
CREATE TABLE Ingredient (
-- making PK:
    Ingredient_ID INT AUTO_INCREMENT,
    Ingredient_Name VARCHAR(100) NOT NULL,
    Ingredient_Source VARCHAR(100) NOT NULL,
    Barcode INT NOT NULL, 
	Primary Key(Ingredient_ID),
	--  INGREDIENTS should have unique names and not duplicated in a product:
    UNIQUE (Barcode, Ingredient_Name)
);

-- Nutritional Detail table
CREATE TABLE NutritionalDetail (
-- making PK:
    Nutritional_Detail_Id INT AUTO_INCREMENT,
    Barcode INT NOT NULL,
    Nutritional_Detail VARCHAR(100) NOT NULL,
    Amount VARCHAR(50) NOT NULL,
	Primary Key(Nutritional_Detail_Id),
	FOREIGN KEY (Barcode) REFERENCES Product(Barcode),
	--  nutritional facts should have unique names and not duplicated in a product:
	UNIQUE (Barcode, Nutritional_Detail)
);

CREATE TABLE Consumer (
-- making PK:
    Consumer_Id INT AUTO_INCREMENT,
    -- email could be null since giving an email is optional for consumers.
    Email VARCHAR(100),
	Primary Key(Consumer_Id)
);



-- ProductRequest table: Consumers can request to add a product by providing partial or full info.
CREATE TABLE ProductRequest (
    Request_Id INT AUTO_INCREMENT NOT NULL,
    Consumer_Id INT NOT NULL,
    -- even though partial information is allowed, barcode and product name is required when requesting to add a product to the database (to maintain database steucture and clarity).
    Barcode Int NOT NULL,
    Product_Name VARCHAR(100) NOT NULL,
    Manufacturer_Name VARCHAR(100),
    -- Store_Name refers to the store in which consumer purchased the product, not all stores in which it is sold in!!:
    Store_Name VARCHAR(100), 
	Dietary_Preference VARCHAR(100), 
    PRIMARY KEY (Request_Id),
    FOREIGN KEY (Consumer_Id) REFERENCES Consumer(Consumer_Id)
);

-- ProductRequestIngredient table to store 1-many ingredients related to a product request
CREATE TABLE ProductRequestIngredient (
-- keeps track of the # of ingredients provided by consumer:
    Request_Ingredient_Id INT AUTO_INCREMENT NOT NULL, 
    Request_Id INT NOT NULL,
    Ingredient_Name VARCHAR(100),
    Ingredient_Source VARCHAR(100),
    PRIMARY KEY (Request_Ingredient_Id),
    FOREIGN KEY (Request_Id) REFERENCES ProductRequest(Request_Id)
);

-- ProductRequestNutritionalDetail table to store 0-many nutritional details related to a product request
CREATE TABLE ProductRequestNutritionalDetail (
-- keeps track of the # of nutritional facts provided by consumer:
    Request_Nutritional_Detail_Id INT AUTO_INCREMENT NOT NULL,
    Request_Id INT NOT NULL,
    Nutritional_Detail_Name VARCHAR(100),
    Amount VARCHAR(100),
    PRIMARY KEY (Request_Nutritional_Detail_Id),
    FOREIGN KEY (Request_Id) REFERENCES ProductRequest(Request_Id)
);


SHOW TABLES;
Describe Product;
Describe Manufacturer;
Describe Store;
Describe Store_Locations;
Describe Ingredient;
Describe NutritionalDetail;
Describe Consumer;
Describe ProductRequest;
Describe ProductRequestIngredient;
Describe ProductRequestNutritionalDetail;
