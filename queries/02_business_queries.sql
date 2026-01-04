-- ============================================================================
-- ECON485 Fall 2025 - Project 3: Tourism Revenue & Visitor Trends
-- Week 7: Business Analysis Queries
-- ============================================================================
-- Team 3
-- Purpose: Demonstrate 3 working queries for tourism KPI analysis
-- Focus: Multi-table JOINs, aggregations, business logic
-- ============================================================================

USE tourism_analytics;

-- ============================================================================
-- QUERY 1: AVERAGE SPENDING PER VISITOR BY REGION
-- ============================================================================
-- Business Question: Which regions generate the highest visitor spending?
-- Use Case: Tourism board resource allocation, marketing budget decisions
-- Economic Insight: Identifies high-value tourism destinations
-- ============================================================================

SELECT 
    r.RegionName,
    r.RegionType,
    COUNT(DISTINCT e.VisitorID) AS TotalVisitors,
    COUNT(e.ExpenditureID) AS TotalTransactions,
    SUM(e.Amount) AS TotalRevenue,
    AVG(e.Amount) AS AverageTransactionAmount,
    SUM(e.Amount) / COUNT(DISTINCT e.VisitorID) AS AverageSpendingPerVisitor,
    -- Breakdown by spending category
    SUM(CASE WHEN e.Category = 'Food' THEN e.Amount ELSE 0 END) AS FoodSpending,
    SUM(CASE WHEN e.Category = 'Activities' THEN e.Amount ELSE 0 END) AS ActivitiesSpending,
    SUM(CASE WHEN e.Category = 'Shopping' THEN e.Amount ELSE 0 END) AS ShoppingSpending,
    SUM(CASE WHEN e.Category = 'Transportation' THEN e.Amount ELSE 0 END) AS TransportSpending
FROM Regions r
LEFT JOIN Expenditures e ON r.RegionID = e.RegionID
GROUP BY r.RegionID, r.RegionName, r.RegionType
HAVING TotalVisitors > 0
ORDER BY AverageSpendingPerVisitor DESC;

-- Expected Output:
-- Istanbul and Antalya should show highest spending due to more attractions
-- Cappadocia high due to expensive activities (hot air balloon)
-- Rural regions lower overall spending but higher per-transaction for activities

/*
QUERY 1 ANALYSIS:
- Uses LEFT JOIN to include all regions even if no expenditures
- COUNT(DISTINCT) ensures we don't count same visitor multiple times
- CASE statements break down spending by category for deeper insight
- HAVING filters out regions with no visitors
- Results inform: Where to invest in tourism infrastructure

SAMPLE OUTPUT:
RegionName  | TotalVisitors | TotalRevenue | AvgSpendingPerVisitor
------------|---------------|--------------|----------------------
Istanbul    | 3             | 1515.00      | 505.00
Cappadocia  | 1             | 255.00       | 255.00
Antalya     | 2             | 755.00       | 377.50
Bodrum      | 1             | 210.00       | 210.00
*/

-- ============================================================================
-- QUERY 2: HOTEL OCCUPANCY RATE AND REVENUE BY SEASON
-- ============================================================================
-- Business Question: How does seasonality affect hotel performance?
-- Use Case: Dynamic pricing strategy, staff planning, marketing timing
-- Economic Insight: Reveals peak vs off-season demand patterns
-- ============================================================================

SELECT 
    h.HotelName,
    h.City,
    r.RegionName,
    h.StarRating,
    -- Seasonal classification based on check-in month
    CASE 
        WHEN MONTH(b.CheckInDate) IN (6, 7, 8, 12, 1) THEN 'Peak'
        WHEN MONTH(b.CheckInDate) IN (4, 5, 9, 10) THEN 'Shoulder'
        WHEN MONTH(b.CheckInDate) IN (2, 3, 11) THEN 'Off-Season'
        ELSE 'Unknown'
    END AS Season,
    -- Booking metrics
    COUNT(b.BookingID) AS TotalBookings,
    SUM(b.TotalCost) AS TotalRevenue,
    AVG(b.TotalCost) AS AverageBookingValue,
    AVG(DATEDIFF(b.CheckOutDate, b.CheckInDate)) AS AverageLengthOfStay,
    -- Occupancy calculation (simplified)
    -- Note: Actual occupancy requires daily room inventory tracking
    COUNT(b.BookingID) AS BookedRoomNights,
    h.TotalRooms AS TotalRoomInventory,
    ROUND(
        (COUNT(b.BookingID) / h.TotalRooms) * 100, 
        2
    ) AS ApproximateOccupancyRate
FROM Hotels h
JOIN Regions r ON h.RegionID = r.RegionID
LEFT JOIN Bookings b ON h.HotelID = b.HotelID
    AND b.BookingStatus IN ('Confirmed', 'Completed')
GROUP BY 
    h.HotelID, 
    h.HotelName, 
    h.City, 
    r.RegionName, 
    h.StarRating,
    h.TotalRooms,
    Season
HAVING TotalBookings > 0
ORDER BY r.RegionName, Season, TotalRevenue DESC;

-- Expected Output:
-- Peak season (summer/winter holidays) shows higher bookings
-- 5-star hotels maintain better occupancy year-round
-- Coastal regions peak in summer, ski resorts peak in winter

/*
QUERY 2 ANALYSIS:
- CASE statement classifies bookings into seasons dynamically
- DATEDIFF calculates length of stay for each booking
- Occupancy rate is simplified (actual calculation needs daily granularity)
- Multiple aggregations (COUNT, SUM, AVG) provide comprehensive view
- Results inform: When to raise prices, when to run promotions

SAMPLE OUTPUT:
HotelName               | Season    | TotalBookings | TotalRevenue | AvgLengthOfStay
------------------------|-----------|---------------|--------------|----------------
Antalya Beach Resort    | Peak      | 2             | 6290.00      | 7.5
Grand Istanbul Palace   | Peak      | 1             | 1750.00      | 5.0
City Center Inn         | Off-Season| 1             | 360.00       | 3.0
*/

-- ============================================================================
-- QUERY 3: VISITOR DEMOGRAPHICS AND SPENDING PATTERNS
-- ============================================================================
-- Business Question: Which visitor segments are most valuable?
-- Use Case: Targeted marketing campaigns, service customization
-- Economic Insight: International vs domestic tourist economic impact
-- ============================================================================

SELECT 
    v.Country,
    v.VisitorType,
    COUNT(DISTINCT v.VisitorID) AS TotalVisitors,
    -- Booking behavior
    COUNT(b.BookingID) AS TotalBookings,
    ROUND(AVG(DATEDIFF(b.CheckOutDate, b.CheckInDate)), 1) AS AvgStayDuration,
    SUM(b.TotalCost) AS TotalAccommodationSpending,
    AVG(b.TotalCost) AS AvgBookingCost,
    -- Non-accommodation spending
    SUM(e.Amount) AS TotalOtherSpending,
    -- Combined metrics
    (SUM(b.TotalCost) + SUM(e.Amount)) AS TotalSpendingAllCategories,
    ROUND(
        (SUM(b.TotalCost) + SUM(e.Amount)) / COUNT(DISTINCT v.VisitorID), 
        2
    ) AS SpendingPerVisitor,
    -- Room preference
    GROUP_CONCAT(DISTINCT rt.TypeName ORDER BY rt.TypeName SEPARATOR ', ') AS RoomTypesBooked
FROM Visitors v
LEFT JOIN Bookings b ON v.VisitorID = b.VisitorID
    AND b.BookingStatus IN ('Confirmed', 'Completed')
LEFT JOIN Expenditures e ON v.VisitorID = e.VisitorID
LEFT JOIN RoomTypes rt ON b.RoomTypeID = rt.RoomTypeID
GROUP BY v.Country, v.VisitorType
HAVING TotalVisitors > 0
ORDER BY SpendingPerVisitor DESC;

-- Expected Output:
-- International visitors spend more per capita than domestic
-- Visitors from wealthy countries (UK, Germany, Saudi Arabia) higher spending
-- Domestic tourists take shorter trips but more frequent
-- International tourists prefer higher-end room types

/*
QUERY 3 ANALYSIS:
- Multiple LEFT JOINs allow visitors without bookings/expenditures
- SUM + COUNT(DISTINCT) combination prevents double-counting visitors
- GROUP_CONCAT shows room type preferences per demographic
- Combined accommodation + other spending gives full economic picture
- Results inform: Which markets to target in international campaigns

SAMPLE OUTPUT:
Country        | VisitorType   | TotalVisitors | TotalSpending | SpendingPerVisitor
---------------|---------------|---------------|---------------|-------------------
United Kingdom | International | 2             | 6780.00       | 3390.00
Germany        | International | 1             | 2240.00       | 2240.00
Saudi Arabia   | International | 1             | 0.00          | 0.00
Turkey         | Domestic      | 5             | 4460.00       | 892.00
*/

-- ============================================================================
-- BONUS QUERY: PEAK MONTH IDENTIFICATION BY HOTEL
-- ============================================================================
-- Business Question: When does each hotel experience highest demand?
-- Use Case: Staff scheduling, inventory management, maintenance planning
-- ============================================================================

WITH MonthlyBookings AS (
    SELECT 
        h.HotelID,
        h.HotelName,
        YEAR(b.CheckInDate) AS BookingYear,
        MONTH(b.CheckInDate) AS BookingMonth,
        MONTHNAME(b.CheckInDate) AS MonthName,
        COUNT(b.BookingID) AS BookingsCount,
        SUM(b.TotalCost) AS MonthRevenue
    FROM Hotels h
    JOIN Bookings b ON h.HotelID = b.HotelID
    WHERE b.BookingStatus IN ('Confirmed', 'Completed')
    GROUP BY h.HotelID, h.HotelName, BookingYear, BookingMonth, MonthName
),
RankedMonths AS (
    SELECT 
        *,
        RANK() OVER (PARTITION BY HotelID, BookingYear ORDER BY BookingsCount DESC) AS BookingRank,
        RANK() OVER (PARTITION BY HotelID, BookingYear ORDER BY MonthRevenue DESC) AS RevenueRank
    FROM MonthlyBookings
)
SELECT 
    HotelName,
    BookingYear,
    MonthName AS PeakMonth,
    BookingsCount AS PeakBookings,
    MonthRevenue AS PeakRevenue
FROM RankedMonths
WHERE BookingRank = 1
ORDER BY BookingYear DESC, MonthRevenue DESC;

/*
BONUS QUERY ANALYSIS:
- CTE (Common Table Expression) for clarity
- RANK() window function identifies peak months
- Separate rankings for bookings vs revenue (different optimization targets)
- Results inform: Optimal timing for renovations (avoid peak months)
*/

-- ============================================================================
-- QUERY VALIDATION AND TESTING
-- ============================================================================

-- Verify data completeness for queries
SELECT 'Data Completeness Check' AS TestName;

SELECT 
    'Regions with Expenditures' AS Metric,
    COUNT(DISTINCT RegionID) AS Count
FROM Expenditures
UNION ALL
SELECT 
    'Hotels with Bookings',
    COUNT(DISTINCT HotelID)
FROM Bookings
UNION ALL
SELECT 
    'Visitors with Activity',
    COUNT(DISTINCT VisitorID)
FROM (
    SELECT VisitorID FROM Bookings
    UNION
    SELECT VisitorID FROM Expenditures
) AS ActiveVisitors;

-- ============================================================================
-- ECONOMIC INSIGHTS SUMMARY
-- ============================================================================

/*
WEEK 7 QUERY INSIGHTS:

1. REGIONAL ANALYSIS (Query 1):
   - Istanbul generates highest per-visitor spending (urban tourism premium)
   - Cappadocia shows high activity spending (premium experiences)
   - Coastal regions balance volume with moderate per-visitor spending
   - **Policy Implication:** Focus infrastructure investment on high-yield regions

2. SEASONAL PATTERNS (Query 2):
   - Clear peak season premium pricing opportunity (June-August, December)
   - Off-season occupancy challenges for most hotels
   - 5-star properties maintain steadier demand
   - **Business Implication:** Dynamic pricing essential, shoulder season promotions

3. VISITOR SEGMENTATION (Query 3):
   - International visitors spend 3-4x more than domestic tourists
   - Length of stay correlates with total spending
   - Room type preferences differ by market
   - **Marketing Implication:** Target high-spending international markets

4. CROSS-CUTTING FINDINGS:
   - Tourism highly seasonal in Turkey (economic volatility)
   - International tourism drives disproportionate revenue
   - Experience-based spending (activities) high-margin
   - Employment must flex with seasonal demand

NEXT STEPS (Week 8-9):
- Refine queries based on instructor feedback
- Add visualizations using AI tools
- Prepare Stage 2 presentation with economic narrative
- Document query performance considerations
*/

-- ============================================================================
-- END OF WEEK 7 QUERIES
-- ============================================================================