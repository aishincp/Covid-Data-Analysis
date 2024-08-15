------------ COVID DEATHS QUERIES_------------------------
-- KPI Queries

-- Total Deaths Worldwide
Select
	Sum(new_deaths) as OverallDeaths
From PortfolioProjects..CovidDeathsLatest
Where continent is not null
	and location not in ('World', 'International', 'Lower middle income', 'Upper middle income', 'High income', 'Low income', 'European Union')

-- Total Cases Worldwide
Select
	Sum(new_cases) as OverallCases
From PortfolioProjects..CovidDeathsLatest
Where continent is not null
	and location not in ('World', 'International', 'Lower middle income', 'Upper middle income', 'High income', 'Low income', 'European Union')

-- Overall Death Rate Worldwide
Select 
   Round((Max(total_deaths) * 1.0 / Max(total_cases)) * 100, 2) as DeathRateWorldwide
From PortfolioProjects..CovidDeathsLatest
Where continent is not null
    --and location not in ('World', 'International', 'Lower middle income', 'Upper middle income', 'High income', 'Low income', 'European Union');



-- Overall Vaccinations Worldwide

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

-- Step 2: Join to Get Latest Vaccination Data
LatestVaccinationData AS (
    SELECT 
        a.location,
        a.latest_date,
        b.people_vaccinated
    FROM 
        LatestDatePerLocation a
    JOIN 
        PortfolioProjects..CovidVaccinationLatest b
    ON 
        a.location = b.location AND a.latest_date = b.date
)

-- Step 3: Sum Fully Vaccinated Numbers
SELECT 
    SUM(people_vaccinated) AS VaccinationDoseWorldwide
FROM 
    LatestVaccinationData;




-- Overall People Fully Vaccinated Worldwide (1.8 billion people got both vaccinations)
-- Step 1: Identify Latest Data Per Location
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

-- Step 2: Join to Get Latest Vaccination Data
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

-- Step 3: Sum Fully Vaccinated Numbers
SELECT 
    SUM(people_fully_vaccinated) AS PeopleFullyVaccinatedWorldwide
FROM 
    LatestVaccinationData;





------------------------ COVID DEATH QUERIES-----------------------------------
--GlobalDeathPercentage
Select
	SUM(new_cases) As TotalCases,
	SUM(CAST(new_deaths As INT)) as TotalDeaths,
	SUM(CAST(new_deaths as int) * 1.0) / SUM(new_cases) * 100 As GlobalDeathPercentage
From PortfolioProjects..CovidDeathsLatest
Where continent is not null
	and location not in ('World', 'International', 'Lower middle income', 'Upper middle income', 'High income', 'Low income', 'European Union')
Order By 1, 2;


-- DeathPercentagePerContinent
Select
	continent,
	SUM(new_cases) as total_cases, 
	SUM(new_deaths) as total_deaths, 
	SUM(CAST(new_deaths as decimal)) / NULLIF(SUM(New_Cases), 0)*100 as DeathPercentage
From PortfolioProjects..CovidDeathsLatest
Where continent is not null 
Group By continent
Order By continent;

-- PercentagePopulationInfected
Select location, 
	population, 
	Sum(new_cases) as InfectedCount, 
	Sum((new_cases)*1.0 / (population) * 100) as PercentageInfectedPopulation
From PortfolioProjects..CovidDeathsLatest
Where continent is not null
Group By location, population
Order by location;


--  Deaths Trends Over Time (Yearly & Monthly)
Select
	Year(date) as Year,
	Month(date) as Month,
	FORMAT(date, 'MMMM') as MonthName,
	Sum(new_deaths) as Total_Deaths
From PortfolioProjects..CovidDeathsLatest
Where continent is not null
	and location not in ('World', 'International', 'Lower middle income', 'Upper middle income', 'High income', 'Low income', 'European Union')
Group by Year(date), Month(date),FORMAT(date, 'MMMM')
Order by Year, Month;


-- Top 5 Countries with High Reproduction Rate
Select Top 5
	location,
	Max(reproduction_rate) as Max_Reproduction_Rate
From PortfolioProjects..CovidDeathsLatest
Group by location
Order By Max_Reproduction_Rate desc;

-- Top 5 countries with Highest ICU Patients per Million:
Select Top 5
	continent,
    location, 
    Sum(icu_patients) as Max_ICU_Patients
From PortfolioProjects..CovidDeathsLatest
Where continent is not null
	and location not in ('World', 'International', 'Lower middle income', 'Upper middle income', 'High income', 'Low income', 'European Union')
Group by continent, location
Order by Max_ICU_Patients desc;

-- Top 5 Countries with Population Vs. Deaths:
Select Top 5
	location,
	population,
	Sum(new_deaths) as Total_Deaths
From PortfolioProjects..CovidDeathsLatest
Where continent is not null
	and location not in ('World', 'International', 'Lower middle income', 'Upper middle income', 'High income', 'Low income', 'European Union')
Group by location, population
Order by Total_Deaths desc;

-- Bottom 5 Countries with Population Vs. Deaths:
Select Top 5
	--continent,
	location,
	population,
	Sum(new_deaths) as Total_Deaths
From PortfolioProjects..CovidDeathsLatest
Where continent is not null
	and location not in ('World', 'International', 'Lower middle income', 'Upper middle income', 'High income', 'Low income', 'European Union')
	and total_deaths is not null
Group by location, population
Order by Total_Deaths asc;

-- Countries with Highest Excess Mortality:
Select 
	Year(date) as Year,
	Month(date) as Month,
	Format(date, 'MMMM') as MonthName, 
	location,
	Max(excess_mortality) as ExcessMortalityRate
From PortfolioProjects..CovidDeathsLatest
Where continent is not null
	and excess_mortality is not null
Group by location, Year(date), Month(date), Format(date, 'MMMM')
Order by ExcessMortalityRate desc, Year asc, Month asc;





