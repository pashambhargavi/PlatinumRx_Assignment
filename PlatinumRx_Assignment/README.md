# PlatinumRx Data Analyst Assignment

> **Author:** [Your Name]  
> **Date:** April 2026  
> **Role Applied For:** Data Analyst

---

## 📁 Repository Structure

```
PlatinumRx_Assignment/
│
├── SQL/
│   ├── 01_Hotel_Schema_Setup.sql    ← Tables + seed data for Hotel system
│   ├── 02_Hotel_Queries.sql         ← Answers to Part A Q1–Q5
│   ├── 03_Clinic_Schema_Setup.sql   ← Tables + seed data for Clinic system
│   └── 04_Clinic_Queries.sql        ← Answers to Part B Q1–Q5
│
├── Spreadsheets/
│   └── Ticket_Analysis.xlsx         ← 4-sheet workbook (ticket, feedbacks,
│                                        analysis, documentation)
│
├── Python/
│   ├── 01_Time_Converter.py         ← Minutes → "X hrs Y minutes"
│   └── 02_Remove_Duplicates.py      ← Remove duplicate chars using a loop
│
└── README.md                        ← This file
```

---

## Phase 1 – SQL Proficiency

### How to Run

1. Open **MySQL Workbench** (or any MySQL-compatible tool; queries also include SQLite alternatives as comments).
2. Run `01_Hotel_Schema_Setup.sql` first — creates tables and inserts sample data.
3. Run `02_Hotel_Queries.sql` — execute each query block individually to see results.
4. Repeat: run `03_Clinic_Schema_Setup.sql`, then `04_Clinic_Queries.sql`.

> For Clinic Q4 and Q5 set the variables at the top of the file:
> ```sql
> SET @TARGET_YEAR  = 2021;
> SET @TARGET_MONTH = 11;   -- change as needed
> ```

### Part A – Hotel System (Questions 1–5)

| Q# | Technique Used | Key Idea |
|----|---------------|----------|
| Q1 | Correlated subquery | Find MAX booking_date per user, retrieve room_no |
| Q2 | 3-table JOIN + GROUP BY | `SUM(quantity × rate)` for Nov 2021 bookings |
| Q3 | JOIN + GROUP BY + HAVING | Same as Q2 but for Oct 2021 and bill > 1000 |
| Q4 | CTE + RANK() window function | Most/least ordered item per month by quantity |
| Q5 | CTE + DENSE_RANK() | Customer with 2nd-highest bill per month |

### Part B – Clinic System (Questions 1–5)

| Q# | Technique Used | Key Idea |
|----|---------------|----------|
| Q1 | GROUP BY + SUM | Revenue per `sales_channel` |
| Q2 | JOIN + GROUP BY + ORDER + LIMIT 10 | Top 10 customers by total spend |
| Q3 | Two CTEs + LEFT JOIN | Month-wise revenue vs expense; Profit/Loss flag |
| Q4 | CTEs + RANK() PARTITION BY city | Most profitable clinic per city for a month |
| Q5 | CTEs + DENSE_RANK() PARTITION BY state | 2nd least profitable clinic per state |

---

## Phase 2 – Spreadsheet Proficiency

### File: `Spreadsheets/Ticket_Analysis.xlsx`

| Sheet | Contents |
|-------|----------|
| **ticket** | Raw ticket data (10 sample rows) |
| **feedbacks** | Feedback data; col D auto-populated via formula |
| **analysis** | Helper columns (Same Day?, Same Hour?) + outlet summary |
| **documentation** | Formula-by-formula explanation |

### Question 1 – Populate `ticket_created_at`

Formula used in `feedbacks!D2` (copied down):
```excel
=IFERROR(INDEX(ticket!B:B, MATCH(A2, ticket!E:E, 0)), "Not Found")
```
**Why INDEX+MATCH instead of VLOOKUP?**  
VLOOKUP requires the lookup column to be the *leftmost* column of the range.  
`cms_id` is in column E of the ticket sheet while `created_at` is in column B — INDEX+MATCH handles this without reordering columns.

### Question 2 – Same Day and Same Hour Counts

**Same Day helper column:**
```excel
=IF(INT(C3)=INT(D3), "Yes", "No")
```
`INT()` strips the decimal (time) portion from Excel's datetime serial number, leaving only the date integer.

**Same Hour helper column:**
```excel
=IF(AND(INT(C3)=INT(D3), HOUR(C3)=HOUR(D3)), "Yes", "No")
```
Both same-day AND same-hour conditions must be true.

**Outlet summary (COUNTIFS):**
```excel
=COUNTIFS($B$3:$B$12, A14, $E$3:$E$12, "Yes")
```
Counts rows per outlet where the condition (same day / same hour) is "Yes".

---

## Phase 3 – Python Proficiency

### How to Run

**Requirements:** Python 3.x (no external libraries needed)

```bash
# Time Converter
python Python/01_Time_Converter.py

# Remove Duplicates
python Python/02_Remove_Duplicates.py
```

### Question 1 – Time Conversion

```python
hours          = total_minutes // 60   # integer division
remaining_mins = total_minutes  % 60   # modulo for remainder
```

| Input | Output |
|-------|--------|
| 130 | 2 hrs 10 minutes |
| 110 | 1 hr 50 minutes |
| 60  | 1 hr |
| 45  | 45 minutes |

### Question 2 – Remove Duplicates (using a loop)

```python
result = ""
for char in input_string:
    if char not in result:   # check before adding
        result += char
```

| Input | Output |
|-------|--------|
| "programming" | "progamin" |
| "aabbcc" | "abc" |
| "hello world" | "helo wrd" |

---

## Assumptions

- SQL queries target **MySQL 8+** (window functions supported). SQLite alternatives are provided as comments.
- Sample data is synthetic but realistic enough to exercise all query scenarios (ensuring bills > 1000 exist in Oct 2021, multiple users per month, etc.).
- For the spreadsheet, dates are stored as text strings in sample data; Excel date serial arithmetic works when cells are formatted as datetime.
- Python scripts are vanilla Python 3 with no third-party dependencies.
