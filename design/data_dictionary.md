# Data Dictionary
## ECON485 Project 3: Tourism Revenue & Visitor Trends Database

**Database Name:** tourism_analytics  
**DBMS:** MariaDB 10.6+  
**Character Set:** UTF-8 (utf8mb4_unicode_ci)  
**Last Updated:** Week 14, Fall 2025

---

## Table of Contents

1. [Regions](#1-regions)
2. [Hotels](#2-hotels)
3. [Visitors](#3-visitors)
4. [RoomTypes](#4-roomtypes)
5. [Seasons](#5-seasons)
6. [Bookings](#6-bookings)
7. [Expenditures](#7-expenditures)
8. [HotelRoomPricing](#8-hotelroompricing-optional)

---

## 1. REGIONS

**Table Name:** `Regions`  
**Description:** Geographic tourist destinations including cities, provinces, and resort areas  
**Primary Key:** RegionID  
**Foreign Keys:** None  
**Relationships:** One region has many hotels (1:N)

### Columns

| Column Name | Data Type | Null | Key | Default | Description | Example Values |
|-------------|-----------|------|-----|---------|-------------|----------------|
| RegionID | INT | NO | PK | AUTO_INCREMENT | Unique identifier for each region | 1, 2, 3 |
| RegionName | VARCHAR(100) | NO | INDEX | — | Official name of the region | Istanbul, Antalya, Cappadocia |
| Country | VARCHAR(100) | NO | INDEX | 'Turkey' | Country where region is located | Turkey |
| RegionType | ENUM | NO | INDEX | — | Classification of region type | Urban, Coastal, Rural, Mountain |
| Population | INT | YES | — | NULL | Total population of the region | 15460000, 2511700 |
| GDP | DECIMAL(15,2) | YES | — | NULL | Regional GDP in millions USD | 285000.00, 45000.00 |
| Description | TEXT | YES | — | NULL | Additional information about the region | 'Largest city, cultural hub' |
| CreatedAt | TIMESTAMP | NO | — | CURRENT_TIMESTAMP | Record creation timestamp | 2025-01-15 10:30:00 |

### Constraints

- **CHECK:** Population >= 0
- **CHECK:** GDP >= 0
- **UNIQUE:** None (multiple regions can have same name in different countries)

### Indexes

- `idx_region_name` on RegionName
- `idx_country` on Country
- `idx_region_type` on RegionType

### Sample Data

```
RegionID | RegionName | Country | RegionType | Population | GDP
---------|------------|---------|------------|------------|----------
1        | Istanbul   | Turkey  | Urban      | 15460000   | 285000.00
2        | Antalya    | Turkey  | Coastal    | 2511700    | 45000.00
3        | Cappadocia | Turkey  | Rural      | 367000     | 8500.00
```

---

## 2. HOTELS

**Table Name:** `Hotels`  
**Description:** Accommodation facilities offering rooms to visitors  
**Primary Key:** HotelID  
**Foreign Keys:** RegionID → Regions(RegionID)  
**Relationships:** 
- Belongs to one region (N:1)
- Has many bookings (1:N)

### Columns

| Column Name | Data Type | Null | Key | Default | Description | Example Values |
|-------------|-----------|------|-----|---------|-------------|----------------|
| HotelID | INT | NO | PK | AUTO_INCREMENT | Unique hotel identifier | 1, 2, 3 |
| HotelName | VARCHAR(200) | NO | INDEX | — | Official name of the hotel | Grand Istanbul Palace |
| RegionID | INT | NO | FK, INDEX | — | Region where hotel is located | 1 (Istanbul) |
| StarRating | DECIMAL(2,1) | NO | INDEX | — | Hotel quality rating (1.0-5.0) | 5.0, 4.5, 3.5 |
| TotalRooms | INT | NO | — | — | Total number of available rooms | 250, 180, 120 |
| Address | VARCHAR(300) | YES | — | NULL | Street address | Sultanahmet Square 15 |
| City | VARCHAR(100) | YES | — | NULL | City name | Istanbul, Antalya |
| ZipCode | VARCHAR(20) | YES | — | NULL | Postal code | 34122, 07100 |
| ContactPhone | VARCHAR(50) | YES | — | NULL | Contact phone number | +90-212-555-0001 |
| ContactEmail | VARCHAR(100) | YES | — | NULL | Contact email address | info@hotel.com |
| CreatedAt | TIMESTAMP | NO | — | CURRENT_TIMESTAMP | Record creation timestamp | 2025-01-15 10:30:00 |

### Constraints

- **CHECK:** StarRating BETWEEN 1.0 AND 5.0
- **CHECK:** TotalRooms > 0
- **CHECK:** ContactEmail LIKE '%@%.%' (if provided)
- **FOREIGN KEY:** RegionID REFERENCES Regions(RegionID) ON DELETE RESTRICT ON UPDATE CASCADE

### Indexes

- `idx_hotel_region` on RegionID
- `idx_hotel_rating` on StarRating
- `idx_hotel_name` on HotelName

### Sample Data

```
HotelID | HotelName              | RegionID | StarRating | TotalRooms | City
--------|------------------------|----------|------------|------------|----------
1       | Grand Istanbul Palace  | 1        | 5.0        | 250        | Istanbul
2       | Bosphorus View Hotel   | 1        | 4.5        | 180        | Istanbul
4       | Antalya Beach Resort   | 2        | 5.0        | 400        | Antalya
```

---

## 3. VISITORS

**Table Name:** `Visitors`  
**Description:** Individual tourists with demographic information  
**Primary Key:** VisitorID  
**Foreign Keys:** None  
**Relationships:** 
- Has many bookings (1:N)
- Has many expenditures (1:N)

### Columns

| Column Name | Data Type | Null | Key | Default | Description | Example Values |
|-------------|-----------|------|-----|---------|-------------|----------------|
| VisitorID | INT | NO | PK | AUTO_INCREMENT | Unique visitor identifier | 1, 2, 3 |
| FirstName | VARCHAR(100) | NO | — | — | Visitor's first name | Ahmet, John, Emma |
| LastName | VARCHAR(100) | NO | INDEX | — | Visitor's last name | Yılmaz, Smith, Johnson |
| Country | VARCHAR(100) | NO | INDEX | — | Visitor's country of origin | Turkey, United Kingdom, Germany |
| Age | INT | YES | — | NULL | Visitor's age in years | 35, 28, 45 |
| Gender | ENUM | YES | — | NULL | Visitor's gender | Male, Female, Other, PreferNotToSay |
| VisitorType | ENUM | NO | INDEX | — | Classification of visitor | Domestic, International |
| Email | VARCHAR(100) | YES | — | NULL | Contact email | visitor@email.com |
| Phone | VARCHAR(50) | YES | — | NULL | Contact phone | +90-532-123-4567 |
| RegisteredDate | TIMESTAMP | NO | — | CURRENT_TIMESTAMP | Account registration date | 2024-07-10 14:20:00 |

### Constraints

- **CHECK:** Age BETWEEN 0 AND 120 (if provided)
- **CHECK:** Email LIKE '%@%.%' (if provided)

### Indexes

- `idx_visitor_country` on Country
- `idx_visitor_type` on VisitorType
- `idx_visitor_name` on (LastName, FirstName)

### Sample Data

```
VisitorID | FirstName | LastName | Country        | Age | VisitorType   | Email
----------|-----------|----------|----------------|-----|---------------|--------------------
1         | Ahmet     | Yılmaz   | Turkey         | 35  | Domestic      | ahmet.y@email.com
6         | John      | Smith    | United Kingdom | 45  | International | john.s@email.co.uk
8         | Hans      | Mueller  | Germany        | 52  | International | hans.m@email.de
```

---

## 4. ROOMTYPES

**Table Name:** `RoomTypes`  
**Description:** Categorization of hotel room types across all properties  
**Primary Key:** RoomTypeID  
**Foreign Keys:** None  
**Relationships:** One room type used in many bookings (1:N)

### Columns

| Column Name | Data Type | Null | Key | Default | Description | Example Values |
|-------------|-----------|------|-----|---------|-------------|----------------|
| RoomTypeID | INT | NO | PK | AUTO_INCREMENT | Unique room type identifier | 1, 2, 3 |
| TypeName | VARCHAR(50) | NO | UNIQUE | — | Name of room category | Standard, Deluxe, Suite |
| BaseCapacity | INT | NO | — | — | Maximum occupancy | 2, 4, 6 |
| Description | TEXT | YES | — | NULL | Detailed room description | 'Basic room with essential amenities' |

### Constraints

- **CHECK:** BaseCapacity BETWEEN 1 AND 10
- **UNIQUE:** TypeName (each type name appears once)

### Indexes

None (small lookup table)

### Sample Data

```
RoomTypeID | TypeName     | BaseCapacity | Description
-----------|--------------|--------------|----------------------------------
1          | Standard     | 2            | Basic room with essential amenities
2          | Deluxe       | 2            | Enhanced room with better view
3          | Suite        | 4            | Large room with separate living area
```

---

## 5. SEASONS

**Table Name:** `Seasons`  
**Description:** Temporal classifications for seasonal tourism analysis  
**Primary Key:** SeasonID  
**Foreign Keys:** None  
**Relationships:** Used to classify bookings by date (derived relationship)

### Columns

| Column Name | Data Type | Null | Key | Default | Description | Example Values |
|-------------|-----------|------|-----|---------|-------------|----------------|
| SeasonID | INT | NO | PK | AUTO_INCREMENT | Unique season identifier | 1, 2, 3 |
| SeasonName | ENUM | NO | — | — | Season category | Peak, Shoulder, Off-Season |
| StartMonth | INT | NO | — | — | Starting month (1-12) | 6, 4, 2 |
| EndMonth | INT | NO | — | — | Ending month (1-12) | 8, 5, 3 |
| YearApplicable | INT | YES | — | NULL | Year for this season definition | 2024, 2025 |
| Description | TEXT | YES | — | NULL | Additional season details | 'Summer high season' |

### Constraints

- **CHECK:** StartMonth BETWEEN 1 AND 12
- **CHECK:** EndMonth BETWEEN 1 AND 12
- **CHECK:** YearApplicable >= 2020
- **UNIQUE:** (SeasonName, YearApplicable)

### Indexes

None (small reference table)

### Sample Data

```
SeasonID | SeasonName | StartMonth | EndMonth | YearApplicable | Description
---------|------------|------------|----------|----------------|------------------------
1        | Peak       | 6          | 8        | 2024           | Summer high season
2        | Peak       | 12         | 1        | 2024           | Winter holidays
3        | Shoulder   | 4          | 5        | 2024           | Spring season
```

---

## 6. BOOKINGS

**Table Name:** `Bookings`  
**Description:** Reservation records linking visitors to hotels  
**Primary Key:** BookingID  
**Foreign Keys:** 
- VisitorID → Visitors(VisitorID)
- HotelID → Hotels(HotelID)
- RoomTypeID → RoomTypes(RoomTypeID)

**Relationships:**
- Belongs to one visitor (N:1)
- Belongs to one hotel (N:1)
- Uses one room type (N:1)

### Columns

| Column Name | Data Type | Null | Key | Default | Description | Example Values |
|-------------|-----------|------|-----|---------|-------------|----------------|
| BookingID | INT | NO | PK | AUTO_INCREMENT | Unique booking identifier | 1, 2, 3 |
| VisitorID | INT | NO | FK, INDEX | — | Visitor who made booking | 1, 6, 8 |
| HotelID | INT | NO | FK, INDEX | — | Hotel where booking is made | 1, 4, 7 |
| RoomTypeID | INT | NO | FK | — | Type of room booked | 1, 2, 3 |
| CheckInDate | DATE | NO | INDEX | — | Arrival date | 2024-07-15, 2025-06-20 |
| CheckOutDate | DATE | NO | INDEX | — | Departure date | 2024-07-20, 2025-06-25 |
| NumberOfGuests | INT | NO | — | 1 | Number of people in booking | 1, 2, 4 |
| PricePerNight | DECIMAL(10,2) | NO | — | — | Room rate per night | 350.00, 280.00 |
| TotalCost | DECIMAL(10,2) | NO | — | — | Total booking cost (denormalized) | 1750.00, 1680.00 |
| BookingStatus | ENUM | NO | INDEX | 'Confirmed' | Current status | Confirmed, Cancelled, Completed |
| BookingDate | TIMESTAMP | NO | — | CURRENT_TIMESTAMP | When booking was created | 2024-07-01 10:30:00 |

### Constraints

- **CHECK:** CheckOutDate > CheckInDate
- **CHECK:** PricePerNight > 0
- **CHECK:** TotalCost > 0
- **CHECK:** NumberOfGuests BETWEEN 1 AND 10
- **FOREIGN KEY:** All FKs with RESTRICT on DELETE, CASCADE on UPDATE
- **BUSINESS RULE:** TotalCost = PricePerNight × (CheckOutDate - CheckInDate)

### Indexes

- `idx_booking_visitor` on VisitorID
- `idx_booking_hotel` on HotelID
- `idx_booking_dates` on (CheckInDate, CheckOutDate)
- `idx_booking_status` on BookingStatus
- `idx_booking_hotel_dates` on (HotelID, CheckInDate)

### Denormalization Note

**TotalCost** is intentionally denormalized (violates 3NF) for performance and historical accuracy. See normalization_analysis.md for justification.

### Sample Data

```
BookingID | VisitorID | HotelID | CheckInDate | CheckOutDate | PricePerNight | TotalCost | Status
----------|-----------|---------|-------------|--------------|---------------|-----------|----------
1         | 1         | 1       | 2024-07-15  | 2024-07-20   | 350.00        | 1750.00   | Completed
2         | 2         | 4       | 2024-08-01  | 2024-08-07   | 280.00        | 1680.00   | Completed
11        | 11        | 1       | 2025-06-15  | 2025-06-20   | 380.00        | 1900.00   | Confirmed
```

---

## 7. EXPENDITURES

**Table Name:** `Expenditures`  
**Description:** Detailed spending records beyond accommodation costs  
**Primary Key:** ExpenditureID  
**Foreign Keys:**
- VisitorID → Visitors(VisitorID)
- RegionID → Regions(RegionID)

**Relationships:**
- Belongs to one visitor (N:1)
- Occurs in one region (N:1)

### Columns

| Column Name | Data Type | Null | Key | Default | Description | Example Values |
|-------------|-----------|------|-----|---------|-------------|----------------|
| ExpenditureID | INT | NO | PK | AUTO_INCREMENT | Unique expenditure identifier | 1, 2, 3 |
| VisitorID | INT | NO | FK, INDEX | — | Visitor who spent money | 1, 6, 8 |
| RegionID | INT | NO | FK, INDEX | — | Region where spending occurred | 1, 2, 3 |
| Category | ENUM | NO | INDEX | — | Type of spending | Food, Activities, Shopping, Transportation, Other |
| Amount | DECIMAL(10,2) | NO | — | — | Amount spent in local currency | 120.00, 80.00, 250.00 |
| ExpenditureDate | DATE | NO | INDEX | — | Date of transaction | 2024-07-15, 2024-08-02 |
| Description | VARCHAR(300) | YES | — | NULL | Details about expenditure | 'Dinner at seafood restaurant' |
| CreatedAt | TIMESTAMP | NO | — | CURRENT_TIMESTAMP | Record creation timestamp | 2024-07-15 20:30:00 |

### Constraints

- **CHECK:** Amount > 0
- **FOREIGN KEY:** All FKs with RESTRICT on DELETE, CASCADE on UPDATE

### Indexes

- `idx_expenditure_visitor` on VisitorID
- `idx_expenditure_region` on RegionID
- `idx_expenditure_category` on Category
- `idx_expenditure_date` on ExpenditureDate
- `idx_expenditure_region_date` on (RegionID, ExpenditureDate)

### Sample Data

```
ExpenditureID | VisitorID | RegionID | Category       | Amount  | ExpenditureDate | Description
--------------|-----------|----------|----------------|---------|-----------------|---------------------------
1             | 1         | 1        | Food           | 120.00  | 2024-07-15      | Dinner at seafood restaurant
2             | 1         | 1        | Activities     | 80.00   | 2024-07-16      | Bosphorus cruise tour
3             | 1         | 1        | Shopping       | 250.00  | 2024-07-18      | Turkish carpets
```

---

## 8. HOTELROOMPRICING (Optional)

**Table Name:** `HotelRoomPricing`  
**Description:** Dynamic pricing based on hotel, room type, and season (optional enhancement)  
**Primary Key:** PricingID  
**Foreign Keys:**
- HotelID → Hotels(HotelID)
- RoomTypeID → RoomTypes(RoomTypeID)
- SeasonID → Seasons(SeasonID)

**Relationships:**
- Belongs to one hotel (N:1)
- Belongs to one room type (N:1)
- Belongs to one season (N:1)

### Columns

| Column Name | Data Type | Null | Key | Default | Description | Example Values |
|-------------|-----------|------|-----|---------|-------------|----------------|
| PricingID | INT | NO | PK | AUTO_INCREMENT | Unique pricing record identifier | 1, 2, 3 |
| HotelID | INT | NO | FK, INDEX | — | Hotel offering this pricing | 1, 4, 7 |
| RoomTypeID | INT | NO | FK | — | Room type being priced | 1, 2, 3 |
| SeasonID | INT | NO | FK, INDEX | — | Season when price applies | 1, 3, 5 |
| PricePerNight | DECIMAL(10,2) | NO | — | — | Room rate for this combination | 350.00, 420.00 |
| AvailableRooms | INT | NO | — | — | Number of rooms available | 50, 30, 100 |

### Constraints

- **CHECK:** PricePerNight > 0
- **CHECK:** AvailableRooms >= 0
- **UNIQUE:** (HotelID, RoomTypeID, SeasonID)
- **FOREIGN KEY:** All FKs with CASCADE on DELETE and UPDATE

### Indexes

- `idx_pricing_hotel` on HotelID
- `idx_pricing_season` on SeasonID

### Sample Data

```
PricingID | HotelID | RoomTypeID | SeasonID | PricePerNight | AvailableRooms
----------|---------|------------|----------|---------------|----------------
1         | 1       | 1          | 1        | 320.00        | 80
2         | 1       | 1          | 3        | 220.00        | 100
3         | 1       | 2          | 1        | 450.00        | 50
```

---

## Entity Relationship Summary

```
Regions (1) ----< Hotels (N)
Hotels (1) ----< Bookings (N)
Visitors (1) ----< Bookings (N)
RoomTypes (1) ----< Bookings (N)
Visitors (1) ----< Expenditures (N)
Regions (1) ----< Expenditures (N)

Optional:
Hotels (1) ----< HotelRoomPricing (N)
RoomTypes (1) ----< HotelRoomPricing (N)
Seasons (1) ----< HotelRoomPricing (N)

Derived:
Seasons (1) ~~~< Bookings (N) [based on CheckInDate]
```

---

## Database Statistics

| Table | Columns | Sample Records | Primary Key | Foreign Keys | Indexes |
|-------|---------|----------------|-------------|--------------|---------|
| Regions | 8 | 10 | RegionID | 0 | 3 |
| Hotels | 11 | 15 | HotelID | 1 | 3 |
| Visitors | 10 | 16 | VisitorID | 0 | 3 |
| RoomTypes | 4 | 5 | RoomTypeID | 0 | 0 |
| Seasons | 6 | 8 | SeasonID | 0 | 0 |
| Bookings | 11 | 16 | BookingID | 3 | 5 |
| Expenditures | 8 | 17 | ExpenditureID | 2 | 5 |
| HotelRoomPricing | 6 | 0 (optional) | PricingID | 3 | 2 |

**Total Tables:** 8 (7 core + 1 optional)  
**Total Sample Records:** 87  
**Total Indexes:** 21

---

## Naming Conventions

- **Tables:** PascalCase, plural nouns (Regions, Hotels, Bookings)
- **Columns:** PascalCase (RegionID, CheckInDate, TotalCost)
- **Primary Keys:** TableNameID (RegionID, HotelID)
- **Foreign Keys:** Same name as referenced PK
- **Indexes:** idx_tablename_columnname

---

## Data Quality Rules

1. **Referential Integrity:** All foreign keys enforced with constraints
2. **Date Validation:** CheckOutDate must always be after CheckInDate
3. **Positive Values:** All monetary amounts and counts must be > 0
4. **Email Format:** Basic validation with LIKE '%@%.%'
5. **Enum Constraints:** Gender, VisitorType, BookingStatus, Category limited to predefined values
6. **Historical Accuracy:** TotalCost denormalized to preserve booking cost at time of reservation

---

## Performance Considerations

- **High-Traffic Tables:** Bookings, Expenditures (most queries target these)
- **Index Strategy:** Composite indexes on (HotelID, CheckInDate) for occupancy queries
- **View Optimization:** 4 materialized views created for common dashboard queries
- **Query Patterns:** Most analytics involve date ranges and regional aggregations

---

**Document Version:** 1.0  
**Last Updated:** Week 14, Fall 2025  
**Maintained By:** Team 3 - Data Analyst