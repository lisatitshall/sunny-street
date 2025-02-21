# Sunny Street Report

## Summary
Sunny Street provide healthcare to vulnerable people in the community. The aim of this project is to visualize Sunny Street data using Power BI. The data was obtained from a [Viz for Social Good project](https://www.vizforsocialgood.com/join-a-project/sunnystreet21) in 2021.

The aims of the visualization are to:
- Demonstrate their social impact to stakeholders and sponsors
- Show how they positively impact people over the course of their lives
- Understand how the service has changed between 2019 and 2021 (including Covid-19)
- Understand how patient demographics have changed between 2019 and 2021

### Steps followed
- Step 1: Use Sunny Street brand guidelines to create a theme in Power BI (note: font types don't match)
- Step 2: Load data from Excel spreadsheets into Power BI
- Step 3: Use Power Query Editor to explore data and change datatypes as required
- Step 4: Brainstorm visualization ideas taking the overall aims into account
- Step 5: Add measures and calculated columns
- Step 6: Add visualizations and visual calculations
- Step 7: Add R script visualizations for free text analysis

For more detail on the actions taken during selected steps see the [Detailed Steps](#detailed-steps) section.

## Report
The first page of the report was a high level overview of the services that Sunny Street provide. A row of cards show key KPI's, two simple bar and column charts show activities and patient ages and a map shows activity locations. 

![image](https://github.com/user-attachments/assets/30cee75d-8c5c-41f4-8407-70b86199c85c)

The second page explored how services have changed over time with particular emphasis on the impact of Covid-19. 
![image](https://github.com/user-attachments/assets/d01181ae-ecc7-40bb-ba9f-bafe8fecbeb2)

The third page looked at patient demographics and how they've also changed over time. 

![image](https://github.com/user-attachments/assets/688ba44c-5923-41d5-8a13-8a96c6e51cc1)

The final page looks at feedback from patients and service providers. The visuals on the left explore the 10 most common words of positive, neutral and negative sentiment. The visuals on the right give each word a sentiment score between -5 and 5 where 0 is neutral and 5 is extremely positive. The darker the pink, the more words have the same sentiment score/word count. 

![image](https://github.com/user-attachments/assets/31bd5134-29a7-48db-b58e-178507b0b41a)

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
    - Total / Average activity duration
    - Bar chart showing number of activities by program
    - Bar chart showing number of patients by age and housing status
  - Services
    - Bar chart showing number of activities by quarter (any trend by program, filter to remove partial quarters/years)
    - Line chart showing conversations over time - mental health, suicide preventation, substance use, health education, medication and total (patients)
    - Bar chart showing number of referrals by year
    - Line chart showing consultations over time - medical, nurse practitioner, nursing/paramedic, allied health, telehealth
    - Add Covid information to highlight differences in services (March 23rd 2020 national lockdown, March 30th Queensland lockdown, 2nd May 2020 restrictions eased, July 8th 2020 - October 26th 2020 Victoria lockdown, Dec-Jan 2021 smaller lockdowns for Sydney areas, Feb short Victoria lockdown, Jan 8th /Mar/June/July/August 2021 small Queensland lockdowns, May-Aug 2021 Victoria/NSW lockdowns, Oct 2021 last lockdowns end)
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
  ### Step 6: Add visualizations and visual calculations
  The following visual calculation was added to a matrix summarizing the housing status of Sunny Street service users. It calculates the percentage change between years. Data types in visual calculations can't be changed so the FORMAT function was used to return a percentage with 0 decimal places. 
  ```
  % Change = IF(
    ISBLANK(PREVIOUS([%])),
    BLANK(),
    FORMAT(([%] - PREVIOUS([%])), "0%")
    )
  ```
  The final table after formatting is shown below.
  
  ![image](https://github.com/user-attachments/assets/2e02583d-f9ac-41ca-bd6d-4f65a576e065)

  The following line chart shows how the number of consultations has changed over time. Sunny Street were interested in seeing how Covid-19 affected services so vertical lines have been added to show key milestones of the pandemic. The number of consultations saw a sharp spike after the 1st lockdown and slowed down after restrictions were eased. In November 2020 there was another spike which could be due to rising cases before the 2nd lockdown was introduced in January 2021. The start of the pandemic also coincided with the introduction of telehealth consultations. 

  ![image](https://github.com/user-attachments/assets/34226984-ca59-4970-bfcb-aa9ba0a06638)

  For a map visual a custom tooltip was created (see below). This was useful for a couple of reasons:
  - By default the latitude and longitude were shown on the tooltip. They didn't add useful information and looked messy.
  - They allow for a quick comparison between activities in all areas (shown on cards at the top of the page) with a single area
 
  ![image](https://github.com/user-attachments/assets/f15e220b-e68f-411c-a479-8e29167f3634)

  ### Step 7: Use R scripts for free text analysis
  The following R code was used to produce visualizations plotting the 10 most common words by sentiment.
  ```
  #create a list of common words that won't be meaningful in this context
  common_words <- c("patient", "patients", "person", "people", 
                    "sunny", "street", "ss",
                    "nurse", "doctor", "dr") 
  other_stop_words <- as.data.frame(common_words) %>% 
    rename(word = common_words)
  
  #tokenize patient feedback into words and remove stop/common words
  patient_feedback_words <- patient_feedback %>% 
    filter(!is.na(PatientFeedback)) %>%
    unnest_tokens(word, PatientFeedback) %>% 
    anti_join(stop_words) %>% anti_join(other_stop_words)

  #count words first, then find sentiment
  feedback_common_sentiment <- patient_feedback_words %>%
  count(word, sort = TRUE) %>%
  left_join(get_sentiments("bing")) %>% 
  replace_na(list(sentiment = "neutral"))

  #plot 10 most common words of all sentiments
  feedback_common_sentiment %>%
    group_by(sentiment) %>%
    slice_max(n, n= 10, with_ties = FALSE) %>%
    ungroup() %>% 
    mutate(word = reorder(word, n)) %>%
    ggplot(aes(n, word, fill = sentiment)) +
    geom_col() +
    facet_wrap(~sentiment, scales = "free_y") +
    labs(y = NULL, x = "Word Count") +
    theme_bw() +
    theme(axis.text=element_text(size=18),
          axis.title=element_text(size=18),
          legend.text=element_text(size=18),
          legend.title=element_text(size=18),
          strip.text = element_blank(),
          line= element_blank()) +
    scale_fill_manual(values = c("#FDDB22", "#5F6B6D", "#ED0C6E"))
  ```

