-- select all the tables
SELECT CONCAT('select ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name from`', table_name, '` limit 30;')
FROM information_schema.tables
WHERE table_schema = 'bike';


-- select columns 
SHOW FULL COLUMNS FROM `bike`.`2021_Jan`;

-- selection of order by 
select concat('select rideable_type,count(*) from`',table_name,'`group by rideable_type;') from information_schema.tables where table_schema='bike' order by field(table_name,'2021_Jan','2021_Feb','2021_Mar','2021_Apr','2021_May','2021_Jun','2021_Jul','2021_Aug','2021_Sep','2021_Oct','2021_Nov','2021_Dec');

select end_lat from`2021_Jan`union all   
select end_lat from`2021_Feb`union all  
select end_lat from`2021_Mar`union all  
select end_lat from`2021_Apr`union all  
select end_lat from`2021_May`union all  
select end_lat from`2021_Jun`union all  
select end_lat from`2021_Jul`union all  
select end_lat from`2021_Aug`union all  
select end_lat from`2021_Sep`union all  
select end_lat from`2021_Oct`union all  
select end_lat from`2021_Nov`union all  
select end_lat from`2021_Dec`;
