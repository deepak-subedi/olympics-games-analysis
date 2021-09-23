# Data Analyst Portfolio Project – Olympics Games Analysis

## Business Problem

The challenge for this data analyst project is outlined below. This has been used continuously to ensure that the right data has been selected, transformed and used in the data visualization which is meant to be passed on to the business users.

**“As a data analyst working at a news company you are asked to visualize data that will help readers understand how countries have performed historically in the summer Olympic Games.
<br />
You also know that there is an interest in details about the competitors, so if you find anything interesting then don’t hesitate to bring that in also.
<br />
The main task is still to show historical performance for different countries, with the possibility to select your own country.”**

## Data Collection & Table Structures
The necessary data was first put into a SQL database and afterwards transformed using the transformations that you can see below.

### Olympic Games View
Exercise data were recorded every single date and the focus was on amount of steps. The date column is used to connect to the date dimension and Activity_FK is used to connect to the activity dimension.

SELECT <br />
	[ID], <br />
	[Name] AS [Competitor Name], <br />
	CASE WHEN [Sex] = 'M' THEN 'Male' Else 'Female' END AS Sex, -- better name for filter and validation <br />
	[Age], <br />
	CASE <br />
		WHEN [Age] < 18 THEN 'Under 18' <br />
		WHEN [AGE] BETWEEN 18 AND 25 THEN '18-25' <br />
		WHEN [AGE] BETWEEN 25 AND 30 THEN '25-30' <br />
		WHEN [AGE] > 30 THEN 'Over 30' <br />
	END AS [Age Grouping], <br />
	[Height], <br />
	[Weight], <br />
	[NOC] AS [Nation Code], -- Explained abbrebiation <br />
	LEFT([Games], CHARINDEX(' ', [Games]) - 1) AS Year, <br />
	[Sport], <br />
	[Event], <br />
	CASE WHEN [Medal] = 'NA' THEN 'Not Registered' ELSE [Medal] END AS Medal  -- Replaced NA with Not Registered <br />
FROM [olympic_games].[dbo].[athletes_event_results] <br />
WHERE RIGHT(Games, CHARINDEX(' ',REVERSE(Games)) - 1) = 'Summer'  -- Where Clause to isolate Summer Season <br />

![GitHub Fact_Exercise](/images/Fact_Exercise.PNG)

Following steps were done in Power BI to transform this table to be ready for analysis purposes:

    Promoted row so that the data so that the first row was used as headers.
    Removed unnecessary columns.
    Changed column to have the correct type (date, numbers etc.) for later use in calculations.
    
![GitHub Fact_Exercise](/images/Fact_Activity_steps.PNG)
    
### DIM_Activity
DIM_Activity describes two different types of activities: Walking and running. On some days walking was chosen as a preferred activity time, and other days running were performed.

![GitHub Fact_Exercise](/images/Dim_Activity.PNG)

 Following steps were done in Power BI to transform this table to be ready for analysis purposes:

    Promoted row so that the data so that the first row was used.
    Renamed necessary columns to give better business friendly names.
    Capitalized each for in the description column for improved data quality.
    
![GitHub Fact_Exercise](/images/Dim_Activity_steps.PNG)
    
### DIM_Date

The DIM_Date dimension is based on a simple table with dates, where date was used to derive several new fields which would be used in the exercise analysis dashboard:

    Promoted row so that the data so that the first row was used.
    Changed the column to DateType
    Inserted several new columns based on the date.
    
![GitHub Fact_Exercise](/images/Dim_Date_steps.PNG)
    
## Data Model

Below is a screenshot of the data model after cleansed and prepared tables were read into Power BI.

The FACT table **(FACT_Exercise)** is connected to two dimension tables **(DIM_Activity and DIM_Date)** with the correct relationship established (1 to *) between dimension and fact tables.

![GitHub Fact_Exercise](/images/Data_Model.PNG)

## Calculations

The following calculations were created in the Power BI reports using DAX (Data Analysis Expressions). To lessen the extent of coding, the re-use of measures (measure branching) was emphasized:

**Average Steps** – This is a simple AVERAGE function around the Steps column:
AVERAGE( FACT_Activity[Steps] )

**Total Steps** – This is a simple SUM function around the Steps column:
SUM( FACT_Activity[Steps] )

**Steps (Running)** – This is a calculation to isolate the Total Steps measure by filtering it by the “Running Activity”:

CALCULATE(
[Total Steps],
DIM_Activity[ActivityName] = “Running”
)

**Steps (Walking)** – This is a calculation to isolate the Total Steps measure by filtering it by the “Walking Activity”:

CALCULATE(
[Total Steps],
DIM_Activity[ActivityName] = “Walking”
)

**Running % of Total** – Here we are using two measures from before to find the % of steps that were done by running:

DIVIDE(
[Steps (Running)],
[Total Steps]
)

**Walking % of Total** – Here we are using two measures from before to find the % of steps that were done by walking:

DIVIDE(
[Steps (Walking)],
[Total Steps]
)

**Total Steps (Cumulative)** – Here we are re-using the Total Steps measure and using different functions to cumulatively calculate the total steps:

CALCULATE(
[Total Steps],
FILTER(
ALLSELECTED( DIM_Date ),
DIM_Date[Date]
<= MAX( FACT_Activity[Date] )
)
)

**Week Over Week % Change Steps** – Here we are using the Total Steps measure and using different functions, with variables, to calculate the Week over Week % Change of Steps:

VAR CurrentWeek =
CALCULATE(
[Total Steps],
FILTER(
ALL( DIM_Date ),
DIM_Date[Week of Year]
= SELECTEDVALUE( DIM_Date[Week of Year] )
)
)
VAR PreviousWeek =
CALCULATE(
[Total Steps],
FILTER(
ALL( DIM_Date ),
DIM_Date[Week of Year]
= SELECTEDVALUE( DIM_Date[Week of Year] ) – 1
)
)
RETURN
DIVIDE(
( CurrentWeek – PreviousWeek ),
PreviousWeek
)


## Exercise Analysis Dashboard

The finish report consists of two different dashboards. One is more of a basic version, while the second version contains more advanced visualizations. To enable these visualizations the calculation language DAX (Data Analysis Expressions) were used.

### Basic Analysis

![GitHub Fact_Exercise](/images/Basic_Calculation.PNG)

### Advance Calculation

![GitHub Fact_Exercise](/images/Advance_Calculation.PNG)
