SELECT *
FROM SQLHousing.dbo.Housing

/* Standardizing Sale Date */
SELECT SaleDate,CONVERT(Date,SaleDate)
FROM SQLHousing.dbo.Housing

ALTER TABLE SQLHousing.dbo.Housing
ADD SaleDateStd Date;

UPDATE SQLHousing.dbo.Housing
SET SaleDateStd = CONVERT(Date, SaleDate)

SELECT SaleDateStd
FROM SQLHousing.dbo.Housing

/*Populating Property Address NULL Spaces */
SELECT *
FROM SQLHousing.dbo.Housing
ORDER BY ParcelID

/* PARCEL ID is the address identifier. So finding parcel IDS of the 
NULL data so as to fill it with the address of that parcel ID which 
can be found in the rest of the dataset. Unique ID Is different for each 
entry */

SELECT Housing1.ParcelID, Housing1.PropertyAddress,Housing2.ParcelID,Housing2.PropertyAddress, ISNULL(Housing1.PropertyAddress, Housing2.PropertyAddress) 
/* ISNULL basically sees if the address of housing1 is NULL then we set it to Housing2 address */
FROM SQLHousing.dbo.Housing Housing1
JOIN SQLHousing.DBO.Housing Housing2
ON Housing1.ParcelID=Housing2.ParcelID
AND Housing1.[UniqueID] <> Housing2.[UniqueID]
WHERE Housing1.PropertyAddress IS NULL

UPDATE Housing1
SET PropertyAddress =ISNULL(Housing1.PropertyAddress, Housing2.PropertyAddress)
FROM SQLHousing.dbo.Housing Housing1
JOIN SQLHousing.DBO.Housing Housing2
ON Housing1.ParcelID=Housing2.ParcelID
AND Housing1.[UniqueID] <> Housing2.[UniqueID]
WHERE Housing1.PropertyAddress IS NULL

/*Breaking Down address to individual column (Address, City, State) */
SELECT PropertyAddress
FROM SQLHousing.dbo.Housing
ORDER BY ParcelID

SELECT SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress)-1) AS Address 
, SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) AS City 
/*CHARINDEX Basically looks for the character in the quotes in the string PropertyAddress and returns value till that character */
FROM SQLHousing.dbo.Housing

ALTER TABLE SQLHousing.dbo.Housing
ADD PropertySplitAddress nvarchar(255)

ALTER TABLE SQLHousing.dbo.Housing
ADD PropertySplitCity nvarchar(255)

UPDATE SQLHousing.dbo.Housing
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress)-1)

UPDATE SQLHousing.dbo.Housing
SET PropertySplitCity =  SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

/*Similary spiliting Owner addres but using alternative method. This is how owner 
address is currently stored: 1808  FOX CHASE DR, GOODLETTSVILLE, TN */
SELECT OwnerAddress
FROM SQLHousing.DBO.Housing

SELECT 
PARSENAME(REPLACE(OwnerAddress,',','.'),1) 
/* The PARSENAME only see '.'as a delimiter. So first we replace all the 
',' to '.' and then pass that through Parsename starting from position 1 which 
is the start of the Address. */ 
FROM SQLHousing.DBO.Housing

/* This only returns TN which is after the last ',' */

SELECT 
PARSENAME(REPLACE(OwnerAddress,',','.'),1) 
,PARSENAME(REPLACE(OwnerAddress,',','.'),2) 
,PARSENAME(REPLACE(OwnerAddress,',','.'),3) 
FROM SQLHousing.DBO.Housing

/*This now separatesth eaddress but it does ot backwards, 
so you get state - City-Address */ 
SELECT 
PARSENAME(REPLACE(OwnerAddress,',','.'),3)  
,PARSENAME(REPLACE(OwnerAddress,',','.'),2) 
,PARSENAME(REPLACE(OwnerAddress,',','.'),1) 
FROM SQLHousing.DBO.Housing
/* So we just change the starting position */

ALTER TABLE SQLHousing.DBO.Housing
ADD OwnerSplitAddress nvarchar(255)

UPDATE SQLHousing.DBO.Housing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3) 


ALTER TABLE SQLHousing.DBO.Housing
ADD OwnerSplitCity nvarchar(255)

UPDATE SQLHousing.DBO.Housing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2) 


ALTER TABLE SQLHousing.DBO.Housing
ADD OwnerSplitState nvarchar(255)

UPDATE SQLHousing.DBO.Housing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1) 

SELECT * 
FROM SQLHousing.dbo.Housing

/* Change Y and N to Yes and No in 'Sold as Vacant'Field */
SELECT DISTINCT(SoldAsVacant),COUNT(SoldAsVacant)
FROM SQLHousing.dbo.Housing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant
,CASE WHEN SoldAsVacant='Y' THEN 'Yes' 
	  WHEN SoldAsVacant='N' THEN 'No' 
	  ELSE SoldAsVacant
	  END
FROM SQLHousing.dbo.Housing

Update SQLHousing.dbo.Housing
SET SoldAsVacant = CASE WHEN SoldAsVacant='Y' THEN 'Yes' 
	  WHEN SoldAsVacant='N' THEN 'No' 
	  ELSE SoldAsVacant
	  END

/* Remove Duplicates */
/* So what we are doing is identifying duplicates by checking the parcel ID , Property Address, Sale price
Sale Date , legal reference. So we if find duplicate entries we will delet them. 
Using partition by to group the duplicates and orderby unique ID */

WITH Row_Num_CTE AS (
SELECT * ,
ROW_NUMBER() OVER (PARTITION BY  ParcelID, 
					PropertyAddress, 
					SalePrice, 
					SaleDate,
					LegalReference
					ORDER BY UniqueID ) Row_Num
FROM SQLHousing.dbo.Housing
)
DELETE
FROM Row_Num_CTE
WHERE Row_Num >1


SELECT * 
FROM SQLHousing.dbo.Housing

/* Deleting unused columns: Such As the original Property and Owner Address before splitting */

SELECT * 
FROM SQLHousing.dbo.Housing

ALTER TABLE SQLHousing.dbo.Housing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE SQLHousing.dbo.Housing
DROP COLUMN SaleDate