
# dplyr package

library(dplyr)
# Manipulate (subsetting) cases--------------

df1<-filter(nydata,BOROUGH=="MANHATTAN")
# Alternative: df1<-subset(nydata,BOROUGH=="MANHATTAN")
rm(df1)

# Try filtering using loop
start_time <- Sys.time()
df1<-filter(nydata,BOROUGH=="MANHATTAN")
end_time <- Sys.time()

start_time1 <- Sys.time()
ind=0
k=1
for(i in 1:length(nydata$BOROUGH)){

  
  #if you use ! with a function it gives you the opposite of the value, below we use !is.na to get the not na values
if(!is.na(nydata$BOROUGH[i])){
  

  if (nydata$BOROUGH[i]=="MANHATTAN"){
    ind[k]=i
    k=k+1
  }
}
}
df2<-nydata[ind,]
end_time1 <- Sys.time()

print(paste0("Time taken using filter function: ", (end_time-start_time)))
print(paste0("Time taken using loop: ", (end_time1-start_time1)))



df1<-distinct(nydata,BOROUGH)
#Alternative: unique(nydata$BOROUGH)

df1<-sample_frac(nydata, 0.1, replace = TRUE)
df1<-sample_n(nydata, 1000, replace = TRUE)


# Alternative: x<-sample(1:(length(nydata$BOROUGH)/10), replace = TRUE)
# df1<-nydata[x,]

df1<-slice(nydata,10:15)
# Alternative: df1<-nydata[10:15,]

# Manipulate variables----------------

v<-pull(nydata, BOROUGH)
v<-pull(nydata, 3)
# Alternative: v<-nydata$BOROUGH

v<-select(nydata, BOROUGH,ZIP.CODE)
# Alternative: v<-nydata[,3:4]

df1<-arrange(nydata, BOROUGH)
df1<-arrange(nydata, desc(BOROUGH))
# Alternative: df1<-nydata[order(BOROUGH),]

# Create variables----------------
#the below code gives a new column named newcol with all the values =2
df1<-mutate(nydata,newcol =2)
# Alternative: df1$newcol=2

v<-transmute(nydata, NUMBER.OF.PERSONS.INJURED)
# Alternative: v<-nydata$NUMBER.OF.PERSONS.INJURED

rm(df1)
rm(v,ind,nydata)
df<- mtcars
# Data Aggregation------------------
# One function, one variable
#the below code can be used to calculate the mean of a variable and show it under mean_mpg
summarise(mtcars, mean_mpg=mean(mpg))
# One function multiple variables
summarise(mtcars, mean_mpg=mean(mpg), mean_cyl=mean(cyl))
# Many function, one variable
summarise(mtcars, mean_mpg=mean(mpg),max_mpg=max(mpg))
# Many function, multiple variable
summarise(mtcars, mean_mpg=mean(mpg),max_cyl=max(cyl))

# One function, one variable using group_by function
summarise(group_by(mtcars,cyl), mean_mpg=mean(mpg))
# One function, many variable using group_by function
summarise(group_by(mtcars,cyl), mean_mpg=mean(mpg), mean_disp=mean(disp))
# Many function, many variable using group_by function
summarise(group_by(mtcars,cyl), count_cyl=n(), mean_mpg=mean(mpg), max_disp=max(disp))

# Use of summarise_each function
summarise_each(group_by(mtcars,cyl),funs(min, max, mean),mpg,disp)

# Calculate the number of persons injured by borough using summarise
summarise(group_by(nydata,BOROUGH), number_of_persons_injured = sum(NUMBER.OF.PERSONS.INJURED,na.rm = TRUE))
#use na.rm to remove the NA values from the column 
temp <- subset(nydata, nydata$BOROUGH == "BRONX")
sum(temp$NUMBER.OF.PERSONS.INJURED, na.rm = TRUE)

# Merging dataframes--------------------------
one <- mtcars[1:4, ]
two <- mtcars[11:14, ]
df3<-bind_rows(one, two)
# Alternative: df3<-rbind(one,two)
df3<-bind_cols(one, two)
# Alternative: df3<-cbind(one,two)
# The above rbind and cbind functions will work only if the number of columns are queal in both Dataframe and the header of the columns match
# bind_cols is better than cbind because it changes the name of the header if they are both same


# Joining two data table if both have one common column

a<-data.frame("x1"=c("A","B","C"),"x2"=c(1,2,3),stringsAsFactors = FALSE )
b<-data.frame("x1"=c("A","B","D"),"x3"=c(T,F,T),stringsAsFactors = FALSE )

left_join(a,b,by="x1")

right_join(a,b,by="x1")

inner_join(a,b,by="x1")

full_join(a,b,by="x1")

# Joining two data table if both have multiple common column

a<-data.frame("x1"=c("A","B","C"),"x2"=c(1,2,3),"x4"=c(10,20,30),stringsAsFactors = FALSE )
b<-data.frame("x1"=c("A","B","D"),"x3"=c(T,F,T),"x4"=c(10,20,30),stringsAsFactors = FALSE )

left_join(a,b,by=c("x1","x4"))
inner_join(a,b,by=c("x1","x4"))

# Joining two data table by forcing one column equal to another column

a<-data.frame("x1"=c("A","B","C"),"x2"=c(1,2,3),stringsAsFactors = FALSE )
b<-data.frame("x5"=c("A","B","D"),"x3"=c(T,F,T),stringsAsFactors = FALSE )

left_join(a,b,by=c("x1"="x5"))
inner_join(a,b,by=c("x1"="x5"))
# inner_join(x, y): Return all rows from x where there are matching values in y, 
#and all columns from x and y. If there are multiple matches between x and y, 
#all combination of the matches are returned. 
# This is a mutating join.
ljsp <- left_join(superheroes, publishers)


# inner_join(x, y): Return all rows from x where there are matching values in y, 
# and all columns from x and y. If there are multiple matches between x and y, 
# all combination of the matches are returned. 
# This is a mutating join.
ijps <- inner_join(publishers, superheroes)

# semi_join(x, y): Return all rows from x where there 
# are matching values in y, keeping just columns from x.
# A semi join differs from an inner join because an inner join will return 
# one row of x for each matching row of y, where a semi join will never duplicate rows of x. 
# This is a filtering join.
sjsp <- semi_join(superheroes, publishers)

# anti_join(x, y): Return all rows from x where there are not matching values in y, 
#keeping just columns from x. This is a filtering join.
ajps <- anti_join(publishers, superheroes)

# full_join(x, y): Return all rows and all columns from both x and y. 
#Where there are not matching values, returns NA for the one missing. 
#This is a mutating join.
fjsp <- full_join(superheroes, publishers)


# Pipe operator for clean code
library(magrittr)

nydata %>%
  group_by(BOROUGH)%>%
  summarise(sum_injured=sum(NUMBER.OF.PERSONS.INJURED, na.rm=TRUE)) %>%
  arrange(desc(sum_injured))

test<-nydata %>%
  filter(BOROUGH=="MANHATTAN")%>%
  select(BOROUGH, DATE, TIME)

nydata %>%
group_by(BOROUGH) %>%
  summarize(total = sum(NUMBER.OF.PERSONS.INJURED, na.rm = TRUE))

  
nydata %>%
  group_by(BOROUGH) %>%
  summarize(total_injured = sum(NUMBER.OF.PERSONS.INJURED,na.rm=TRUE), motorist_killed=sum(NUMBER.OF.MOTORIST.KILLED,na.rm=TRUE))

nydata %>%
  group_by(BOROUGH,NUMBER.OF.MOTORIST.KILLED) %>%
  summarize(total_injured = sum(NUMBER.OF.PERSONS.INJURED,na.rm=TRUE))

 
  