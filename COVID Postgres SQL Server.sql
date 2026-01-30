
--Checking if data are saved in the database
SELECT *
FROM coviddeaths
ORDER BY 3, 4;

SELECT *
FROM covidvaccinations
ORDER BY 3, 4;


-- Selecting data that I am going to be using
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM coviddeaths
ORDER BY 1, 2;


-- Looking at Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country
SELECT location,
       date,
       total_cases,
       total_deaths,
       (total_deaths::FLOAT / total_cases::FLOAT) * 100 AS deathpercentage
FROM coviddeaths
WHERE location ILIKE '%states%'
ORDER BY 1, 2;


-- Looking at Total Cases vs Population
-- Shows what percentage of population got COVID
SELECT location,
       date,
       total_cases,
       population,
       (total_cases::FLOAT / population) * 100 AS percentpopulationinfected
FROM coviddeaths
ORDER BY 1, 2;


-- Countries with highest infection rate compared to population
SELECT location,
       population,
       MAX(total_cases::INT) AS highestinfectioncount,
       MAX((total_cases::FLOAT / population) * 100) AS percentpopulationinfected
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY percentpopulationinfected DESC;


-- Countries with highest death count
SELECT location,
       MAX(total_deaths::INT) AS totaldeathcount
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY totaldeathcount DESC;


-- LET'S BREAK THINGS DOWN BY CONTINENT
-- Locations where continent IS NULL are aggregated continent rows
SELECT location,
       MAX(total_deaths::INT) AS totaldeathcount
FROM coviddeaths
WHERE continent IS NULL
GROUP BY location
ORDER BY totaldeathcount DESC;


-- Continents with highest death count
SELECT continent,
       MAX(total_deaths::INT) AS totaldeathcount
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY totaldeathcount DESC;


-- GLOBAL NUMBERS
SELECT
    SUM(new_cases) AS total_cases,
    SUM(new_deaths::INT) AS total_deaths,
    (SUM(new_deaths::FLOAT) / SUM(new_cases)) * 100 AS deathpercentage
FROM coviddeaths
WHERE continent IS NOT NULL;


-- Total Population vs Vaccinations
SELECT
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    SUM(vac.new_vaccinations::BIGINT)
        OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)
        AS rollingpeoplevaccinated
FROM coviddeaths dea
JOIN covidvaccinations vac
    ON dea.location = vac.location
   AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2, 3;


-- USE CTE
WITH popvsvac AS (
    SELECT
        dea.continent,
        dea.location,
        dea.date,
        dea.population,
        vac.new_vaccinations,
        SUM(vac.new_vaccinations::BIGINT)
            OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)
            AS rollingpeoplevaccinated
    FROM coviddeaths dea
    JOIN covidvaccinations vac
        ON dea.location = vac.location
       AND dea.date = vac.date
    WHERE dea.continent IS NOT NULL
)
SELECT *,
       (rollingpeoplevaccinated / population) * 100 AS percentvaccinated
FROM popvsvac;


-- TEMP TABLE
DROP TABLE IF EXISTS percentpopulationvaccinated;

CREATE TEMP TABLE percentpopulationvaccinated (
    continent TEXT,
    location TEXT,
    date DATE,
    population FLOAT,
    new_vaccinations BIGINT,
    rollingpeoplevaccinated NUMERIC
);

INSERT INTO percentpopulationvaccinated
SELECT
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations::BIGINT,
    SUM(vac.new_vaccinations::BIGINT)
        OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)
FROM coviddeaths dea
JOIN covidvaccinations vac
    ON dea.location = vac.location
   AND dea.date = vac.date;


SELECT *,
       (rollingpeoplevaccinated / population) * 100 AS percentvaccinated
FROM percentpopulationvaccinated;


-- Creating View for later visualizations
CREATE OR REPLACE VIEW percentpopulationvaccinated_view AS
SELECT
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    SUM(vac.new_vaccinations::BIGINT)
        OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)
        AS rollingpeoplevaccinated
FROM coviddeaths dea
JOIN covidvaccinations vac
    ON dea.location = vac.location
   AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;


SELECT *
FROM percentpopulationvaccinated_view;
