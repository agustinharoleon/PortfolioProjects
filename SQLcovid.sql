SELECT *
FROM Portfolio_Project_Covid..CovidDeaths

SELECT *
FROM Portfolio_Project_Covid..CovidDeaths
Where continent is not null
order by 3,4

SELECT *
FROM Portfolio_Project_Covid..CovidVaccinations
order by 3,4




-- Select Data that we are going to be using

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM Portfolio_Project_Covid..CovidDeaths
Where continent is not null
order by 1,2



-- Looking a Total cases vs Total Deaths

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM Portfolio_Project_Covid..CovidDeaths
Where continent is not null
order by 1,2

-- Shows likelihood of dying if you contract Covid in your country

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM Portfolio_Project_Covid..CovidDeaths
Where location LIKE '%states%'
and continent is not null
order by 1,2

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM Portfolio_Project_Covid..CovidDeaths
Where location LIKE '%pai%'
and continent is not null
order by 1,2

-- Looking at Total Cases vs population


--Shows what percentage of population got Covid

SELECT Location, date, population, total_deaths, (total_cases/population)*100 as DeathPercentage
FROM Portfolio_Project_Covid..CovidDeaths
Where location LIKE '%states%'
order by 1,2


SELECT Location, date, population, total_deaths, (total_cases/population)*100 as DeathPercentage
FROM Portfolio_Project_Covid..CovidDeaths
Where location LIKE '%pain%'
order by 1,2

SELECT Location, date, population, total_deaths, (total_cases/population)*100 as PercentPopulationInfected
FROM Portfolio_Project_Covid..CovidDeaths

--Where location LIKE '%pain%'
order by 1,2


-- Looking at Countries with Highest Infection rate compared to population 

SELECT Location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
FROM Portfolio_Project_Covid..CovidDeaths
Where continent is not null
GROUP BY Location, Population
order by 1,2

SELECT Location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
FROM Portfolio_Project_Covid..CovidDeaths
Where continent is not null
GROUP BY Location, Population
order by PercentPopulationInfected desc


-- Showing Countries with Higuest Death Count per Population


SELECT Location, MAX(cast(total_deaths as int)) as TotalDeathsCount
FROM Portfolio_Project_Covid..CovidDeaths
Where continent is not null
GROUP BY Location
order by TotalDeathsCount desc


-- LET´S BREAK THINGS DOWN BY CONTINENT



-- Showing continents with the highest death count per population

SELECT Location, MAX(cast(total_deaths as int)) as TotalDeathsCount
FROM Portfolio_Project_Covid..CovidDeaths
Where continent is null
GROUP BY Location
order by TotalDeathsCount desc




SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathsCount
FROM Portfolio_Project_Covid..CovidDeaths
Where continent is not null
GROUP BY CONTINENT
order by TotalDeathsCount desc


-- GLOBAL NUMBERS

SELECT Location, date, total_cases, total_deaths, (total_cases/population)*100 as DeathPercentage
FROM Portfolio_Project_Covid..CovidDeaths
Where location is not null
order by 1,2


SELECT
    date,
    SUM(NEW_CASES) as total_cases,
    SUM(CAST(new_deaths AS int)) as total_deaths,
    SUM(CAST(new_deaths AS int)) / SUM(NEW_CASES) * 100 as DeathPercentage
FROM
    Portfolio_Project_Covid..CovidDeaths
WHERE
    [continent] IS NOT NULL
GROUP BY
    date
ORDER BY
    1, 2;


	SELECT
    date,
    SUM(NEW_CASES),
    SUM(CAST(new_deaths AS int)) as total_deaths,
    SUM(CAST(new_deaths AS int)) / SUM(NEW_CASES) * 100 as DeathPercentage
FROM
    Portfolio_Project_Covid..CovidDeaths
WHERE
    [continent] IS NOT NULL
GROUP BY
    date
ORDER BY
    1, 2;


SELECT
    SUM(NEW_CASES) as total_cases,
    SUM(CAST(new_deaths AS int)) as total_deaths,
    SUM(CAST(new_deaths AS int)) / SUM(NEW_CASES) * 100 as DeathPercentage
FROM
    Portfolio_Project_Covid..CovidDeaths
WHERE
    [continent] IS NOT NULL
--GROUP BY date
ORDER BY
    1, 2;


-- Looking at Total Population vs Vaccinations

SELECT*
FROM Portfolio_Project_Covid..CovidDeaths dea
Join Portfolio_Project_Covid..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date


SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM Portfolio_Project_Covid..CovidDeaths dea
Join Portfolio_Project_Covid..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
order by 2,3


SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location)
FROM Portfolio_Project_Covid..CovidDeaths dea
Join Portfolio_Project_Covid..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
order by 2,3


SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
FROM Portfolio_Project_Covid..CovidDeaths dea
Join Portfolio_Project_Covid..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
order by 2,3


SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM Portfolio_Project_Covid..CovidDeaths dea
Join Portfolio_Project_Covid..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
order by 2,3


-- USE CTE

With PopvsVac (Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM Portfolio_Project_Covid..CovidDeaths dea
Join Portfolio_Project_Covid..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3
)
SELECT*
FROM PopvsVac

With PopvsVac (Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM Portfolio_Project_Covid..CovidDeaths dea
Join Portfolio_Project_Covid..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3
)

SELECT*, (RollingPeopleVaccinated/Population)*100
From PopvsVac



-- TEMP TABLE

DROP Table if exist #PercentPopulationVaccinated

Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric,
)

Inser into #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM Portfolio_Project_Covid..CovidDeaths dea
Join Portfolio_Project_Covid..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--Where dea.continent is not null
--order by 2,3

SELECT*, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated




--Creating View to store data for visualizations

CREATE VIEW PercentPopulationVaccinated AS
SELECT
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    SUM(CONVERT(int, vac.new_vaccinations)) OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.Date) as RollingPeopleVaccinated
    --, (RollingPeopleVaccinated/population)*100
FROM
    Portfolio_Project_Covid..CovidDeaths dea
JOIN
    Portfolio_Project_Covid..CovidVaccinations vac ON dea.location = vac.location AND dea.date = vac.date
WHERE
    dea.continent IS NOT NULL;


SELECT * FROM PercentPopulationVaccinated ORDER BY location, date;



