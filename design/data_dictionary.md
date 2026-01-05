# Data Dictionary
## ECON485 Project 3: Tourism Revenue & Visitor Trends Database

**Database:** `tourism_analytics`  
**DBMS:** MariaDB 10.6+  
**Character Set:** utf8mb4_unicode_ci  
**Last Updated:** 2026-01-04

---

## Tables
1. Regions  
2. Hotels  
3. Visitors  
4. RoomTypes  
5. Seasons  
6. Bookings  
7. Expenditures  
8. HotelRoomPricing (optional)

---

## 1) Regions
**Purpose:** Geographic destinations (cities, provinces, resort areas)  
**PK:** RegionID  
**Relationships:** 1:N with Hotels; 1:N with Expenditures

| Column | Type | Null | Key | Default | Description |
|--------|------|------|-----|---------|-------------|
| RegionID | INT AUTO_INCREMENT | NO | PK | — | Region identifier |
| RegionName | VARCHAR(100) | NO | IDX | — | Region name |
| Country | VARCHAR(100) | NO | IDX | 'Turkey' | Country |
| RegionType | ENUM('Urban','Coastal','Rural','Mountain') | NO | IDX | — | Region classification |
| Population | INT | YES | — | NULL | Population (>=0) |
| GDP | DECIMAL(15,2) | YES | — | NULL | GDP in millions USD (>=0) |
| Description | TEXT | YES | — | NULL | Notes |
| CreatedAt | TIMESTAMP | NO | — | CURRENT_TIMESTAMP | Created time |

Indexes: idx_region_name, idx_country, idx_region_type  
Checks: Population >= 0; GDP >= 0

---

## 2) Hotels
**Purpose:** Accommodation facilities  
**PK:** HotelID  
**FKs:** RegionID → Regions.RegionID  
**Relationships:** N:1 Regions; 1:N Bookings; 1:N HotelRoomPricing

| Column | Type | Null | Key | Default | Description |
|--------|------|------|-----|---------|-------------|
| HotelID | INT AUTO_INCREMENT | NO | PK | — | Hotel identifier |
| HotelName | VARCHAR(200) | NO | IDX | — | Official hotel name |
| RegionID | INT | NO | FK, IDX | — | Region |
| StarRating | DECIMAL(2,1) | NO | IDX | — | Rating 1.0–5.0 |
| TotalRooms | INT | NO | — | — | Total rooms (>0) |
| Address | VARCHAR(300) | YES | — | NULL | Street address |
| City | VARCHAR(100) | YES | — | NULL | City |
| ZipCode | VARCHAR(20) | YES | — | NULL | Postal code |
| ContactPhone | VARCHAR(50) | YES | — | NULL | Phone |
| ContactEmail | VARCHAR(100) | YES | — | NULL | Email |
| CreatedAt | TIMESTAMP | NO | — | CURRENT_TIMESTAMP | Created time |

Indexes: idx_hotel_region, idx_hotel_rating, idx_hotel_name  
Checks: StarRating between 1.0 and 5.0; TotalRooms > 0; ContactEmail LIKE '%@%.%'  
FK: RegionID ON DELETE RESTRICT ON UPDATE CASCADE

---

## 3) Visitors
**Purpose:** Tourist records with demographics  
**PK:** VisitorID  
**Relationships:** 1:N Bookings; 1:N Expenditures

| Column | Type | Null | Key | Default | Description |
|--------|------|------|-----|---------|-------------|
| VisitorID | INT AUTO_INCREMENT | NO | PK | — | Visitor identifier |
| FirstName | VARCHAR(100) | NO | — | — | First name |
| LastName | VARCHAR(100) | NO | IDX | — | Last name |
| Country | VARCHAR(100) | NO | IDX | — | Country of origin |
| Age | INT | YES | — | NULL | Age (0–120) |
| Gender | ENUM('Male','Female','Other','PreferNotToSay') | YES | — | NULL | Gender |
| VisitorType | ENUM('Domestic','International') | NO | IDX | — | Visitor classification |
| Email | VARCHAR(100) | YES | — | NULL | Email |
| Phone | VARCHAR(50) | YES | — | NULL | Phone |
| RegisteredDate | TIMESTAMP | NO | — | CURRENT_TIMESTAMP | Registered time |

Indexes: idx_visitor_country, idx_visitor_type, idx_visitor_name (LastName, FirstName)  
Checks: Age between 0 and 120; Email LIKE '%@%.%' if provided

---

## 4) RoomTypes
**Purpose:** Standard room categories  
**PK:** RoomTypeID  
**Relationships:** 1:N Bookings; 1:N HotelRoomPricing

| Column | Type | Null | Key | Default | Description |
|--------|------|------|-----|---------|-------------|
| RoomTypeID | INT AUTO_INCREMENT | NO | PK | — | Room type identifier |
| TypeName | VARCHAR(50) | NO | UNIQUE | — | Category name |
| BaseCapacity | INT | NO | — | — | Max occupancy (1–10) |
| Description | TEXT | YES | — | NULL | Details |

Checks: BaseCapacity > 0 and <= 10

---

## 5) Seasons
**Purpose:** Seasonal periods for analytics  
**PK:** SeasonID  
**Relationships:** 1:N HotelRoomPricing; derived link to Bookings by date

| Column | Type | Null | Key | Default | Description |
|--------|------|------|-----|---------|-------------|
| SeasonID | INT AUTO_INCREMENT | NO | PK | — | Season identifier |
| SeasonName | ENUM('Peak','Shoulder','Off-Season') | NO | — | — | Season label |
| StartMonth | INT | NO | — | — | Start month (1–12) |
| EndMonth | INT | NO | — | — | End month (1–12) |
| YearApplicable | INT | YES | — | NULL | Year (>=2020) |
| Description | TEXT | YES | — | NULL | Notes |

Checks: StartMonth 1–12; EndMonth 1–12; YearApplicable >= 2020  
Unique: (SeasonName, YearApplicable)

---

## 6) Bookings
**Purpose:** Reservations linking visitors, hotels, and room types  
**PK:** BookingID  
**FKs:** VisitorID → Visitors; HotelID → Hotels; RoomTypeID → RoomTypes  
**Relationships:** N:1 Visitors; N:1 Hotels; N:1 RoomTypes

| Column | Type | Null | Key | Default | Description |
|--------|------|------|-----|---------|-------------|
| BookingID | INT AUTO_INCREMENT | NO | PK | — | Booking identifier |
| VisitorID | INT | NO | FK, IDX | — | Visitor |
| HotelID | INT | NO | FK, IDX | — | Hotel |
| RoomTypeID | INT | NO | FK | — | Room type |
| CheckInDate | DATE | NO | IDX | — | Arrival date |
| CheckOutDate | DATE | NO | IDX | — | Departure date |
| NumberOfGuests | INT | NO | — | 1 | Guests (1–10) |
| PricePerNight | DECIMAL(10,2) | NO | — | — | Nightly rate |
| TotalCost | DECIMAL(10,2) | NO | — | — | Denormalized total |
| BookingStatus | ENUM('Confirmed','Cancelled','Completed') | NO | IDX | 'Confirmed' | Status |
| BookingDate | TIMESTAMP | NO | — | CURRENT_TIMESTAMP | Created time |

Checks: CheckOutDate > CheckInDate; PricePerNight > 0; TotalCost > 0; NumberOfGuests 1–10  
Indexes: idx_booking_visitor, idx_booking_hotel, idx_booking_dates, idx_booking_status, idx_booking_hotel_dates  
Business note: TotalCost intentionally denormalized for performance/history.

---

## 7) Expenditures
**Purpose:** Non-accommodation spending by visitors  
**PK:** ExpenditureID  
**FKs:** VisitorID → Visitors; RegionID → Regions  
**Relationships:** N:1 Visitors; N:1 Regions

| Column | Type | Null | Key | Default | Description |
|--------|------|------|-----|---------|-------------|
| ExpenditureID | INT AUTO_INCREMENT | NO | PK | — | Expenditure identifier |
| VisitorID | INT | NO | FK, IDX | — | Visitor |
| RegionID | INT | NO | FK, IDX | — | Region of spend |
| Category | ENUM('Accommodation','Food','Activities','Shopping','Transportation','Other') | NO | IDX | — | Spend category |
| Amount | DECIMAL(10,2) | NO | — | — | Amount (>0) |
| ExpenditureDate | DATE | NO | IDX | — | Spend date |
| Description | VARCHAR(300) | YES | — | NULL | Notes |
| CreatedAt | TIMESTAMP | NO | — | CURRENT_TIMESTAMP | Created time |

Checks: Amount > 0  
Indexes: idx_expenditure_visitor, idx_expenditure_region, idx_expenditure_category, idx_expenditure_date, idx_expenditure_region_date

---

## 8) HotelRoomPricing (Optional)
**Purpose:** Seasonal pricing per hotel-room-type combination  
**PK:** PricingID  
**FKs:** HotelID → Hotels; RoomTypeID → RoomTypes; SeasonID → Seasons  
**Relationships:** N:1 Hotels; N:1 RoomTypes; N:1 Seasons

| Column | Type | Null | Key | Default | Description |
|--------|------|------|-----|---------|-------------|
| PricingID | INT AUTO_INCREMENT | NO | PK | — | Pricing identifier |
| HotelID | INT | NO | FK, IDX | — | Hotel |
| RoomTypeID | INT | NO | FK | — | Room type |
| SeasonID | INT | NO | FK, IDX | — | Season |
| PricePerNight | DECIMAL(10,2) | NO | — | — | Price (>0) |
| AvailableRooms | INT | NO | — | — | Rooms available (>=0) |

Unique: (HotelID, RoomTypeID, SeasonID)  
Checks: PricePerNight > 0; AvailableRooms >= 0  
FKs: CASCADE on DELETE/UPDATE

---

## Entity Relationships (summary)
```
Regions 1 --- N Hotels
Regions 1 --- N Expenditures
Visitors 1 --- N Bookings
Visitors 1 --- N Expenditures
Hotels 1 --- N Bookings
RoomTypes 1 --- N Bookings

Optional:
Hotels 1 --- N HotelRoomPricing
RoomTypes 1 --- N HotelRoomPricing
Seasons 1 --- N HotelRoomPricing

Derived:
Seasons ~~~ Bookings (via CheckInDate)
```

---

## Notes & Alignment with Data
- CSV files in `/data` are external reference exports; they are not directly loaded into these normalized tables without transformation.  
- Sample counts from earlier synthetic data are retired; load scripts should respect the constraints above.  
- Monetary columns use dot (`.`) as decimal separator; ensure locale handling during imports.

---

**Maintained by:** Team 3 — Data Analyst  
**Document Version:** 2.0
