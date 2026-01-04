# Sample Data Description
## ECON485 Project 3: Tourism Revenue & Visitor Trends

**Team 3 - Fall 2025**  
**Data Generation Date:** Week 6  
**Last Updated:** Week 14

---

## Overview

This folder contains sample data for the Tourism Analytics Database. All data is **synthetic** (computer-generated) for educational purposes and does not represent real individuals or actual tourism statistics.

---

## Data Files

| File Name | Records | Description | Date Range |
|-----------|---------|-------------|------------|
| `regions_sample.csv` | 10 | Geographic tourist destinations in Turkey | — |
| `hotels_sample.csv` | 15 | Accommodation facilities across regions | — |
| `visitors_sample.csv` | 16 | Tourist demographics (domestic + international) | 2024-2025 |
| `roomtypes_sample.csv` | 5 | Hotel room categories | — |
| `seasons_sample.csv` | 8 | Seasonal period definitions | 2024-2025 |
| `bookings_sample.csv` | 16 | Hotel reservations | 2024-02 to 2025-09 |
| `expenditures_sample.csv` | 17 | Non-accommodation spending | 2024-07 to 2024-09 |

**Total Records:** 87

---

## Data Characteristics

### Geographic Coverage
- **10 Regions** across Turkey
- **Distribution:**
  - 2 Urban (Istanbul, Izmir)
  - 5 Coastal (Antalya, Bodrum, Trabzon, Marmaris)
  - 2 Rural (Cappadocia, Ephesus, Pamukkale)
  - 1 Mountain (Uludağ)

### Hotel Distribution
- **15 Hotels** across all regions
- **Star Ratings:**
  - 5-star: 3 hotels
  - 4.5-star: 3 hotels
  - 4.0-star: 5 hotels
  - 3.5-star: 3 hotels
  - 3.0-star: 1 hotel
- **Total Room Inventory:** 2,165 rooms

### Visitor Demographics
- **16 Visitors** total
- **50% Domestic** (Turkish citizens): 5 visitors
- **50% International**: 11 visitors from 10 countries
  - Europe: UK, Germany, France, Italy, Spain (5)
  - Middle East: Saudi Arabia (1)
  - Asia: Russia, China (2)
  - Americas: United States (1)
  - Oceania: Australia (1)
- **Age Range:** 27-52 years
- **Gender Split:** 56% Male, 44% Female

### Booking Patterns
- **16 Bookings** across 2-year period
- **Temporal Distribution:**
  - 2024: 10 bookings (completed)
  - 2025: 6 bookings (confirmed, future)
- **Seasonal Distribution:**
  - Peak Season (Jun-Aug, Dec-Jan): 8 bookings (50%)
  - Shoulder Season (Apr-May, Sep-Oct): 5 bookings (31%)
  - Off-Season (Feb-Mar, Nov): 3 bookings (19%)
- **Average Length of Stay:** 5.3 nights
- **Price Range:** 120-650 TL per night

### Expenditure Patterns
- **17 Spending Records**
- **Category Distribution:**
  - Food: 5 transactions (29%)
  - Activities: 7 transactions (41%)
  - Shopping: 3 transactions (18%)
  - Transportation: 2 transactions (12%)
- **Amount Range:** 45-450 TL per transaction
- **Total Spending:** 2,450 TL (non-accommodation)

---

## Data Generation Methodology

### Source of Realism
Data was designed to reflect realistic Turkish tourism patterns:

1. **Geographic Data:** Based on actual Turkish regions with approximate population/GDP
2. **Hotel Names:** Fictional but realistic-sounding hotel names
3. **Pricing:** Seasonal variation based on industry standards
   - Peak season: +30-50% price increase
   - Off-season: 20-40% discount
4. **Visitor Distribution:** 50/50 domestic/international mix typical of Turkish tourism
5. **Spending Patterns:** Higher spending for international visitors (2-3x domestic)

### Data Quality Assurances
- ✅ No orphaned records (all foreign keys valid)
- ✅ No duplicate primary keys
- ✅ Realistic date ranges (CheckOut > CheckIn)
- ✅ Positive monetary values
- ✅ Age ranges plausible (27-52 years)
- ✅ Email formats valid
- ✅ Phone numbers follow international format

### Known Limitations
- **Small Sample Size:** 87 records insufficient for real analytics (educational purpose)
- **Perfect Data Quality:** No missing values or errors (unrealistic in production)
- **Limited Time Range:** Only 20 months of bookings
- **No Cancellations:** All bookings either Completed or Confirmed (no Cancelled status)
- **Balanced Distribution:** Intentionally designed patterns (real data more random)

---

## Data Relationships

### Entity Connections
```
Regions (10)
  └─→ Hotels (15)
       └─→ Bookings (16)
            └─→ Visitors (16)
  └─→ Expenditures (17)
       └─→ Visitors (16)

RoomTypes (5)
  └─→ Bookings (16)

Seasons (8) [derived relationship with Bookings based on dates]
```

### Foreign Key Coverage
- **All bookings** linked to valid visitors, hotels, room types ✅
- **All expenditures** linked to valid visitors and regions ✅
- **All hotels** linked to valid regions ✅
- **No NULL foreign keys** in critical relationships ✅

---

## Loading Data into Database

### Method 1: SQL LOAD DATA (Recommended)
```sql
USE tourism_analytics;

LOAD DATA LOCAL INFILE '/path/to/regions_sample.csv'
INTO TABLE Regions
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(RegionID, RegionName, Country, RegionType, Population, GDP, Description, CreatedAt);

-- Repeat for all tables
```

### Method 2: SQL INSERT FROM CSV
Use provided SQL script: `design/schema.sql` already contains INSERT statements

### Method 3: Database Import Tool
- MySQL Workbench: Table Data Import Wizard
- phpMyAdmin: Import tab → CSV format
- Command line: `mysqlimport` utility

---

## Data Export Commands

If you need to regenerate CSV files from database:

```sql
-- Export Regions
SELECT * FROM Regions
INTO OUTFILE '/var/lib/mysql-files/regions_export.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

-- Repeat for each table
```

**Note:** Requires `FILE` privilege and `secure_file_priv` configuration.

---

## Sample Queries Using This Data

### Query 1: Total Tourism Revenue by Region
```sql
SELECT 
    r.RegionName,
    SUM(b.TotalCost) + SUM(e.Amount) AS TotalRevenue
FROM Regions r
LEFT JOIN Hotels h ON r.RegionID = h.RegionID
LEFT JOIN Bookings b ON h.HotelID = b.HotelID
LEFT JOIN Expenditures e ON r.RegionID = e.RegionID
GROUP BY r.RegionName
ORDER BY TotalRevenue DESC;
```

### Query 2: International vs Domestic Spending
```sql
SELECT 
    v.VisitorType,
    COUNT(b.BookingID) AS Bookings,
    SUM(b.TotalCost) AS AccommodationSpend,
    SUM(e.Amount) AS OtherSpend,
    SUM(b.TotalCost) + SUM(e.Amount) AS TotalSpend
FROM Visitors v
LEFT JOIN Bookings b ON v.VisitorID = b.VisitorID
LEFT JOIN Expenditures e ON v.VisitorID = e.VisitorID
GROUP BY v.VisitorType;
```

### Query 3: Occupancy by Season
```sql
SELECT 
    CASE 
        WHEN MONTH(CheckInDate) IN (6,7,8,12,1) THEN 'Peak'
        WHEN MONTH(CheckInDate) IN (4,5,9,10) THEN 'Shoulder'
        ELSE 'Off-Season'
    END AS Season,
    COUNT(*) AS Bookings,
    AVG(PricePerNight) AS AvgPrice
FROM Bookings
GROUP BY Season;
```

---

## Data Privacy & Ethics

### Synthetic Data Declaration
**All data in this project is FICTIONAL and generated for educational purposes.**

- **No real persons:** Visitor names are common placeholder names
- **No actual hotels:** Hotel names are invented
- **No real bookings:** All transactions are simulated
- **No sensitive information:** Email addresses and phone numbers are format examples only

### If Using Real Data
For production systems handling actual tourism data:
- ✅ Obtain proper consent for data collection
- ✅ Anonymize personally identifiable information (PII)
- ✅ Comply with GDPR, KVKK (Turkey), and local privacy laws
- ✅ Implement data retention and deletion policies
- ✅ Secure databases with encryption and access controls

---

## Expanding the Dataset

### For Further Testing
If you need more data:

1. **Python Script:** Use `test_data_generator.py` (if included)
2. **Manual Addition:** Follow existing patterns in CSV files
3. **Duplicate & Modify:** Copy existing records with new IDs

### Scaling Considerations
For realistic production volumes:
- **Regions:** 50-100 (multiple countries)
- **Hotels:** 500-5,000
- **Visitors:** 10,000-1,000,000
- **Bookings:** 50,000-5,000,000 annually
- **Expenditures:** 100,000-10,000,000 transactions

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | Week 6 | Initial dataset created with 87 records |
| 1.1 | Week 7 | Verified data quality, no missing values |
| 1.2 | Week 14 | Final CSV exports, documentation updated |

---

## Acknowledgments

**Data Sources Referenced (for realism):**
- Turkish Statistical Institute (TÜİK) - Population data
- Ministry of Culture and Tourism - Hotel distribution
- World Tourism Organization (UNWTO) - Visitor patterns
- Industry reports - Seasonal pricing trends

**Note:** While these sources informed realistic patterns, all specific data points are synthesized.

---

## Contact

**Questions about the data?**
- See: `/docs/ai_logs.md` for data generation process
- See: `/design/data_dictionary.md` for field definitions
- Contact: Team 3 - Data Analyst

---

**Data Status:** ✅ Complete and validated  
**Ready for Use:** Week 6 onwards  
**Last Validation:** Week 14, Fall 2025