select *
from `covidportfolio.Covid.Coviddeaths`
order by 3,4

--select *
--from `covidportfolio.Covid.covidvac`
--order 3,4

--Select Data that we are going to use

select location, date, total_cases, new_cases, total_deaths, population
from `covidportfolio.Covid.Coviddeaths`
order by 1,2

--Looking at Total Cases vs Total Cases

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as deathpercentage
from `covidportfolio.Covid.Coviddeaths`
order by 1,2

-- Picking the United States out of all the countries

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as deathpercentage
from `covidportfolio.Covid.Coviddeaths`
where location like '%States%'
and continent is not null
order by 1,2


-- Looking at Total Cases vs Population
-- Shows what precentage of population got Covid
select location, date, total_cases, population, (total_cases/population)*100 as casesvspop
from `covidportfolio.Covid.Coviddeaths`
where location like '%States%'
and continent is not null
order by 1,2

-- Looking for Countries with highest Infection Rate

select location, population, Max(total_cases) as Highestinfection, max((total_cases/population)*100) as precentinfected
from `covidportfolio.Covid.Coviddeaths`
where continent is not null
group by location, population
order by precentinfected desc


-- Countries with Highest Death Count

select location,  Max(total_deaths) as Totaldeathcount
from `covidportfolio.Covid.Coviddeaths`
where continent is not null
group by location
order by Totaldeathcount desc

-- Showing continents with highest death count

select location,  Max(total_deaths) as Totaldeathcount
from `covidportfolio.Covid.Coviddeaths`
where continent is null
group by location
order by Totaldeathcount desc

-- Global Numbers

select  date, sum(new_cases) as total_cases,sum(new_deaths) as total_deaths,
(case when sum(new_deaths) <> 0 
then sum(new_deaths)/sum(new_cases) * 100 end)  as deathpercentage
from `covidportfolio.Covid.Coviddeaths`
where continent is null
group by date
order by 1,2

-- Total number of Precent of Deaths

select   sum(new_cases) as total_cases,sum(new_deaths) as total_deaths,
(case when sum(new_deaths) <> 0 
then sum(new_deaths)/sum(new_cases) * 100 end)  as deathpercentage
from `covidportfolio.Covid.Coviddeaths` -- depends on the serivce that you are currently using
where continent is null
--group by date
order by 1,2

-- Joining the 2 tables
-- Looking at Total Population vs Vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from `covidportfolio.Covid.Coviddeaths` dea
join `covidportfolio.Covid.covidvac` vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3




select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as rollingvaccinated
from `covidportfolio.Covid.Coviddeaths` dea
join `covidportfolio.Covid.covidvac` vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3


-- Using CTE


With PopvsVac
as 
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as rollingvaccinated-- (rollingvaccinated/population)*100 as totalvaccinated
from `covidportfolio.Covid.Coviddeaths` dea
join `covidportfolio.Covid.covidvac` vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *, (rollingvaccinated/population)*100 as precentvaccinated
from PopvsVac

--creating view to store data

create view `covidprotfolio.Covid.percentpopulationvaccinated` as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as rollingvaccinated
from `covidportfolio.Covid.Coviddeaths` dea
join `covidportfolio.Covid.covidvac` vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3