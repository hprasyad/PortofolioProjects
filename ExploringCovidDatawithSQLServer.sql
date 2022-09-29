SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM CovidDeaths
WHERE location = 'Indonesia'
ORDER BY location, date

-- Looking at the total cases vs population
SELECT location, date, total_cases, population, (total_deaths/population)*100 as DeathPercentage
FROM CovidDeaths
WHERE location = 'Indonesia'
ORDER BY location, date

-- What country with highest infection rate compare to population?
SELECT location, population, MAX(total_cases) AS HighestInfectionCount, (MAX(total_deaths/population))*100 as PercentPopulationInfected
FROM CovidDeaths
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC

-- Showing countries with highest death count per population
SELECT location, MAX(Cast(Total_deaths as int)) as TotalDeathCount
FROM CovidDeaths
WHERE continent is not null
GROUP BY location
ORDER BY TotalDeathCount DESC

-- Showing continent with highest death count per population
SELECT continent, MAX(Cast(Total_deaths as int)) as TotalDeathCount
FROM CovidDeaths
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount DESC

-- Global Numbers
SELECT SUM(new_cases) AS Total_Cases, SUM(CAST(new_deaths AS INT)) as total_Deaths, SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 as DeathPercentage
FROM CovidDeaths
WHERE continent is not null
--GROUP BY date
ORDER BY 1,2

-- Looking at the total population vs vaccination
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
	,SUM(CAST(vac.new_vaccinations as bigint)) OVER (partition by dea.location ORDER BY dea.location, dea.date) AS RollingVaccinations
	,(RollingVaccinations/dea.population)*100
FROM CovidDeaths dea
JOIN CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3