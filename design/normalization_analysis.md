# Normalization Analysis Document
## ECON485 Project 3: Tourism Revenue & Visitor Trends

**Team 3 - Fall 2025**  
**Date:** Week 5  
**Prepared by:** Member 2 (Data Analyst)  
**Reviewed by:** All team members

---

## Purpose

This document analyzes our database schema for compliance with Third Normal Form (3NF), identifies normalization violations, and documents design decisions including intentional denormalizations with justification.

---

## Normalization Theory Review

### First Normal Form (1NF)
**Requirements:**
- All attributes contain atomic (indivisible) values
- No repeating groups or arrays
- Each row is unique (primary key exists)

### Second Normal Form (2NF)
**Requirements:**
- Must satisfy 1NF
- No partial dependencies: All non-key attributes must depend on the **entire** primary key
- Only relevant for tables with composite primary keys

### Third Normal Form (3NF)
**Requirements:**
- Must satisfy 2NF
- No transitive dependencies: Non-key attributes must not depend on other non-key attributes
- All attributes must depend directly on the primary key

---

## Schema Analysis

### Table 1: Regions

**Current Structure:**
```
Regions(RegionID, RegionName, Country, RegionType, Population, GDP, Description, CreatedAt)
Primary Key: RegionID
```

**1NF Compliance:** ✅ PASS
- All attributes are atomic
- No repeating groups
- Primary key (RegionID) ensures uniqueness

**2NF Compliance:** ✅ PASS
- Single-column primary key → partial dependencies impossible
- All attributes depend on RegionID

**3NF Compliance:** ✅ PASS
- No transitive dependencies identified
- RegionName, Country, RegionType, Population, GDP all directly describe the region
- No non-key attribute depends on another non-key attribute

**Conclusion:** Regions table is in 3NF.

---

### Table 2: Hotels

**Current Structure:**
```
Hotels(HotelID, HotelName, RegionID, StarRating, TotalRooms, Address, City, ZipCode, 
       ContactPhone, ContactEmail, CreatedAt)
Primary Key: HotelID
Foreign Keys: RegionID → Regions(RegionID)
```

**1NF Compliance:** ✅ PASS
- All attributes atomic
- No arrays or repeating groups
- Primary key present

**2NF Compliance:** ✅ PASS
- Single-column PK → no partial dependencies

**3NF Compliance:** 🔍 ANALYSIS REQUIRED

**Potential Issue: City and RegionID**
- **Question:** Does City depend on RegionID?
- **Analysis:** 
  - Hotels in the same region may be in different cities (e.g., a region like "Coastal Province" contains multiple cities)
  - City is a property of the hotel's address, not derivable from RegionID alone
- **Conclusion:** No transitive dependency; City is independent attribute

**Potential Issue: ZipCode and City**
- **Question:** Does ZipCode determine City?
- **Analysis:**
  - In real world: Yes, ZipCode → City (transitive dependency)
  - **3NF Violation?** Technically yes
  - **Our Decision:** Accept this denormalization
  - **Justification:** 
    1. Address components are commonly stored together for convenience
    2. Creating separate ZipCode table for city lookup is excessive granularity
    3. Minimal update anomaly risk (hotel addresses rarely change)
    4. Query simplicity: Displaying hotel address doesn't require extra JOINs

**Conclusion:** Hotels table is effectively in 3NF with documented, justified denormalization of address components.

---

### Table 3: Visitors

**Current Structure:**
```
Visitors(VisitorID, FirstName, LastName, Country, Age, Gender, VisitorType, 
         Email, Phone, RegisteredDate)
Primary Key: VisitorID
```

**1NF Compliance:** ✅ PASS
- All attributes atomic
- No multi-valued attributes

**2NF Compliance:** ✅ PASS
- Single-column PK

**3NF Compliance:** 🔍 ANALYSIS

**Potential Issue: VisitorType and Country**
- **Question:** Does VisitorType (Domestic/International) depend on Country?
- **Analysis:**
  - VisitorType is relative to tourism board's home country
  - If tourism board is in Turkey: Country='Turkey' → VisitorType='Domestic'
  - However, VisitorType also depends on context (which country's perspective)
- **Design Decision:**
  - VisitorType is **explicitly stored** rather than derived
  - Rationale: Flexibility if database used by multi-national tourism organization
  - Not a true transitive dependency because VisitorType requires additional context beyond Country

**Conclusion:** Visitors table is in 3NF.

---

### Table 4: RoomTypes

**Current Structure:**
```
RoomTypes(RoomTypeID, TypeName, BaseCapacity, Description)
Primary Key: RoomTypeID
```

**1NF Compliance:** ✅ PASS

**2NF Compliance:** ✅ PASS

**3NF Compliance:** ✅ PASS
- Simple lookup table
- No transitive dependencies

**Conclusion:** RoomTypes table is in 3NF.

---

### Table 5: Seasons

**Current Structure:**
```
Seasons(SeasonID, SeasonName, StartMonth, EndMonth, YearApplicable, Description)
Primary Key: SeasonID
```

**1NF Compliance:** ✅ PASS

**2NF Compliance:** ✅ PASS

**3NF Compliance:** ✅ PASS
- All attributes directly describe the season
- No transitive dependencies

**Conclusion:** Seasons table is in 3NF.

---

### Table 6: Bookings

**Current Structure:**
```
Bookings(BookingID, VisitorID, HotelID, RoomTypeID, CheckInDate, CheckOutDate, 
         NumberOfGuests, PricePerNight, TotalCost, BookingStatus, BookingDate)
Primary Key: BookingID
Foreign Keys: VisitorID → Visitors, HotelID → Hotels, RoomTypeID → RoomTypes
```

**1NF Compliance:** ✅ PASS

**2NF Compliance:** ✅ PASS

**3NF Compliance:** 🔍 CRITICAL ANALYSIS

**Issue: TotalCost is a Derived Attribute**

**Formula:** TotalCost = PricePerNight × (CheckOutDate - CheckInDate)

**3NF Violation?** YES
- TotalCost depends on PricePerNight, CheckOutDate, CheckInDate (non-key attributes)
- This is a **computed field**, creating a transitive functional dependency

**Normalization Theory says:** Remove TotalCost, calculate in queries

**Our Team Decision:** **KEEP** TotalCost (intentional denormalization)

**Justification:**

1. **Performance:**
   - TotalCost is queried frequently (revenue reports, KPIs)
   - Computing on-the-fly adds latency: `SUM(PricePerNight * DATEDIFF(CheckOutDate, CheckInDate))`
   - Precomputed value enables faster aggregations

2. **Data Integrity:**
   - In tourism industry, booking costs are **immutable** after confirmation
   - Price locked at booking time, cannot be changed
   - No risk of TotalCost becoming inconsistent with price/dates

3. **Historical Accuracy:**
   - If room prices change, old bookings retain original cost
   - Recomputing from current PricePerNight would be incorrect
   - TotalCost preserves historical transaction values

4. **Application Logic:**
   - Application validates: TotalCost = PricePerNight × nights before insert
   - Database constraint (if implemented): CHECK TotalCost = PricePerNight * DATEDIFF(...)
   - Reduces business logic complexity in reporting layer

**Trade-off Accepted:**
- **Benefit:** Query performance, data integrity, historical accuracy
- **Cost:** 8 bytes per booking for redundant decimal field
- **Risk Mitigation:** Application-level validation, immutable booking policy

**Conclusion:** Bookings table is in 2NF with **intentional violation of 3NF** for TotalCost, fully documented and justified.

---

### Table 7: Expenditures

**Current Structure:**
```
Expenditures(ExpenditureID, VisitorID, RegionID, Category, Amount, ExpenditureDate, 
             Description, CreatedAt)
Primary Key: ExpenditureID
Foreign Keys: VisitorID → Visitors, RegionID → Regions
```

**1NF Compliance:** ✅ PASS

**2NF Compliance:** ✅ PASS

**3NF Compliance:** ✅ PASS
- All attributes depend directly on ExpenditureID
- Category, Amount, Date describe the expenditure itself
- No transitive dependencies

**Conclusion:** Expenditures table is in 3NF.

---

## Summary of Normalization Status

| Table | 1NF | 2NF | 3NF | Notes |
|-------|-----|-----|-----|-------|
| Regions | ✅ | ✅ | ✅ | Fully normalized |
| Hotels | ✅ | ✅ | ⚠️ | Address denormalization accepted |
| Visitors | ✅ | ✅ | ✅ | Fully normalized |
| RoomTypes | ✅ | ✅ | ✅ | Fully normalized |
| Seasons | ✅ | ✅ | ✅ | Fully normalized |
| Bookings | ✅ | ✅ | ⚠️ | TotalCost denormalization justified |
| Expenditures | ✅ | ✅ | ✅ | Fully normalized |

**Overall Assessment:** 
- 5 tables in strict 3NF
- 2 tables with intentional, documented denormalizations
- All denormalizations have clear business justifications

---

## Denormalization Decisions Summary

### Decision 1: Keep Address Components Together (Hotels)
**Fields:** City, ZipCode in same table  
**Rationale:** Practical convenience, minimal update risk  
**Alternative Considered:** Separate Locations table  
**Rejected Because:** Over-engineering for this use case  

### Decision 2: Keep TotalCost in Bookings
**Field:** TotalCost (computed from PricePerNight × nights)  
**Rationale:** Performance, historical accuracy, immutability  
**Alternative Considered:** Calculate in queries/views  
**Rejected Because:** Performance penalty, loses historical context  

---

## Changes from Week 4 Schema

### Modifications Made for 3NF:

1. **Removed RegionName from Bookings** (transitive dependency)
   - Was considering adding for query convenience
   - Correctly removed; use JOIN instead

2. **Validated VisitorType independence**
   - Confirmed not derivable from Country alone
   - Explicitly stored by design

3. **Confirmed no HotelName in Bookings**
   - Already correct in Week 4 design
   - No changes needed

4. **Added CHECK constraints** (to be implemented in SQL)
   - BookingStatus IN ('Confirmed', 'Cancelled', 'Completed')
   - CheckOutDate > CheckInDate
   - PricePerNight > 0
   - Age >= 0 AND Age <= 120

---

## Instructor Feedback Integration

**Feedback Received:** (awaiting Week 4 review)

**Anticipated Questions:**
1. Why keep TotalCost if it's derivable?
   - **Answer:** See detailed justification in Bookings analysis above
   
2. Should VisitorType be in a separate table?
   - **Answer:** No, it's an attribute of the visitor, not a separate entity
   
3. Is 7 tables sufficient complexity?
   - **Answer:** Yes, covers all required relationships; can add HotelRoomPricing if requested

---

## Next Steps (Week 6)

1. Implement schema in SQL with all constraints
2. Add CHECK constraints for data validation
3. Create indexes on foreign keys and frequently queried fields
4. Test with sample data insertion
5. Validate that queries perform efficiently with denormalized TotalCost

---

## References

- Silberschatz, A., Korth, H. F., & Sudarshan, S. (2019). *Database System Concepts* (7th ed.). Chapter 7: Relational Database Design.
- Date, C. J. (2004). *An Introduction to Database Systems* (8th ed.). Chapter 11: Further Normalization.
- Course Homework 1: Normalization requirements and examples
- Week 4 lecture: 3NF principles and practical trade-offs

---

**Document Status:** Completed  
**Approval:** Team reviewed and approved (Week 5 Monday meeting)  
**Next Review:** Week 6 after SQL implementation
