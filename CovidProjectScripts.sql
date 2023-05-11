

Select * From PortfolioProject..CovidDeaths
Where continent is not null
Order by 3,4

--Select * From PortfolioProject..CovidVaccinations
--Order by 3,4

--Select the data from table to work upon

Select location,date,total_cases,new_cases,total_deaths,Population From
 PortfolioProject..CovidDeaths
 Where continent is not null
 Order by 1,2

 ----Find  Total cases Vs Total Deaths
 --Likely to get infectious

 Select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage From
 PortfolioProject..CovidDeaths
 Where location = 'India'
 Order by 1,2

 ----Find  Total cases Vs Total Population
 --Shows percentage of infected population

 Select location,date,population,total_cases,(total_cases/population)*100 AS InfectedPopulation
 From CovidDeaths
 Where continent is not null
 --Where location like 'India'
 order by 1,2

 --Shows countries with highest infection rate by population

 Select location,population,MAX(total_cases) as HighestInfectionCount,MAX((total_cases/population))*100 as InfectedPopulation
 From PortfolioProject..CovidDeaths
 Where continent is not null
 Group by location,population
 Order by InfectedPopulation Desc

 --Shows countries with highest DeathCount per population

 Select location,MAX(cast(total_deaths as int)) as TotalDeathCount 
 From CovidDeaths
 Where continent is not null
 Group by location
 Order by TotalDeathCount  Desc

 -- --Shows locationwise  Highest DeathCount per population

 Select location,MAX(Cast(total_deaths as int)) as TotalDeathCount
 From CovidDeaths
 Where continent is  null
 Group by location
 Order by TotalDeathCount Desc

 
 --Shows Continent wise highest DeathCount per population

 Select continent,MAX(Cast(total_deaths as int)) as TotalDeathCount
 From CovidDeaths
 Where continent is not  null
 Group by continent
 Order by TotalDeathCount Desc

 --Global Numbers Data

 Select SUM(new_cases) as total_cases,SUM(CAST(new_deaths as int)) as total_deaths,Sum(CAST(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
 From CovidDeaths
 Where continent is not null
 --Group by date
 Order by 1,2

 --Shows Total Population Vs  Vaccinations

 With PopvsVac(Continent,Location,Date,Population,New_Vaccinations,RollingPeopleVaccinated)
 as
 (
 Select dea.continent,dea.location,dea.date,population,vac.new_vaccinations
 ,SUM(Convert(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,dea.date) 
 as RollingPeopleVaccinated
 --,(RollingPeopleVaccinated/population)*100
 From CovidDeaths dea
 Join 
  CovidVaccinations vac
  on dea.location = vac.location
  and dea.date = vac.date
  Where dea.continent is not null
  --Order by 2,3
  )
Select * ,(RollingPeopleVaccinated/Population)*100
From PopvsVac

--TEMP TABLE


Drop Table if exists #Percentage_Population_Vaccinated
Create Table #Percentage_Population_Vaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #Percentage_Population_Vaccinated
 Select dea.continent,dea.location,dea.date,population,vac.new_vaccinations
 ,SUM(Convert(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,dea.date) 
 as RollingPeopleVaccinated
 --,(RollingPeopleVaccinated/population)*100
 From CovidDeaths dea
 Join 
  CovidVaccinations vac
  on dea.location = vac.location
  and dea.date = vac.date
  --Where dea.continent is not null
  --Order by 2,3


  Select * ,(RollingPeopleVaccinated/Population)*100
From #Percentage_Population_Vaccinated


--Create View For Data Storage later used for Visualization

Create View PercentagePopulationVaccinated as 
Select dea.continent,dea.location,dea.date,population,vac.new_vaccinations
 ,SUM(Convert(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,dea.date) 
 as RollingPeopleVaccinated
 --,(RollingPeopleVaccinated/population)*100
 From CovidDeaths dea
 Join 
  CovidVaccinations vac
  on dea.location = vac.location
  and dea.date = vac.date
  Where dea.continent is not null
  --Order by 2,3

  Select * From
  PercentagePopulationVaccinated





