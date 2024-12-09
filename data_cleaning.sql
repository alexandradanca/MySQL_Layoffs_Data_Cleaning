-- ---0. Duplicate the root db so as not to affect root data set 
-- Create new table like layoffs
CREATE TABLE layoffs_db
LIKE layoffs;

-- insert all the atributes
INSERT INTO layoffs_db
SELECT *
FROM layoffs;

-- ---1. Delete duplicate rows
-- View it
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country,
funds_raised_millions) AS row_num
FROM layoffs_db
ORDER BY row_num DESC;

-- Create new db
DROP TABLE IF EXISTS layoffs_db2;
CREATE TABLE `layoffs_db2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Insert atributes and values + row_num to show the duplicate rows
INSERT INTO layoffs_db2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country,
funds_raised_millions) AS row_num
FROM layoffs_db;

-- Delete duplicate row
DELETE
FROM layoffs_db2
WHERE row_num > 1;

-- --2. Standardizing Data
-- 2.1. White space between data for each variable
DROP PROCEDURE IF EXISTS white_space_in_var;
DELIMITER $$
USE `world_layoffs` $$
CREATE PROCEDURE white_space_in_var(IN column_name VARCHAR(100))
BEGIN
    SET @query = CONCAT(
        'SELECT * FROM layoffs_db2 WHERE ', column_name, ' LIKE " %" OR ', column_name, ' LIKE "% ";'
    );
    PREPARE stmt FROM @query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END $$
DELIMITER ;

CALL white_space_in_var('company'); -- just here we have white space for 11 rows
CALL white_space_in_var('location');
CALL white_space_in_var('industry');
CALL white_space_in_var('stage');
CALL white_space_in_var('country');

-- Delete white space
UPDATE layoffs_db2
SET company = TRIM(company);

-- 2.2. Rename similar data
SELECT DISTINCT(company) FROM layoffs_db2 ORDER BY 1;
SELECT DISTINCT(location) FROM layoffs_db2 ORDER BY 1;
SELECT DISTINCT(industry) FROM layoffs_db2 ORDER BY 1; -- Crypto
SELECT DISTINCT(stage) FROM layoffs_db2 ORDER BY 1;
SELECT DISTINCT(country) FROM layoffs_db2 ORDER BY 1; -- United States

-- Rename
UPDATE layoffs_db2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_db2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

-- 2.3. Formatate date and change datatype
UPDATE layoffs_db2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_db2
MODIFY COLUMN `date` DATE;

-- 3. Null/Blank Value
-- Change blank value to null
UPDATE layoffs_db2
SET industry = NULL
WHERE industry = '';

-- View null data
SELECT *
FROM layoffs_db2
WHERE industry IS NULL;

-- Check which industries are for the same company and join it
SELECT company, location, industry
FROM layoffs_db2
WHERE company = 'Airbnb';

-- Join the same industry if company name and location are the same
UPDATE layoffs_db2 l1
JOIN layoffs_db2 l2
  ON l1.company = l2.company
  AND l1.location = l2.location
SET l1.industry = l2.industry
WHERE l1.industry IS NULL AND l2.industry IS NOT NULL;


-- 4. Remove Unnecessary Columns/Rows
-- View ultiple columns with null data
SELECT *
FROM layoffs_db2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE 
FROM layoffs_db2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- Delete unnecessary Columns
ALTER TABLE layoffs_db2
DROP COLUMN row_num;