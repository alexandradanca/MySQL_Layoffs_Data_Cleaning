<h1 align="center">
    MySQL- Data Cleaning
    <br />
    <hr />
   Layoffs Dataset
</h1>
<h3>Case Study: Data Cleaning and Preparation for Layoffs Dataset</h3>
<h4>Introduction</h4>
<p>The layoffs dataset required extensive cleaning and preparation to ensure data integrity and consistency for further analysis. The SQL script provided outlines the steps taken to duplicate the dataset, remove duplicates, standardize data, handle null values, and eliminate unnecessary columns or rows. This case study explores the rationale, execution, and outcomes of these steps.</p>

<h4>0. Duplicating the Dataset</h4>
<p>To prevent accidental alterations to the original dataset, a duplicate table layoffs_db was created. This best practice ensures that the original data remains intact and available for reference or rollback if required.</p>

 ![image](https://github.com/user-attachments/assets/510fe7af-271c-4063-895b-7abd81b241ed)
<br/><br/>
<h4>1. Removing Duplicate Rows</h4>
<p>Duplicate rows were identified and removed using the following process:</p>

![image](https://github.com/user-attachments/assets/87db5943-3ac5-41db-8ac6-883cbc40f711)

<ol>
  <li>Identification of Duplicates</li>
  <img src="./outputs/1.duplicate_rows.png">
  <li>Removal of Duplicates</li>
</ol>
<p>The dataset now contains unique entries, reducing redundancy and potential biases in analysis</p>


<br/><br/>
<h4>2. Standardizing Data</h4>

![image](https://github.com/user-attachments/assets/479aa8f1-2520-419b-9d1b-db5610b216b0)

<ol>
  <li>Trimming Whitespace</li>
  <p>A stored procedure was used to identify and clean leading or trailing spaces for attribute <b>company</b></p>
  <img src="./outputs/2.1. white_space_btw_data.png">
  <li>Renaming Similar Data</li>
  <p>Standardization was applied to harmonize data values:</p>
  <ul>
    <li>Industries like "Crypto..." were renamed to "Crypto"</li>
    <img src="./outputs/2.2. similar_data_name.png">
    <li>Country names such as "United States..." were trimmed of extraneous periods or spaces.</li>
    <img src="./outputs/2.2. similar_data_name2.png">
  </ul>
  <li>Formatting Dates</li>
  <p>The date column was converted from text to a standard DATE format using STR_TO_DATE() and further validated with a schema update.</p>
</ol>
<p>The data is now consistent, readable, and ready for aggregation or analysis</p>


<br/><br/>
<h4>3. Handling Null and Blank Values</h4>

![image](https://github.com/user-attachments/assets/8bb0e89f-30d0-4b39-85fd-42954b88f186)

<ol>
  <li>Replacing Blank Values</li>
  <p>Blank values in the industry column were replaced with NULL to better represent missing data.</p>
  <li>Filling Missing Data</li>
  <img src="./outputs/3.1.check_null_val_industry.png">
  <p>Missing industry values were inferred and filled based on matching company and location values when available.</p>
  <img src="./outputs/3.2.check_similar_company.png">
</ol>


<br/><br/>
<h4>4. Removing rows with excessive nulls and removing unnecessary columns</h4>
<p>Rows where total_laid_off and percentage_laid_off were both NULL were deleted as they provided no actionable information.</p>

![image](https://github.com/user-attachments/assets/a994095a-5986-4898-9d2f-976e682c4740)

<img src="./outputs/4.multiple_column_with_null_val.png">


<br/><br/>
<h3>Conclusion</h3>
<p>This cleaning process transforms the layoffs dataset into a reliable resource for analysis. By addressing issues like duplicates, inconsistent formatting, and missing data, the dataset now aligns with best practices for data quality. Future analyses can confidently leverage this refined dataset to uncover trends, correlations, and actionable insights regarding layoffs across industries and regions.</p>
