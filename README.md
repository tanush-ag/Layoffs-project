"layoffs.csv" is the raw dataset obtined from the internet. I contains information regarding layoffs of the employees in absolute and relative terms from various
companies, indstry, location, fund raised in million, and a couple of more columns.

"data_cleaning.sql" is created in MySQL Workbench version 8.0
This file contains SQL code for cleaning the dataset to make it usable to line out insights from the dataset.
To practice professionalism, duplicate tables have been created to be able to retrive original dataset if anything goes haywire.
As a general practice in professional environment, duplicate tables have been created to ensure that the original dataset could be retrieved in case of any mishappening(s).
In "layoffs_staging_2" table, rows have been deleted where there are null values in both the cols ('total_laid_off' & 'percentage_laid_off') as the data could not be populated.
