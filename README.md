# 📊 Internship Opportunity Analysis System

> A real-world SQL data analysis project uncovering hiring trends, skill demand,
> and market patterns from 500+ internship listings scraped from Internshala.

---

## 🧩 Problem Statement

The internship market is noisy. Students waste hours applying to roles without
understanding which skills are actually in demand, which sectors hire the most,
or when hiring peaks during the year.

This project answers those questions using nothing but **raw data and SQL**.

---

## 🎯 Objective

- Identify the **top in-demand skills** across internship listings
- Discover **peak hiring months** and seasonal patterns
- Analyze **stipend trends** across roles, locations, and sectors
- Understand which **industries and cities** offer the most opportunities
- Provide actionable insights for students optimizing their job search

---

## 🗂️ Dataset

| Property | Details |
|---|---|
| Source | Internshala (real internship listings) |
| Format | Excel (.xlsx) - `internship_final.xlsx` |
| Records | 500+ internship listings |
| Coverage | Multiple industries, cities, roles, and stipend ranges |

**Key columns include:**
- `role` - Internship title / position
- `company` - Hiring company name
- `location` - City / Remote
- `stipend` - Monthly stipend offered
- `duration` - Internship duration (weeks/months)
- `skills_required` - Skills listed in the posting
- `sector` - Industry/sector category
- `posted_date` - Date the listing was posted

---

## 🛠️ Tech Stack

| Tool | Purpose |
|---|---|
| **MySQL** | Database creation, querying, and analysis |
| **Excel** | Raw dataset storage and output visualization |
| **Git** | Version control |

---

## 📁 Project Structure
```
Internship-Opportunity-Analysis-System/
│
├── intershala_project.sql      # All SQL queries (schema + analysis)
├── internship_final.xlsx       # Raw dataset
└── README.md                   # Project documentation
```

---

## ⚙️ How to Run

**Step 1 - Clone the repository**
```bash
git clone https://github.com/JD1304/Internship-Opportunity-Analysis-System-SQL-Project-.git
cd Internship-Opportunity-Analysis-System-SQL-Project-
```

**Step 2 - Set up the database**
- Open **MySQL Workbench** or any MySQL client
- Create a new schema:
```sql
CREATE DATABASE internship_analysis;
USE internship_analysis;
```

**Step 3 - Import the data**
- Import `internship_final.xlsx` into MySQL as a table
- Or use the table creation + insert statements inside `intershala_project.sql`

**Step 4 - Run the queries**
- Open `intershala_project.sql` in your MySQL client
- Execute query blocks section by section to reproduce all findings

---

## 🔍 Key SQL Concepts Used

### 1. Multi-Table JOINs
Used to combine role, location, sector, and stipend data across
related tables to produce unified analytical views.
```sql
SELECT r.role_name, l.city, s.sector_name, i.stipend
FROM internships i
JOIN roles r ON i.role_id = r.id
JOIN locations l ON i.location_id = l.id
JOIN sectors s ON i.sector_id = s.id;
```

### 2. GROUP BY and Aggregations
Used to rank skills by frequency, calculate average stipends per
sector, and count listings by city and month.
```sql
SELECT sector_name, COUNT(*) AS total_listings,
       ROUND(AVG(stipend), 2) AS avg_stipend
FROM internships i
JOIN sectors s ON i.sector_id = s.id
GROUP BY sector_name
ORDER BY total_listings DESC;
```

### 3. Subqueries
Used to filter results dynamically — for example, finding all roles
that offer above-average stipends without hardcoding values.
```sql
SELECT role_name, stipend
FROM internships
WHERE stipend > (
    SELECT AVG(stipend) FROM internships
)
ORDER BY stipend DESC;
```

---

## 📈 Key Findings

| # | Insight | Finding |
|---|---|---|
| 1 | Top in-demand skill | Python appeared in 38% of all listings |
| 2 | Highest paying sector | Technology offered the highest avg stipend |
| 3 | Peak hiring month | March and September showed the highest listing volume |
| 4 | Most active city | Bangalore led with the highest number of postings |
| 5 | Most common duration | 2-month internships were the most frequently offered |
| 6 | Remote vs On-site | 45%+ of listings offered remote or hybrid options |

> Note: Findings are based on the dataset at the time of collection.
> Actual market conditions may vary.

---

## 💡 Business Impact

This analysis directly helps:
- **Students** - Know which skills to build and when to apply
- **Career counselors** - Back their advice with real market data
- **Recruiters** - Benchmark stipends and understand competition by sector

---

## 🚀 Future Enhancements

- [ ] Connect dataset to **Power BI** for interactive dashboard
- [ ] Automate data collection using Python web scraping
- [ ] Add **time-series analysis** for month-wise hiring trend charts
- [ ] Expand dataset to 2,000+ listings for stronger statistical confidence
- [ ] Build a student-facing **stipend calculator** based on role and city

---

## 👤 Author

**Jash Desai**
B.Tech Computer Engineering - NMIMS University, Mumbai

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-blue?style=flat&logo=linkedin)](https://linkedin.com)
[![GitHub](https://img.shields.io/badge/GitHub-Follow-black?style=flat&logo=github)](https://github.com/JD1304)
[![Email](https://img.shields.io/badge/Email-Contact-red?style=flat&logo=gmail)](mailto:jashdesai1304@gmail.com)

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

---

*If this project helped you, consider giving it a ⭐ on GitHub!*
