select*
from Data_Table
---------------------------------
select*
from Data_Table
--------------------
update April
	set Months ='Apr'

update August
	set Months ='Aug'

update December
	set Months ='Dec'

update July
	set Months ='Jul'

update June
	set Months ='Jun'

update May
	set Months ='May'

update November
	set Months ='Nov'

update October
	set Months ='Oct'

update September
	set Months ='Sept'

----------------------------------
------Combine_Data-----------
INSERT INTO Data_Table
select* from April
union all
select* from August
union all
select* from December
union all
select* from July
union all
select* from June
union all
select* from May
union all
select* from November
union all
select* from October
union all
select* from September
---------------------------
select*
from Data_Table
---------------------------------
-------delete_unneeded_column
alter table Data_Table drop column start_lat,start_lng,end_lat,end_lng
---------------------------------
select*
from Data_Table
where ride_id is null
---------------------------------
select Distinct( rideable_type) 
from Data_Table
------------------------------------------------------------------------------
----------------------------check if there extra spaces-----------------------
select rideable_type
from Data_Table
where len(rideable_type) <> len(RTRIM(LTRIM(rideable_type)))
---------------------------------
Select*
from Data_Table
where started_at is null  or  ended_at is null
---start_at_column
alter table Data_Table add Date_start_at  Date

update Data_Table
		set Date_start_at = CONVERT(Date,started_at) 
---------
alter table Data_Table add Time_start_at  Time

Update Data_Table
		set Time_start_at =Convert(Time,Started_at)
--------------------------------------------------------
--end_at_column

alter table Data_Table add Date_end_at Date

		update Data_Table
				set Date_end_at = Convert(Date,ended_at)

alter table Data_table add Time_end_at Time

		update Data_Table
				set Time_end_at = Convert(Time,ended_at)

--------------------------------------------------------------
Select*
from Data_Table
--------------------------------------------------------------
Select*
from Data_Table
where start_station_name is null or start_station_name =''

Select count(*)
from Data_Table
where start_station_name is null or start_station_name =''

update Data_Table 
	   set start_station_name ='Not Mentioned'
	   where start_station_name is null or start_station_name =''

select*
from Data_Table
where start_station_id is null or start_station_name=''

select count(*)
from Data_Table
where start_station_id is null or start_station_id=''

update Data_Table
		set start_station_id ='Not Mentioned'
		where start_station_id is null or start_station_id=''
------------------
select*
from Data_Table
where end_station_name is null or end_station_name ='' or
	  end_station_id is null or end_station_id =''

select count(*)
from Data_Table
where end_station_name is null or end_station_name ='' or
	  end_station_id is null or end_station_id =''

update Data_Table
		set end_station_name = 'Not Mentioned' , 
		    end_station_id   = 'Not Mentioned'
		where end_station_name is null or end_station_name ='' or
	          end_station_id is null or end_station_id =''

-------------------------------------------------------------------
select start_station_id,start_station_id,end_station_name,end_station_id
from Data_Table
where  len(start_station_name) <> len(LTRIM(RTRIM(start_station_name))) or 
	   len(start_station_id) <> len(LTRIM(RTRIM(start_station_id))) or
	   len(end_station_name) <> len(LTRIM(RTRIM(end_station_name))) or 
	   len(end_station_id) <> len(LTRIM(RTRIM(end_station_id)))

-------------------------------------------------------------------------
select*
from Data_Table
where member_casual is null or member_casual =''

select Distinct(member_casual)
from Data_Table

select  member_casual
from Data_Table
where len(member_casual) <> len(LTRIM(RTRIM(member_casual)))

----------------------------------------------------------------------
select*
from Data_Table
------------------------------------------------------------------------
-----------------------Remove_Duplicate---------------------------------
WITH Duplicated AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY
                rideable_type,
                started_at,
                ended_at,
                start_station_name,
                start_station_id,
                end_station_name,
                end_station_id,
                member_casual,
                Months
            ORDER BY
                ride_id
        ) AS Check_duplicate
    FROM
        Data_Table
)

--select count(*)
--FROM Duplicated
--Where Check_duplicate >1

Delete
FROM Duplicated
Where Check_duplicate >1

---------------------------------------------------------------------------
SELECT*
FROM Data_Table
---------------------------------------------------------------------------
---------------------------DELETE_unneeded_column--------------------------
Alter Table Data_Table drop column started_at
Alter Table Data_Table drop column ended_at
---------------------------------------------------------------------------
---------------------------let'S_Start_Analysis----------------------------
select *--COUNT(*)
from Data_Table
---------------------
select rideable_type,count(rideable_type)
from Data_Table
group by rideable_type
order by 2 desc
----------------------
select start_station_name,COUNT(start_station_name)
from Data_Table
group by start_station_name
order by 2 DESC
-----------------------
SELECT
   Time_start_at,
  Time_end_at,
  Convert(DATETIME,Time_end_at) - Convert(DATETIME,Time_start_at) AS Difference
FROM Data_Table

Alter Table Data_Table add Ride_length DATETIME

	Update Data_Table
		set Ride_length =
		Convert(DATETIME,Time_end_at) - Convert(DATETIME,Time_start_at)

select*
from Data_Table

update Data_Table
	set Ride_length =
	Convert(TIME,Ride_length)

Alter Table Data_Table drop Column Ride_length

select CONCAT(Date_start_at,' ',Time_start_at)
from Data_Table

Alter Table Data_Table Add Started_at DATETIME
	update Data_Table
			set Started_at =
			Convert(DATETIME,Date_start_at)+Convert(DATETIME,Time_start_at)

Alter Table Data_Table Add ended_at DATETIME
	update Data_Table
			set ended_at =
			Convert(DATETIME,Date_end_at)+Convert(DATETIME,Time_end_at)

select top(100)*
from Data_Table


select top(100)*,ended_at-Started_at
from Data_Table

Alter Table Data_Table Add Ride_length DATETIME
	update Data_Table
			set Ride_length=
			ended_at-Started_at

select top(100)*,CONVERT(TIME,Ride_length)
from Data_Table

------------------------------------
select top(1000)*
from Data_Table
------------------------------------
update Data_Table
		set Ride_length =
		CAST(Ride_length AS TIME)

------------------------------------
Select rideable_type,COUNT(rideable_type)
from Data_Table
group by rideable_type
order by 2 DESC
------------------------------------------
Select start_station_name,Count(start_station_name)
from Data_Table
group by start_station_name
order by 2 DESC
-------------------------------------------
Select end_station_name,Count(end_station_name)
from Data_Table
group by end_station_name
order by 2 DESC
--------------------------------------------
select member_casual,count(member_casual)
from Data_Table
group by member_casual
order by 2 DESC
---------------------------------------------
select Months,count(Months)
from Data_Table
group by Months
order by 2 DESC
---------------------------------------------
select Months,count(Months)
from Data_Table
where start_station_name <> 'Not Mentioned' or
	  end_station_name <> 'Not Mentioned'
group by Months
order by 2 DESC
----------------------------------------------
select
	CAST(CAST(AVG(CAST(CAST(Ride_length as DATETIME)As Float))AS DATETIME)AS TIME) AS Average,
	CAST(CAST(SUM(CAST(CAST(Ride_length AS DATETIME)AS FLOAT))AS DATETIME)AS TIME) AS Total_Time		
from Data_Table
----------------------------------------------
SELECT top(1000)*
from Data_Table
-----------------------------------------------
---------Delete_UNneeded Column----------------
alter table Data_Table drop column Started_at,ended_at
---------------------------------------------------------
select*
from (select *,
			Ntile(4) Over (Order By (SELECT NULL)) AS G
	  from Data_Table

) AS Groups	
Where G= 4