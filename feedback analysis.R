library(tidyverse)
library(tidytext)
library(readxl)
library(textdata)

#read feedback in from Excel
feedback <- read_excel("data/feedback.xlsx")

#three separate dataframes for each feedback type
journal_entry <- feedback %>% select(JournalEntry) %>% 
  filter(!is.na(JournalEntry))

patient_feedback <- feedback %>% select(PatientFeedback) %>% 
  filter(!is.na(PatientFeedback))

service_provider_feedback <- feedback %>% 
  select(ServiceProviderFeedbackReceived) %>% 
  filter(!is.na(ServiceProviderFeedbackReceived))

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

#count most popular
feedback_common <- patient_feedback_words %>%
  count(word, sort = TRUE)

#bar chart of 10 most common words
feedback_common %>% 
  slice_head(n= 10) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(n, word)) +
  geom_col() +
  labs(y = NULL) +
  theme_bw()

#get positive / negative sentiments
bing <- get_sentiments("bing")

#left join to get positive/negative/neutral
patient_feedback_words_sentiment <- patient_feedback_words %>%
  left_join(bing) %>% 
  replace_na(list(sentiment = "neutral"))

#plot number of positive/negative/neutral words
barplot(table(patient_feedback_words_sentiment$sentiment))

#alternatively count words first, then find sentiment
feedback_common_sentiment <- patient_feedback_words %>%
  count(word, sort = TRUE) %>%
  left_join(get_sentiments("bing")) %>% 
  replace_na(list(sentiment = "neutral"))

#same bar chart as before but coloured by sentiment to highlight
# the positive words
feedback_common_sentiment %>% slice_head(n= 10) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(n, word, fill = sentiment)) +
  geom_col() +
  labs(y = NULL) +
  theme_bw()

#plot 10 most common words of all sentiments
#can either facet wrap or show all on same bar chart
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

#look at number rating instead of positive / negative
afinn <- get_sentiments("afinn")

feedback_common_rating <- patient_feedback_words %>%
  count(word, sort = TRUE) %>%
  left_join(afinn) %>% 
  replace_na(list(value = 0))

#plot ratings against how many times words appear
ggplot(feedback_common_rating, aes(x = value, y = n)) +
  geom_bin_2d() +
  theme_bw() +
  theme(
    line= element_blank(),
    axis.text=element_text(size=18),
    axis.title=element_text(size=18),
    legend.text=element_text(size=18),
    legend.title=element_text(size=18)) +
  labs(x = "Sentiment Score (5 = extremely positive)", 
       y =  "Word Count") +
  scale_x_continuous(breaks = c(-5:5), labels = c(-5:5), limits = c(-5,5)) +
  scale_fill_gradient(name = "Frequency", high = "#ED0C6E", low = "#F89EC5" )
       
