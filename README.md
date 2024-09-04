# *Covid Analysis*

## 1. Overview
#### Description
This project involves comprehensive analysis and visualization of global COVID-19 data, mostly focusing on global numbers, mortality rates, death trends, overall impact by location and more. This work showcases skills in __data analysis__, __SQL__ in __data manipulation__ and __Power BI__ for creating __interactive dashboards__
#### Objective
To analyze global COVID-19 data and provide insightful visualizations that can help in understanding the pandemic's impact across different regions.

## 2. Inspiration & Motivation
The project idea was inspired by the need to better understand the global impact of COVID-19 and to demonstrate my SQL, Power BI, and data analysis skills in real-world scenarios. The aim is to create a project that only analyzed COVID-19 data but also along with that visualized it in a way that could easily be interpreted by various stakeholders.

## 3. Data Collection
#### Data Source
- ###### *Description*:
  The dataset was sources from ["Our World in Data"](https://ourworldindata.org/coronavirus), which provides extensive information on COVID-19 cases, deaths, vaccinations, cases, tests and many more related metrics globally.
- ###### *File Format*:
  __Microsoft Excel__

#### Data Filtering and Processing:
- ###### *Initial Data*:
  The dataset columns included as: __Add screenshot of the dataset first five columns and also columns__
- ###### *Filtering**:
  Focused on COVID-19 deaths, cases and vaccinations, I filtered the data to include relevant columns and removed any aggregate data like 'World', 'International', or income-based groupings, which mostl contains missing values.

## 4. SQL Queries and Data Manipulation
#### Database Setup:
- ###### *Environment Setup*:
  __SQL Server Management Studio (SSMS)__
- ###### *Database*:
  Created a database named 'PortfolioProjects' with tables for 'CovidDeathsLatest' and 'CovidVaccinationsLatest'.

![image](https://github.com/user-attachments/assets/9c600f38-2cfb-43a5-a228-dfe6ed96f7e7)

#### Key SQL Queries:
- ###### *Total Deaths Worldwide*:
  ```
  Select Sum(new_deaths) as OverallDeaths
  From PortfolioProjects..CovidDeathsLatest
  Where continent is not null
    and location not in ('World', 'International', 'Lower middle income', 'Upper middle income', 'High income', 'Low income', 'European Union')
  ```
- ###### *Overall Death Rate Worldwide*:
  ```
   Select 
       Round((Max(total_deaths) * 1.0 / Max(total_cases)) * 100, 2) as DeathRateWorldwide
   From PortfolioProjects..CovidDeathsLatest
   Where continent is not null
  ```
#### Detailed Analysis Queries:
- ###### *DeathPercentagePerContinent*:
  ```
  Select
	  continent,
	  SUM(new_cases) as total_cases, 
	  SUM(new_deaths) as total_deaths, 
	  SUM(CAST(new_deaths as decimal)) / NULLIF(SUM(New_Cases), 0)*100 as DeathPercentage
  From PortfolioProjects..CovidDeathsLatest
  Where continent is not null 
  Group By continent
  Order By continent;
  ```
- ###### *Overall People Fully Vaccinated Worldwide*:
```
Step 1: Identifyig latest Date Per Location
WITH LatestDatePerLocation AS (
    SELECT 
        location, 
        MAX(date) AS latest_date
    FROM 
        PortfolioProjects..CovidVaccinationLatest
    WHERE 
        continent IS NOT NULL
        AND location NOT IN ('World', 'International', 'Lower middle income', 'Upper middle income', 'High income', 'Low income', 'European Union')
    GROUP BY 
        location
),

Step 2: Join the upper query to get latest Vaccination Data
LatestVaccinationData AS (
    SELECT 
        a.location,
        a.latest_date,
        b.people_fully_vaccinated
    FROM 
        LatestDatePerLocation a
    JOIN 
        PortfolioProjects..CovidVaccinationLatest b
    ON 
        a.location = b.location AND a.latest_date = b.date
)

Step 3: Sum Fully Vaccinated Numbers
SELECT 
    SUM(people_fully_vaccinated) AS PeopleFullyVaccinatedWorldwide
FROM 
    LatestVaccinationData;
```

All other relevant queries can be found here [SQL Queries](https://github.com/aishincp/Covid-Data-Analysis/blob/main/CovidDeathsQuery_New.sql)

#### Saving Results:
The results of these queries were exported to Excel sheets, which were then imported into Power BI for visualization.


## 5. Data Visualization in Power BI

#### a. Overview:
- ###### *Tools Used*:
  __Microsoft Power BI Desktop__
- ###### *Objective*:
  Power BI is used to create interactive covid analysis dashboard that visually represent the data insights derived from above SQL queries.

#### b. Power BI Setup:
- ###### *Importing Data*:
  The saved excel sheets generated from SQL queries were then imported to Power BI
  
![image](https://github.com/user-attachments/assets/65b4b99f-5ffc-4a21-aa89-a832a20dc4e8)
  
- ###### *Data Model*:
  Connected the data tables 'Covid Deaths' and 'Covid Vaccinations' based on common fields such as __location__ and __date__.

#### c. Dashboard Design:

- ###### *KPI Cards*: Global Deaths, Global Cases, Global Death Rate, Overall Vaccinations (Atleast One Dose), Overall People Fully Vaccinated (Both Doses)

- ###### *Dashboard*: [Download Dahboard from here](https://github.com/aishincp/Covid-Data-Analysis/blob/main/Covid.pbix)

![image](https://github.com/user-attachments/assets/38a8a0fb-8861-479e-8a63-e2c74b24749a)


