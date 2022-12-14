select count(*),sysdatetime(), 'Maka Makharshvili' myname from CS689_Assign4.dbo.MANUFACTURE_FACT

select * from (
	select SUBSTRING(CS689_Assign4.dbo.CALENDAR_MANUFACTURE_DIM.manufacture_year,3,4)year,
	CS689_Assign4.dbo.FACTORY_DIM.FACTORY_LABEL factory_name,
	sum(CS689_Assign4.dbo.MANUFACTURE_FACT.qty_passed) total_units_produced,
	sum(CS689_Assign4.dbo.MANUFACTURE_FACT.qty_failed) total_units_failed,
	ROW_NUMBER()over (partition by CS689_Assign4.dbo.CALENDAR_MANUFACTURE_DIM.manufacture_year order by sum(CS689_Assign4.dbo.MANUFACTURE_FACT.qty_passed)
	desc) as Factory_Rank
	from CS689_Assign4.dbo.CALENDAR_MANUFACTURE_DIM,
	CS689_Assign4.dbo.FACTORY_DIM,
	CS689_Assign4.dbo.MANUFACTURE_FACT
	where CS689_Assign4.dbo.MANUFACTURE_FACT.MANUFACTURE_CAL_KEY=CS689_Assign4.dbo.CALENDAR_MANUFACTURE_DIM.MANUFACTURE_CAL_KEY
	and CS689_Assign4.dbo.MANUFACTURE_FACT.FACTORY_KEY=CS689_Assign4.dbo.FACTORY_DIM.FACTORY_KEY
	group by CS689_Assign4.dbo.CALENDAR_MANUFACTURE_DIM.MANUFACTURE_YEAR, CS689_Assign4.dbo.FACTORY_DIM.FACTORY_LABEL)
	where factory_rank <=3
	order by 1 desc



--2
select factory_name, month, total_units_passed, total_units_failed from(
select a.factory_label factory_name
,case when b.MANUFACTURE_CAL_KEY,11,2 ='01' then '01-January'
when b.MANUFACTURE_CAL_KEY,11,2 ='02' then '02-February'
when b.MANUFACTURE_CAL_KEY,11,2 ='03' then '03-March'
end month
,sum(b.qty_passed) total_units_passed,
sum(b.qty_failed) total_units_failed,
ROW_NUMBER()over (partition by substring(b.MANUFACTURE_CAL_KEY,11,2) order by
sum(b.qty_passed) Rank_Factory
from CS689_Assign4.dbo.MANUFACTURE_FACT b
join CS689_Assign4.dbo.factory_dim a on b.factory_key=a.factory_key
where substring (b.MANUFACTURE_CAL_KEY,6,4)='2022'
group by rollup(a.factory_label,substring(b.MANUFACTURE_CAL_KEY,11,2))
)
where rank_factory <=3;


WITH factoryunits AS  
(SELECT calendar_manufacture_dim.manufacture_year 
,calendar_manufacture_dim.manufacture_day_date, factory_dim.factory_label, 
 manufacture_fact.qty_passed,manufacture_fact.qty_failed,  CONCAT(DAY FROM calendar_manufacture_dim.manufacture_day_date) 
     ,'-', 
	 	CASE when(MONTH FROM 
calendar_manufacture_dim.manufacture_day_date) 
	 	 	WHEN 1 THEN 'January' 
	 	 	WHEN 2 THEN 'February' 
	 	 	WHEN 3 THEN 'March' 
	 	 	WHEN 4 THEN 'April' 
	 	 	WHEN 5 THEN 'May' 
	 	 	WHEN 6 THEN 'June' 
	 	 	WHEN 7 THEN 'July' 
	 	 	WHEN 8 THEN 'August' 
	 	 	WHEN 9 THEN 'September' 
	 	 	WHEN 10 THEN 'October' 
	 	 	WHEN 11 THEN 'November' 
	 	 	WHEN 12 THEN 'December' 
    END ) AS Month, 
 ROW_NUMBER() OVER(PARTITION BY factory_dim.factory_label ORDER BY manufacture_fact.qty_passed DESC)  
 AS ranks FROM  factory_dim  
 JOIN manufacture_fact ON factory_dim.factory_key=manufacture_fact.factory_key  JOIN calendar_manufacture_dim ON 
calendar_manufacture_dim.manufacture_cal_key=manufacture_fact.manufacture_cal _key 
WHERE EXTRACT(YEAR FROM calendar_manufacture_dim.manufacture_day_date)=2022 )  
SELECT manufacture_year,factory_label,qty_passed,qty_failed,SUM(qty_passed),Month,rank s  FROM factoryunits WHERE ranks<=3 GROUP BY ROLLUP(manufacture_year,factory_label,qty_passed,qty_failed,Month,ranks) 


--3
select factory_name,brand_name month, total_units_passed, total_units_failed from(
select CS689_Assign4.dbo.FACTORY_DIM.factory_label factory_name, CS689_Assign4.dbo.PRODUCT_DIM.brand_label brand_name
,case when CS689_Assign4.dbo.MANUFACTURE_FACT.MANUFACTURE_CAL_KEY,11,2)='01' then '01-January'
when CS689_Assign4.dbo.MANUFACTURE_FACT.MANUFACTURE_CAL_KEY,11,2)='02' then '02-February'
when CS689_Assign4.dbo.MANUFACTURE_FACT.MANUFACTURE_CAL_KEY,11,2)='03' then '03-March'
end month
,sum(CS689_Assign4.dbo.MANUFACTURE_FACT.qty_passed) total_units_passed
,sum(CS689_Assign4.dbo.MANUFACTURE_FACT.qty_failed) total_units_failed
,ROW_NUMBER()over (partition by CS689_Assign4.dbo.CALENDAR_MANUFACTURE_Fact.MANUFACTURE_CAL_KEY,11,2) order by
sum(CS689_Assign4.dbo.MANUFACTURE_FACT.qty_passed) Rank_Factory
from CS689_Assign4.dbo.MANUFACTURE_FACT
join CS689_Assign4.dbo.factory_dim on CS689_Assign4.dbo.MANUFACTURE_FACT.factory_key=CS689_Assign4.dbo.factory_dim.factory_key
join CS689_Assign4.dbo.PRODUCT_DIM on CS689_Assign4.dbo.MANUFACTURE_FACT.product_key= CS689_Assign4.dbo.PRODUCT_DIM.product_key
where substring (CS689_Assign4.dbo.MANUFACTURE_FACT.MANUFACTURE_CAL_KEY,6,4)='2021'
group by rollup(CS689_Assign4.dbo.factory_dim.factory_label,CS689_Assign4.dbo.PRODUCT_DIM.brand_label, substring(CS689_Assign4.dbo.MANUFACTURE_FACT.MANUFACTURE_CAL_KEY,11,2))
)
where rank_factory <=3;

--4
select factory_name,brand_name month, total_units_passed, total_units_failed from(
select CS689_Assign4.dbo.FACTORY_DIM.factory_label factory_name, CS689_Assign4.dbo.PRODUCT_DIM.brand_label brand_name
,case when CS689_Assign4.dbo.MANUFACTURE_FACT.MANUFACTURE_CAL_KEY,11,2)='01' then '01-January'
when CS689_Assign4.dbo.MANUFACTURE_FACT.MANUFACTURE_CAL_KEY,11,2)='02' then '02-February'
when CS689_Assign4.dbo.MANUFACTURE_FACT.MANUFACTURE_CAL_KEY,11,2)='03' then '03-March'
end month
,sum(CS689_Assign4.dbo.MANUFACTURE_FACT.qty_passed) total_units_passed
,sum(CS689_Assign4.dbo.MANUFACTURE_FACT.qty_failed) total_units_failed
,ROW_NUMBER()over (partition by CS689_Assign4.dbo.CALENDAR_MANUFACTURE_Fact.MANUFACTURE_CAL_KEY,11,2) order by
sum(CS689_Assign4.dbo.MANUFACTURE_FACT.qty_passed) Rank_Factory
from CS689_Assign4.dbo.MANUFACTURE_FACT
join CS689_Assign4.dbo.factory_dim on CS689_Assign4.dbo.MANUFACTURE_FACT.factory_key=CS689_Assign4.dbo.factory_dim.factory_key
join CS689_Assign4.dbo.PRODUCT_DIM on CS689_Assign4.dbo.MANUFACTURE_FACT.product_key= CS689_Assign4.dbo.PRODUCT_DIM.product_key
where substring (CS689_Assign4.dbo.MANUFACTURE_FACT.MANUFACTURE_CAL_KEY,6,4)='2021'
group by CS689_Assign4.dbo.factory_dim.factory_label,CS689_Assign4.dbo.PRODUCT_DIM.brand_label,cube(CS689_Assign4.dbo.MANUFACTURE_FACT.MANUFACTURE_CAL_KEY,11,2))
where rank_factory <=3;

--6
select a.manufacture_year,3,4 year,
b.factory_label  factory_name,
sum(c.qty_passed) total_units_produced
from cs689_Assign4.dbo.calendar_manufacture_dim a,
cs689_Assign4.dbo.factory_dim b,
cs689_Assign4.dbo.manufacture_fact c
where c.manufacture_cal_key=a.manufacture_cal_key
and c.factory_key=b.factory_key
and  substring(c.manufacture_cal_key,6,4) in(2022,2021,2020,2019,2018)
and substring(c.manufacture_cal_key,11,2)='02'
group by a.manufacture_year,b.factory_label
order by 2, 1 desc

--7
select * from(
select substring(a.manufacture_year,3,4) year,
b.factory_label  factory_name,
sum(c.qty_passed) total_units_produced
from cs689_Assign4.dbo.calendar_manufacture_dim a,
cs689_Assign4.dbo.factory_dim b,
cs689_Assign4.dbo.manufacture_fact c
where c.manufacture_cal_key=a.manufacture_cal_key
and c.factory_key=b.factory_key
and  substring(c.manufacture_cal_key,6,4) in(2022,2021,2020,2019,2018)
and substring(c.manufacture_cal_key,11,2)='02'
group by a.manufacture_year,b.factory_label
) d
pivot(
sum(total_units_produced) for year in ([2018],[2019],[2020],[2021],[2022])
)as pivot_tbl;

WITH produced AS  
(SELECT calendar_manufacture_dim.manufacture_year, factory_dim.factory_label,manufacture_fact.qty_passed,manufacture_fact.qty_failed,
ROW_NUMBER() OVER(PARTITION BY calendar_manufacture_dim.manufacture_year 
ORDER BY manufacture_fact.qty_passed DESC) AS ranks FROM  factory_dim JOIN manufacture_fact ON factory_dim.factory_key=manufacture_fact.factory_key JOIN calendar_manufacture_dim ON 
calendar_manufacture_dim.manufacture_cal_key=manufacture_fact.manufacture_cal_key)
SELECT * FROM produced WHERE ranks<=3 


select factory_name,brand_name month, total_units_passed, total_units_failed from(
select CS689_Assign4.dbo.FACTORY_DIM.factory_label factory_name, CS689_Assign4.dbo.PRODUCT_DIM.brand_label brand_name
,case when CS689_Assign4.dbo.MANUFACTURE_FACT.MANUFACTURE_CAL_KEY,11,2)='01' then '01-January'
when CS689_Assign4.dbo.MANUFACTURE_FACT.MANUFACTURE_CAL_KEY,11,2)='02' then '02-February'
when CS689_Assign4.dbo.MANUFACTURE_FACT.MANUFACTURE_CAL_KEY,11,2)='03' then '03-March'
end month,
ROW_NUMBER() OVER(PARTITION BY factory_dim.factory_label ORDER BY manufacture_fact.qty_passed DESC)  
 AS ranks FROM  factory_dim  
 JOIN manufacture_fact ON factory_dim.factory_key=manufacture_fact.factory_key  JOIN calendar_manufacture_dim ON 
calendar_manufacture_dim.manufacture_cal_key=manufacture_fact.manufacture_cal_key 
WHERE EXTRACT(YEAR FROM calendar_manufacture_dim.manufacture_day_date)=2022 )  
SELECT manufacture_year,factory_label,qty_passed,qty_failed,SUM(qty_passed),Month,rank s  FROM factoryunits WHERE ranks<=3 GROUP BY ROLLUP(manufacture_year,factory_label,qty_passed,qty_failed,Month,ranks) 



