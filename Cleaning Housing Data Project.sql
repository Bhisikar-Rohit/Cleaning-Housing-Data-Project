/*

Cleaning Data in SQl Queries

*/

Select *
From PortfolioProject.dbo.NashvilleHousing 

---------------------------------------------------------------------------------------------

--Standardize Date Format 

Select saleDateConverted, Convert(Date,SaleDate)
From PortfolioProject.dbo.NashvilleHousing 

Update NashvilleHousing
Set saledate = convert(date,saledate)

Alter Table NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
Set SaleDateConverted = convert(date,saledate)

--------------------------------------------------------------------------------------------

--Populated Property Address Data

Select *
From PortfolioProject.dbo.NashvilleHousing 
--Where PropertyAddress is null
Order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL (a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
Join PortfolioProject.dbo.NashvilleHousing b
     on a.ParcelID = b.ParcelID
	 And a.[UniqueId] <> b.[UniqueId]
Where a.PropertyAddress is null 


Update a
SET PropertyAddress =  ISNULL (a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
Join PortfolioProject.dbo.NashvilleHousing b
     on a.ParcelID = b.ParcelID
	 And a.[UniqueId] <> b.[UniqueId]
Where a.PropertyAddress is null 

--------------------------------------------------------------------------------------------

--Breaking out Address into Individual Colums (Address, City, State)

Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is null
--Order by ParcelID

Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX (',',PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX (',',PropertyAddress) +1, Len(PropertyAddress)) as Address 

From PortfolioProject.dbo.NashvilleHousing


Alter Table NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX (',',PropertyAddress) -1)

Alter Table NashvilleHousing
Add PropertySplitCity Nvarchar(225);

Update NashvilleHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX (',',PropertyAddress) +1, Len(PropertyAddress))


Select *

From PortfolioProject.dbo.NashvilleHousing

Select OwnerAddress
From PortfolioProject.dbo.NashvilleHousing

Select
Parsename(Replace(OwnerAddress,',','.'), 3)
,Parsename(Replace(OwnerAddress,',','.'), 2)
,Parsename(Replace(OwnerAddress,',','.'), 1)
From PortfolioProject.dbo.NashvilleHousing


Alter Table NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitAddress = Parsename(Replace(OwnerAddress,',','.'), 3)

Alter Table NashvilleHousing
Add OwnerSplitCity Nvarchar(225);

Update NashvilleHousing
Set OwnerSplitCity = Parsename(Replace(OwnerAddress,',','.'), 2)

Alter Table NashvilleHousing
Add OwnerSplitState Nvarchar(225);

Update NashvilleHousing
Set OwnerSplitState = Parsename(Replace(OwnerAddress,',','.'), 1)


Select *
From PortfolioProject.dbo.NashvilleHousing

----------------------------------------------------------------------------------------

--Chnage Y and N to Yes and No in "Sold as Vacant" Field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2

Select SoldAsVacant
, Case when SoldAsVacant = 'Y' Then 'Yes'
       When SoldAsVacant = 'N' Then 'No'
	   Else SoldAsVacant
	   END
From PortfolioProject.dbo.NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant = Case When SoldAsVacant = 'Y' Then 'Yes'
When SoldAsVacant = 'N' Then 'No'
Else SoldAsVacant
End 


------------------------------------------------------------------------------------------------

-- Remove Duplicates

With RowNumCTE AS(
Select *,
ROW_NUMBER() Over (
Partition by ParcelID,
			 PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
			 ORDER By 
			  UniqueID
			  ) row_num

From PortfolioProject.dbo.NashvilleHousing
--order by ParcelID 
)
Select *
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress



Select *
From PortfolioProject.dbo.NashvilleHousing




------------------------------------------------------------------------------------------------------

--Delete Unused Coludms

Select *
From PortfolioProject.dbo.NashvilleHousing

Alter Table PortfolioProject.dbo.NashvilleHousing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress

Alter Table PortfolioProject.dbo.NashvilleHousing
Drop Column Saledate


