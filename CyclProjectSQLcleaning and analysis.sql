--First view of the data

select *
from CyclProject..[07_2022]


--Cleaning Process

--I use July as a sample month to explore the data so I can determine what and how to clean


select member_casual
from CyclProject..[07_2022]

--823.488 rows

-------------------------------------------------------------------------------------------------------

--Checking for duplicates

--Method No1 - counting the distinct ride_id, as a key column which must be unique for each transaction
select distinct(ride_id)
from CyclProject..[07_2022]

--823.488 rows - same as before, indicates for no duplicates

--Method No2 - look for similar transactions
with Row_num_count as(
select *,
	ROW_NUMBER() over (
	partition by
				started_at,
				ended_at,
				start_station_id,
				end_station_id
				order by ride_id
				) row_num
from CyclProject..[07_2022])
select *
from Row_num_count
where row_num > 1


--There seems to be 11 similar rides with different ride_id. É will keep these because it is an insignificant amount
--and there is a possibility to be different transactions from people that took the same ride



-------------------------------------------------------------------------------------------------------


--Checking for nulls in important columns
select *
from CyclProject..[07_2022]
where started_at is null

select *
from CyclProject..[07_2022]
where ended_at is null

select *
from CyclProject..[07_2022]
where member_casual is null

--No nulls in important columns

-------------------------------------------------------------------------------------------------------

--Checking for data not from July_2022

select started_at
from CyclProject..[07_2022]
order by started_at

select started_at
from CyclProject..[07_2022]
order by started_at desc

--All the data are from rides in July

-------------------------------------------------------------------------------------------------------

--Checking for more than two user_types

select distinct(member_casual)
from CyclProject..[07_2022]


--Only member and casual user_type

-------------------------------------------------------------------------------------------------------

--Checking for strange ride_length

select started_at, ended_at, DATEDIFF(second, started_at, ended_at) as ride_length
from CyclProject..[07_2022]
order by 3

--There is data where the time the ride ended is before the time it started.
--As this seems to be impossible, these data are wrong and have to be cleaned and not included in the analysis.


select started_at, ended_at, DATEDIFF(second, started_at, ended_at) as ride_length
from CyclProject..[07_2022]
where DATEDIFF(second, started_at, ended_at) < 60 and DATEDIFF(second, started_at, ended_at) >= 0 
order by 3

-- There are 17.798 rides in less than a minute. É cannot consider these as normal rides for the analysis.
-- So É clean this data too.


select started_at, ended_at, DATEDIFF(HOUR, started_at, ended_at) as ride_length, start_station_name, end_station_name, member_casual
from CyclProject..[07_2022]
where DATEDIFF(HOUR, started_at, ended_at) > 24
order by 3 desc

--There is an important number (852 cases) of rides where the ride_length is more than 24 hours.
--The majority of these cases are from casual users and the end_staton is missing. Probably they never returned to the station and were missing.
--The "story" of these cases is inconclusive so É will not include these cases in the analysis, as they seem to have a strange behavior.



-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------

--**So, after merging the 12-month data, for the analysis I have to exclude data where ride_length is less than a minute and more than 24 hours.**


-------------------------------------------------------------------------------------------------------

--From now on I continue the analysis with merged data


--I calculate the average ride time and the total rides by usertype
With Merged as (select member_casual, started_at, ended_at from CyclProject..[03_2023]
union
select member_casual, started_at, ended_at from CyclProject..[02_2023]
union
select member_casual, started_at, ended_at from CyclProject..[01_2023]
union
select member_casual, started_at, ended_at from CyclProject..[12_2022]
union
select member_casual, started_at, ended_at from CyclProject..[11_2022]
union
select member_casual, started_at, ended_at from CyclProject..[10_2022]
union
select member_casual, started_at, ended_at from CyclProject..[09_2022]
union
select member_casual, started_at, ended_at from CyclProject..[08_2022]
union
select member_casual, started_at, ended_at from CyclProject..[07_2022]
union
select member_casual, started_at, ended_at from CyclProject..[06_2022]
union
select member_casual, started_at, ended_at from CyclProject..[05_2022]
union
select member_casual, started_at, ended_at from CyclProject..[04_2022])

select 
	member_casual as usertype, 
	avg(DATEDIFF(minute, started_at, ended_at)) as average_ride_time,
	count(*) as total_rides,
	avg(DATEDIFF(MINUTE, started_at, ended_at))*count(*)/60 as total_ridehours
from Merged
where DATEDIFF(MINUTE, started_at, ended_at) between 1 and 1440
group by member_casual;





--I calculate the avg ride time, the total rides and the total ridehours by user_type and by month

With Merged as (select member_casual, started_at, ended_at from CyclProject..[03_2023]
union
select member_casual, started_at, ended_at from CyclProject..[02_2023]
union
select member_casual, started_at, ended_at from CyclProject..[01_2023]
union
select member_casual, started_at, ended_at from CyclProject..[12_2022]
union
select member_casual, started_at, ended_at from CyclProject..[11_2022]
union
select member_casual, started_at, ended_at from CyclProject..[10_2022]
union
select member_casual, started_at, ended_at from CyclProject..[09_2022]
union
select member_casual, started_at, ended_at from CyclProject..[08_2022]
union
select member_casual, started_at, ended_at from CyclProject..[07_2022]
union
select member_casual, started_at, ended_at from CyclProject..[06_2022]
union
select member_casual, started_at, ended_at from CyclProject..[05_2022]
union
select member_casual, started_at, ended_at from CyclProject..[04_2022])
select 
	member_casual as user_type,
	datename(MONTH, started_at) as MonthName,
	datepart(MONTH, started_at) as Month,
	avg(DATEDIFF(minute, started_at, ended_at)) as average_ride_time,
	count(*) as total_rides,
	avg(DATEDIFF(MINUTE, started_at, ended_at))*count(*)/60 as total_ridehours
from Merged
where DATEDIFF(MINUTE, started_at, ended_at) between 1 and 1440
group by member_casual, datename(MONTH, started_at), datepart(MONTH, started_at)
order by 1, 3;




--I calculate the avg ride time, the total rides and the total ridehours by user_type and by weekday

set datefirst 1;        --Setting week start on Monday


With Merged as (select member_casual, started_at, ended_at from CyclProject..[03_2023]
union
select member_casual, started_at, ended_at from CyclProject..[02_2023]
union
select member_casual, started_at, ended_at from CyclProject..[01_2023]
union
select member_casual, started_at, ended_at from CyclProject..[12_2022]
union
select member_casual, started_at, ended_at from CyclProject..[11_2022]
union
select member_casual, started_at, ended_at from CyclProject..[10_2022]
union
select member_casual, started_at, ended_at from CyclProject..[09_2022]
union
select member_casual, started_at, ended_at from CyclProject..[08_2022]
union
select member_casual, started_at, ended_at from CyclProject..[07_2022]
union
select member_casual, started_at, ended_at from CyclProject..[06_2022]
union
select member_casual, started_at, ended_at from CyclProject..[05_2022]
union
select member_casual, started_at, ended_at from CyclProject..[04_2022])

select 
	member_casual as user_type,
	datename(DW, started_at) as WeekdayName,
	datepart(DW, started_at) as Weekday,
	avg(DATEDIFF(minute, started_at, ended_at)) as average_ride_time,
	count(*) as total_rides,
	avg(DATEDIFF(MINUTE, started_at, ended_at))*count(*)/60 as total_ridehours
from Merged
where DATEDIFF(MINUTE, started_at, ended_at) between 1 and 1440
group by member_casual, datename(DW, started_at), datepart(DW, started_at)
order by 1, 3;


--I export these three tables as csv files and continue the analysis and visualization part in Spreadsheets