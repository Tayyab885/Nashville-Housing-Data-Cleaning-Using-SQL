Select *
From dbo.NashvilleHousingData;

-- Task#1: Standardize the Date Format

Select SaleDate,
	CONVERT(Date,SaleDate)
From PortfolioProjects.dbo.NashvilleHousingData;

-- First we will Create a new column
Alter Table NashvilleHousingData
Add SaleDateConverted  Date;

-- Updating the new column
Update NashvilleHousingData
Set SaleDateConverted = CONVERT(Date,SaleDate);

Select SaleDateConverted
From NashvilleHousingData;

-- Task#2: Populate Property Address Data

Select PropertyAddress
From NashvilleHousingData;

-- Checking Null values in PropertyAddress
Select *
From NashvilleHousingData
Where PropertyAddress Is Null;

-- Join table to itself based on ParcelID and UniqueID
Select t1.ParcelID,
	t1.PropertyAddress,
	t2.ParcelID,
	t2.PropertyAddress
From NashvilleHousingData t1
Join NashvilleHousingData t2
	ON t1.ParcelID = t2.ParcelID
	AND t1.[UniqueID ] != t2.[UniqueID ]
Where t1.PropertyAddress Is NULL;

-- Filling the null values
Select t1.ParcelID,
	t1.PropertyAddress,
	t2.ParcelID,
	t2.PropertyAddress,
	ISNULL(t1.PropertyAddress,t2.PropertyAddress)
From NashvilleHousingData t1
Join NashvilleHousingData t2
	ON t1.ParcelID = t2.ParcelID
	AND t1.[UniqueID ] != t2.[UniqueID ]
Where t1.PropertyAddress Is NULL;

-- Update the column to fill the values

Update t1
SET PropertyAddress = ISNULL(t1.PropertyAddress,t2.PropertyAddress)
From NashvilleHousingData t1
Join NashvilleHousingData t2
	ON t1.ParcelID = t2.ParcelID
	AND t1.[UniqueID ] != t2.[UniqueID ]
Where t1.PropertyAddress Is NULL;

Select *
From NashvilleHousingData
Where PropertyAddress Is Null;

-- Task#3: Splitting the Address in Individual columns for(address,city,State)

Select SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1) as Address,
	SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as City
From NashvilleHousingData;

-- We have to create two columns to update it in the data

Alter Table NashvilleHousingData
Add AddressOfProperty Nvarchar(255);

Update NashvilleHousingData
Set AddressOfProperty = SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1);

Alter Table NashvilleHousingData
Add CityOfProperty Nvarchar(255);

Update NashvilleHousingData
Set CityOfProperty = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress));


Select *
From NashvilleHousingData;


-- Now for OwnerAddress
Select OwnerAddress
From NashvilleHousingData;

-- This time we will use Parsename(Remember Parsname split data based on period(.) so we have to replace the comma(,) with period(.)) and it goes from back so 1 means last one.


Select 
	PARSENAME(Replace(OwnerAddress,',','.'),1) as StateOfOwner,
	PARSENAME(Replace(OwnerAddress,',','.'),2) as CityOfOwner,
	PARSENAME(Replace(OwnerAddress,',','.'),3) as AddressOfOwner
From NashvilleHousingData;


-- We have to createcolumns to update it in the data

Alter Table NashvilleHousingData
Add AddressOfOwner Nvarchar(255);

Update NashvilleHousingData
Set AddressOfOwner = PARSENAME(Replace(OwnerAddress,',','.'),3);

Alter Table NashvilleHousingData
Add CityOfOwner Nvarchar(255);

Update NashvilleHousingData
Set CityOfOwner = PARSENAME(Replace(OwnerAddress,',','.'),2);

Alter Table NashvilleHousingData
Add StateOfOwner Nvarchar(255);

Update NashvilleHousingData
Set StateOfOwner = PARSENAME(Replace(OwnerAddress,',','.'),1);

Select *
From NashvilleHousingData;

-- Task#4 Changing values of SoldAsVacant to only Yes and No

Select Distinct(SoldAsVacant)
From NashvilleHousingData;

Select Distinct(SoldAsVacant), 
	COUNT(SoldASVacant)
From NashvilleHousingData
Group By SoldAsVacant
Order By 2;

-- Replace the Y with Yes and N with No
Select SoldAsVacant,
	Case When SoldAsVacant = 'Y' Then 'Yes'
		When SoldAsVacant = 'N' Then 'No'
		Else SoldAsVacant
	END
From NashvilleHousingData;

-- Update the column
Update NashvilleHousingData
SET SoldAsVacant = Case When SoldAsVacant = 'Y' Then 'Yes'
		When SoldAsVacant = 'N' Then 'No'
		Else SoldAsVacant
		END;


Select Distinct(SoldAsVacant), 
	COUNT(SoldASVacant)
From NashvilleHousingData
Group By SoldAsVacant
Order By 2;


-- Task#5: Remove Duplicates

With ROWNUM AS(
		Select *,
			ROW_NUMBER() OVER(Partition BY ParcelID,
								PropertyAddress,
								SalePrice,
								SaleDate,
								LegalReference 
								Order By UniqueID) row_num
		From NashvilleHousingData
)

Select *
From ROWNUM
Where row_num > 1;

-- Delete the Duplicates
With ROWNUM AS(
		Select *,
			ROW_NUMBER() OVER(Partition BY ParcelID,
								PropertyAddress,
								SalePrice,
								SaleDate,
								LegalReference 
								Order By UniqueID) row_num
		From NashvilleHousingData
)

Delete 
From ROWNUM
Where row_num > 1;

-- Checking Again
With ROWNUM AS(
		Select *,
			ROW_NUMBER() OVER(Partition BY ParcelID,
								PropertyAddress,
								SalePrice,
								SaleDate,
								LegalReference 
								Order By UniqueID) row_num
		From NashvilleHousingData
)

Select *
From ROWNUM
Where row_num > 1;



-- Task#6 Delete Unused Columns
Select *
From NashvilleHousingData;

-- Lets delete the PropertyAddress and OwnerAddress as we create new column based on addres,city and state for both

Alter Table NashvilleHousingData
Drop Column PropertyAddress,OwnerAddress,TaxDistrict;

Alter Table NashvilleHousingData
Drop Column SaleDate;

---
Select *
From NashvilleHousingData;