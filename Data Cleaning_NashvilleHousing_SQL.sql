-- Cleaning Data in SQL Queriess


--------------------------------------------------------------------------------------------------------

--Standardize date

SELECT SaleDateConverted, CONVERT(Date, SaleDate)
FROM NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate)

------IF above doesnt work, use below codes

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)


-----------------------------------------------------------------------------------------------------------------------------------

-- Populate Proprety Address data

SELECT *
FROM NashvilleHousing
--WHERE PropertyAddress is NULL
ORDER BY ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousing a
JOIN NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress is NULL

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousing a
JOIN NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress is NULL



-- Breaking out address into individual column(Address, City, state)

SELECT OwnerAddress
FROM NashvilleHousing
----WHERE PropertyAddress is NULL
--ORDER BY ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as Address
FROM NashvilleHousing


ALTER TABLE NashvilleHousing
Add PropertySplitAddress NVarChar(225);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE NashvilleHousing
Add PropertySplitCity NVarchar(225);

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))

SELECT *
FROM NashvilleHousing


SELECT OwnerAddress
FROM NashvilleHousing

SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.') ,3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') ,2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') ,1)
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
Add OwnerSplitAddress NVarChar(225);

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity NVarChar(225);

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState NVarChar(225);

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,3)

SELECT *
FROM NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------------------

--CHANGE Y and N to YES and No in 'SoldAsVacan' field

SELECT SoldAsVacant,
CASE 
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'NO'
	ELSE SoldAsVacant
	END
FROM NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = 
CASE 
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'NO'
	ELSE SoldAsVacant
	END
FROM NashvilleHousing

Select Distinct(SoldAsVacant)
FROM NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------------------

-- REMOVE DUPLICATES

WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
	ORDER BY UniqueID
	) row_num
FROM NashvilleHousing
--ORDER BY ParcelID
)
SELECT*
FROM RowNumCTE
WHERE row_num > 1
--ORDER BY SaleDate

------------------------------------------------------------------------------------------------------------------------------------------

-- Delete Unused Column

ALTER TABLE NashvilleHousing
DROP COLUMN PropertyAddress, OwnerAddress, TaxDistrict

ALTER TABLE NashvilleHousing
DROP COLUMN SaleDate


Select*
FROM NashvilleHousing