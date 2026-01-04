# ECON485 Fall 2025 - Project Definition
## Project 3: Tourism Revenue & Visitor Trends Database

**Team 3 Members:** Mert Ak�n, [Member 2], [Member 3], [Member 4]  
**Date:** Week 4, Fall 2025  
**Instructor:** ECON485 Course Instructor

---

## Business Problem Statement

Tourism boards and regional development agencies require comprehensive data systems to track visitor flows, accommodation demand, and economic impact across multiple destinations. Currently, tourism data is often fragmented across hotels, attractions, and payment systems, making it difficult to analyze seasonal patterns, optimize pricing strategies, or measure tourism's contribution to regional economies. This project develops a relational database that consolidates visitor demographics, hotel bookings, spending patterns, and regional characteristics to enable data-driven tourism policy and business decisions.

## Main Entities and Relationships

### Core Entities

**1. Regions** - Geographic tourist destinations (cities, provinces, resort areas)  
*Attributes:* RegionID (PK), RegionName, Country, RegionType (urban/coastal/rural), Population, GDP

**2. Hotels** - Accommodation facilities offering rooms to visitors  
*Attributes:* HotelID (PK), HotelName, RegionID (FK), StarRating, TotalRooms, Address, ContactInfo

**3. Visitors** - Individual tourists with demographic information  
*Attributes:* VisitorID (PK), FullName, Country, Age, VisitorType (domestic/international), Gender

**4. Bookings** - Reservation records linking visitors to hotels  
*Attributes:* BookingID (PK), VisitorID (FK), HotelID (FK), CheckInDate, CheckOutDate, RoomTypeID (FK), PricePerNight, TotalCost

**5. Expenditures** - Detailed spending records beyond accommodation  
*Attributes:* ExpenditureID (PK), VisitorID (FK), RegionID (FK), Category (food/activities/shopping/transport), Amount, ExpenditureDate

**6. Seasons** - Temporal classifications for seasonal analysis  
*Attributes:* SeasonID (PK), SeasonName (Peak/Shoulder/Off-Season), StartMonth, EndMonth, YearApplicable

**7. RoomTypes** - Categorization of hotel accommodations  
*Attributes:* RoomTypeID (PK), TypeName (Standard/Deluxe/Suite), BaseCapacity, Description

### Entity Relationships

- **Regions** (1) → (N) **Hotels**: Each region hosts multiple hotels
- **Hotels** (1) → (N) **Bookings**: Each hotel has multiple reservations
- **Visitors** (1) → (N) **Bookings**: Each visitor can make multiple bookings
- **Visitors** (1) → (N) **Expenditures**: Each visitor generates multiple spending records
- **Regions** (1) → (N) **Expenditures**: Spending occurs in specific regions
- **RoomTypes** (1) → (N) **Bookings**: Each booking specifies a room type
- **Seasons** (1) → (N) **Bookings**: Bookings occur within seasonal periods (derived relationship)

## Expected Key Performance Indicators (KPIs)

### Financial Metrics
1. **Average Spending Per Visitor** - Total expenditures divided by visitor count, segmented by region
2. **Revenue Per Available Room (RevPAR)** - Hotel revenue divided by total room inventory
3. **Regional Tourism Revenue** - Aggregate visitor spending by geographic area

### Operational Metrics
4. **Hotel Occupancy Rate** - Percentage of rooms booked vs. available, by season
5. **Average Length of Stay** - Mean duration of visitor bookings
6. **Peak Month Identification** - Month with highest visitor volume or revenue by hotel/region

### Demographic Insights
7. **Visitor Distribution by Origin** - Domestic vs. international tourist ratios
8. **Spending Patterns by Visitor Type** - Expenditure differences across demographics

### Economic Impact
9. **Seasonal Revenue Variation** - Comparison of peak, shoulder, and off-season performance
10. **Tourism Contribution to Regional Economy** - Tourism revenue as percentage of regional GDP

## Initial Use Cases

**Use Case 1: Tourism Board Strategic Planning**  
The regional tourism board queries the database to identify which regions attract the highest-spending visitors during off-season periods, informing targeted marketing campaigns.

**Use Case 2: Hotel Pricing Optimization**  
A hotel chain analyzes historical occupancy rates and competitor pricing to adjust room rates dynamically based on seasonal demand forecasts.

**Use Case 3: Infrastructure Investment Analysis**  
Government planners assess visitor density and spending patterns to prioritize infrastructure investments (airports, roads, attractions) in underserved but high-potential regions.

**Use Case 4: Economic Impact Reporting**  
Economists calculate tourism's contribution to regional employment and GDP by analyzing visitor spending across accommodation, dining, and activity categories.

## AI-Assisted Approach

**Tools Used:**
- **Perplexity AI:** Researched tourism industry database standards and KPI definitions
- **ChatGPT:** Validated entity relationships and suggested normalization improvements
- **dbdiagram.io:** Created initial Entity-Relationship diagram (see attached)

**AI Interaction Highlights:**
- Prompt to ChatGPT: "What entities should a tourism revenue tracking system include?"
- AI suggested: Regions, Hotels, Visitors, Bookings, Payments - validated our initial brainstorm
- Correction made: AI initially suggested "Payments" table; we refined to "Expenditures" with category breakdown for richer economic analysis

## Economic Relevance

This database supports microeconomic analysis of tourism markets, including:
- **Supply-Demand Dynamics:** Hotel pricing and occupancy reflect demand elasticity
- **Seasonal Labor Economics:** Employment patterns tied to peak tourism periods
- **Regional Development:** Tourism as engine for local economic growth
- **Consumer Behavior:** Spending patterns reveal preferences and willingness-to-pay

By aggregating micro-level transaction data, the system enables macroeconomic insights into tourism's role as an economic sector, informing both private business strategy and public policy.

---

**Deliverable Status:** Week 4 Initial Planning  
**Next Steps:** Normalize schema to 3NF (Week 5), Implement in SQL (Week 6)
