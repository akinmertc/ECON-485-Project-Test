// ECON485 Project 3: Tourism Revenue & Visitor Trends
// Initial ER Diagram - Week 4
// Use at: https://dbdiagram.io/

// ========================================
// TABLE DEFINITIONS
// ========================================

Table Regions {
  RegionID int [pk, increment]
  RegionName varchar(100) [not null]
  Country varchar(100) [not null]
  RegionType varchar(50) [note: 'urban, coastal, rural, mountain']
  Population int
  GDP decimal(15,2) [note: 'Regional GDP in millions']
  Description text
  CreatedAt timestamp [default: `CURRENT_TIMESTAMP`]
  
  Indexes {
    RegionName
    Country
  }
  
  Note: 'Geographic tourist destinations - cities, provinces, resort areas'
}

Table Hotels {
  HotelID int [pk, increment]
  HotelName varchar(200) [not null]
  RegionID int [ref: > Regions.RegionID, not null]
  StarRating decimal(2,1) [note: '1.0 to 5.0']
  TotalRooms int [not null]
  Address varchar(300)
  City varchar(100)
  ZipCode varchar(20)
  ContactPhone varchar(50)
  ContactEmail varchar(100)
  CreatedAt timestamp [default: `CURRENT_TIMESTAMP`]
  
  Indexes {
    RegionID
    StarRating
    HotelName
  }
  
  Note: 'Accommodation facilities offering rooms to visitors'
}

Table Visitors {
  VisitorID int [pk, increment]
  FirstName varchar(100) [not null]
  LastName varchar(100) [not null]
  Country varchar(100) [not null]
  Age int
  Gender varchar(20) [note: 'Male, Female, Other, PreferNotToSay']
  VisitorType varchar(50) [note: 'Domestic, International']
  Email varchar(100)
  Phone varchar(50)
  RegisteredDate timestamp [default: `CURRENT_TIMESTAMP`]
  
  Indexes {
    Country
    VisitorType
    (LastName, FirstName)
  }
  
  Note: 'Individual tourists with demographic information'
}

Table RoomTypes {
  RoomTypeID int [pk, increment]
  TypeName varchar(50) [not null, unique, note: 'Standard, Deluxe, Suite, Family, Presidential']
  BaseCapacity int [not null, note: 'Maximum occupancy']
  Description text
  
  Note: 'Categorization of hotel room types across all hotels'
}

Table Seasons {
  SeasonID int [pk, increment]
  SeasonName varchar(50) [not null, note: 'Peak, Shoulder, Off-Season']
  StartMonth int [not null, note: '1-12']
  EndMonth int [not null, note: '1-12']
  YearApplicable int [note: 'Applicable year if patterns change']
  Description text
  
  Note: 'Temporal classifications for seasonal tourism analysis'
}

Table Bookings {
  BookingID int [pk, increment]
  VisitorID int [ref: > Visitors.VisitorID, not null]
  HotelID int [ref: > Hotels.HotelID, not null]
  RoomTypeID int [ref: > RoomTypes.RoomTypeID, not null]
  CheckInDate date [not null]
  CheckOutDate date [not null]
  NumberOfGuests int [default: 1]
  PricePerNight decimal(10,2) [not null]
  TotalCost decimal(10,2) [not null]
  BookingStatus varchar(50) [default: 'Confirmed', note: 'Confirmed, Cancelled, Completed']
  BookingDate timestamp [default: `CURRENT_TIMESTAMP`]
  
  Indexes {
    VisitorID
    HotelID
    CheckInDate
    CheckOutDate
    (CheckInDate, CheckOutDate)
  }
  
  Note: 'Reservation records linking visitors to hotels'
}

Table Expenditures {
  ExpenditureID int [pk, increment]
  VisitorID int [ref: > Visitors.VisitorID, not null]
  RegionID int [ref: > Regions.RegionID, not null]
  Category varchar(50) [not null, note: 'Accommodation, Food, Activities, Shopping, Transportation, Other']
  Amount decimal(10,2) [not null]
  ExpenditureDate date [not null]
  Description varchar(300)
  CreatedAt timestamp [default: `CURRENT_TIMESTAMP`]
  
  Indexes {
    VisitorID
    RegionID
    Category
    ExpenditureDate
  }
  
  Note: 'Detailed spending records beyond accommodation costs'
}

// Optional: Linking table for hotel-specific room type pricing
Table HotelRoomPricing {
  PricingID int [pk, increment]
  HotelID int [ref: > Hotels.HotelID, not null]
  RoomTypeID int [ref: > RoomTypes.RoomTypeID, not null]
  SeasonID int [ref: > Seasons.SeasonID, not null]
  PricePerNight decimal(10,2) [not null]
  AvailableRooms int [not null]
  
  Indexes {
    (HotelID, RoomTypeID, SeasonID) [unique]
  }
  
  Note: 'Dynamic pricing based on hotel, room type, and season'
}

// ========================================
// RELATIONSHIP NOTES
// ========================================

// One Region has Many Hotels
// One Hotel has Many Bookings
// One Visitor makes Many Bookings
// One RoomType is used in Many Bookings
// One Visitor generates Many Expenditures
// One Region receives Many Expenditures

// Derived Relationships:
// Bookings can be classified by Season based on CheckInDate
// Hotels belong to Regions, so Bookings indirectly relate to Regions

// ========================================
// CARDINALITY SUMMARY
// ========================================

// Regions (1) ---> (N) Hotels
// Hotels (1) ---> (N) Bookings
// Visitors (1) ---> (N) Bookings
// RoomTypes (1) ---> (N) Bookings
// Visitors (1) ---> (N) Expenditures
// Regions (1) ---> (N) Expenditures
// Hotels (1) ---> (N) HotelRoomPricing
// RoomTypes (1) ---> (N) HotelRoomPricing
// Seasons (1) ---> (N) HotelRoomPricing

// ========================================
// BUSINESS RULES (to be enforced)
// ========================================

// 1. CheckOutDate must be after CheckInDate
// 2. PricePerNight and TotalCost must be positive
// 3. StarRating must be between 1.0 and 5.0
// 4. Age must be >= 0 and <= 120 (if provided)
// 5. TotalCost = PricePerNight * (CheckOutDate - CheckInDate)
// 6. NumberOfGuests <= RoomType.BaseCapacity

// ========================================
// SAMPLE QUERIES TO IMPLEMENT
// ========================================

// Q1: Average spending per visitor per region
// Q2: Peak month by hotel (highest occupancy or revenue)
// Q3: Occupancy rate by season
// Q4: Revenue per available room (RevPAR)
// Q5: Visitor demographic distribution
// Q6: Regional tourism revenue comparison
// Q7: Length of stay analysis
// Q8: Seasonal revenue patterns

// ========================================
// NORMALIZATION STATUS
// ========================================

// Current Design: 2NF (partial 3NF)
// Week 5 Goal: Full 3NF compliance
// Potential Issues to Address:
// - Derived attributes (TotalCost can be calculated)
// - Seasonal classification logic needs refinement
// - Consider separate Address table if many hotels share locations

// ========================================
// AI TOOL USAGE LOG
// ========================================

// Tool: dbdiagram.io
// Purpose: Visual ER diagram generation
// Result: Successfully created initial schema visualization

// Tool: ChatGPT
// Prompt: "Suggest optimal indexes for tourism database queries"
// Response: Recommended composite indexes on (CheckInDate, CheckOutDate)
//           and separate indexes on foreign keys
// Validation: Accepted recommendation, added to schema

// ========================================
// END OF INITIAL ER DIAGRAM
// ========================================