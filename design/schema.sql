-- ============================================================================
-- ECON485 Fall 2025 - Project 3: Tourism Revenue & Visitor Trends
-- Complete Database Schema (3NF Normalized)
-- ============================================================================
-- Team 3
-- Date: Week 5
-- Database: MariaDB 10.6+
-- Character Set: UTF-8
-- ============================================================================

-- Drop existing database if exists (clean slate)
DROP DATABASE IF EXISTS tourism_analytics;

-- Create database with UTF-8 support
CREATE DATABASE tourism_analytics
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_unicode_ci;

USE tourism_analytics;

-- ============================================================================
-- TABLE 1: REGIONS
-- Geographic tourist destinations (cities, provinces, resort areas)
-- ============================================================================

CREATE TABLE Regions (
    RegionID INT AUTO_INCREMENT PRIMARY KEY,
    RegionName VARCHAR(100) NOT NULL,
    Country VARCHAR(100) NOT NULL DEFAULT 'Turkey',
    RegionType ENUM('Urban', 'Coastal', 'Rural', 'Mountain') NOT NULL,
    Population INT,
    GDP DECIMAL(15,2) COMMENT 'Regional GDP in millions USD',
    Description TEXT,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Constraints
    CONSTRAINT chk_population CHECK (Population >= 0),
    CONSTRAINT chk_gdp CHECK (GDP >= 0),
    
    -- Indexes for performance
    INDEX idx_region_name (RegionName),
    INDEX idx_country (Country),
    INDEX idx_region_type (RegionType)
) ENGINE=InnoDB
  COMMENT='Geographic tourist destinations';

-- ============================================================================
-- TABLE 2: HOTELS
-- Accommodation facilities offering rooms to visitors
-- ============================================================================

CREATE TABLE Hotels (
    HotelID INT AUTO_INCREMENT PRIMARY KEY,
    HotelName VARCHAR(200) NOT NULL,
    RegionID INT NOT NULL,
    StarRating DECIMAL(2,1) NOT NULL,
    TotalRooms INT NOT NULL,
    Address VARCHAR(300),
    City VARCHAR(100),
    ZipCode VARCHAR(20),
    ContactPhone VARCHAR(50),
    ContactEmail VARCHAR(100),
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Foreign Key
    FOREIGN KEY (RegionID) REFERENCES Regions(RegionID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    
    -- Constraints
    CONSTRAINT chk_star_rating CHECK (StarRating >= 1.0 AND StarRating <= 5.0),
    CONSTRAINT chk_total_rooms CHECK (TotalRooms > 0),
    CONSTRAINT chk_email_format CHECK (ContactEmail LIKE '%@%.%'),
    
    -- Indexes
    INDEX idx_hotel_region (RegionID),
    INDEX idx_hotel_rating (StarRating),
    INDEX idx_hotel_name (HotelName)
) ENGINE=InnoDB
  COMMENT='Accommodation facilities';

-- ============================================================================
-- TABLE 3: VISITORS
-- Individual tourists with demographic information
-- ============================================================================

CREATE TABLE Visitors (
    VisitorID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    Country VARCHAR(100) NOT NULL,
    Age INT,
    Gender ENUM('Male', 'Female', 'Other', 'PreferNotToSay'),
    VisitorType ENUM('Domestic', 'International') NOT NULL,
    Email VARCHAR(100),
    Phone VARCHAR(50),
    RegisteredDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Constraints
    CONSTRAINT chk_age CHECK (Age >= 0 AND Age <= 120),
    CONSTRAINT chk_visitor_email CHECK (Email IS NULL OR Email LIKE '%@%.%'),
    
    -- Indexes
    INDEX idx_visitor_country (Country),
    INDEX idx_visitor_type (VisitorType),
    INDEX idx_visitor_name (LastName, FirstName)
) ENGINE=InnoDB
  COMMENT='Individual tourists with demographics';

-- ============================================================================
-- TABLE 4: ROOM_TYPES
-- Categorization of hotel room types
-- ============================================================================

CREATE TABLE RoomTypes (
    RoomTypeID INT AUTO_INCREMENT PRIMARY KEY,
    TypeName VARCHAR(50) NOT NULL UNIQUE,
    BaseCapacity INT NOT NULL,
    Description TEXT,
    
    -- Constraints
    CONSTRAINT chk_capacity CHECK (BaseCapacity > 0 AND BaseCapacity <= 10)
) ENGINE=InnoDB
  COMMENT='Room type categories';

-- ============================================================================
-- TABLE 5: SEASONS
-- Temporal classifications for seasonal tourism analysis
-- ============================================================================

CREATE TABLE Seasons (
    SeasonID INT AUTO_INCREMENT PRIMARY KEY,
    SeasonName ENUM('Peak', 'Shoulder', 'Off-Season') NOT NULL,
    StartMonth INT NOT NULL,
    EndMonth INT NOT NULL,
    YearApplicable INT,
    Description TEXT,
    
    -- Constraints
    CONSTRAINT chk_start_month CHECK (StartMonth >= 1 AND StartMonth <= 12),
    CONSTRAINT chk_end_month CHECK (EndMonth >= 1 AND EndMonth <= 12),
    CONSTRAINT chk_year CHECK (YearApplicable >= 2020),
    
    -- Unique constraint: one season definition per name per year
    UNIQUE KEY unique_season_year (SeasonName, YearApplicable)
) ENGINE=InnoDB
  COMMENT='Seasonal period definitions';

-- ============================================================================
-- TABLE 6: BOOKINGS
-- Reservation records linking visitors to hotels
-- ============================================================================

CREATE TABLE Bookings (
    BookingID INT AUTO_INCREMENT PRIMARY KEY,
    VisitorID INT NOT NULL,
    HotelID INT NOT NULL,
    RoomTypeID INT NOT NULL,
    CheckInDate DATE NOT NULL,
    CheckOutDate DATE NOT NULL,
    NumberOfGuests INT NOT NULL DEFAULT 1,
    PricePerNight DECIMAL(10,2) NOT NULL,
    TotalCost DECIMAL(10,2) NOT NULL COMMENT 'Denormalized for performance - see normalization doc',
    BookingStatus ENUM('Confirmed', 'Cancelled', 'Completed') NOT NULL DEFAULT 'Confirmed',
    BookingDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Foreign Keys
    FOREIGN KEY (VisitorID) REFERENCES Visitors(VisitorID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    FOREIGN KEY (HotelID) REFERENCES Hotels(HotelID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    FOREIGN KEY (RoomTypeID) REFERENCES RoomTypes(RoomTypeID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    
    -- Constraints
    CONSTRAINT chk_checkout_after_checkin CHECK (CheckOutDate > CheckInDate),
    CONSTRAINT chk_price_positive CHECK (PricePerNight > 0),
    CONSTRAINT chk_total_cost_positive CHECK (TotalCost > 0),
    CONSTRAINT chk_guests CHECK (NumberOfGuests > 0 AND NumberOfGuests <= 10),
    
    -- Indexes for common queries
    INDEX idx_booking_visitor (VisitorID),
    INDEX idx_booking_hotel (HotelID),
    INDEX idx_booking_dates (CheckInDate, CheckOutDate),
    INDEX idx_booking_status (BookingStatus),
    INDEX idx_booking_hotel_dates (HotelID, CheckInDate)
) ENGINE=InnoDB
  COMMENT='Reservation records';

-- ============================================================================
-- TABLE 7: EXPENDITURES
-- Detailed spending records beyond accommodation costs
-- ============================================================================

CREATE TABLE Expenditures (
    ExpenditureID INT AUTO_INCREMENT PRIMARY KEY,
    VisitorID INT NOT NULL,
    RegionID INT NOT NULL,
    Category ENUM('Accommodation', 'Food', 'Activities', 'Shopping', 'Transportation', 'Other') NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    ExpenditureDate DATE NOT NULL,
    Description VARCHAR(300),
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Foreign Keys
    FOREIGN KEY (VisitorID) REFERENCES Visitors(VisitorID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    FOREIGN KEY (RegionID) REFERENCES Regions(RegionID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    
    -- Constraints
    CONSTRAINT chk_amount_positive CHECK (Amount > 0),
    
    -- Indexes
    INDEX idx_expenditure_visitor (VisitorID),
    INDEX idx_expenditure_region (RegionID),
    INDEX idx_expenditure_category (Category),
    INDEX idx_expenditure_date (ExpenditureDate),
    INDEX idx_expenditure_region_date (RegionID, ExpenditureDate)
) ENGINE=InnoDB
  COMMENT='Visitor spending records';

-- ============================================================================
-- OPTIONAL TABLE: HOTEL_ROOM_PRICING
-- Dynamic pricing based on hotel, room type, and season
-- (Implement if time permits in Stage 2)
-- ============================================================================

CREATE TABLE HotelRoomPricing (
    PricingID INT AUTO_INCREMENT PRIMARY KEY,
    HotelID INT NOT NULL,
    RoomTypeID INT NOT NULL,
    SeasonID INT NOT NULL,
    PricePerNight DECIMAL(10,2) NOT NULL,
    AvailableRooms INT NOT NULL,
    
    -- Foreign Keys
    FOREIGN KEY (HotelID) REFERENCES Hotels(HotelID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (RoomTypeID) REFERENCES RoomTypes(RoomTypeID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (SeasonID) REFERENCES Seasons(SeasonID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    
    -- Constraints
    CONSTRAINT chk_pricing_positive CHECK (PricePerNight > 0),
    CONSTRAINT chk_available_rooms CHECK (AvailableRooms >= 0),
    
    -- Unique constraint: one price per hotel-room-season combination
    UNIQUE KEY unique_hotel_room_season (HotelID, RoomTypeID, SeasonID),
    
    -- Indexes
    INDEX idx_pricing_hotel (HotelID),
    INDEX idx_pricing_season (SeasonID)
) ENGINE=InnoDB
  COMMENT='Seasonal pricing for hotel rooms';

-- ============================================================================
-- SUMMARY STATISTICS
-- ============================================================================

SELECT 'Schema Created Successfully!' AS Status;

SELECT 
    TABLE_NAME AS 'Table',
    TABLE_COMMENT AS 'Description'
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'tourism_analytics'
  AND TABLE_NAME NOT LIKE '%INFORMATION%'
ORDER BY TABLE_NAME;

-- ============================================================================
-- END OF SCHEMA DEFINITION
-- ============================================================================

/*
NORMALIZATION STATUS:
- 7 core tables + 1 optional table
- 5 tables in strict 3NF
- 2 tables with intentional, documented denormalizations:
  1. Hotels: Address components (City, ZipCode)
  2. Bookings: TotalCost (derived but immutable)
  
All denormalizations justified in normalization_analysis.md

NEXT STEPS (Week 6):
1. Generate sample data (Python script)
2. Test INSERT, UPDATE, DELETE operations
3. Validate constraints
4. Verify foreign key cascades
5. Test basic SELECT queries

DATABASE FEATURES USED:
- AUTO_INCREMENT primary keys
- ENUM for constrained values
- CHECK constraints for data validation
- Foreign keys with CASCADE options
- Indexes on foreign keys and query patterns
- Comments for documentation
- UTF-8 character set support
*/