# Exploring Categorical Data

#loading
orange <- read.csv('https://raw.githubusercontent.com/selva86/datasets/master/orange_juice_withmissing.csv')



# having a look at the data
str(orange)

require(tidyverse)
glimpse(orange)
head(orange)

summary(orange)


# checking for NA, hist, etc. at one place
orange%>%
  skimr::skim_to_wide() %>%
  kableExtra::kable() %>%
  kableExtra::kable_styling()



# Analysing categorical vars

levels(orange$Purchase)

#checking categorical vars against each other
table(orange$Purchase, orange$Store7)

mod(orange$Purchase)


# According to skimr report the number of NAs is not propertional to size of the
# dataset. As a result, we can we can use knnImpute to fix the NAs

#before exploring more we need to fix the 
require(caret)
preProcessMissingModel <- preProcess(orange, method = 'knnImpute')

require(RANN)
orange <- predict(preProcessMissingModel, newdata = orange)


#checking whether there are any NAs
anyNA(orange)

#Now looking at the data again:
orange%>%
  skimr::skim_to_wide() %>%
  kableExtra::kable() %>%
  kableExtra::kable_styling()


# Visually, we can detect some of the variables are skewed 
# but let's do it automatically

require(moments)
skewness(orange$STORE)

orange %>% 
  select(-Purchase, -Store7) %>% #exclusing categorical vars
  skewness() %>% 
  View()

#Skewness can be visualised as well:

skewness.info <- orange %>% 
  select(-Purchase, -Store7) %>% #exclusing categorical vars
  skewness() %>% 
  data.frame()

skewness.info$Variables <- rownames(skewness.info)
colnames(skewness.info) <- c("Skewness", "Variable")

skewness.info %>% 
  ggplot(aes(x=Variable, y=Skewness))+
  geom_bar(stat = "identity", fill="darkgreen", alpha=.7)+
  coord_flip()

#positive skewness means it's skewed towards right.



# A next step would be to transorm some variables.
# PctDiscMM is a good candidate

orange %>% 
  ggplot(aes(x=PctDiscMM))+
  geom_density(fill="darkgreen", alpha=.4)


# And this is the same variable after log transform
orange %>% 
  ggplot(aes(x=log(PctDiscMM)))+
  geom_density(fill="darkgreen", alpha=.4)



orange$PctDiscMM_log <- orange$PctDiscMM
#or alternatively 
#orange %>% 
#  mutate(PctDiscMM.log = log(PctDiscMM))



# After transformation, we need to check for outliers
# let's







