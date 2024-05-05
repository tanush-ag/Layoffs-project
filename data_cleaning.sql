-- Data Cleaning
Select * 
FROM layoffs;

-- 1. Removing Duplicates
-- 2. Standardize data
-- 3. Null values/ blank
-- 4. Remove any unneccesary cols


SELECT * from layoffs;

CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT *
FROM layoffs_staging;


INSERT layoffs_staging
SELECT *
FROM layoffs;

-- checking duplicates by assigning row number

SELECT *, 
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, 
percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
FROM layoffs_staging;

WITH duplicates as (
SELECT *, ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, 
percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
FROM layoffs_staging)

-- SELECT (sum(row_num)/2 FROM duplicates WHERE row_num > 1;

SELECT *
FROM duplicates
WHERE row_num>1;
-- WHERE company LIKE "Better%";

-- Creating another table w/o duplicate entries

-- Copied clipboard from layoffs_staging table

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT *, ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, 
percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
FROM layoffs_staging;

-- Deleting the duplicate values
DELETE
FROM layoffs_staging2
WHERE row_num>1;

-- checking if duplicates are deleted
SELECT *
FROM layoffs_staging2
WHERE row_num>1;

-- Standardizing the data

-- a. removing white spaces from company name
SELECT company, TRIM(company)
FROM layoffs_staging2;

-- Updating Company col

UPDATE layoffs_staging2
SET company = TRIM(company);

SELECT DISTINCT industry 
from layoffs_staging2
ORDER BY 1;

-- Combining similar industries (crypto)
UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT location
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET location = 'Dusseldorf'
WHERE industry LIKE 'DÃ¼sseldorf';

SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;

SELECT DISTINCT country,TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

-- Converting `date`col data type from text to date

SELECT `date` , STR_TO_DATE(`date`,'%m/%d/%Y')
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`,'%m/%d/%Y');

-- Using ALTER as `date` data type did not changed;

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

SELECT * 
FROM layoffs_staging2;

SELECT DISTINCT company
FROM layoffs_staging2
ORDER BY 1;


-- Populating industry column w/o values, if possible

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL OR industry = '';

-- checking for different companies if they have industry in any other entry
SELECT *
FROM layoffs_staging2
WHERE company LIKE 'Bally%';

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

-- Joining the same tables to fill in values

SELECT t1.company, t1.industry, t1.location, t2.company, t2.industry, t2.location
FROM	layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
WHERE t1.industry IS NULL
	AND t2.industry IS NOT NULL;
  
UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2 
		ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
	AND t2.industry IS NOT NULL;

-- Updated the industry by searching on internet
UPDATE layoffs_staging2
SET industry = 'Entertainment'
WHERE company LIKE 'Bally%';


