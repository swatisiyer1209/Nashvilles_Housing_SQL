# Nashville Housing Data Cleaning Project

This project focuses on cleaning and preparing Nashville housing data using SQL. The dataset includes information about housing in Nashville, and the goal is to perform data cleaning operations to ensure the dataset is ready for analysis.

## Dataset

The dataset used in this project is named "Nashville_Housing_Data.csv" and contains the following columns:

UniqueID 	ParcelID	LandUse	PropertyAddress	SaleDate	SalePrice	LegalReference	SoldAsVacant	OwnerName	OwnerAddress	Acreage	TaxDistrict	LandValue	BuildingValue	TotalValue	YearBuilt	Bedrooms	FullBath	HalfBath

- `UniqueID`: Unique identifier for each data entry.
- `ParcelID`: Unique identifier for each property.
- `LandUse`: Attributed to different uses of land.
- `PropertyAddress`: Street address of the property.
- `SaleDate`: Date when the property was sold.
- `SalePrice`: Sale price of the property.
- `LegalReference`: Reference to housing documentation.
- `SoldAsVacant`: Credits house occupation status during sale.
- `OwnerName`: Name of the owner.
- `OwnerAddress`: Address of the owner.
- `Acreage`: Total acres of the property.
- `TaxDistrict`: District of Taxation.
- `LandValue`: Valuation of land.
- `BuildingValue`: Valuation of building.
- `TotalValue`: Valuation of the property.
- `YearBuilt`: Year the property was built.
- `Bedrooms`: Number of bedrooms in the property.
- `FullBath`: Number of bathrooms in the property that contains a shower, a bathtub, a sink,   
              and a toilet.
- `HalfBath`: Number of bathrooms in the property that contains only a sink and a toilet.


## Data Cleaning Steps

The following data cleaning steps have been performed on the dataset:

1. **Standardizing Data:**
   - Ensured that sale dates are standardized.
   - Ensured that SoldAsVaccant data is standardized.
        
2. **Handling Missing Values:**
   - Checked for missing values in propety address.
   - Imputed missing values using ParcelID.

3. **Spliting Data into multiple column**
   - Split property address into multiple columns.
   - Split owner address into multiple columns.

4. **Removing Duplicates:**
   - Identified and removed duplicate rows from the dataset. 

4. **Deleting unused columns**



