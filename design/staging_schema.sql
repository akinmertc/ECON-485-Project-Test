-- ============================================================================
-- ECON485 Project - Staging Layer for CSV Integration
-- ============================================================================
-- Purpose:
--   Store aggregate/statistical data from external CSV files in isolated
--   staging tables, separate from transactional tables.
--
-- Usage:
--   mysql -u root -p tourism_analytics < design/staging_schema.sql
-- ============================================================================

USE tourism_analytics;

-- Disable FK checks during DDL to avoid dependency issues.
SET @old_fk_checks = @@FOREIGN_KEY_CHECKS;
SET FOREIGN_KEY_CHECKS = 0;

-- ============================================================================
-- STAGING TABLE 1: Provincial_Accommodation_Stats
-- Source: data/csv_2022_data.csv
-- ============================================================================

CREATE TABLE IF NOT EXISTS Provincial_Accommodation_Stats (
    StatID BIGINT AUTO_INCREMENT PRIMARY KEY,
    Province VARCHAR(100) NOT NULL,
    District VARCHAR(100) NOT NULL,
    RegionID INT NULL COMMENT 'Optional link to Regions.RegionID',

    ForeignArrivals BIGINT UNSIGNED NOT NULL DEFAULT 0,
    LocalArrivals BIGINT UNSIGNED NOT NULL DEFAULT 0,
    TotalArrivals BIGINT UNSIGNED NOT NULL DEFAULT 0,

    ForeignOvernights BIGINT UNSIGNED NOT NULL DEFAULT 0,
    LocalOvernights BIGINT UNSIGNED NOT NULL DEFAULT 0,
    TotalOvernights BIGINT UNSIGNED NOT NULL DEFAULT 0,

    AvgStayForeign DECIMAL(6,3) NULL,
    AvgStayLocal DECIMAL(6,3) NULL,
    AvgStayTotal DECIMAL(6,3) NULL,

    OccupancyForeign DECIMAL(6,3) NULL,
    OccupancyLocal DECIMAL(6,3) NULL,
    OccupancyTotal DECIMAL(6,3) NULL,

    DataYear SMALLINT NOT NULL DEFAULT 2022,
    CreatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_pas_province (Province),
    INDEX idx_pas_district (District),
    INDEX idx_pas_year (DataYear),
    INDEX idx_pas_region (RegionID),
    INDEX idx_pas_province_year (Province, DataYear),

    CONSTRAINT chk_pas_arrivals_nonneg CHECK (
        ForeignArrivals >= 0 AND LocalArrivals >= 0 AND TotalArrivals >= 0
    ),
    CONSTRAINT chk_pas_overnights_nonneg CHECK (
        ForeignOvernights >= 0 AND LocalOvernights >= 0 AND TotalOvernights >= 0
    ),
    CONSTRAINT chk_pas_avgstay_nonneg CHECK (
        (AvgStayForeign IS NULL OR AvgStayForeign >= 0) AND
        (AvgStayLocal IS NULL OR AvgStayLocal >= 0) AND
        (AvgStayTotal IS NULL OR AvgStayTotal >= 0)
    ),
    CONSTRAINT chk_pas_occupancy_range CHECK (
        (OccupancyForeign IS NULL OR (OccupancyForeign >= 0 AND OccupancyForeign <= 100)) AND
        (OccupancyLocal IS NULL OR (OccupancyLocal >= 0 AND OccupancyLocal <= 100)) AND
        (OccupancyTotal IS NULL OR (OccupancyTotal >= 0 AND OccupancyTotal <= 100))
    ),
    CONSTRAINT fk_pas_region FOREIGN KEY (RegionID)
        REFERENCES Regions(RegionID)
        ON DELETE SET NULL
        ON UPDATE CASCADE
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='Provincial accommodation statistics (staging)';

-- ============================================================================
-- STAGING TABLE 2: National_Tourism_Financials
-- Source: data/csv_income_and_expenses_data.csv
-- ============================================================================

CREATE TABLE IF NOT EXISTS National_Tourism_Financials (
    FinancialID BIGINT AUTO_INCREMENT PRIMARY KEY,
    Year SMALLINT NOT NULL,

    IncomingVisitors BIGINT UNSIGNED NULL,
    DepartingCitizens BIGINT UNSIGNED NULL,

    TourismIncomeThousandUSD DECIMAL(15,2) NULL,
    TransferPassengerIncomeThousandUSD DECIMAL(15,2) NULL,
    AvgExpenditureUSD DECIMAL(10,2) NULL,
    TourismExpenditureThousandUSD DECIMAL(15,2) NULL,
    CitizenExpenditureUSD DECIMAL(10,2) NULL,

    CreatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    UNIQUE KEY uk_ntf_year (Year),
    INDEX idx_ntf_year (Year),

    CONSTRAINT chk_ntf_year_range CHECK (Year BETWEEN 2000 AND 2100),
    CONSTRAINT chk_ntf_nonneg CHECK (
        (IncomingVisitors IS NULL OR IncomingVisitors >= 0) AND
        (DepartingCitizens IS NULL OR DepartingCitizens >= 0) AND
        (TourismIncomeThousandUSD IS NULL OR TourismIncomeThousandUSD >= 0) AND
        (TransferPassengerIncomeThousandUSD IS NULL OR TransferPassengerIncomeThousandUSD >= 0) AND
        (AvgExpenditureUSD IS NULL OR AvgExpenditureUSD >= 0) AND
        (TourismExpenditureThousandUSD IS NULL OR TourismExpenditureThousandUSD >= 0) AND
        (CitizenExpenditureUSD IS NULL OR CitizenExpenditureUSD >= 0)
    )
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='National tourism financial time series (staging)';

-- ============================================================================
-- STAGING TABLE 3: Age_Group_Travel_Statistics
-- Source: data/csv_Number_of_trips_and_nights_by_age_group_of_travelers_data.csv
-- ============================================================================

CREATE TABLE IF NOT EXISTS Age_Group_Travel_Statistics (
    StatID BIGINT AUTO_INCREMENT PRIMARY KEY,
    Year SMALLINT NOT NULL,
    Quarter TINYINT NOT NULL DEFAULT 3 COMMENT '1-4; Q3 in source data',

    AgeGroup ENUM('0-14','15-24','25-44','45-64','65+','Total') NOT NULL,
    NumberOfTripsThousand DECIMAL(12,3) NULL,
    NumberOfOvernightsThousand DECIMAL(12,3) NULL,
    AvgOvernights DECIMAL(8,3) NULL,

    CreatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    UNIQUE KEY uk_age_year_q (Year, Quarter, AgeGroup),
    INDEX idx_age_year (Year),
    INDEX idx_age_group (AgeGroup),

    CONSTRAINT chk_age_year_range CHECK (Year BETWEEN 2000 AND 2100),
    CONSTRAINT chk_age_quarter_range CHECK (Quarter BETWEEN 1 AND 4),
    CONSTRAINT chk_age_nonneg CHECK (
        (NumberOfTripsThousand IS NULL OR NumberOfTripsThousand >= 0) AND
        (NumberOfOvernightsThousand IS NULL OR NumberOfOvernightsThousand >= 0) AND
        (AvgOvernights IS NULL OR AvgOvernights >= 0)
    )
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='Age group travel statistics (staging)';

-- ============================================================================
-- VIEW: Provincial summary for reporting
-- ============================================================================

DROP VIEW IF EXISTS vw_provincial_summary;
CREATE VIEW vw_provincial_summary AS
SELECT
    Province,
    DataYear,
    COUNT(DISTINCT District) AS DistrictCount,
    SUM(TotalArrivals) AS TotalArrivals,
    SUM(TotalOvernights) AS TotalOvernights,
    ROUND(
        SUM(TotalOvernights) / NULLIF(SUM(TotalArrivals), 0),
        3
    ) AS AvgStayWeighted,
    ROUND(
        SUM(
            CASE
                WHEN OccupancyTotal IS NULL THEN 0
                ELSE OccupancyTotal * TotalOvernights
            END
        ) / NULLIF(SUM(CASE WHEN OccupancyTotal IS NULL THEN 0 ELSE TotalOvernights END), 0),
        3
    ) AS OccupancyWeighted,
    ROUND(
        SUM(ForeignArrivals) / NULLIF(SUM(TotalArrivals), 0) * 100,
        2
    ) AS ForeignArrivalsPct
FROM Provincial_Accommodation_Stats
GROUP BY Province, DataYear;

-- ============================================================================
-- VIEW: Reconciliation between staging and transactional data
-- Note: join relies on Province matching Regions.RegionName
-- ============================================================================

DROP VIEW IF EXISTS vw_reconciliation_provincial_bookings;
CREATE VIEW vw_reconciliation_provincial_bookings AS
SELECT
    s.Province,
    s.DataYear,
    s.TotalArrivals AS StagingTotalArrivals,
    s.TotalOvernights AS StagingTotalOvernights,
    t.BookingCount AS TransactionalBookings,
    t.OvernightNights AS TransactionalOvernights,
    (t.BookingCount - s.TotalArrivals) AS ArrivalDiff,
    (t.OvernightNights - s.TotalOvernights) AS OvernightDiff,
    ROUND(
        t.BookingCount / NULLIF(s.TotalArrivals, 0) * 100,
        2
    ) AS BookingCoveragePct
FROM (
    SELECT
        Province,
        DataYear,
        SUM(TotalArrivals) AS TotalArrivals,
        SUM(TotalOvernights) AS TotalOvernights
    FROM Provincial_Accommodation_Stats
    GROUP BY Province, DataYear
) s
LEFT JOIN (
    SELECT
        r.RegionName AS Province,
        YEAR(b.CheckInDate) AS DataYear,
        COUNT(*) AS BookingCount,
        SUM(DATEDIFF(b.CheckOutDate, b.CheckInDate)) AS OvernightNights
    FROM Regions r
    JOIN Hotels h ON h.RegionID = r.RegionID
    JOIN Bookings b ON b.HotelID = h.HotelID
    GROUP BY r.RegionName, YEAR(b.CheckInDate)
) t
    ON t.Province = s.Province AND t.DataYear = s.DataYear;

-- ============================================================================
-- LOAD DATA INFILE templates (adjust paths and IGNORE rows as needed)
-- ============================================================================

/*
LOAD DATA LOCAL INFILE 'data/csv_2022_data.csv'
INTO TABLE Provincial_Accommodation_Stats
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 2 ROWS
(@Province, @District,
 @ForeignArrivals, @LocalArrivals, @TotalArrivals,
 @ForeignOvernights, @LocalOvernights, @TotalOvernights,
 @AvgStayForeign, @AvgStayLocal, @AvgStayTotal,
 @OccupancyForeign, @OccupancyLocal, @OccupancyTotal)
SET
    Province = NULLIF(@Province, ''),
    District = NULLIF(@District, ''),
    ForeignArrivals = NULLIF(@ForeignArrivals, '-'),
    LocalArrivals = NULLIF(@LocalArrivals, '-'),
    TotalArrivals = NULLIF(@TotalArrivals, '-'),
    ForeignOvernights = NULLIF(@ForeignOvernights, '-'),
    LocalOvernights = NULLIF(@LocalOvernights, '-'),
    TotalOvernights = NULLIF(@TotalOvernights, '-'),
    AvgStayForeign = NULLIF(@AvgStayForeign, '-'),
    AvgStayLocal = NULLIF(@AvgStayLocal, '-'),
    AvgStayTotal = NULLIF(@AvgStayTotal, '-'),
    OccupancyForeign = NULLIF(@OccupancyForeign, '-'),
    OccupancyLocal = NULLIF(@OccupancyLocal, '-'),
    OccupancyTotal = NULLIF(@OccupancyTotal, '-');
*/

/*
LOAD DATA LOCAL INFILE 'data/csv_income_and_expenses_data.csv'
INTO TABLE National_Tourism_Financials
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 8 ROWS
(@Year, @IncomingVisitors, @DepartingCitizens,
 @TourismIncome, @TransferPassengerIncome, @AvgExpenditure,
 @TourismExpenditure, @CitizenExpenditure)
SET
    Year = NULLIF(@Year, ''),
    IncomingVisitors = NULLIF(REPLACE(@IncomingVisitors, ' ', ''), ''),
    DepartingCitizens = NULLIF(REPLACE(@DepartingCitizens, ' ', ''), ''),
    TourismIncomeThousandUSD = NULLIF(@TourismIncome, '-'),
    TransferPassengerIncomeThousandUSD = NULLIF(@TransferPassengerIncome, '-'),
    AvgExpenditureUSD = NULLIF(@AvgExpenditure, '-'),
    TourismExpenditureThousandUSD = NULLIF(@TourismExpenditure, '-'),
    CitizenExpenditureUSD = NULLIF(@CitizenExpenditure, '-');
*/

/*
LOAD DATA LOCAL INFILE 'data/csv_Number_of_trips_and_nights_by_age_group_of_travelers_data.csv'
INTO TABLE Age_Group_Travel_Statistics
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 5 ROWS
(@AgeGroup,
 @Trips2017, @Overnights2017, @Avg2017,
 @Trips2018, @Overnights2018, @Avg2018)
SET
    Year = 2017,
    Quarter = 3,
    AgeGroup = @AgeGroup,
    NumberOfTripsThousand = NULLIF(@Trips2017, '-'),
    NumberOfOvernightsThousand = NULLIF(@Overnights2017, '-'),
    AvgOvernights = NULLIF(@Avg2017, '-');

-- Repeat for 2018 by reloading with Year = 2018 and mapping 2018 columns.
*/

-- ============================================================================
-- Validation queries
-- ============================================================================

SELECT 'Staging layer ready' AS Status;

SELECT TABLE_NAME, ENGINE, TABLE_COLLATION
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME IN (
    'Provincial_Accommodation_Stats',
    'National_Tourism_Financials',
    'Age_Group_Travel_Statistics'
  );

-- Restore FK checks.
SET FOREIGN_KEY_CHECKS = @old_fk_checks;
