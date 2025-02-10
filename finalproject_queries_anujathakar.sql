create table agency_dim(
agency_id int primary key,
agency varchar(50) not null
)

create table arrest_type_dim(
arrest_type_id int primary key,
arrest_type varchar(50)
)

create table dl_state_dim(
dl_state_id int primary key,
dl_state varchar(50)
)

create table driver_state_dim(
driver_state_id int primary key,
driver_state varchar(50)
)

create table search_arrest_reason_dim(
search_arrest_reason_id int primary key,
search_arrest_reason varchar(50)
)


create table search_reason_dim(
search_reason_id int primary key,
search_reason varchar(50)
)

create table search_type_dim(
search_type_id int primary key,
search_type varchar(50)
)

create table state_dim(
state_id int primary key,
state varchar(50)
)

create table sub_agency_dim(
sub_agency_id int primary key,
sub_agency varchar(50)
)

create table vehicle_type_dim(
vehicle_type_id int primary key,
vehicle_type varchar(100)
)

create table violation_type_dim(
violation_type_id int primary key,
violation_type varchar(50)
)

create table violations_fact (
    violation_id varchar(100) PRIMARY KEY,         
    date_of_stop date,                             
    time_of_stop time,                             
    agency_f varchar(50),                          
    subagency_f varchar(100),                      
    description varchar(255),                     
    location_name varchar(255),                  
    latitude numeric(10, 6),                       
    longitude numeric(10, 6),                      
    accident boolean,                              
    belts boolean,                                 
    personal_injury boolean,                       
    property_damage boolean,                       
    fatal boolean,                                 
    commercial_license boolean,                    
    hazmat boolean,                                
    commercial_vehicle boolean,                   
    alcohol boolean,                              
    work_zone boolean,                             
    search_conducted boolean,                      
    search_disposition_f varchar(50),            
    search_outcome_f varchar(50),                 
    search_reason_f varchar(50),                 
    search_reason_for_stop varchar(100),         
    search_type_f varchar(50),                    
    search_arrest_reason_f varchar(100),          
    state_f char(20),                               
    vehicle_type_f varchar(50),                  
    year_f int,                                    
    make varchar(50),                          
    model varchar(50),                            
    vehicle_color varchar(50),                  
    violation_type_f varchar(50),                 
    charge varchar(50),                            
    article varchar(100),                         
    contributed_to_accident boolean,              
    driver_city varchar(100),                     
    driver_state_f char(20),                       
    dl_state_f char(20),                            
    arrest_type_f varchar(50),                    
    geolocation varchar(500),
	agency_id integer references agency_dim(agency_id),
	arrest_type_id integer references arrest_type_dim(arrest_type_id),
	dl_state_id integer references dl_state_dim(dl_state_id),
	driver_state_id integer references driver_state_dim(driver_state_id),
	search_arrest_reason_id integer references search_arrest_reason_dim(search_arrest_reason_id),
	search_reason_id integer references search_reason_dim(search_reason_id),
	--search_outcome_id integer references search_outcome_dim(search_outcome_id),
	search_type_id integer references search_type_dim(search_type_id),
	state_id integer references state_dim(state_id),
	sub_agency_id integer references sub_agency_dim(sub_agency_id),
	vehicle_type_id integer references vehicle_type_dim(vehicle_type_id),
	violation_type_id integer references violation_type_dim(violation_type_id)
);



-----Data cleaning using update queries for the fact table------------------------
------ Description column: handling invalid and missing values---------------------

update violations_fact
set description = 'Unknown'
where (description is null or description ~ '^[0-9]+$');



------ search_conducted column: handle missing values-------------------------

update violations_fact
set search_conducted = 'No'
where search_conducted is null;


------search_disposition_f column: handle missing values------------------

update violations_fact
set search_disposition_f = 'Nothing'
where search_disposition_f is null;


--- search_outcome_f column: handle missing values---------------

update violations_fact
set search_outcome_f = 'Unknown'
where search_outcome_f is null;


---- search_reason_f column: handle missing values------------

update violations_fact
set search_reason_f = 'Unknown'
where search_reason_f is null;


---- search_reason_for_stop column: handle missing values----

update violations_fact
set search_reason_for_stop = 'Unknown'
where search_reason_for_stop is null;


--- search_type_f column: handle missing values---------------

update violations_fact
set search_type_f = 'Unknown'
where search_type_f is null;


--- search_reason_f column: handle missing values-------------

update violations_fact
set search_arrest_reason_f = 'Other'
where search_arrest_reason_f is null;


---- state_f column: handle missing and invalid values----

update violations_fact
set state_f = 'Unknown'
where (state_f is null or state_f = 'XX');

---- year_f column: handle invalid and null values----

update violations_fact
set year_f = 00
where (year_f is null or year_f = 0);


----model column: handle invalid and null values-----
update violations_fact
set model = 'Unknown'
where (model is null or model = '0');


--- article column: handle missing values----

update violations_fact
set article = 'Unknown'
where article is null;

--- driver_city: handle invalid and missing values----

update violations_fact
set driver_city = 'Unknown'
where (driver_city is null or driver_city = '0')


--- driver_state_f column: handling invalid and null values----

update violations_fact
set driver_state_f = 'Unknown'
where (driver_state_f is null or driver_state_f = 'XX');


---- dl_state_f column: handling invalid and null values-----

update violations_fact
set dl_state_f = 'Unknown'
where (dl_state_f is null or dl_state_f = 'XX');


--------------------------Update invalid states in violations_fact table------------------------------
update violations_fact
set state_f = 'UNKNOWN',
    dl_state_f = 'UNKNOWN',
    driver_state_f = 'UNKNOWN'
where state_f in ('AB', 'BC', 'MH', 'NB', 'NF', 'NU', 'NV', 'ON', 'PE', 'PQ','QC','US')
   or dl_state_f in ('AB', 'BC', 'MH', 'NB', 'NF', 'NU', 'NV', 'ON', 'PE', 'PQ','QC','US')
   or driver_state_f in ('AB', 'BC', 'MH', 'NB', 'NF', 'NU', 'NV', 'ON', 'PE', 'PQ','QC','US');


---------------------------Update invalid states for dimension tables---------------------------------

update state_dim
set state = 'Unknown'
where state in ('AB', 'BC', 'MH', 'NB', 'NF', 'NU', 'NV', 'ON', 'PE', 'PQ','QC','US','XX');

update dl_state_dim
set dl_state = 'Unknown'
where dl_state in ('AB', 'BC', 'MH', 'NB', 'NF', 'NU', 'NV', 'ON', 'PE', 'PQ','QC','US','XX');

update driver_state_dim
set driver_state = 'Unknown'
where driver_state in ('AB', 'BC', 'MH', 'NB', 'NF', 'NU', 'NV', 'ON', 'PE', 'PQ','QC','US','XX');


------------------ Find the vehicle type with the highest violations-------------------

select
    vtd.vehicle_type,
    count(*) as total_violations
from
    violations_fact vf
join vehicle_type_dim vtd on vf.vehicle_type_id = vtd.vehicle_type_id
group by
    vtd.vehicle_type
order by
    total_violations desc
limit 1;


-------------------Number of accidents caused due to alcohol-----------------
select
    count(*) as total_accidents_with_alcohol
from
    violations_fact
where
    alcohol = true
	and accident = true;

----------------Number of accidents caused due to not wearing seat belt-------------
select
    count(*) as total_accidents_without_belts
from
    violations_fact
where
    belts = FALSE and accident = TRUE;


--------------Number of accidents that caused property damage---------------------
select
    count(*) as total_accidents_with_property_damage
from
    violations_fact
where
    property_damage = true
	and accident = true;

---------------Top 5 States with highest number of arrests-------------------------

select
    sd.state,
    count(*) as total_arrests
from
    violations_fact vf
join state_dim sd on vf.state_id = sd.state_id
where
    vf.arrest_type_f is not null
group by
    sd.state
order by
    total_arrests desc
limit 5;

-----------------Top 5 driver's states with highest number of arrests-----------------

select
    ds.driver_state,
    count(*) as total_arrests
from
    violations_fact vf
join driver_state_dim ds on vf.driver_state_id = ds.driver_state_id
where
    vf.arrest_type_f is not null
group by
    ds.driver_state
order by
    total_arrests desc
limit 5;


----------- Find the highest violation type---------------------------------

select
    vtd.violation_type,
    count(*) as total_violations
from
    violations_fact vf
join violation_type_dim vtd on vf.violation_type_id = vtd.violation_type_id
group by
    vtd.violation_type
order by
    total_violations desc
limit 1;


------------Find the top 5 search reasons---------------------

select
    sr.search_reason,
    count(*) as total_searches
from
    violations_fact vf
join search_reason_dim sr on vf.search_reason_id = sr.search_reason_id
where
    vf.search_conducted = TRUE
group by
    sr.search_reason
order by
    total_searches desc
limit 5;

