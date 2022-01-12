Select *
From CovidDataAnalysis..Coronavirus_Deaths
Where continent is not null
order by 3,4

-- Select *
-- From CovidDataAnalysis..Coronavirus_Vaccinations
-- order by 3,4

-- Coronavirus_Deaths Analysis: Factors for Death.

Select location, date, total_cases, new_cases, total_deaths, new_deaths, population
From CovidDataAnalysis..Coronavirus_Deaths
Where continent is not null
order by 1,2

-- Analysing total cases vs total deaths

-- Percentage of people that have died froom those that were infected by covid-19

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From CovidDataAnalysis..Coronavirus_Deaths
Where location like '%United Kingdom%'
Where continent is not null
order by 1,2

Select date, convert (varchar(8), date, 3) As converteddate From CovidDataAnalysis..Coronavirus_Deaths -- converting date format to DD/MM/YYYY


--comment: Covid cases (2) in the UK were found o the 31/01/2020 and there were no deaths reported
-- comment: The first death in the UK from covid was reported on the 06/03/2020
-- questions:1) What quarter had the highest deaths?
-- what day had the highest deaths?
-- produce a graph of the deaths over the entire period? 
-- is the death percentage higher after the vacciantions started? 

-- identifying total cases vs total population


Select location, date, population, total_cases, (total_cases/population)*100 as PositivePercentagePopulation
From CovidDataAnalysis..Coronavirus_Deaths
Where location like '%United Kingdom%'
Where continent is not null
order by 1,2

-- Observing countries with highest infections relative to population.-- 

Select location, population, MAX(total_cases) as HighestInfectionRate, MAX(total_cases/population)*100 as PositivePercentagePopulation
From CovidDataAnalysis..Coronavirus_Deaths
Group by Location, Population
Where continent is not null
order by PositivePercentagePopulation desc

-- Observing countries with highest deaths relative to population.-- 

Select location, population, MAX(cast(total_deaths as int)) as HighestDeaths, MAX(total_deaths/population)*100 as DeathPercentagePopulation
From CovidDataAnalysis..Coronavirus_Deaths
Where continent is not null
Group by Location, Population
order by DeathPercentagePopulation desc


-- BREAKING DOWN STATISTICS BY CONTINENT--
-- HighestDeaths by continent 

Select location, MAX(cast(total_deaths as int)) as HighestDeaths
From CovidDataAnalysis..Coronavirus_Deaths
Where continent is null
Group by location
order by HighestDeaths desc

-- Continents by highest death count 

Select continent, MAX(cast(total_deaths as int)) as HighestDeaths
From CovidDataAnalysis..Coronavirus_Deaths
Where continent is not null
Group by continent
order by HighestDeaths desc


--- Analysing covid statistics globally -- 

-- Total number of new cases per day across the whole world

Select date, SUM(new_cases) -- , total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From CovidDataAnalysis..Coronavirus_Deaths
--Where location like '%United Kingdom%'
Where continent is not null
Group by date
order by 1,2

-- Total number of new deaths per day globally --  

Select date, SUM(new_cases), SUM(cast(new_deaths as int)) -- , total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From CovidDataAnalysis..Coronavirus_Deaths
--Where location like '%United Kingdom%'
Where continent is not null
Group by date
order by 1,2

-- Death percentages per day across the world --  

Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From CovidDataAnalysis..Coronavirus_Deaths
--Where location like '%United Kingdom%'
Where continent is not null
Group by date
order by 1,2

-- total cases and total deaths across the world 

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From CovidDataAnalysis..Coronavirus_Deaths
--Where location like '%United Kingdom%'
Where continent is not null
-- Group by date
order by 1,2

-- COMMENTS: 1.77% Death Percentage across the world, These are new cases and new deaths accumulated to date. 1.77% of the entire global population that
-- COMMENTS: contracted covid-19 died of it. 



Select*
From CovidDataAnalysis..Coronavirus_Deaths dea
Join CovidDataAnalysis..Coronavirus_Vaccinations vac
On dea.location = vac.location
and dea.date = vac.date


-- LOOKING AT THE TOTAL NUMBER OF PEOPLE THAT ARE VACCINATED IN THE WORLD (GLOBALLY)
-- TOTAL POPULATION VS VACCINATIONS

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingVaccinations)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by  dea.location Order by dea.location, dea.Date) as RollingVaccinations
, -- (RollingVaccinations/population)*100
From CovidDataAnalysis..Coronavirus_Deaths dea
Join CovidDataAnalysis..Coronavirus_Vaccinations vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 1,2,3
)
Select*
From PopvsVac

-- CTE 
