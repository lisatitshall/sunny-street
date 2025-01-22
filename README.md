# Sunny Street Report

## Summary
Sunny Street provide healthcare to vulnerable people in the community. The aim of this project is to visualize Sunny Street data using PowerBI. The data was obtained from a [Viz for Social Good project](https://www.vizforsocialgood.com/join-a-project/sunnystreet21) in 2021.

The aims of the visualization are to:
- Demonstrate their social impact to stakeholders and sponsors (government, health services, philanthropists and corporate sponsors)
- Show how they positively impact people over the course of their lives
- Understand how the service has changed between 2019 and 2021 (including Covid-19)
- Understand how patient demographics have changed between 2019 and 2021
- Quantify the effect the service has on Emergency Department presentations

### Steps followed
- Step 1: Load data from Excel spreadsheets into Power BI
- Step 2: Use Power Query Editor to explore data and change datatypes as required

## Detailed steps
### Step 2: Use Power Query Editor to explore data
The following actions were taken for the patient data:
- Changed numerical data types to text if they didn't require calculations e.g. postcode
- Removed blank rows
- Replaced year of birth 1900 with null. This is where the year wasn't provided by the patient or wasn't added to the dataset.
- Replaced ethnicity "Not provided" with null because there were already a lot of nulls and there wasn't a good reason to have a separate "Not provided" category.
- Added a conditional column for Ethnicity Region. This was because there were many ethnicities listed and some only had a few data points. It made more sense to group into larger regions e.g. Europe, Asia, Africa, Middle East and Oceania. Note: the Oceania category consists of ethnicities that aren't Australian e.g. New Zealand and Samoa. 
- Replaced gender "Unknown" and "Other" with null because were only two data points with these entries. 

