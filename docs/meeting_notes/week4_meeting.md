# ECON485 Project 3 - Meeting Notes: Week 4

**Meeting Date:** Friday, Week 4 (Fall 2025)  
**Meeting Type:** Project Definition Review & Finalization  
**Duration:** 2 hours  
**Location:** Library Study Room B

## 📋 Attendees

- ✅ Mert Ak�n - Project Lead
- ✅ [Member 2] - Data Analyst  
- ✅ [Member 3] - Economic Analyst
- ✅ [Member 4] - Documentation Lead

## 🎯 Meeting Objectives

1. Review and finalize 1-page project definition document
2. Complete initial ER diagram design
3. Validate AI-assisted schema against course requirements
4. Prepare for Stage 1 submission (due Sunday)
5. Plan Week 5 activities (normalization to 3NF)

---

## 📝 Discussion Summary

### 1. Project Definition Document Review

**Presented by:** Member 3 (Economic Analyst)

**Document Status:** Draft completed Wednesday, reviewed by all members Thursday

**Team Feedback:**

**Strengths Identified:**
- ✅ Clear business problem statement
- ✅ Comprehensive entity descriptions
- ✅ Good mix of financial, operational, and economic KPIs
- ✅ Use cases demonstrate practical applications

**Requested Revisions:**
- **Member 1:** Add StarRating attribute to Hotels entity description
  - **Action:** Added to entity list
  
- **Member 2:** Clarify relationship between Bookings and Seasons
  - **Action:** Added note about "derived relationship based on CheckInDate"
  
- **Member 4:** Expand AI interaction paragraph with specific example
  - **Action:** Added ChatGPT query validation example with correction made

**Final Approval:** ✅ Unanimous approval after revisions

---

### 2. ER Diagram Design Review

**Presented by:** Member 1 (Project Lead)

**Tool Used:** dbdiagram.io (as planned)

**Design Walkthrough:**

**Core Entities Confirmed:**
1. Regions (10 fields)
2. Hotels (11 fields)
3. Visitors (10 fields)
4. Bookings (11 fields)
5. Expenditures (8 fields)
6. Seasons (6 fields)
7. RoomTypes (4 fields)

**Relationships Validated:**
- Regions 1:N Hotels ✅
- Hotels 1:N Bookings ✅
- Visitors 1:N Bookings ✅
- Visitors 1:N Expenditures ✅
- Regions 1:N Expenditures ✅
- RoomTypes 1:N Bookings ✅

**Design Discussion Points:**

**Q: Should we add HotelRoomPricing table now or later?**
- Member 2: "It would enable dynamic pricing by season"
- Member 1: "Adds complexity; maybe Week 5 refinement?"
- **Decision:** Add as optional entity in ER diagram with note "to be implemented if time permits in Stage 2"

**Q: How to handle Seasons relationship with Bookings?**
- Member 3: "Seasons aren't directly linked; they're derived from CheckInDate"
- Member 2: "We could add SeasonID as FK in Bookings?"
- Member 1: "That creates redundancy; better to calculate in queries"
- **Decision:** Keep Seasons separate; use JOIN with date range matching in SQL queries

**Q: Do we need an Activities entity (tourist attractions)?**
- Member 4: "Could enrich analysis but adds scope"
- Member 3: "Let's focus on core entities first; Activities can be future enhancement"
- **Decision:** Document as "potential future enhancement" but not in initial schema

**Final ER Diagram Status:** ✅ Approved for submission

---

### 3. Normalization Pre-Check

**Led by:** Member 2 (Data Analyst)

**Objective:** Ensure we're on track for 3NF by Week 5

**Current Status:** 2NF with some 3NF compliance

**Normalization Issues Discussed:**

**Issue #1: TotalCost in Bookings table**
- **Problem:** TotalCost can be derived: PricePerNight × (CheckOutDate - CheckInDate)
- **3NF Violation?** Yes (derived attribute)
- **Discussion:**
  - Member 2: "Keeping it improves query performance"
  - Member 3: "Creates update anomaly if PricePerNight changes"
  - Member 1: "In tourism, prices are immutable after booking"
- **Decision:** Keep TotalCost as denormalized field; document trade-off rationale
- **Rationale:** Performance benefit outweighs theoretical purity; no practical update risk

**Issue #2: Potential transitive dependencies**
- **Checked:** Bookings → HotelID → RegionID
- **Confirmed:** No RegionName stored in Bookings ✅
- **Checked:** Visitors → Country → (implied continent/region)
- **Confirmed:** No derived geographic data in Visitors ✅

**Week 5 Plan:**
1. Formal 3NF analysis document
2. Eliminate any remaining partial dependencies
3. Document all intentional denormalizations with justification

---

### 4. Sample Data Strategy

**Presented by:** Member 2 (Data Analyst)

**Data Generation Approach:**

**Option 1: Manual CSV creation**
- Pros: Full control, realistic data
- Cons: Time-consuming, limited volume

**Option 2: Python script (AI-assisted)**
- Pros: Large volume, reproducible, seasonal patterns
- Cons: May need refinement for realism

**Team Decision:** Hybrid approach
1. Use AI-generated Python script for bulk data (Member 2 to develop Week 5)
2. Manually curate 5-10 "featured" examples for demo purposes
3. Ensure data quality: No orphaned records, realistic distributions

**Data Volume Targets:**
- 10 Regions
- 50 Hotels (5 per region average)
- 1,000 Visitors
- 3,000 Bookings (over 24 months: 2024-2025)
- 10,000 Expenditures (multiple per visitor)
- 3 Seasons (Peak, Shoulder, Off)
- 5 Room Types (Standard, Deluxe, Suite, Family, Presidential)

**Seasonal Distribution:**
- Peak (Jun-Aug, Dec-Jan): 50% of bookings
- Shoulder (Apr-May, Sep-Oct): 30% of bookings
- Off (Feb-Mar, Nov): 20% of bookings

---

### 5. GitHub Repository Organization

**Reviewed by:** Member 4 (Documentation Lead)

**Current Structure:**
```
ECON485-F25-Team3-Tourism/
├── /design (✅ created)
│   ├── ER_diagram_v1.png (✅ to upload today)
│   └── schema.sql (⏳ Week 5)
├── /data (✅ created)
├── /queries (✅ created)
├── /docs (✅ created)
│   ├── ai_logs.md (✅ completed through Week 4)
│   ├── meeting_notes/ (✅ created)
│   │   ├── week3_kickoff.md (✅ uploaded)
│   │   └── week4_finalization.md (🔄 this document)
│   └── presentations/ (✅ created)
└── README.md (✅ updated today)
```

**Git Activity This Week:**
- 15 commits across 4 branches
- All members have contributed
- No merge conflicts (good branching practice)

**Commit Message Quality Check:**
- ✅ Most messages are descriptive
- ⚠️ Member 3 has some vague commits ("update")
- **Action:** Reminded team of commit message standards

---

### 6. AI Tool Reflections

**Discussion Topic:** What worked well, what didn't?

**ChatGPT Feedback:**
- **Member 1:** "Very helpful for initial schema suggestions, but needed significant refinement"
- **Member 3:** "Excellent for KPI brainstorming and economic context"
- **Member 4:** "Generated good starting templates for documentation"

**Perplexity AI Feedback:**
- **Member 3:** "Better than ChatGPT for industry-specific research"
- **Member 2:** "Provided sources, which helped verify accuracy"

**dbdiagram.io Feedback:**
- **Member 1:** "Syntax is intuitive, exports cleanly"
- **Member 2:** "Wish it had better index visualization"

**Key Learning:**
- AI is excellent for **generating starting points**
- Human review is **essential** for domain accuracy
- **Testing** AI-generated code revealed important edge cases
- **Documentation** of AI interactions is time-consuming but valuable

**AI Usage Plan for Week 5:**
- Try SQLAI (HuggingFace) for text-to-SQL conversion
- Use GitHub Copilot for SQL boilerplate (if available to team)
- Continue logging all interactions

---

### 7. Stage 1 Submission Checklist

**Due:** Sunday, Week 4, 11:59 PM

**Required Deliverables:**

| Item | Status | Owner | Final Check |
|------|--------|-------|-------------|
| 1-page project definition (PDF) | ✅ Ready | Member 3 | Member 1 |
| Initial ER diagram (PNG) | ✅ Ready | Member 1 | Member 2 |
| GitHub repo structure | ✅ Complete | Member 1 | All |
| README.md updated | ✅ Complete | Member 4 | Member 1 |
| AI logs (Week 3-4) | ✅ Complete | Member 4 | Member 3 |
| Meeting notes (Week 3-4) | 🔄 In progress | Member 4 | Member 1 |
| Instructor invited to repo | ✅ Done | Member 1 | — |

**Submission Process:**
1. Member 1 creates `/deliverables/stage1/` folder in repo
2. Upload PDF and PNG files
3. Tag release: `v1.0-stage1-planning`
4. Share GitHub link with instructor via Slack
5. Confirm receipt by Monday morning

---

### 8. Week 5 Planning

**Focus:** Normalize schema to 3NF and begin SQL implementation

**Assigned Tasks:**

| Task | Owner | Deadline |
|------|-------|----------|
| Write normalization analysis document | Member 2 | Tuesday |
| Refine ER diagram based on 3NF | Member 1 | Wednesday |
| Create schema.sql (DDL statements) | Member 2 | Thursday |
| Generate sample data (Python script) | Member 2 | Thursday |
| Review and validate schema | All | Friday meeting |

**Week 5 Deliverables:**
- Updated ER diagram (ER_diagram_final.png)
- schema.sql with CREATE TABLE statements
- normalization_analysis.md documenting 3NF compliance

---

## ✅ Action Items

| # | Action | Owner | Due Date | Status |
|---|--------|-------|----------|--------|
| 1 | Upload final project definition PDF | Member 3 | Sun Week 4 | 🔄 |
| 2 | Upload ER diagram PNG | Member 1 | Sun Week 4 | 🔄 |
| 3 | Complete this meeting notes document | Member 4 | Sun Week 4 | 🔄 |
| 4 | Tag GitHub release v1.0-stage1-planning | Member 1 | Sun Week 4 | ⏳ |
| 5 | Notify instructor of submission | Member 1 | Sun Week 4 | ⏳ |
| 6 | Start normalization analysis | Member 2 | Mon Week 5 | ⏳ |
| 7 | Begin Python data generator script | Member 2 | Mon Week 5 | ⏳ |

---

## 🤔 Questions / Concerns

**Q: Is our entity count (7 tables) sufficient?**
- **A:** Yes, course requires "multiple entities"; 7 is good coverage. Can add HotelRoomPricing later if needed.

**Q: Are we on schedule?**
- **A:** Yes, Stage 1 deliverables are complete. On track for Week 5 normalization.

**Q: Should we start thinking about queries now?**
- **A:** Yes, informally. Week 5 focus is schema, but Week 6 is CRUD operations, so reviewing query patterns helps validate schema design.

---

## 📅 Next Meeting

**Date:** Monday, Week 5  
**Time:** 4:00 PM  
**Agenda:**
- Review Stage 1 submission status
- Present normalization analysis
- Discuss SQL schema draft
- Begin planning CRUD operations for Week 6

---

## 💡 Key Insights

1. **AI Tools are Powerful but Require Oversight:** Every AI suggestion needed team validation
2. **Economic Context Drives Design:** Our KPI requirements shaped entity structure
3. **Normalization is a Judgment Call:** We made conscious trade-off (TotalCost denormalization)
4. **Documentation Takes Time:** AI logs and meeting notes are valuable but time-intensive
5. **Team Collaboration is Essential:** Different perspectives (data, econ, tech) strengthen design

---

## 📚 Resources Referenced

- Course syllabus (normalization requirements)
- Homework 1 (ER diagram examples)
- UNWTO tourism statistics portal
- Database normalization theory (Silberschatz textbook)

---

**Meeting Adjourned:** 6:00 PM  
**Minutes Recorded By:** [Member 4] - Documentation Lead  
**Approved By:** Mert Ak�n - Project Lead  

**Next Steps:** Finalize Stage 1 submission, begin Week 5 normalization work.
