# Data Analyst Portfolio Project – Olympics Games Analysis

## Business Problem

The challenge for this data analyst project is outlined below. This has been used continuously to ensure that the right data has been selected, transformed and used in the data visualization which is meant to be passed on to the business users.

**“As a data analyst working at a news company you are asked to visualize data that will help readers understand how countries have performed historically in the summer Olympic Games.
<br />
<br />
You also know that there is an interest in details about the competitors, so if you find anything interesting then don’t hesitate to bring that in also.
<br />
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
    
## Data Model

As this is a view where dimensions and facts have been combined, the data model that is created in Power BI is one table. The query from previous step was loaded in directly.

![GitHub Fact_Exercise](/images/Data_Model.PNG)

## Calculations

The following calculations were created in the Power BI reports using DAX (Data Analysis Expressions). To lessen the extent of coding, the re-use of measures (measure branching) was emphasized:

Number of Competitors: 

**# of Competitors** = DISTINCTCOUNT( ‘Olympic Data'[ID] )

**# of Medals** = COUNTROWS( ‘Olympic Data’ )

**# Of Medals (Registered)** = CALCULATE( [# of Medals], FILTER( ‘Olympic Data’, ‘Olympic Data'[Medal] = “Bronze” || ‘Olympic Data’ [Medal] = “Gold” || ‘Olympic Data'[Medal] = “Silver” ))


## Olympics Games Analysis

The finished dashboard consist of visualizations and filters that gives an easy option for the end users to navigate the summer games through history. Some possibilities are to filter by period using year, nation code to focus on one country or look into either a competitor or specific sports over time.


![GitHub Fact_Exercise](/images/Olympics_games_analysis.PNG)

