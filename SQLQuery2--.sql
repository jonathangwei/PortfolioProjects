
select *
from [dbo].['Covid Deaths$']
order by 3,4

--select *
--from [dbo].['Covid Vaccinations$']
--order by 3,4

--select data I'll be usx

select location, date, total_cases, new_cases, total_deaths, population
from [dbo].['Covid Deaths$']
where location ='Cameroon'
order by 1,2

-- Looking at Total Cases vs Total Deaths
--shows likelihood of dying if you contract covid in CMR

select location, date, total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from [dbo].['Covid Deaths$']
where location ='Cameroon'
order by 1,2

-- Looking AT Total Cases vs Percentage
-- shows pop that has gotten covid
select location, date,population,total_cases,(total_deaths/population)*100 as DeathPercentage
from [dbo].['Covid Deaths$']
where location ='Cameroon'
order by 1,2

----Looking @countries w/ highest infection rate compared to pop
select location,population,MAX(total_cases) AS HighestInfectionCount, MAX((total_deaths/population))*100 as PercentagePopulationInfeected
from [dbo].['Covid Deaths$']
where location ='Cameroon'
Group by location, population
order by PercentagePopulationInfeected desc


-- showing countries w/ highest death count/pop

select location,MAX(cast(total_deaths as int)) AS TotalDeathCount
from [dbo].['Covid Deaths$']
where location ='Cameroon'
Group by location
order by TotalDeathCount desc



--Number
select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(New_Cases)*100 as DeathPercentage
from [dbo].['Covid Deaths$']
--where location ='Cameroon' 
where location != null
Group by date
order by 1,2


--looking @total pop vs vaccinations
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(INT,vac.new_vaccinations))OVER (Partition by dea.location) as People_Vacinated
from [dbo].['Covid Deaths$'] dea
join [dbo].['Covid Vaccinations$'] vac
	on dea.location = vac.location
	and dea.date=vac.date
where dea.location ='Cameroon'
order by 2,3

--USE CTE

with Pop_vs_Vac
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(INT,vac.new_vaccinations))OVER (Partition by dea.location) as People_Vaccinated
from [dbo].['Covid Deaths$'] dea
join [dbo].['Covid Vaccinations$'] vac
	on dea.location = vac.location
	and dea.date=vac.date
where dea.location ='Cameroon'
)
select *,(People_Vaccinated/population)*100 as percentage_vaccinated
from Pop_vs_Vac


-- Temp Table

Drop Table if exists #Percent_Pop_Vaccinated
Create Table #Percent_Pop_Vaccinated
(
Location nvarchar(255),
Date datetime,
Population numeric,
new_vaccinations numeric,
People_vaccinated numeric
)

Insert into #Percent_Pop_Vaccinated
select dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(INT,vac.new_vaccinations))OVER (Partition by dea.location) as People_Vaccinated
from [dbo].['Covid Deaths$'] dea
join [dbo].['Covid Vaccinations$'] vac
	on dea.location = vac.location
	and dea.date=vac.date
where dea.location ='Cameroon'



--Creating View to store data for later visualizations

Create View Percent_Pop_Vaccinated as
select dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(INT,vac.new_vaccinations))OVER (Partition by dea.location) as People_Vaccinated
from [dbo].['Covid Deaths$'] dea
join [dbo].['Covid Vaccinations$'] vac
	on dea.location = vac.location
	and dea.date=vac.date
where dea.location ='Cameroon'


select *
from Percent_Pop_Vaccinated






