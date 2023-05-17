

--Cleaning Data in SQL Queries

Select * From PortfolioProject.dbo.HousingProject



-- Standardize Date Format

Select SaleDateConverted,convert(date,saledate) From 
PortfolioProject.dbo.HousingProject

Update HousingProject
Set SaleDateConverted = convert(date,saledate)

Alter Table HousingProject
Add SaleDateConverted Date;


-- Populate Property Address data

Select *
From HousingProject
--Where PropertyAddress is null
Order by ParcelID

Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.HousingProject a
JOIN PortfolioProject.dbo.HousingProject b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
SET a.PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.HousingProject a
JOIN PortfolioProject.dbo.HousingProject b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null





-- Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From PortfolioProject.dbo.HousingProject
--Where PropertyAddress is null
--Order by ParcelID

Select SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) AS Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) AS Address
From PortfolioProject.dbo.HousingProject

Alter Table HousingProject
Add SplitPropertyAddress NVARCHAR(255);

Update HousingProject
Set SplitPropertyAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

Alter Table HousingProject
Add SplitPropertyCity NVARCHAR(255);

Update HousingProject
Set SplitPropertyCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))

Select * 
From PortfolioProject.dbo.HousingProject

Select OwnerAddress
From PortfolioProject.dbo.HousingProject

Select PARSENAME(REPLACE(OwnerAddress,',','.'),3)
,PARSENAME(REPLACE(OwnerAddress,',','.'),2)
,PARSENAME(REPLACE(OwnerAddress,',','.'),1)
From PortfolioProject.dbo.HousingProject

ALter Table HousingProject
Add OwnerSplitAddress NVARCHAR(255);

Update HousingProject
Set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

Alter Table HousingProject
Add OwnerSplitCity NVARCHAR(255);

Update HousingProject
Set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

Alter Table HousingProject
Add OwnerSplitState NVARCHAR(255);

Update HousingProject
Set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)
 
Select *
From PortfolioProject.dbo.HousingProject




-- Change Y and N to Yes and No in "Sold as Vacant" field

Select DISTINCT(SoldAsVacant),COUNT(SoldAsVacant)
From PortfolioProject.dbo.HousingProject
Group by SoldAsVacant
Order By 2


Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' Then 'Yes'
       When SoldAsVacant = 'N' Then 'No'
	   ELSE SoldAsVacant
	   END
From PortfolioProject.dbo.HousingProject

Update HousingProject
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' Then 'Yes'
       When SoldAsVacant = 'N' Then 'No'
	   ELSE SoldAsVacant
	   END





-- Remove Duplicates

WITH ROWNUMCTE AS (
Select *,
     ROW_NUMBER() OVER(
	 PARTITION BY ParcelID,
	              PropertyAddress,
				  SaleDate,
				  SalePrice,
				  LegalReference
				  Order By 
				  UniqueID
				  ) row_num
				  
From PortfolioProject.dbo.HousingProject
--Order By ParcelID
)

Select *
From ROWNUMCTE
Where row_num > 1
Order by PropertyAddress




-- Delete Unused Columns

Select * 
From PortfolioProject.dbo.HousingProject

Alter Table PortfolioProject.dbo.HousingProject
DROP COLUMN OwnerAddress,TaxDistrict,PropertyAddress

Alter Table PortfolioProject.dbo.HousingProject
DROP COLUMN SaleDate





--- Importing Data using OPENROWSET and BULK INSERT	





--USE PortfolioProject 






---- Using BULK INSERT





---- Using OPENROWSET