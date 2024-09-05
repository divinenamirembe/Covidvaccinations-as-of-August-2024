

SELECT *
FROM PortfolioProject..CovidDeaths
WHERE continent is NOT NULL
ORDER BY 3, 4


--SELECT *
--FROM PortfolioProject..CovidVaccinations
--ORDER BY 3, 4

--Select the data that we are going to be using

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
WHERE continent is NOT NULL
ORDER BY 1,2


--Looking at total_cases vs total_deaths
--Shows the likelihood of death if one contracted Covid in a given country 
SELECT location,
	   date,
	   total_cases,
	   total_deaths,
	   CASE 
           WHEN total_cases = 0 THEN NULL 
           ELSE (total_deaths / total_cases)*100 
		   END AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE location like '%states%'
AND continent is NOT NULL
ORDER BY 1,2


--Explore total_cases vs population
--Shows what percentage of the popualtion contracted covid in a given country
SELECT location,
	   date,
	   population,
	   total_cases,
	   CASE 
           WHEN total_cases = 0 THEN NULL 
           ELSE (total_cases/population)*100 
		   END AS InfectedPercentage
FROM PortfolioProject..CovidDeaths
WHERE location like '%states%'
AND continent is NOT NULL
ORDER BY 1,2


--Looking at countries with highest infection rates compared to population

SELECT location,
	   population,
	   MAX(total_cases) AS HighestInfectionCount,
	   CASE 
           WHEN population = 0 THEN NULL 
           ELSE (MAX(total_cases)/population)*100 
		   END AS InfectedPercentage
FROM PortfolioProject..CovidDeaths
--WHERE location like '%states%'
AND continent is NOT NULL
GROUP BY location, population
ORDER BY InfectedPercentage DESC

--BREAK THINGS DOWN BY CONTINENT


--Showing countries with the highest death count per population
SELECT location,
	   MAX(CAST(total_deaths AS int)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent is NOT NULL
--WHERE location like '%states%'
GROUP BY location
ORDER BY TotalDeathCount DESC


-- Showing continents with the highest death count per population 

SELECT continent,
	   MAX(CAST(total_deaths AS int)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent is NOT NULL
--WHERE location like '%states%'
GROUP BY continent
ORDER BY TotalDeathCount DESC


-- GLOBAL NUMBERS

SELECT SUM(new_cases) AS total_cases,
       SUM(new_deaths) AS total_deaths,
       CASE
           WHEN SUM(new_cases) = 0 THEN NULL
           ELSE SUM(new_deaths) / SUM(new_cases) * 100
       END AS DeathPercentage
FROM PortfolioProject..CovidDeaths
--WHERE location like '%states%'
WHERE continent is NOT NULL
--GROUP BY date
ORDER BY 1,2


--Looking at total population vs vaccination 

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations AS int)) OVER (PARTITION BY dea.location)
FROM PortfolioProject..CovidDeaths AS dea
JOIN PortfolioProject..CovidVaccinations AS vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is NOT NULL
ORDER BY 1,2,3
