/*

clearning data in SQL Queries

*/

Select *
from sqldatacleaning.dbo.NashvileHousing


-- Standardize Data Format


Select SaleDateConverted, CONVERT(date,SaleDate)
from sqldatacleaning.dbo.NashvileHousing



Update NashvileHousing
SET SaleDate - CONVERT(date,SaleDate)



ALTER TABLE NashvilleHousing   /*ALTER TABLE NashvilleHousing ALTER COLUMN SaleDate DATE*/
Add SaleDateConverted Date;


Update NashvileHousing
SET SaleDateConverted - CONVERT(date,SaleDate)



-- Populate Property Address data


   
Select  a.ParcelID, a.PropertyAddress, b.ParcelID, a.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from sqldatacleaning.dbo.NashvileHousing a
JOIN sqldatacleaning.dbo.NashvileHousing b
   on a.ParcelID = b.ParcelID
   AND a.[UniqueID ] <> [UniqueID ] 
Where a.PropertyAddress is null



Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from sqldatacleaning.dbo.NashvileHousing a
JOIN sqldatacleaning.dbo.NashvileHousing b
   on a.ParcelID = b.ParcelID
   AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


-- breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From sqldatacleaning.dbo.NashvileHousing
-- Where PropertyAddress is null
-- order by parcelID


SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 ,LEN(PropertyAddress)) as Address

from sqldatacleaning.dbo.NashvileHousing



ALTER TABLE sqldatacleaning.dbo.NashvileHousing   
Add PropertySplitAddress Nvarchar(255);


Update sqldatacleaning.dbo.NashvileHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) 



ALTER TABLE sqldatacleaning.dbo.NashvileHousing   
Add PropertySplitCity Nvarchar(255);


Update sqldatacleaning.dbo.NashvileHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 ,LEN(PropertyAddress)) 




Select *
from sqldatacleaning.dbo.NashvileHousing




Select OwnerAddress
from sqldatacleaning.dbo.NashvileHousing




Select
PARSENAME(REPLACE(OwnerAddress,',',','), 3)
,PARSENAME(REPLACE(OwnerAddress,',',','), 2)
,PARSENAME(REPLACE(OwnerAddress,',',','), 1)
from sqldatacleaning.dbo.NashvileHousing


ALTER TABLE sqldatacleaning.dbo.NashvileHousing  
Add OwnerSplitAddress Nvarchar(255);


UPDATE sqldatacleaning.dbo.NashvileHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',',','), 3)


ALTER TABLE sqldatacleaning.dbo.NashvileHousing  
Add OwnerSplitCity Nvarchar(255);


Update sqldatacleaning.dbo.NashvileHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',',','), 2)



ALTER TABLE sqldatacleaning.dbo.NashvileHousing   
Add OwnerSplitState Nvarchar(255);


Update sqldatacleaning.dbo.NashvileHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',',','), 1)


Select *
from sqldatacleaning.dbo.NashvileHousing



-- Change Y AND N to yes and no in "sold as vacant" field



Select Distinct(SoldAsVacant), Count(SoldAsVacant)
from sqldatacleaning.dbo.NashvileHousing
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'YES'
       When SoldAsVacant = 'N' THEN 'NO'
	   ELSE SoldAsVacant
	   END
From sqldatacleaning.dbo.NashvileHousing


Update sqldatacleaning.dbo.NashvileHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'YES'
       When SoldAsVacant = 'N' THEN 'NO'
	   ELSE SoldAsVacant
	   END


-- Remove Duplicates

WITH RownNumCTE AS(
Select *,
    ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
	             PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY 
				    UniqueID
					) row_num

From sqldatacleaning.dbo.NashvileHousing
--order by ParcelID
)
Select *
From RownNumCTE
Where row_num > 1
Order by PropertyAddress



-- Delete Unused Columns


Select *
from sqldatacleaning.dbo.NashvileHousing


ALTER TABLE sqldatacleaning.dbo.NashvileHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress


ALTER TABLE sqldatacleaning.dbo.NashvileHousing
DROP COLUMN SaleDate