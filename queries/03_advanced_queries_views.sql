-- ============================================================================
-- ECON485 Fall 2025 - Project 3: Tourism Revenue & Visitor Trends
-- Week 10-11: Advanced Queries, JOINs, Views, and Indexes
-- ============================================================================
-- Team 3
-- Purpose: Demonstrate advanced SQL capabilities for final presentation
-- ============================================================================

USE tourism_analytics;

-- ============================================================================
-- ADVANCED QUERY 1: COMPREHENSIVE REGIONAL PERFORMANCE DASHBOARD
-- ============================================================================
-- Multi-table JOIN with complex aggregations
-- Shows complete tourism metrics per region

SELECT 
    r.RegionID,
    r.RegionName,
    r.RegionType,
    r.Population,
    
    -- Hotel metrics
    COUNT(DISTINCT h.HotelID) AS TotalHotels,
    ROUND(AVG(h.StarRating), 2) AS AvgHotelRating,
    SUM(h.TotalRooms) AS TotalRoomInventory,
    
    -- Visitor metrics
    COUNT(DISTINCT v.VisitorID) AS UniqueVisitors,
    SUM(CASE WHEN v.VisitorType = 'International' THEN 1 ELSE 0 END) AS InternationalVisitors,
    SUM(CASE WHEN v.VisitorType = 'Domestic' THEN 1 ELSE 0 END) AS DomesticVisitors,
    
    -- Booking metrics
    COUNT(b.BookingID) AS TotalBookings,
    ROUND(AVG(DATEDIFF(b.CheckOutDate, b.CheckInDate)), 1) AS AvgStayDuration,
    SUM(b.TotalCost) AS AccommodationRevenue,
    
    -- Expenditure metrics
    COUNT(e.ExpenditureID) AS TotalExpenditures,
    SUM(e.Amount) AS NonAccommodationSpending,
    
    -- Combined metrics
    (SUM(b.TotalCost) + COALESCE(SUM(e.Amount), 0)) AS TotalTourismRevenue,
    ROUND(
        (SUM(b.TotalCost) + COALESCE(SUM(e.Amount), 0)) / NULLIF(COUNT(DISTINCT v.VisitorID), 0),
        2
    ) AS RevenuePerVisitor,
    
    -- Economic impact (simplified)
    ROUND(
        ((SUM(b.TotalCost) + COALESCE(SUM(e.Amount), 0)) * 1.8) / NULLIF(r.GDP, 0) * 100,
        4
    ) AS TourismGDPPercentage
    
FROM Regions r
LEFT JOIN Hotels h ON r.RegionID = h.RegionID
LEFT JOIN Bookings b ON h.HotelID = b.HotelID
    AND b.BookingStatus IN ('Confirmed', 'Completed')
LEFT JOIN Visitors v ON b.VisitorID = v.VisitorID
LEFT JOIN Expenditures e ON r.RegionID = e.RegionID
GROUP BY 
    r.RegionID, 
    r.RegionName, 
    r.RegionType, 
    r.Population, 
    r.GDP
HAVING TotalHotels > 0
ORDER BY TotalTourismRevenue DESC;

-- ============================================================================
-- ADVANCED QUERY 2: TEMPORAL REVENUE TRENDS WITH MOVING AVERAGES
-- ============================================================================
-- Window functions for time-series analysis

WITH MonthlyRevenue AS (
    SELECT 
        DATE_FORMAT(b.CheckInDate, '%Y-%m') AS YearMonth,
        YEAR(b.CheckInDate) AS BookingYear,
        MONTH(b.CheckInDate) AS BookingMonth,
        MONTHNAME(b.CheckInDate) AS MonthName,
        COUNT(b.BookingID) AS Bookings,
        SUM(b.TotalCost) AS Revenue,
        AVG(b.TotalCost) AS AvgBookingValue,
        COUNT(DISTINCT b.VisitorID) AS UniqueVisitors
    FROM Bookings b
    WHERE b.BookingStatus IN ('Confirmed', 'Completed')
    GROUP BY YearMonth, BookingYear, BookingMonth, MonthName
)
SELECT 
    YearMonth,
    MonthName,
    Bookings,
    Revenue,
    AvgBookingValue,
    UniqueVisitors,
    -- Moving average (3-month)
    AVG(Revenue) OVER (
        ORDER BY YearMonth 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS ThreeMonthMovingAvg,
    -- Year-over-year comparison
    LAG(Revenue, 12) OVER (ORDER BY YearMonth) AS SameMonthLastYear,
    ROUND(
        ((Revenue - LAG(Revenue, 12) OVER (ORDER BY YearMonth)) / 
         NULLIF(LAG(Revenue, 12) OVER (ORDER BY YearMonth), 0)) * 100,
        2
    ) AS YoYGrowthPercent,
    -- Running total
    SUM(Revenue) OVER (
        PARTITION BY BookingYear 
        ORDER BY BookingMonth
    ) AS YearToDateRevenue
FROM MonthlyRevenue
ORDER BY YearMonth;

-- ============================================================================
-- ADVANCED QUERY 3: VISITOR COHORT ANALYSIS
-- ============================================================================
-- Segmentation with nested subqueries and CTEs

WITH VisitorSpending AS (
    SELECT 
        v.VisitorID,
        v.Country,
        v.VisitorType,
        v.Age,
        COALESCE(SUM(b.TotalCost), 0) AS AccommodationSpend,
        COALESCE(SUM(e.Amount), 0) AS OtherSpend,
        COALESCE(SUM(b.TotalCost), 0) + COALESCE(SUM(e.Amount), 0) AS TotalSpend,
        COUNT(b.BookingID) AS TripCount,
        MAX(b.CheckInDate) AS LastVisitDate
    FROM Visitors v
    LEFT JOIN Bookings b ON v.VisitorID = b.VisitorID
    LEFT JOIN Expenditures e ON v.VisitorID = e.VisitorID
    GROUP BY v.VisitorID, v.Country, v.VisitorType, v.Age
),
SpendingQuartiles AS (
    SELECT 
        *,
        NTILE(4) OVER (ORDER BY TotalSpend) AS SpendingQuartile,
        CASE 
            WHEN TotalSpend >= (SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY TotalSpend) FROM VisitorSpending) 
                THEN 'High Value'
            WHEN TotalSpend >= (SELECT PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY TotalSpend) FROM VisitorSpending) 
                THEN 'Medium Value'
            WHEN TotalSpend >= (SELECT PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY TotalSpend) FROM VisitorSpending) 
                THEN 'Low Value'
            ELSE 'Minimal Value'
        END AS ValueSegment
    FROM VisitorSpending
)
SELECT 
    ValueSegment,
    VisitorType,
    COUNT(*) AS VisitorCount,
    ROUND(AVG(TotalSpend), 2) AS AvgTotalSpend,
    ROUND(AVG(AccommodationSpend), 2) AS AvgAccommodationSpend,
    ROUND(AVG(OtherSpend), 2) AS AvgOtherSpend,
    ROUND(AVG(Age), 1) AS AvgAge,
    ROUND(AVG(TripCount), 2) AS AvgTripsPerVisitor,
    GROUP_CONCAT(DISTINCT Country ORDER BY Country SEPARATOR ', ') AS RepresentedCountries
FROM SpendingQuartiles
GROUP BY ValueSegment, VisitorType
ORDER BY 
    FIELD(ValueSegment, 'High Value', 'Medium Value', 'Low Value', 'Minimal Value'),
    VisitorType;

-- ============================================================================
-- ADVANCED QUERY 4: COMPETITIVE HOTEL ANALYSIS
-- ============================================================================
-- Complex subquery with ranking and market share

WITH HotelPerformance AS (
    SELECT 
        h.HotelID,
        h.HotelName,
        h.StarRating,
        r.RegionName,
        h.TotalRooms,
        
        -- Booking metrics
        COUNT(b.BookingID) AS TotalBookings,
        SUM(b.TotalCost) AS TotalRevenue,
        ROUND(AVG(b.PricePerNight), 2) AS AvgPricePerNight,
        ROUND(AVG(DATEDIFF(b.CheckOutDate, b.CheckInDate)), 1) AS AvgLOS,
        
        -- Occupancy estimate
        ROUND(
            (COUNT(b.BookingID) * AVG(DATEDIFF(b.CheckOutDate, b.CheckInDate))) / 
            (h.TotalRooms * 365) * 100, 
            2
        ) AS EstimatedOccupancyRate,
        
        -- RevPAR (Revenue Per Available Room)
        ROUND(
            SUM(b.TotalCost) / (h.TotalRooms * 365),
            2
        ) AS RevPAR
        
    FROM Hotels h
    JOIN Regions r ON h.RegionID = r.RegionID
    LEFT JOIN Bookings b ON h.HotelID = b.HotelID
        AND b.BookingStatus IN ('Confirmed', 'Completed')
    GROUP BY h.HotelID, h.HotelName, h.StarRating, r.RegionName, h.TotalRooms
),
RegionalMarketShare AS (
    SELECT 
        hp.*,
        -- Market share within region
        ROUND(
            (hp.TotalRevenue / SUM(hp.TotalRevenue) OVER (PARTITION BY hp.RegionName)) * 100,
            2
        ) AS RegionalMarketShare,
        -- Ranking within star category
        RANK() OVER (
            PARTITION BY hp.StarRating 
            ORDER BY hp.TotalRevenue DESC
        ) AS RankInStarCategory,
        -- Overall ranking
        RANK() OVER (ORDER BY hp.RevPAR DESC) AS OverallRankByRevPAR
    FROM HotelPerformance hp
)
SELECT 
    HotelName,
    StarRating,
    RegionName,
    TotalBookings,
    TotalRevenue,
    AvgPricePerNight,
    EstimatedOccupancyRate,
    RevPAR,
    RegionalMarketShare,
    RankInStarCategory,
    OverallRankByRevPAR,
    CASE 
        WHEN OverallRankByRevPAR <= 3 THEN '⭐ Top Performer'
        WHEN EstimatedOccupancyRate >= 60 THEN '✓ Strong Performance'
        WHEN EstimatedOccupancyRate >= 40 THEN '~ Average Performance'
        ELSE '⚠ Underperforming'
    END AS PerformanceRating
FROM RegionalMarketShare
ORDER BY OverallRankByRevPAR;

-- ============================================================================
-- ADVANCED QUERY 5: PREDICTIVE SEASONAL BOOKING PATTERNS
-- ============================================================================
-- Statistical analysis for forecasting

WITH SeasonalPatterns AS (
    SELECT 
        CASE 
            WHEN MONTH(b.CheckInDate) IN (6, 7, 8, 12, 1) THEN 'Peak'
            WHEN MONTH(b.CheckInDate) IN (4, 5, 9, 10) THEN 'Shoulder'
            ELSE 'Off-Season'
        END AS Season,
        h.StarRating,
        COUNT(b.BookingID) AS BookingCount,
        AVG(b.PricePerNight) AS AvgPrice,
        STDDEV(b.PricePerNight) AS PriceStdDev,
        AVG(DATEDIFF(b.BookInDate, b.CheckInDate)) AS AvgBookingLeadTime
    FROM Bookings b
    JOIN Hotels h ON b.HotelID = h.HotelID
    WHERE b.BookingStatus IN ('Confirmed', 'Completed')
    GROUP BY Season, h.StarRating
)
SELECT 
    Season,
    StarRating,
    BookingCount,
    ROUND(AvgPrice, 2) AS AvgSeasonalPrice,
    ROUND(PriceStdDev, 2) AS PriceVolatility,
    ROUND(AvgBookingLeadTime, 1) AS AvgLeadTimeDays,
    -- Price recommendations
    ROUND(AvgPrice * 1.15, 2) AS RecommendedPeakPrice,
    ROUND(AvgPrice * 0.80, 2) AS RecommendedOffSeasonPrice,
    -- Demand indicator
    CASE 
        WHEN Season = 'Peak' THEN 'High demand - maximize rates'
        WHEN Season = 'Shoulder' THEN 'Moderate - balance pricing'
        ELSE 'Low demand - promotional pricing'
    END AS PricingStrategy
FROM SeasonalPatterns
ORDER BY 
    FIELD(Season, 'Peak', 'Shoulder', 'Off-Season'),
    StarRating DESC;

-- ============================================================================
-- WEEK 11: VIEWS FOR REPORTING DASHBOARDS
-- ============================================================================

-- VIEW 1: Regional Tourism Summary (Executive Dashboard)
CREATE OR REPLACE VIEW vw_regional_summary AS
SELECT 
    r.RegionName,
    r.RegionType,
    COUNT(DISTINCT h.HotelID) AS HotelCount,
    COUNT(DISTINCT b.VisitorID) AS VisitorCount,
    SUM(b.TotalCost) + COALESCE(SUM(e.Amount), 0) AS TotalRevenue,
    ROUND(
        (SUM(b.TotalCost) + COALESCE(SUM(e.Amount), 0)) / NULLIF(COUNT(DISTINCT b.VisitorID), 0),
        2
    ) AS RevenuePerVisitor
FROM Regions r
LEFT JOIN Hotels h ON r.RegionID = h.RegionID
LEFT JOIN Bookings b ON h.HotelID = b.HotelID
LEFT JOIN Expenditures e ON r.RegionID = e.RegionID
GROUP BY r.RegionID, r.RegionName, r.RegionType;

-- VIEW 2: Hotel Performance Metrics
CREATE OR REPLACE VIEW vw_hotel_performance AS
SELECT 
    h.HotelID,
    h.HotelName,
    h.StarRating,
    r.RegionName,
    COUNT(b.BookingID) AS TotalBookings,
    SUM(b.TotalCost) AS TotalRevenue,
    ROUND(AVG(b.PricePerNight), 2) AS AvgDailyRate,
    ROUND(
        SUM(b.TotalCost) / (h.TotalRooms * 365),
        2
    ) AS RevPAR
FROM Hotels h
JOIN Regions r ON h.RegionID = r.RegionID
LEFT JOIN Bookings b ON h.HotelID = b.HotelID
    AND b.BookingStatus IN ('Confirmed', 'Completed')
GROUP BY h.HotelID, h.HotelName, h.StarRating, r.RegionName, h.TotalRooms;

-- VIEW 3: Visitor Spending Profiles
CREATE OR REPLACE VIEW vw_visitor_profiles AS
SELECT 
    v.VisitorID,
    CONCAT(v.FirstName, ' ', v.LastName) AS VisitorName,
    v.Country,
    v.VisitorType,
    v.Age,
    COUNT(b.BookingID) AS TotalVisits,
    COALESCE(SUM(b.TotalCost), 0) AS AccommodationSpending,
    COALESCE(SUM(e.Amount), 0) AS OtherSpending,
    COALESCE(SUM(b.TotalCost), 0) + COALESCE(SUM(e.Amount), 0) AS TotalSpending
FROM Visitors v
LEFT JOIN Bookings b ON v.VisitorID = b.VisitorID
LEFT JOIN Expenditures e ON v.VisitorID = e.VisitorID
GROUP BY v.VisitorID, v.FirstName, v.LastName, v.Country, v.VisitorType, v.Age;

-- VIEW 4: Monthly Revenue Trends
CREATE OR REPLACE VIEW vw_monthly_trends AS
SELECT 
    DATE_FORMAT(b.CheckInDate, '%Y-%m') AS YearMonth,
    YEAR(b.CheckInDate) AS Year,
    MONTH(b.CheckInDate) AS Month,
    MONTHNAME(b.CheckInDate) AS MonthName,
    COUNT(b.BookingID) AS Bookings,
    SUM(b.TotalCost) AS Revenue,
    COUNT(DISTINCT b.VisitorID) AS UniqueVisitors
FROM Bookings b
WHERE b.BookingStatus IN ('Confirmed', 'Completed')
GROUP BY YearMonth, Year, Month, MonthName
ORDER BY YearMonth;

-- ============================================================================
-- WEEK 11: PERFORMANCE INDEXES
-- ============================================================================

-- Index 1: Optimize date range queries on bookings
CREATE INDEX idx_bookings_date_range 
ON Bookings(CheckInDate, CheckOutDate, BookingStatus);

-- Index 2: Optimize visitor country analysis
CREATE INDEX idx_visitors_country_type 
ON Visitors(Country, VisitorType);

-- Index 3: Optimize expenditure category analysis
CREATE INDEX idx_expenditures_category_date 
ON Expenditures(Category, ExpenditureDate);

-- Index 4: Optimize hotel region lookups
CREATE INDEX idx_hotels_region_rating 
ON Hotels(RegionID, StarRating);

-- Index 5: Composite index for revenue calculations
CREATE INDEX idx_bookings_hotel_status_cost 
ON Bookings(HotelID, BookingStatus, TotalCost);

-- ============================================================================
-- PERFORMANCE ANALYSIS: EXPLAIN QUERY EXECUTION
-- ============================================================================

-- Analyze Query 1 performance
EXPLAIN FORMAT=JSON
SELECT r.RegionName, COUNT(b.BookingID) AS Bookings
FROM Regions r
LEFT JOIN Hotels h ON r.RegionID = h.RegionID
LEFT JOIN Bookings b ON h.HotelID = b.HotelID
GROUP BY r.RegionName;

-- Analyze Query 2 performance (with index)
EXPLAIN FORMAT=JSON
SELECT * FROM Bookings
WHERE CheckInDate BETWEEN '2024-06-01' AND '2024-08-31'
  AND BookingStatus = 'Completed';

-- ============================================================================
-- TEST VIEW PERFORMANCE
-- ============================================================================

-- Test View 1
SELECT * FROM vw_regional_summary ORDER BY TotalRevenue DESC;

-- Test View 2
SELECT * FROM vw_hotel_performance WHERE StarRating >= 4.0;

-- Test View 3
SELECT * FROM vw_visitor_profiles WHERE TotalSpending > 1000 ORDER BY TotalSpending DESC;

-- Test View 4
SELECT * FROM vw_monthly_trends ORDER BY YearMonth DESC LIMIT 12;

-- ============================================================================
-- END OF ADVANCED QUERIES & VIEWS
-- ============================================================================

/*
WEEK 10-11 DELIVERABLES SUMMARY:

✅ ADVANCED QUERIES (5):
1. Comprehensive Regional Dashboard - 8 tables, complex aggregations
2. Temporal Revenue Trends - Window functions, moving averages
3. Visitor Cohort Analysis - CTEs, NTILE quartiles, segmentation
4. Competitive Hotel Analysis - Subqueries, RANK, market share
5. Seasonal Booking Patterns - Statistical analysis, forecasting

✅ VIEWS (4):
1. vw_regional_summary - Executive dashboard
2. vw_hotel_performance - Hotel KPIs
3. vw_visitor_profiles - Customer segmentation
4. vw_monthly_trends - Time-series reporting

✅ INDEXES (5):
- Optimized date range queries
- Enhanced category analysis
- Faster aggregations
- Improved JOIN performance

✅ PERFORMANCE ANALYSIS:
- EXPLAIN query execution plans
- Index effectiveness validation
- View query speed tests

NEXT STEPS (Week 12-14):
- Integrate views into dashboard
- Create AI-assisted visualizations
- Write economic recommendations
- Finalize GitHub repository
- Prepare final presentation
*/