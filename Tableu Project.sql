-- We take these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe


select location,  sum(new_deaths) as TotalDeathCount
from `covidportfolio.Covid.Coviddeaths`
where continent is null
and location not in ('World','European Union', 'International')
group by location
order by TotalDeathCount desc


Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From `covidportfolio.Covid.Coviddeaths`
Group by Location, Population
order by PercentPopulationInfected desc


Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From `covidportfolio.Covid.Coviddeaths`
Group by Location, Population, date
order by PercentPopulationInfected desc