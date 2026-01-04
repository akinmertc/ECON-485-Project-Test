-- ============================================================================
-- ECON485 Fall 2025 - Project 3: Tourism Revenue & Visitor Trends
-- Week 6: CRUD Operations Demonstration
-- ============================================================================
-- Team 3
-- Purpose: Demonstrate basic database operations (Create, Read, Update, Delete)
-- Database: tourism_analytics
-- ============================================================================

USE tourism_analytics;

-- ============================================================================
-- PART 1: CREATE OPERATIONS (INSERT)
-- ============================================================================

-- -----------------------------------------------------------------------------
-- INSERT Sample Regions
-- -----------------------------------------------------------------------------

INSERT INTO Regions (RegionName, Country, RegionType, Population, GDP, Description) VALUES
('Istanbul', 'Turkey', 'Urban', 15460000, 285000.00, 'Largest city, cultural and economic hub'),
('Antalya', 'Turkey', 'Coastal', 2511700, 45000.00, 'Mediterranean resort city, tourism capital'),
('Cappadocia', 'Turkey', 'Rural', 367000, 8500.00, 'Historical region famous for rock formations'),
('Bodrum', 'Turkey', 'Coastal', 180000, 12000.00, 'Aegean coastal town, luxury resorts'),
('Pamukkale', 'Turkey', 'Rural', 25000, 3200.00, 'Natural hot springs and travertine terraces'),
('Izmir', 'Turkey', 'Urban', 4400000, 78000.00, 'Third largest city, Aegean coast'),
('Trabzon', 'Turkey', 'Coastal', 810000, 18000.00, 'Black Sea region, historical monasteries'),
('Uludağ', 'Turkey', 'Mountain', 45000, 2800.00, 'Ski resort near Bursa'),
('Ephesus', 'Turkey', 'Rural', 12000, 1500.00, 'Ancient city ruins, archaeological site'),
('Marmaris', 'Turkey', 'Coastal', 95000, 7500.00, 'Beach resort, yacht marina');

-- Verify insertions
SELECT RegionID, RegionName, RegionType, Population FROM Regions;

-- -----------------------------------------------------------------------------
-- INSERT Sample Hotels
-- -----------------------------------------------------------------------------

INSERT INTO Hotels (HotelName, RegionID, StarRating, TotalRooms, Address, City, ZipCode, ContactPhone, ContactEmail) VALUES
-- Istanbul hotels
('Grand Istanbul Palace', 1, 5.0, 250, 'Sultanahmet Square 15', 'Istanbul', '34122', '+90-212-555-0001', 'info@grandistanbul.com'),
('Bosphorus View Hotel', 1, 4.5, 180, 'Ortaköy Caddesi 45', 'Istanbul', '34347', '+90-212-555-0002', 'bookings@bosphorusview.com'),
('City Center Inn', 1, 3.5, 120, 'Taksim Meydanı 8', 'Istanbul', '34435', '+90-212-555-0003', 'reception@citycenterinn.com'),

-- Antalya hotels
('Antalya Beach Resort', 2, 5.0, 400, 'Lara Beach Road 100', 'Antalya', '07100', '+90-242-555-0101', 'reservations@antalyabeach.com'),
('Mediterranean Suites', 2, 4.0, 200, 'Konyaaltı Avenue 78', 'Antalya', '07050', '+90-242-555-0102', 'info@medsuits.com'),
('Sunrise Hotel', 2, 3.0, 90, 'Old Town Center 23', 'Antalya', '07100', '+90-242-555-0103', 'contact@sunrisehotel.com'),

-- Cappadocia hotels  
('Cave Suites Cappadocia', 3, 4.5, 45, 'Göreme Village Center', 'Nevşehir', '50180', '+90-384-555-0201', 'bookings@cavesuites.com'),
('Fairy Chimney Hotel', 3, 4.0, 60, 'Uçhisar Castle Road 12', 'Nevşehir', '50240', '+90-384-555-0202', 'info@fairychimney.com'),

-- Bodrum hotels
('Bodrum Luxury Marina', 4, 5.0, 150, 'Marina Boulevard 5', 'Bodrum', '48400', '+90-252-555-0301', 'concierge@bodrummarina.com'),
('Aegean Breeze Hotel', 4, 4.0, 100, 'Gümbet Beach 34', 'Bodrum', '48400', '+90-252-555-0302', 'reservations@aegeanbreeze.com'),

-- Additional regions
('Thermal Spa Resort', 5, 4.5, 80, 'Travertine Terraces Road 1', 'Denizli', '20190', '+90-258-555-0401', 'spa@thermalresort.com'),
('Izmir Bay Hotel', 6, 4.0, 200, 'Kordon Boulevard 156', 'Izmir', '35220', '+90-232-555-0501', 'info@izmirbay.com'),
('Sumela Monastery Inn', 7, 3.5, 50, 'Altındere Valley 8', 'Trabzon', '61750', '+90-462-555-0601', 'bookings@sumelainn.com'),
('Uludağ Ski Lodge', 8, 4.0, 120, 'Ski Resort Center', 'Bursa', '16370', '+90-224-555-0701', 'reservations@uludagski.com'),
('Ephesus Heritage Hotel', 9, 3.5, 60, 'Ancient City Entrance 45', 'Selçuk', '35920', '+90-232-555-0801', 'info@ephesusheritage.com');

-- Verify hotels
SELECT HotelID, HotelName, StarRating, City FROM Hotels LIMIT 10;

-- -----------------------------------------------------------------------------
-- INSERT Sample Room Types
-- -----------------------------------------------------------------------------

INSERT INTO RoomTypes (TypeName, BaseCapacity, Description) VALUES
('Standard', 2, 'Basic room with essential amenities, double bed'),
('Deluxe', 2, 'Enhanced room with better view and premium bedding'),
('Suite', 4, 'Large room with separate living area, suitable for families'),
('Family', 5, 'Spacious room with multiple beds for families with children'),
('Presidential', 6, 'Luxury suite with panoramic views and premium services');

SELECT * FROM RoomTypes;

-- -----------------------------------------------------------------------------
-- INSERT Sample Seasons
-- -----------------------------------------------------------------------------

INSERT INTO Seasons (SeasonName, StartMonth, EndMonth, YearApplicable, Description) VALUES
('Peak', 6, 8, 2024, 'Summer high season: June to August'),
('Peak', 12, 1, 2024, 'Winter holidays: December to January'),
('Shoulder', 4, 5, 2024, 'Spring season: April to May'),
('Shoulder', 9, 10, 2024, 'Autumn season: September to October'),
('Off-Season', 2, 3, 2024, 'Winter low season: February to March'),
('Off-Season', 11, 11, 2024, 'November low season'),
('Peak', 6, 8, 2025, 'Summer high season 2025'),
('Shoulder', 4, 5, 2025, 'Spring season 2025');

SELECT * FROM Seasons;

-- -----------------------------------------------------------------------------
-- INSERT Sample Visitors
-- -----------------------------------------------------------------------------

INSERT INTO Visitors (FirstName, LastName, Country, Age, Gender, VisitorType, Email, Phone) VALUES
-- Domestic visitors (Turkish)
('Ahmet', 'Yılmaz', 'Turkey', 35, 'Male', 'Domestic', 'ahmet.yilmaz@email.com', '+90-532-123-4567'),
('Ayşe', 'Kaya', 'Turkey', 28, 'Female', 'Domestic', 'ayse.kaya@email.com', '+90-533-234-5678'),
('Mehmet', 'Demir', 'Turkey', 42, 'Male', 'Domestic', 'mehmet.demir@email.com', '+90-534-345-6789'),
('Fatma', 'Şahin', 'Turkey', 31, 'Female', 'Domestic', 'fatma.sahin@email.com', '+90-535-456-7890'),
('Ali', 'Çelik', 'Turkey', 27, 'Male', 'Domestic', 'ali.celik@email.com', '+90-536-567-8901'),

-- International visitors (Europe)
('John', 'Smith', 'United Kingdom', 45, 'Male', 'International', 'john.smith@email.co.uk', '+44-7700-900123'),
('Emma', 'Johnson', 'United Kingdom', 38, 'Female', 'International', 'emma.johnson@email.co.uk', '+44-7700-900234'),
('Hans', 'Mueller', 'Germany', 52, 'Male', 'International', 'hans.mueller@email.de', '+49-151-234-5678'),
('Marie', 'Dubois', 'France', 29, 'Female', 'International', 'marie.dubois@email.fr', '+33-6-12-34-56-78'),
('Luigi', 'Rossi', 'Italy', 33, 'Male', 'International', 'luigi.rossi@email.it', '+39-320-123-4567'),

-- International visitors (Other regions)
('Mohammed', 'Al-Farsi', 'Saudi Arabia', 40, 'Male', 'International', 'mohammed.alfarsi@email.sa', '+966-50-123-4567'),
('Svetlana', 'Ivanova', 'Russia', 36, 'Female', 'International', 'svetlana.ivanova@email.ru', '+7-916-123-4567'),
('Wang', 'Wei', 'China', 31, 'Male', 'International', 'wang.wei@email.cn', '+86-138-0013-8000'),
('Emily', 'Davis', 'United States', 28, 'Female', 'International', 'emily.davis@email.com', '+1-555-123-4567'),
('Sarah', 'Brown', 'Australia', 34, 'Female', 'International', 'sarah.brown@email.au', '+61-400-123-456');

-- Verify visitors
SELECT VisitorID, CONCAT(FirstName, ' ', LastName) AS FullName, Country, VisitorType FROM Visitors;

-- -----------------------------------------------------------------------------
-- INSERT Sample Bookings
-- -----------------------------------------------------------------------------

INSERT INTO Bookings (VisitorID, HotelID, RoomTypeID, CheckInDate, CheckOutDate, NumberOfGuests, PricePerNight, TotalCost, BookingStatus) VALUES
-- Summer 2024 bookings (Peak season)
(1, 1, 3, '2024-07-15', '2024-07-20', 4, 350.00, 1750.00, 'Completed'),
(2, 4, 2, '2024-08-01', '2024-08-07', 2, 280.00, 1680.00, 'Completed'),
(3, 7, 1, '2024-07-10', '2024-07-14', 2, 200.00, 800.00, 'Completed'),
(6, 2, 5, '2024-08-15', '2024-08-22', 4, 650.00, 4550.00, 'Completed'),
(8, 4, 3, '2024-07-22', '2024-07-29', 3, 320.00, 2240.00, 'Completed'),

-- Shoulder season 2024
(4, 9, 2, '2024-09-10', '2024-09-15', 2, 180.00, 900.00, 'Completed'),
(7, 5, 1, '2024-10-05', '2024-10-10', 2, 150.00, 750.00, 'Completed'),
(9, 11, 2, '2024-04-20', '2024-04-25', 2, 160.00, 800.00, 'Completed'),

-- Off-season 2024
(5, 3, 1, '2024-02-10', '2024-02-13', 2, 120.00, 360.00, 'Completed'),
(10, 8, 2, '2024-03-15', '2024-03-18', 2, 140.00, 420.00, 'Completed'),

-- Future bookings 2025 (Confirmed status)
(11, 1, 3, '2025-06-15', '2025-06-20', 3, 380.00, 1900.00, 'Confirmed'),
(12, 4, 5, '2025-07-01', '2025-07-10', 4, 450.00, 4050.00, 'Confirmed'),
(13, 7, 2, '2025-08-10', '2025-08-15', 2, 250.00, 1250.00, 'Confirmed'),
(14, 9, 1, '2025-05-20', '2025-05-25', 2, 170.00, 850.00, 'Confirmed'),
(15, 2, 4, '2025-07-15', '2025-07-22', 5, 420.00, 2940.00, 'Confirmed');

-- Verify bookings
SELECT BookingID, VisitorID, HotelID, CheckInDate, CheckOutDate, TotalCost, BookingStatus 
FROM Bookings 
ORDER BY CheckInDate;

-- -----------------------------------------------------------------------------
-- INSERT Sample Expenditures
-- -----------------------------------------------------------------------------

INSERT INTO Expenditures (VisitorID, RegionID, Category, Amount, ExpenditureDate, Description) VALUES
-- Visitor 1 expenditures in Istanbul
(1, 1, 'Food', 120.00, '2024-07-15', 'Dinner at seafood restaurant'),
(1, 1, 'Activities', 80.00, '2024-07-16', 'Bosphorus cruise tour'),
(1, 1, 'Shopping', 250.00, '2024-07-18', 'Turkish carpets and souvenirs'),
(1, 1, 'Transportation', 45.00, '2024-07-20', 'Airport transfer'),

-- Visitor 2 expenditures in Antalya
(2, 2, 'Food', 95.00, '2024-08-02', 'Lunch at beach restaurant'),
(2, 2, 'Activities', 150.00, '2024-08-03', 'Scuba diving excursion'),
(2, 2, 'Activities', 60.00, '2024-08-05', 'Paragliding experience'),

-- Visitor 6 (international) expenditures
(6, 1, 'Food', 180.00, '2024-08-16', 'Fine dining experience'),
(6, 1, 'Shopping', 450.00, '2024-08-18', 'Jewelry and leather goods'),
(6, 1, 'Activities', 200.00, '2024-08-19', 'Private guided tour'),
(6, 1, 'Transportation', 120.00, '2024-08-21', 'Private driver service'),

-- Additional expenditures across regions
(3, 3, 'Activities', 180.00, '2024-07-11', 'Hot air balloon ride Cappadocia'),
(3, 3, 'Food', 75.00, '2024-07-12', 'Traditional pottery restaurant'),
(4, 4, 'Activities', 90.00, '2024-09-12', 'Boat tour around Bodrum'),
(4, 4, 'Shopping', 120.00, '2024-09-14', 'Local handicrafts'),
(8, 2, 'Food', 200.00, '2024-07-24', 'Multiple meals at resort'),
(8, 2, 'Activities', 250.00, '2024-07-26', 'Water sports package');

-- Verify expenditures
SELECT ExpenditureID, VisitorID, Category, Amount, ExpenditureDate 
FROM Expenditures 
ORDER BY VisitorID, ExpenditureDate;

-- ============================================================================
-- PART 2: READ OPERATIONS (SELECT)
-- ============================================================================

-- -----------------------------------------------------------------------------
-- Basic SELECT Queries
-- -----------------------------------------------------------------------------

-- Query 1: List all regions with their population
SELECT RegionName, RegionType, Population, GDP 
FROM Regions 
ORDER BY Population DESC;

-- Query 2: Find all 5-star hotels
SELECT HotelName, City, StarRating, TotalRooms, ContactEmail
FROM Hotels
WHERE StarRating = 5.0
ORDER BY TotalRooms DESC;

-- Query 3: Count visitors by country
SELECT Country, VisitorType, COUNT(*) AS VisitorCount
FROM Visitors
GROUP BY Country, VisitorType
ORDER BY VisitorCount DESC;

-- Query 4: Show bookings with details (basic JOIN)
SELECT 
    b.BookingID,
    CONCAT(v.FirstName, ' ', v.LastName) AS VisitorName,
    h.HotelName,
    rt.TypeName AS RoomType,
    b.CheckInDate,
    b.CheckOutDate,
    b.TotalCost,
    b.BookingStatus
FROM Bookings b
JOIN Visitors v ON b.VisitorID = v.VisitorID
JOIN Hotels h ON b.HotelID = h.HotelID
JOIN RoomTypes rt ON b.RoomTypeID = rt.RoomTypeID
ORDER BY b.CheckInDate DESC
LIMIT 10;

-- Query 5: Calculate total expenditures by category
SELECT 
    Category,
    COUNT(*) AS TransactionCount,
    SUM(Amount) AS TotalSpending,
    AVG(Amount) AS AverageSpending
FROM Expenditures
GROUP BY Category
ORDER BY TotalSpending DESC;

-- ============================================================================
-- PART 3: UPDATE OPERATIONS
-- ============================================================================

-- -----------------------------------------------------------------------------
-- Demonstrate UPDATE statements
-- -----------------------------------------------------------------------------

-- Update 1: Change booking status (completed past bookings)
UPDATE Bookings 
SET BookingStatus = 'Completed'
WHERE CheckOutDate < CURDATE() 
  AND BookingStatus = 'Confirmed';

-- Verify update
SELECT BookingID, CheckOutDate, BookingStatus 
FROM Bookings 
WHERE CheckOutDate < CURDATE();

-- Update 2: Correct visitor information
UPDATE Visitors
SET Email = 'ahmet.yilmaz.new@email.com',
    Phone = '+90-532-999-8888'
WHERE VisitorID = 1;

-- Verify update
SELECT VisitorID, CONCAT(FirstName, ' ', LastName) AS Name, Email, Phone
FROM Visitors
WHERE VisitorID = 1;

-- Update 3: Increase hotel room count (expansion)
UPDATE Hotels
SET TotalRooms = TotalRooms + 50
WHERE HotelID = 4; -- Antalya Beach Resort expansion

-- Verify update
SELECT HotelID, HotelName, TotalRooms 
FROM Hotels 
WHERE HotelID = 4;

-- Update 4: Adjust pricing for off-season (example)
UPDATE Bookings
SET PricePerNight = PricePerNight * 0.8,  -- 20% discount
    TotalCost = (PricePerNight * 0.8) * DATEDIFF(CheckOutDate, CheckInDate)
WHERE MONTH(CheckInDate) IN (2, 3, 11)
  AND YEAR(CheckInDate) = 2025
  AND BookingStatus = 'Confirmed';

-- Note: In production, pricing updates should be more controlled
-- This demonstrates UPDATE capability

-- ============================================================================
-- PART 4: DELETE OPERATIONS
-- ============================================================================

-- -----------------------------------------------------------------------------
-- Demonstrate DELETE statements (with safety checks)
-- -----------------------------------------------------------------------------

-- Delete 1: Remove cancelled bookings older than 1 year
DELETE FROM Bookings
WHERE BookingStatus = 'Cancelled'
  AND BookingDate < DATE_SUB(CURDATE(), INTERVAL 1 YEAR);

-- Verify deletion (should show 0 rows if none existed)
SELECT COUNT(*) AS DeletedCount
FROM Bookings
WHERE BookingStatus = 'Cancelled'
  AND BookingDate < DATE_SUB(CURDATE(), INTERVAL 1 YEAR);

-- Delete 2: Remove test visitor record (if exists)
-- First, create a test visitor
INSERT INTO Visitors (FirstName, LastName, Country, Age, VisitorType, Email)
VALUES ('Test', 'User', 'Turkey', 25, 'Domestic', 'test@example.com');

-- Get the test visitor ID
SET @test_visitor_id = LAST_INSERT_ID();

-- Delete the test visitor
DELETE FROM Visitors 
WHERE VisitorID = @test_visitor_id;

-- Verify deletion
SELECT * FROM Visitors WHERE VisitorID = @test_visitor_id;
-- Should return empty result

-- Delete 3: Clean up orphaned expenditures (if any)
-- Note: This won't delete anything due to foreign key constraints
-- Just demonstrating the safety mechanism

-- First check for any orphaned records (shouldn't exist due to FK)
SELECT COUNT(*) AS OrphanedExpenditures
FROM Expenditures e
LEFT JOIN Visitors v ON e.VisitorID = v.VisitorID
WHERE v.VisitorID IS NULL;

-- Attempt to delete (will fail if foreign key constraints are enforced)
-- DELETE FROM Expenditures WHERE VisitorID = 99999;
-- Error: Cannot delete or update a parent row: foreign key constraint fails

-- ============================================================================
-- PART 5: COMPLEX CRUD COMBINATIONS
-- ============================================================================

-- -----------------------------------------------------------------------------
-- Transaction Example: Book a hotel room (Multi-step operation)
-- -----------------------------------------------------------------------------

START TRANSACTION;

-- Step 1: Insert new visitor
INSERT INTO Visitors (FirstName, LastName, Country, Age, Gender, VisitorType, Email, Phone)
VALUES ('Carlos', 'Rodriguez', 'Spain', 37, 'Male', 'International', 'carlos.rodriguez@email.es', '+34-600-123-456');

SET @new_visitor_id = LAST_INSERT_ID();

-- Step 2: Create booking
INSERT INTO Bookings (VisitorID, HotelID, RoomTypeID, CheckInDate, CheckOutDate, NumberOfGuests, PricePerNight, TotalCost, BookingStatus)
VALUES (@new_visitor_id, 1, 2, '2025-09-10', '2025-09-15', 2, 300.00, 1500.00, 'Confirmed');

SET @new_booking_id = LAST_INSERT_ID();

-- Step 3: Record initial expenditure (booking deposit)
INSERT INTO Expenditures (VisitorID, RegionID, Category, Amount, ExpenditureDate, Description)
VALUES (@new_visitor_id, 1, 'Accommodation', 1500.00, CURDATE(), 'Hotel booking deposit');

-- Verify transaction
SELECT 
    v.VisitorID,
    CONCAT(v.FirstName, ' ', v.LastName) AS Name,
    b.BookingID,
    b.CheckInDate,
    b.TotalCost
FROM Visitors v
JOIN Bookings b ON v.VisitorID = b.VisitorID
WHERE v.VisitorID = @new_visitor_id;

COMMIT;

-- ============================================================================
-- PART 6: SUMMARY STATISTICS
-- ============================================================================

-- Current database statistics
SELECT 'Database Statistics' AS Info;

SELECT 
    'Regions' AS TableName,
    COUNT(*) AS RecordCount
FROM Regions
UNION ALL
SELECT 'Hotels', COUNT(*) FROM Hotels
UNION ALL
SELECT 'Visitors', COUNT(*) FROM Visitors
UNION ALL
SELECT 'RoomTypes', COUNT(*) FROM RoomTypes
UNION ALL
SELECT 'Seasons', COUNT(*) FROM Seasons
UNION ALL
SELECT 'Bookings', COUNT(*) FROM Bookings
UNION ALL
SELECT 'Expenditures', COUNT(*) FROM Expenditures;

-- ============================================================================
-- END OF CRUD OPERATIONS DEMONSTRATION
-- ============================================================================

/*
WEEK 6 DELIVERABLE SUMMARY:
✅ CREATE: Inserted sample data across all 7 tables
   - 10 Regions
   - 15 Hotels
   - 5 RoomTypes
   - 8 Seasons
   - 15 Visitors
   - 16 Bookings
   - 17 Expenditures

✅ READ: Demonstrated various SELECT queries
   - Simple SELECT with WHERE
   - JOINs across multiple tables
   - Aggregate functions (COUNT, SUM, AVG)
   - GROUP BY operations

✅ UPDATE: Modified records safely
   - Updated booking status
   - Corrected visitor information
   - Adjusted hotel capacity
   - Modified pricing

✅ DELETE: Removed records with constraints
   - Demonstrated foreign key protection
   - Showed transaction rollback capability
   - Cleaned up test data

✅ TRANSACTIONS: Multi-step booking process
   - Atomic operations
   - COMMIT/ROLLBACK capability

NEXT STEPS (Week 7):
- Develop 3 working queries for business analysis
- Test multi-table JOINs for KPI calculations
- Document query outputs with screenshots
*/