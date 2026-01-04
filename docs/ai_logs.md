# AI Interaction Logs - ECON485 Project 3
## Tourism Revenue & Visitor Trends Database

**Team 3 - Fall 2025**  
**Documentation Lead:** [Member 4]

---

## Purpose of This Document

This log records all interactions with AI tools used during the project, including:
- The prompts/questions we asked
- AI responses (summarized or key excerpts)
- Our verification process
- Corrections or modifications made
- Learning outcomes

This aligns with the course's "fail-forward AI learning" approach, documenting both successes and errors.

---

## Week 3: Initial Planning & Research

### Interaction #1: Tourism Database Research
**Date:** Monday, Week 3  
**Tool:** Perplexity AI  
**Team Member:** Member 3 (Economic Analyst)

**Prompt:**
```
What are the standard entities and relationships in a tourism revenue tracking database? 
What KPIs do tourism boards typically measure?
```

**AI Response Summary:**
- Standard entities: Destinations, Accommodations, Visitors, Bookings, Activities
- Common KPIs: Occupancy rates, Average Daily Rate (ADR), Revenue Per Available Room (RevPAR), Length of Stay, Visitor demographics
- Recommended tracking seasonal patterns and visitor origin (domestic vs international)
- Suggested including expenditure categories beyond accommodation (food, shopping, activities)

**Verification Process:**
- Cross-referenced with World Tourism Organization (UNWTO) statistics portal
- Checked academic literature on tourism economics
- Confirmed these align with real-world tourism board practices

**Team Decision:**
- ✅ Adopted suggested entity structure
- ✅ Included KPIs in our project definition
- ✅ Added expenditure categories as separate tracking
- ⚠️ Modified "Destinations" to "Regions" for clarity in our context

**Learning Outcome:**
AI provided excellent starting point; we validated against authoritative sources rather than blindly accepting.

---

### Interaction #2: Entity Relationship Validation
**Date:** Tuesday, Week 3  
**Tool:** ChatGPT (GPT-4)  
**Team Member:** Member 1 (Project Lead)

**Prompt:**
```
I'm designing a database for a tourism board to track:
- Multiple regions
- Hotels in each region
- Visitors booking hotels
- Visitor spending beyond hotels

What entities and relationships should I include? 
Should I use a separate Payments table or integrate with Bookings?
```

**AI Response (Excerpted):**
```
Recommended Entities:
1. Regions (RegionID, Name, Country)
2. Hotels (HotelID, Name, RegionID FK, StarRating, TotalRooms)
3. Visitors (VisitorID, Name, Country, Age)
4. Bookings (BookingID, VisitorID FK, HotelID FK, CheckIn, CheckOut, TotalCost)
5. Payments (PaymentID, BookingID FK, Amount, PaymentDate, Method)

For spending beyond hotels, consider:
6. AdditionalExpenses (ExpenseID, VisitorID FK, Category, Amount, Date)

Relationships:
- Regions 1:N Hotels
- Hotels 1:N Bookings
- Visitors 1:N Bookings
- Bookings 1:N Payments (if allowing installments)
- Visitors 1:N AdditionalExpenses
```

**Verification Process:**
- Reviewed normalization rules (separate payment records makes sense if multiple payments per booking)
- Discussed with team: Do we need payment method tracking?
- Analyzed: Payment vs. Expenditure naming

**Corrections Made:**
- ❌ Rejected separate "Payments" table for Bookings - in our use case, booking TotalCost is sufficient (no installments)
- ✅ Renamed "AdditionalExpenses" to "Expenditures" for broader scope
- ✅ Added Category field to Expenditures (food, activities, shopping, transport)
- ✅ Added RoomTypes entity (AI didn't suggest, but we identified need for room categorization)

**Why We Made Changes:**
- Simpler schema focuses on tourism analytics, not payment processing
- "Expenditures" is more formal economic terminology
- Room types enable richer pricing analysis

**Learning Outcome:**
AI provided solid foundation, but team's domain knowledge (economics + tourism) led to important refinements. This demonstrates critical AI usage.

---

### Interaction #3: Seasonal Tourism Patterns Research
**Date:** Wednesday, Week 3  
**Tool:** Perplexity AI  
**Team Member:** Member 3 (Economic Analyst)

**Prompt:**
```
How do tourism databases typically model seasonal patterns? 
Should seasons be a separate entity or derived from dates?
```

**AI Response Summary:**
- Two approaches: 
  1. Separate Seasons table (Peak, Shoulder, Off-Season) with date ranges
  2. Derived classification using CASE statements in queries
- Advantage of separate table: Easier reporting and consistent classification
- Advantage of derived: No redundant data, more flexible
- Recommended: Separate table if seasons have distinct pricing or marketing strategies

**Verification Process:**
- Researched hotel industry practices: Most use seasonal pricing tiers
- Checked SQL query complexity for both approaches
- Consulted with team on reporting needs

**Team Decision:**
- ✅ Implemented Seasons as separate entity
- ✅ Defined SeasonID, SeasonName, StartMonth, EndMonth
- ⚠️ Added YearApplicable field (AI didn't suggest) because seasonal patterns can shift year-to-year

**Additional Consideration:**
We'll create a derived relationship between Bookings and Seasons based on CheckInDate for flexible querying.

**Learning Outcome:**
AI presented trade-offs clearly; team chose based on business requirements (pricing analysis). Adding YearApplicable shows we're thinking beyond AI's initial suggestion.

---

## Week 4: Schema Design & ER Diagram

### Interaction #4: ER Diagram Tool Selection
**Date:** Monday, Week 4  
**Tool:** ChatGPT  
**Team Member:** Member 1 (Project Lead)

**Prompt:**
```
What are the best free tools for creating ER diagrams for a course project? 
I need something that exports to PNG and integrates with GitHub.
```

**AI Response (Summarized):**
1. **dbdiagram.io** - Simple syntax, exports PNG/PDF, shareable links
2. **draw.io** - More control, GitHub integration
3. **Lucidchart** - Professional, but limited free tier
4. **MySQL Workbench** - Integrated with database, can reverse-engineer schema

**Verification Process:**
- Tested dbdiagram.io with sample entities
- Checked export quality and ease of use
- Confirmed it meets course requirements

**Team Decision:**
- ✅ Selected dbdiagram.io for initial ER diagram (Week 4)
- Plan to use MySQL Workbench later for schema implementation (Week 6)

**Learning Outcome:**
AI provided multiple options with trade-offs. Quick testing validated dbdiagram.io as best fit for our needs.

---

### Interaction #5: Index Optimization Suggestions
**Date:** Tuesday, Week 4  
**Tool:** ChatGPT  
**Team Member:** Member 2 (Data Analyst)

**Prompt:**
```
For a tourism database with these tables:
- Regions, Hotels, Visitors, Bookings, Expenditures

What indexes should I create for optimal query performance? 
We'll be querying:
1. Hotels by region
2. Bookings by date range
3. Visitor spending by category
4. Average occupancy by hotel
```

**AI Response (Key Recommendations):**
```sql
-- Suggested Indexes:

-- For Hotels table
CREATE INDEX idx_hotels_region ON Hotels(RegionID);

-- For Bookings table
CREATE INDEX idx_bookings_dates ON Bookings(CheckInDate, CheckOutDate);
CREATE INDEX idx_bookings_hotel ON Bookings(HotelID);
CREATE INDEX idx_bookings_visitor ON Bookings(VisitorID);

-- For Expenditures table
CREATE INDEX idx_expenditures_category ON Expenditures(Category);
CREATE INDEX idx_expenditures_region ON Expenditures(RegionID);
CREATE INDEX idx_expenditures_visitor ON Expenditures(VisitorID);

-- Composite indexes for common queries
CREATE INDEX idx_bookings_hotel_dates ON Bookings(HotelID, CheckInDate);
```

**Verification Process:**
- Reviewed MySQL index documentation
- Analyzed query patterns from our KPI requirements
- Considered index maintenance overhead vs. query performance

**Corrections/Additions Made:**
- ✅ Accepted all suggested indexes
- ✅ Added: `CREATE INDEX idx_visitors_country ON Visitors(Country)` - needed for demographic analysis
- ✅ Added: `CREATE INDEX idx_hotels_starrating ON Hotels(StarRating)` - for quality-based filtering

**Why Additional Indexes:**
AI focused on FK relationships, but we identified additional filtering patterns based on our specific KPIs.

**Learning Outcome:**
AI provided solid baseline; domain-specific requirements (visitor demographics, hotel quality filtering) drove additional indexes. This shows we're thinking critically about our queries.

---

### Interaction #6: Normalization Check
**Date:** Wednesday, Week 4  
**Tool:** ChatGPT  
**Team Member:** Member 1 (Project Lead)

**Prompt:**
```
Review this schema for 3NF compliance:

Bookings(BookingID, VisitorID, HotelID, RoomTypeID, CheckInDate, CheckOutDate, 
         PricePerNight, TotalCost, HotelName, RegionName)

Is this normalized? If not, what changes are needed?
```

**AI Response:**
```
❌ NOT in 3NF. Issues:

1. HotelName depends on HotelID (transitive dependency)
   - Violates 3NF: Non-key attribute (HotelName) depends on another non-key (HotelID)
   - Solution: Remove HotelName, join Hotels table when needed

2. RegionName depends on HotelID (transitive dependency)
   - Hotels belong to Regions, so RegionName should be in Regions table
   - Solution: Remove RegionName from Bookings

3. TotalCost can be derived from PricePerNight * nights
   - This is a computed field, creates update anomalies
   - Decision: Either remove OR keep for performance (materialized value)

Corrected Schema:
Bookings(BookingID, VisitorID, HotelID, RoomTypeID, CheckInDate, CheckOutDate, 
         PricePerNight, TotalCost)

Queries for names:
SELECT b.*, h.HotelName, r.RegionName
FROM Bookings b
JOIN Hotels h ON b.HotelID = h.HotelID
JOIN Regions r ON h.RegionID = r.RegionID
```

**Verification Process:**
- Reviewed normalization theory from course materials
- Checked Homework 1 normalization requirements
- Discussed computed field trade-off with team

**Team Decision:**
- ✅ Removed HotelName and RegionName from Bookings (transitive dependency violation confirmed)
- ⚠️ Kept TotalCost as denormalized field - RATIONALE: Frequent queries need this; worth the redundancy for performance
- ✅ Will validate TotalCost = PricePerNight * (CheckOutDate - CheckInDate) in application logic

**Learning Outcome:**
AI correctly identified 3NF violations. We made informed decision to keep TotalCost despite denormalization, understanding the trade-off (performance vs. update complexity). This shows mature database design thinking.

---

### Interaction #7: Sample Data Generation Strategy
**Date:** Thursday, Week 4  
**Tool:** ChatGPT + Python Script  
**Team Member:** Member 2 (Data Analyst)

**Prompt:**
```
Write a Python script to generate sample tourism data:
- 10 regions
- 50 hotels (distributed across regions)
- 1000 visitors
- 3000 bookings over 2 years
- Realistic seasonal patterns (more bookings in summer/winter holidays)
```

**AI Response:**
Provided 200-line Python script using `faker` library and `random` module with seasonal probability distributions.

**Verification Process:**
- Ran script, generated CSV files
- Checked data distribution: 
  - ✅ All regions have hotels
  - ✅ Booking dates show seasonal peaks
  - ✅ No logical errors (CheckOut > CheckIn)
  - ❌ Some visitors have 0 bookings (unrealistic)
  
**Corrections Made:**
- Modified script to ensure every visitor has at least 1 booking
- Added more realistic visitor country distribution (80% domestic, 20% international)
- Adjusted price ranges based on StarRating correlation

**Code Snippet (Corrected):**
```python
# AI-generated (then modified)
def generate_bookings(visitors, hotels, num_bookings=3000):
    bookings = []
    visitor_ids = [v['VisitorID'] for v in visitors]
    
    # MODIFICATION: Ensure each visitor has at least one booking
    for visitor_id in visitor_ids:
        hotel = random.choice(hotels)
        # ... generate booking for this visitor
        bookings.append(booking)
    
    # Then generate remaining random bookings
    # ... (rest of AI-generated code)
```

**Learning Outcome:**
AI provided functional script, but testing revealed edge case (visitors without bookings). We debugged and improved. This is exactly the "fail-forward" learning the course emphasizes.

---

## Summary of Week 3-4 AI Usage

### Tools Used:
1. **Perplexity AI** - Industry research, best practices
2. **ChatGPT** - Schema design, query suggestions, code generation
3. **dbdiagram.io** - ER diagram visualization

### Success Rate:
- **Helpful AI outputs:** 7/7 (100%)
- **Outputs used without modification:** 2/7 (29%)
- **Outputs requiring corrections:** 5/7 (71%)

### Key Corrections Made:
1. Renamed "AdditionalExpenses" → "Expenditures"
2. Removed "Payments" table (unnecessary for our use case)
3. Added RoomTypes entity (AI didn't suggest)
4. Added YearApplicable to Seasons (future-proofing)
5. Fixed sample data generation (visitor booking coverage)
6. Conscious choice to keep TotalCost despite denormalization

### Learning Insights:
- **AI Strength:** Providing starting points, suggesting best practices, generating boilerplate code
- **AI Weakness:** Understanding specific project requirements, domain nuances, edge cases
- **Our Role:** Critical evaluation, domain expertise, testing and validation, thoughtful modifications

### Fail-Forward Examples:
1. **Initial AI suggestion** (Payments table) → **Team correction** (unnecessary complexity)
2. **AI-generated data script** (some visitors with 0 bookings) → **Debugged and fixed**
3. **AI schema** (included redundant fields) → **Normalized to 3NF with informed trade-offs**

---

## Upcoming AI Usage Plans (Week 5+)

- **Week 5:** Use SQLAI (HuggingFace) for text-to-SQL query validation
- **Week 6:** GitHub Copilot for SQL boilerplate generation
- **Week 10:** DataMagic for complex JOIN query verification
- **Week 11:** ExplainMySQL for performance optimization analysis

All interactions will continue to be logged in this document.

---

**Last Updated:** Week 4  
**Next Review:** Week 5 (after normalization complete)  
**Compiled By:** [Member 4] - Documentation Lead
