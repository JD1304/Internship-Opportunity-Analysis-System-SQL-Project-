-- ============================
-- DATABASE CREATION
-- ============================


create database if not exists internshala_project;
use internshala_project;


-- ============================
-- TABLE CREATION
-- ============================


create table internships(
	id int primary key,
    role varchar(100),
    company varchar(100),
    loation varchar(50),
    duration int,
    stipend varchar(50),
    intern_type varchar(100),
    skills text,
    perks text,
    hiring_since varchar(50),
    opportunity_date int,
    opening int,
    hired_candidates int,
    number_of_applications int,
    website_link varchar(255)
);


-- ============================
-- BASIC CHECK
-- ============================


SELECT COUNT(*) FROM internships;


-- ============================
-- FIX COLUMN NAME
-- ============================


ALTER TABLE internships
CHANGE loation location VARCHAR(50);


-- ============================
-- ADD CLEAN STIPEND COLUMN
-- ============================


ALTER TABLE internships
ADD COLUMN stipend_avg INT;


-- ============================
-- CLEAN STIPEND DATA
-- ============================

-- Remove commas
UPDATE internships
SET stipend = REPLACE(stipend, ',', '')
WHERE id > 0;

-- Remove unpaid / performance based
UPDATE internships
SET stipend = NULL
WHERE stipend IN ('Unpaid', 'Performance Based')
  AND id > 0;

-- Remove lump sum text
UPDATE internships
SET stipend = REPLACE(stipend, ' lump sum', '')
WHERE stipend LIKE '%lump sum%'
  AND id > 0;

-- Weekly to monthly (single value)
UPDATE internships
SET stipend =
CAST(REPLACE(stipend, ' /week', '') AS UNSIGNED) * 4
WHERE stipend LIKE '%/week'
  AND stipend NOT LIKE '%-%'
  AND id > 0;

-- Weekly to monthly (range)
UPDATE internships
SET stipend =
CONCAT(
  SUBSTRING_INDEX(stipend,'-',1) * 4,
  '-',
  SUBSTRING_INDEX(REPLACE(stipend,' /week',''),'-',-1) * 4
)
WHERE stipend LIKE '%/week'
  AND stipend LIKE '%-%'
  AND id > 0;

-- Fix encoding
UPDATE internships
SET stipend = REPLACE(stipend, 'Ã‚Â£', '')
WHERE stipend LIKE '%Ã‚Â£%'
  AND id > 0;

-- Final trim
UPDATE internships
SET stipend = TRIM(stipend)
WHERE id > 0;


-- ============================
-- FINAL VALIDATION
-- ============================


SELECT id, stipend
FROM internships
WHERE stipend IS NOT NULL
  AND stipend NOT REGEXP '^[0-9]+(-[0-9]+)?$';


-- ============================
-- CALCULATE AVERAGE STIPEND
-- ============================


UPDATE internships
SET stipend_avg =
CASE
    WHEN stipend LIKE '%-%' THEN
      (SUBSTRING_INDEX(stipend,'-',1) +
       SUBSTRING_INDEX(stipend,'-',-1)) / 2
    WHEN stipend REGEXP '^[0-9]+$' THEN
      stipend
    ELSE NULL
END
WHERE id > 0;


-- ============================
-- SAMPLE OUTPUT
-- ============================


SELECT id, stipend, stipend_avg
FROM internships
LIMIT 15;


-- Display Column Name and Output
select * from internships
order by id asc limit 20;


-- Describing the columns
describe internships;


-- ============================
-- BASIC ANALYSIS
-- ============================


-- Total Numbers of Internships Opportunities
SELECT COUNT(*) AS total_internships
FROM internships;


-- Highest Number Of Applications
select company as Company_Name,
number_of_applications as highest_number_of_applications
from internships
order by number_of_applications desc limit 1;


-- Role Wise Application Demand
select role,
sum(number_of_applications)
from internships
group by role
order by sum(number_of_applications) desc;


-- ============================
-- COMPANY ANALYSIS
-- ============================


-- Top Companies Offering Max Internships
select company,
max(opening)
from internships
group by company
order by max(opening) desc limit 10;



-- Companies Offering Highest Avg Stipend
select company,
	round(avg(stipend_avg), 0) as avg_stipend
from internships
where stipend_avg is not null
group by company
order by avg_stipend desc
limit 10;
    

-- Companies With Highest Hiring Success Rate
SELECT 
    company,
    SUM(hired_candidates) AS total_hired,
    SUM(opening) AS total_openings,
    ROUND((SUM(hired_candidates)/SUM(opening))*100,2) AS success_rate
FROM internships
WHERE opening > 0
GROUP BY company
ORDER BY success_rate DESC
LIMIT 10;

    
-- Highest Paying Internships
SELECT role, company, stipend_avg
FROM internships
WHERE stipend_avg IS NOT NULL
ORDER BY stipend_avg DESC
LIMIT 10;


-- Average Stipend Across All Internships
SELECT ROUND(AVG(stipend_avg),0) AS average_stipend
FROM internships
WHERE stipend_avg IS NOT NULL;


-- Percentage of Paid vs Unpaid Internships
SELECT 
    CASE 
        WHEN stipend_avg IS NULL THEN 'Unpaid'
        ELSE 'Paid'
    END AS category,
    COUNT(*) AS total,
    ROUND((COUNT(*)*100.0)/(SELECT COUNT(*) FROM internships),2) AS percentage
FROM internships
GROUP BY category;


-- Location-wise Distribution of Internships
SELECT location, COUNT(*) AS total_internships
FROM internships
GROUP BY location
ORDER BY total_internships DESC;


-- Cities With Maximum Internship Opportunities
SELECT location, COUNT(*) AS total_posts
FROM internships
GROUP BY location
ORDER BY total_posts DESC
LIMIT 10;


-- Work From Home Internship Analysis
SELECT COUNT(*) AS work_from_home_count
FROM internships
WHERE location LIKE '%Work from home%';


-- Work From Home vs On-Site
SELECT 
    CASE 
        WHEN location LIKE '%Work from home%' THEN 'Work From Home'
        ELSE 'On-Site'
    END AS type,
    COUNT(*) AS total
FROM internships
GROUP BY type;


-- Most Popular Internship Roles
SELECT role, COUNT(*) AS total_posts
FROM internships
GROUP BY role
ORDER BY total_posts DESC
LIMIT 10;


-- Internships With Highest Number of Applications
SELECT role, company, number_of_applications
FROM internships
ORDER BY number_of_applications DESC
LIMIT 10;


-- Role-wise Application Demand
SELECT role, SUM(number_of_applications) AS total_applications
FROM internships
GROUP BY role
ORDER BY total_applications DESC;


-- Average Duration of Internships
SELECT ROUND(AVG(duration),2) AS avg_duration_months
FROM internships;


-- Short-Term vs Long-Term Internship Analysis
SELECT 
    CASE
        WHEN duration <= 3 THEN 'Short-Term'
        ELSE 'Long-Term'
    END AS category,
    COUNT(*) AS total
FROM internships
GROUP BY category;


-- Recently Posted Internship Opportunities
SELECT COUNT(*) AS recent_posts
FROM internships
WHERE opportunity_date <= 7;


-- Oldest Active Internship Listings
SELECT role, company, opportunity_date
FROM internships
ORDER BY opportunity_date DESC
LIMIT 10;


-- Year-wise Hiring Trend of Companies
SELECT hiring_since, COUNT(*) AS total_posts
FROM internships
GROUP BY hiring_since
ORDER BY hiring_since;


-- Growth in Internship Opportunities Over Time
SELECT hiring_since, COUNT(*) AS total_opportunities
FROM internships
GROUP BY hiring_since
ORDER BY hiring_since;


















