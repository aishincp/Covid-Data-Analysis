# *Covid Analysis*

## 1. *Overview*
#### Description
This project involves comprehensive analysis and visualization of global COVID-19 data, mostly focusing on global numbers, mortality rates, death trends, overall impact by location and more. This work showcases skills in __data analysis__, __SQL__ in __data manipulation__ and __Power BI__ for creating __interactive dashboards__
#### Objective
To analyze global COVID-19 data and provide insightful visualizations that can help in understanding the pandemic's impact across different regions.

## 2. *Inspiration & Motivation*
The project idea was inspired by the need to better understand the global impact of COVID-19 and to demonstrate my SQL, Power BI, and data analysis skills in real-world scenarios. The aim is to create a project that only analyzed COVID-19 data but also along with that visualized it in a way that could easily be interpreted by various stakeholders.

## 3. *Data Collection*
#### Data Source
- **Description**: The dataset was sources from ["Our World in Data"](https://ourworldindata.org/coronavirus), which provides extensive information on COVID-19 cases, deaths, vaccinations, cases, tests and many more related metrics globally.
- **File Format**: __Excel__

#### Data Filtering and Processing:
- **Initial Data**: The dataset columns included as: __Add screenshot of the dataset first five columns and also columns__
- **Filtering**: Focused on COVID-19 deaths, cases and vaccinations, I filtered the data to include relevant columns and removed any aggregate data like 'World', 'International', or income-based groupings, which mostl contains missing values.

## 4. SQL Queries and Data Manipulation
#### Database Setup:
- **Environment Setup**: SQL Server Management Studio (SSMS)
- **Database**: Created a database named 'PortfolioProjects' with tables for 'CovidDeathsLatest' and 'CovidVaccinationsLatest'.

![image](https://github.com/user-attachments/assets/9c600f38-2cfb-43a5-a228-dfe6ed96f7e7)

#### Key SQL Queries:
- ###### **Total Deaths Worldwide**:
  ```
  Select Sum(new_deaths) as OverallDeaths
  From PortfolioProjects..CovidDeathsLatest
  Where continent is not null
    and location not in ('World', 'International', 'Lower middle income', 'Upper middle income', 'High income', 'Low income', 'European Union')
  ```
- ###### **Overall Death Rate Worldwide**:
  ```
   Select 
       Round((Max(total_deaths) * 1.0 / Max(total_cases)) * 100, 2) as DeathRateWorldwide
   From PortfolioProjects..CovidDeathsLatest
   Where continent is not null
  ```
#### Detailed Analysis Queries:
- ###### **DeathPercentagePerContinent**:
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
- ###### **Overall People Fully Vaccinated Worldwide**:
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

All other relevant queries can be found here [SQL Queries]()
