# ECON485 Project 3 - Meeting Notes: Week 3

**Meeting Date:** Monday, Week 3 (Fall 2025)  
**Meeting Type:** Initial Team Kickoff  
**Duration:** 90 minutes  
**Location:** Library Study Room B / Zoom Hybrid

## 📋 Attendees

- ✅ Mert Ak�n - Project Lead
- ✅ [Member 2] - Data Analyst  
- ✅ [Member 3] - Economic Analyst
- ✅ [Member 4] - Documentation Lead
- ✅ Instructor [via Slack] - Observing

## 🎯 Meeting Objectives

1. Understand Project 3 assignment requirements
2. Establish team roles and responsibilities
3. Set up communication channels and GitHub repository
4. Brainstorm initial project scope and entities
5. Plan Week 4 deliverables

---

## 📝 Discussion Summary

### 1. Project Overview & Assignment Review

**Topic:** Understanding Tourism Revenue & Visitor Trends Database

**Key Points Discussed:**
- Reviewed assignment document: tracking visitor numbers, hotel stays, and spending by region
- Identified primary goal: enable tourism board to make data-driven decisions
- Discussed real-world applications: seasonal planning, pricing strategies, infrastructure investment
- Examined KPIs: average spending per visitor, peak months, occupancy rates

**Economic Context Discussion:**
- Tourism is a major economic driver in many regions
- Seasonal patterns significantly impact employment and revenue
- Data analytics can inform policy decisions (infrastructure, marketing budgets)
- Hotels and regions compete for visitors - pricing and quality matter

**Questions Raised:**
- Q: Should we include international vs. domestic visitor distinction?
  - A: Yes, good idea for richer analysis
- Q: Do we need to track individual visitors or aggregate data?
  - A: Individual bookings, but can aggregate for reporting
- Q: What level of detail for expenditures (categories)?
  - A: At minimum: accommodation, food, activities, shopping

### 2. Team Roles Assignment

**Decided Structure:**

| Role | Member | Responsibilities |
|------|--------|------------------|
| **Project Lead** | Mert Ak�n | Coordination, GitHub management, final integration |
| **Data Analyst** | [Member 2] | Query development, SQL optimization, testing |
| **Economic Analyst** | [Member 3] | Business logic, KPI definitions, economic interpretation |
| **Documentation Lead** | [Member 4] | AI logs, meeting notes, presentation slides |

**Cross-functional:** All members contribute to schema design and attend all meetings.

### 3. Communication Setup

**Decisions Made:**
- ✅ Created WhatsApp group: "ECON485-Team3-Tourism"
- ✅ Instructor invited and accepted
- ✅ Primary communication: WhatsApp for quick updates, Zoom for weekly meetings
- ✅ Meeting schedule: 
  - Mondays 4:00 PM - Full team sync
  - Thursdays 2:00 PM - Progress check-in
  - Ad-hoc meetings as needed

**Communication Guidelines:**
- Response time expectation: within 24 hours
- Use @mentions for urgent items
- Share all AI tool outputs in group for review
- Document major decisions in meeting notes

### 4. GitHub Repository Setup

**Actions Completed:**
- ✅ Repository created: `ECON485-F25-Team3-Tourism`
- ✅ Folder structure established:
  ```
  /design, /data, /queries, /docs
  ```
- ✅ Initial README.md drafted
- ✅ All team members added as collaborators
- ✅ Instructor granted read access

**Git Workflow Agreed:**
- Main branch protected (requires pull request)
- Each member creates feature branches
- Commit messages must be descriptive
- Weekly merges during Monday meetings

### 5. Initial Project Scope Discussion

**Brainstorming Session - Entities Identified:**

**Core Entities (High Priority):**
1. **Regions** - Geographic areas (cities, provinces)
   - Attributes: RegionID, RegionName, Country, Type (urban/rural/coastal)
   
2. **Hotels** - Accommodation facilities
   - Attributes: HotelID, Name, StarRating, Address, RegionID, TotalRooms
   
3. **Visitors** - Tourist records
   - Attributes: VisitorID, Name, Country, Age, VisitorType (domestic/international)
   
4. **Bookings** - Reservation data
   - Attributes: BookingID, VisitorID, HotelID, CheckInDate, CheckOutDate, RoomType, PricePerNight
   
5. **Expenditures** - Spending records
   - Attributes: ExpenditureID, VisitorID, Category, Amount, Date, RegionID

**Supporting Entities (Medium Priority):**
6. **Seasons** - Temporal classification
   - Attributes: SeasonID, SeasonName (Peak/Shoulder/Off), StartMonth, EndMonth
   
7. **Room Types** - Hotel room categories
   - Attributes: RoomTypeID, TypeName (Standard/Deluxe/Suite), BasePrice, Capacity

**Optional Entities (Low Priority - if time permits):**
8. **Activities** - Tourist attractions/events
9. **Transportation** - Travel methods
10. **Reviews** - Visitor feedback

### 6. AI Tool Exploration

**Tools Tested During Meeting:**

**Perplexity AI:**
- Researched: "tourism board database structure best practices"
- Researched: "seasonal tourism patterns analysis methods"
- Output: Confirmed our entity list aligns with industry standards
- Learned: Most systems track "length of stay" as key metric

**ChatGPT Initial Test:**
- Prompt: "What entities should a tourism revenue database include?"
- Response: Suggested regions, hotels, tourists, bookings, payments
- Team Review: Aligned with our brainstorm, validated our approach

**Documented in:** `/docs/ai_logs.md` (to be created Week 4)

### 7. Week 4 Planning

**Deliverables Due Week 4:**
1. **1-Page Project Definition Document** (PDF)
   - Business problem statement
   - Entity list with descriptions
   - Initial use cases
   - Expected KPIs

2. **Initial ER Diagram** (using dbdiagram.io)
   - Core entities and relationships
   - Primary keys identified
   - Basic cardinalities (1:N, N:M)

**Task Assignments for Week 4:**

| Task | Assigned To | Deadline |
|------|-------------|----------|
| Draft project definition text | Member 3 (Economic Analyst) | Wednesday |
| Create initial ER diagram | Member 1 (Project Lead) | Thursday |
| Research sample tourism datasets | Member 2 (Data Analyst) | Thursday |
| Set up /docs folder structure | Member 4 (Documentation Lead) | Tuesday |
| Review & consolidate all inputs | All members | Friday (meeting) |
| Finalize and submit deliverables | Member 1 | Sunday evening |

---

## ✅ Action Items

| # | Action | Owner | Due Date | Status |
|---|--------|-------|----------|--------|
| 1 | Create GitHub repo and invite team | Member 1 | Week 3 | ✅ Done |
| 2 | Set up WhatsApp group and invite instructor | Member 1 | Week 3 | ✅ Done |
| 3 | Draft initial README.md | Member 1 | Week 3 | ✅ Done |
| 4 | Create folder structure in repo | All | Week 3 | ✅ Done |
| 5 | Write project definition draft | Member 3 | Wed Week 4 | 🔄 In Progress |
| 6 | Design initial ER diagram | Member 1 | Thu Week 4 | 🔄 In Progress |
| 7 | Research sample datasets | Member 2 | Thu Week 4 | 🔄 In Progress |
| 8 | Set up /docs structure | Member 4 | Tue Week 4 | 🔄 In Progress |

---

## 🤔 Questions / Concerns

1. **Data Volume:** How much sample data should we generate?
   - **Decision:** Start with ~1000 visitors, 50 hotels, 10 regions, expand if needed

2. **Time Period:** What date range for bookings?
   - **Decision:** 2 full years (2024-2025) to capture seasonal patterns

3. **Database Platform:** MariaDB vs. PostgreSQL?
   - **Decision:** Use MariaDB as specified in course materials

4. **AI Tool Limits:** How much can we rely on AI-generated code?
   - **Decision:** Always review and test; document all corrections

---

## 📅 Next Meeting

**Date:** Thursday, Week 3  
**Time:** 2:00 PM  
**Agenda:** 
- Progress check on Week 4 tasks
- Review project definition draft
- Preliminary ER diagram feedback

**Date:** Monday, Week 4  
**Time:** 4:00 PM  
**Agenda:**
- Finalize project definition document
- Complete ER diagram
- Prepare for submission

---

## 💡 Key Insights from Discussion

1. **Tourism seasonality** is central to our analysis - must be reflected in database design
2. **Visitor spending patterns** vary significantly by region and visitor type
3. **Hotel occupancy rates** are the primary KPI for accommodation sector
4. **Economic impact** extends beyond direct revenue (employment, infrastructure, local businesses)
5. Our database should enable **predictive analytics** for tourism planning

---

## 📚 Resources Identified

- World Tourism Organization (UNWTO) statistics portal
- National tourism board open datasets (for reference)
- Database design patterns for hospitality industry
- SQL for seasonal time-series analysis tutorials

---

**Meeting Adjourned:** 5:30 PM  
**Minutes Recorded By:** [Member 4] - Documentation Lead  
**Approved By:** Mert Ak�n - Project Lead  

**Next Steps:** Execute Week 4 task assignments, reconvene Thursday for progress check.
