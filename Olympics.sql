USE [Project 3];
SELECT * FROM athlete_events ORDER BY 9
SELECT * FROM noc_regions

--Tokyo olympics 2021--
SELECT * FROM athlete_events WHERE Year=2021;
--Countries participated in Olympics--
SELECT COUNT(DISTINCT region) AS Total_Region FROM noc_regions
--Total Sports events in Olympics--
SELECT DISTINCT Sport FROM athlete_events ORDER BY 1
--Total number of participants--
SELECT COUNT(*) AS Total_Participants FROM athlete_events ORDER BY 1
--Total number of female & male participants--
SELECT Sex,COUNT(*) AS Total FROM athlete_events GROUP BY Sex
--Total number of male and female participation in Tokyo olympics--
SELECT SUM(CASE WHEN Sex='F' THEN 1 ELSE 0 END) AS Total_Female,
SUM(CASE WHEN Sex='M' THEN 1 ELSE 0 END) AS Total_Male
FROM athlete_events
WHERE Year =2021 AND Season='Summer'
--Finding the City wise Male & Female Participation and their Ratio--
WITH CityCTE AS
(
SELECT City,Count(*) AS Total,CAST(SUM(CASE WHEN Sex='F' THEN 1 ELSE 0 END) AS FLOAT) AS Total_Female,
CAST(SUM(CASE WHEN Sex='M' THEN 1 ELSE 0 END) AS FLOAT) AS Total_Male
FROM athlete_events
GROUP BY City

)
SELECT TOP 25 *, (Total_Male/Total_Female) AS Ratio FROM CityCTE 
ORDER BY 3 DESC,4 DESC

--Men Vs Women (Medals attained in Tokyo Olympics)--
SELECT Medal,SUM(CASE WHEN Sex='F' THEN 1 ELSE 0 END) AS Medals_by_Female ,
SUM(CASE WHEN Sex='M' THEN 1 ELSE 0 END) AS Medals_by_Male
FROM athlete_events 
WHERE Medal='Gold' AND Year =2021
GROUP BY Medal
SELECT Medal, SUM(CASE WHEN Sex='F' THEN 1 ELSE 0 END) AS Medals_by_Female ,
SUM(CASE WHEN Sex='M' THEN 1 ELSE 0 END) AS Medals_by_Male
FROM athlete_events 
WHERE Medal='Silver' AND Year =2021
GROUP BY Medal
SELECT Medal, SUM(CASE WHEN Sex='F' THEN 1 ELSE 0 END) AS Medals_by_Female ,
SUM(CASE WHEN Sex='M' THEN 1 ELSE 0 END) AS Medals_by_Male
FROM athlete_events 
WHERE Medal='Bronze' AND Year =2021
GROUP BY Medal
--Top 10 countries with the most Olympic Gold medals--
SELECT TOP 10 B.region,COUNT(*) AS Total_Gold_Medals
FROM athlete_events A JOIN noc_regions B
ON A.NOC=B.NOC 
WHERE A.Medal='Gold'
GROUP BY B.region ORDER BY 2 DESC
--No: of different age group participated --
SELECT Age_Group,Age,Sex,COUNT(*) as Number_of_participants FROM athlete_events GROUP BY Age,Sex,Age_Group ORDER BY 1 DESC
--Age Is Nothing but a Number--
ALTER TABLE athlete_events
ADD Age_Group VARCHAR(255)
UPDATE athlete_events
SET Age_Group= CASE WHEN Age<20 THEN 'Below 20'
WHEN Age BETWEEN 20 AND 30 THEN '20-30'
WHEN Age BETWEEN 30 AND 40 THEN '30-40'
WHEN Age BETWEEN 40 AND 50 THEN '40-50'
WHEN Age BETWEEN 50 AND 60 THEN '50-60'
WHEN Age BETWEEN 60 AND 70 THEN '60-70'
WHEN Age BETWEEN 70 AND 80 THEN '70-80'
WHEN Age>80 THEN 'Above 80'
ELSE 'Not Defined' END 

SELECT * FROM athlete_events WHERE Age_Group ='70-80' 
AND Medal IN ('Gold','Silver','Bronze')

SELECT Sport,Medal,Age,COUNT(*) AS Total FROM athlete_events
WHERE Age_Group ='Below 20' AND Medal ='Gold' AND Year=2021
GROUP BY Sport,Medal,Age
--Top 10 Country that has the higest number of participants--
SELECT TOP 10 Team, COUNT(*) AS No_of_Participants FROM athlete_events
GROUP BY Team
ORDER BY 2 DESC
--2021 Tokyo Olympics Medal Table--
SELECT B.region,A.Year,COUNT(A.Medal) AS Total_Medals FROM athlete_events A JOIN noc_regions B
ON A.NOC=B.NOC
WHERE  Medal IN ('Gold','Silver','Bronze') AND Year=2021
GROUP BY B.region,A.Year ORDER BY 3 DESC
--Total Female Athletes-- 
SELECT City,Sex,Year,COUNT(*) AS Total FROM athlete_events
WHERE  Sex='F' 
GROUP BY Sex,City,Year
ORDER BY 3 DESC
--Total Participation of Female and Male Athletes in each year--
SELECT City,Year,SUM(CASE WHEN Sex='F' THEN 1 ELSE 0 END) AS Total_Female_Athletes,
SUM(CASE WHEN Sex='M' THEN 1 ELSE 0 END) AS Total_Male_Athletes FROM athlete_events 
GROUP BY City,Year ORDER BY 2 DESC
--Total Participants in Summer Vs Winter Season--
SELECT City,Year,SUM(CASE WHEN Season='Summer' THEN 1 ELSE 0 END) AS Total_Athletes_Summer,
SUM(CASE WHEN Season='Winter' THEN 1 ELSE 0 END) AS Total_Athletes_Winter FROM athlete_events 
GROUP BY City,Year ORDER BY 2 DESC
--Top 20 Popular Sport Events of Women and Men--
SELECT TOP 20 Event,COUNT(Event) Total_Women FROM athlete_events 
WHERE Sex='F' 
GROUP BY Event
ORDER BY 2 DESC
SELECT TOP 20 Event,COUNT(Event) Total_Women FROM athlete_events 
WHERE Sex='M' 
GROUP BY Event
ORDER BY 2 DESC
--Height & Weight distribution of athletes who won medal--
SELECT Event,Height,Weight,Age,Year,Medal FROM athlete_events 
WHERE Medal NOT LIKE 'NA' 
--Removing Duplicates--
WITH AthleteCTE AS(
SELECT *,ROW_NUMBER()OVER(PARTITION BY Name,Age,Height,Weight,Event,Team,Year ORDER BY ID) AS Row_No FROM athlete_events 
)
SELECT * FROM AthleteCTE WHERE Row_No>1
DELETE FROM AthleteCTE WHERE Row_No>1
--Delete Unused Column--
ALTER TABLE athlete_events 
DROP COLUMN Games
