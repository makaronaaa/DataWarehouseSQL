
CREATE TABLE "fact_booking" (
    "booking_id" int PRIMARY KEY,
    "user_id" int FOREIGN KEY references "user_table"(user_id),
    "host_id" int FOREIGN KEY references host_details(host_id),
    "Listing_id" int FOREIGN KEY references listing_details(listing_id),
	"date_id" int FOREIGN KEY references dateDim(date_id),
	"cleaning_fee" int,
    "security_deposit" int,
    "extra_people" int,
);
drop table fact_listing
CREATE TABLE "fact_listing" (
    "listing_id" int FOREIGN KEY references listing_details (listing_id),
    "host_id" int FOREIGN KEY references host_details (host_id),
    "location_id" int FOREIGN KEY references listing_location (location_id),
    "instant_bookable" nvarchar,
	"has_availability" nvarchar,
	"price" int,
	"monthly_price" int,
	"total_price" int
);
drop table user_table
CREATE TABLE user_table (
    "user_id" int PRIMARY KEY,
    "user_name" nvarchar(500),
    "user_email" nvarchar(500),
);
CREATE TABLE "host_details" (
    "host_id" int PRIMARY KEY,
    "host_end" DATE,
    "host_response_time" nvarchar(500),
    "host_location" nvarchar(500),
	"host_since_date" date,
);

select * from dateDim
drop table dateDim
CREATE TABLE dateDim (
    "Date_id" int PRIMARY KEY,
    "booking_date" DATE,
    "year" INT,
    "month" INT,
	"day" int,
);

drop table listing_location
CREATE TABLE "listing_location" (
    "location_id" int PRIMARY KEY,
    "neighbourhood" nvarchar(2000),
    "zipcode"  nvarchar(2000),
    "city" nvarchar(2000),
    --"prev_city" nvarchar(2000),
	--"prev_zipcode" nvarchar(200),
);

drop table listing_details

CREATE TABLE listing_details (
    listing_id int PRIMARY KEY,
    room_type nvarchar(500),
    amenities nvarchar(3500),
    property_type nvarchar(500),
	maximum_nights int,
	minimum_nights int,

);
select * from listing_details;
select * from user_table
select * from host_details
select * from listing_location
select * from dateDim
select * from host_details
select* from fact_listing
select* from fact_booking

alter table fact_booking drop column column1
alter table fact_listing drop column column1


-- rank data within groups using window functions in 
SELECT a.room_type
--,a.maximum_nights,
, count(b.user_id) number_of_guests
,RANK() OVER (PARTITION BY a.room_type ORDER BY count(b.user_id) DESC) AS rank_most_popular_room_type
FROM listing_details a join fact_booking b on a.listing_id=b.listing_id
group by  a.room_type;

-- Show the min and max price of neighbourhoods with proprties that have instant bookable feature 
with cte as (select * from fact_listing where instant_bookable='t') 
select a.neighbourhood, min(b.price) min_price ,max(b.price) max_price, avg(price) avg_price
from listing_location a join cte b on a.location_id = b.location_id
group by neighbourhood order by 4 desc;


count(*) from listing_details group by amenities order by 2 desc;

select  A.neighbourhood
   --    ,A.city
       ,sum(B.price) 
       ,count(B.host_id) number_of_guests
from listing_location A
INNER JOIN fact_listing B
ON A.location_id=B.location_id
group by A.neighbourhood,A.city;

select * from fact_booking;
select * from fact_listing;
select * from listing_details;
select * from listing_location;
select * from dateDim;

alter table fact_booking
drop column column1