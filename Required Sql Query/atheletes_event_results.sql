/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
	[ID],
	[Name] AS [Competitor Name],
	CASE WHEN [Sex] = 'M' THEN 'Male' Else 'Female' END AS Sex, -- better name for filter and validation
	[Age],
	CASE 
		WHEN [Age] < 18 THEN 'Under 18'
		WHEN [AGE] BETWEEN 18 AND 25 THEN '18-25'
		WHEN [AGE] BETWEEN 25 AND 30 THEN '25-30'
		WHEN [AGE] > 30 THEN 'Over 30'
	END AS [Age Grouping],
	[Height],
	[Weight],
	[NOC] AS [Nation Code], -- Explained abbrebiation
	LEFT([Games], CHARINDEX(' ', [Games]) - 1) AS Year,
	[Sport],
	[Event],
	CASE WHEN [Medal] = 'NA' THEN 'Not Registered' ELSE [Medal] END AS Medal  -- Replaced NA with Not Registered	
FROM [olympic_games].[dbo].[athletes_event_results]
WHERE RIGHT(Games, CHARINDEX(' ',REVERSE(Games)) - 1) = 'Summer'  -- Where Clause to isolate Summer Season