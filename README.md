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
- Step 1: Use Sunny Street brand guidelines to create a theme in Power BI (font types need changing later)
- Step 2: Load data from Excel spreadsheets into Power BI
- Step 3: Use Power Query Editor to explore data and change datatypes as required
- Step 4: Brainstorm visualization ideas taking the overall aims into account
- Step 5: Add measures and calculated columns

For more detail on the actions taken during selected steps see the [Detailed Steps](#detailed-steps) section.

## Detailed steps
### Step 3: Use Power Query Editor to explore data
The following actions were taken for the patient data:
- Changed numerical data types to text if they didn't require calculations e.g. postcode
- Removed blank rows
- Replaced year of birth 1900 with null. This is where the year wasn't provided by the patient or wasn't added to the dataset.
- Replaced ethnicity "Not provided" with null because there were already a lot of nulls and there wasn't a good reason to have a separate "Not provided" category.
- Added a custom column for Ethnicity Region. This was because there were many ethnicities listed and some only had a few data points. It made more sense to group into larger regions e.g. Europe, Asia, Middle East and Africa and Oceania. Note: the Oceania category consists of ethnicities that aren't Australian e.g. New Zealander and Samoan. 
- Replaced gender "Unknown" and "Other" with null because were only two data points with these options.

The following actions were taken for the activity data:
- Changed the datatypes of Start Time and End Time columns from datetime to time
- Removed Length Hours column because the same information is stored in the Length Minutes column
- Replaced blank Journal Entry with null (and checked repeated comments were for different activities)
- Replaced negative number in Service provider conversations column with positive
- Replaced 0 with null in a number of columns. In the Data Dictionary a 0 in certain columns meant data wasn't recorded. This would be better as a null because 0's would affect calculations. 
- Replaced values in Patient Feedback and Service Provider Feedback columns. There were lots of ways of saying "None" which were all replaced with null. Also decided to replace numbers with null because the column is free text so we couldn't use these numbers for any calculations.

### Step 4: Brainstorming ideas 
- What data are we working with?
  - Time series, quantitative, free text and a little geospatial
- What are we trying to communicate?
  - Social impact of Sunny Street service (high level KPI's e.g. how many people helped)
  - Positive impact on people's lives (analyse free text feedback)
  - How the service has changed between 2019 and 2021 (comparison over categories)
  - How the demographics have changed between 2019 and 2021 (composition of age, gender, ethnicity, location and housing status)
- Who will look at the report and why?
  - Stakeholders and sponsors who help fund the service to understand impact and progress
- What could be on each page?
  - KPI's
    - Total number of patients helped
    - Number of unique patients helped (one person can be listed across multiple years)
    - Number of activities run
    - Map of where activities have run
    - Average activity duration
    - Total medical consults (maybe combine different types of consultations in one visual)
    - Total nursing / paramedic consults
    - Total patient conversations
    - Total patients turned away
  - Services
    - Line chart showing number of activities by month (any trend by quarter and program?)
    - Bar chart showing mental health conversations over time
    - Bar chart showing suicide prevention conversations over time
    - Bar chart showing substance use conversations over time
    - Bar chart showing number of referrals by year
  - Demographics
    - Bar chart of gender split over time (use % instead of count because we have part years of data)
    - Bar chart of housing status split over time (use % instead of count because we have part years of data)
    - Stacked bar chart of ethnicities by year (may need further simplification of ethnicities)
    - Stacked bar chart of age groups by year (would need sensible split for ages, check adulthood and retirement ages in Australia)
  - Feedback
    - Word cloud for common words in Journal Entry?
    - Sentiment analysis for patient feedback (seems mix of frustrations and positive)
   
### Step 5: Add measures and calculated columns
The following are examples of measures and calculated columns that were introduced.
- This measure allowed us to visualize how the gender of patients has changed between 2019 and 2021
  ```
  Gender Percentage = DIVIDE(
    COUNT(Patients[Gender]),
    CALCULATE(
        COUNT(Patients[Gender]), 
        REMOVEFILTERS(Patients[Gender]))
  )
  ```
- This calculated column further simplified the patient ethnicities to show a clearer relationship
  ```
  Ethnicity Region Broad = SWITCH(
    Patients[Ethnicity Region],
    "Aboriginal", "Aboriginal/Torres Strait Islander",
    "Torres Strait Islander", "Aboriginal/Torres Strait Islander",
    "European", "Other",
    "Middle Eastern and African", "Other", 
    "Asian", "Other",
    Patients[Ethnicity Region]
    )
  ```
- This calculated column allowed us to calculate the age of patients. Note: we don't have birth month of patients so some accuracy is lost.
  ```
  Age = IF(
    ISBLANK(Patients[Year of birth ]), 
    BLANK(),
    Patients[Year] - Patients[Year of birth ]
  )
  ```
- This calculated column allowed us to group ages
  ```
  Age Group = SWITCH(
    TRUE(),
    ISBLANK(Patients[Age]), BLANK(),
    Patients[Age] < 18, "0-17",
    Patients[Age] <= 24, "18-24",
    Patients[Age] <= 34, "25-34",
    Patients[Age] <= 44, "35-44",
    Patients[Age] <= 54, "45-54",
    Patients[Age] <= 64, "55-64",
    "65+"
  )
  ```

