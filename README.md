# Nashville Housing Data Cleaning Using SQL
This is a SQL script to clean the Nashville Housing Data. The script includes several tasks such as standardizing the date format, populating the property address data, splitting the address into individual columns, changing values of SoldAsVacant to only 'Yes' and 'No', and removing duplicates.

## Task#1: Standardize the Date Format
To standardize the date format, we used the CONVERT() function to convert the SaleDate column to the Date data type. We created a new column named SaleDateConverted to store the converted date and then updated it using the UPDATE statement. Here is the code:
```
Select *
From dbo.NashvilleHousingData;

Select SaleDate,
	CONVERT(Date,SaleDate)
From PortfolioProjects.dbo.NashvilleHousingData;

Alter Table NashvilleHousingData
Add SaleDateConverted  Date;

Update NashvilleHousingData
Set SaleDateConverted = CONVERT(Date,SaleDate);

Select SaleDateConverted
From NashvilleHousingData;

```
## Task#2: Populate Property Address Data
To populate the property address data, we first checked for null values in the PropertyAddress column using the SELECT and WHERE statements. We then joined the table to itself based on ParcelID and UniqueID to get the missing property addresses. We filled the null values by updating the PropertyAddress column with the ISNULL() function. Here is the code:
```
Select PropertyAddress
From NashvilleHousingData;

Select *
From NashvilleHousingData
Where PropertyAddress Is Null;

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
```
## Task#3: Splitting the Address in Individual Columns for(address,city,State)
To split the address into individual columns for address, city, and state, we used the SUBSTRING() function to extract the address and city from the PropertyAddress column. We created two new columns named AddressOfProperty and CityOfProperty to store the extracted data and then updated them using the UPDATE statement. Here is the code:
```
Select SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1) as Address,
	SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as City
From NashvilleHousingData;

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

```
