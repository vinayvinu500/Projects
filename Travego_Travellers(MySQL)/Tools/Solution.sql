# a.How many females and how many male passengers traveled a minimum distance of 600 KMs? (At the point of 600KM)
select tb.Gender, if(min(tb.min_dist)=0,1,0) as 'Minimum Distance' from (select *,abs(600 - Distance) as min_dist from passengers order by Gender) as tb group by Gender;

# b.Find the minimum ticket price of a Sleeper Bus. 
select Bus_Type, min(price) from prices group by Bus_Type having Bus_Type = 'Sleeper';

# c.Select passenger names whose names start with character 'S' 
select passenger_name from passengers where passenger_name like 'S%';

# d.Calculate price charged for each passenger displaying Passenger name, Boarding City, Destination City, Bus_Type, Price in the output
select passengers.passenger_name, passengers.boarding_city, passengers.destination_city, passengers.bus_type, prices.price 
from passengers inner join prices 
on passengers.Distance = prices.Distance and passengers.bus_type = prices.bus_type
order by passengers.passenger_name;

# e.What are the passenger name(s) and the ticket price for those who traveled 1000 KMs Sitting in a bus?  (no output : We can conclude there is no one who travelled so far)
select passengers.passenger_name, prices.price 
from passengers inner join prices
on passengers.Distance = prices.Distance and passengers.bus_type = prices.bus_type and passengers.Distance = 1000 and passengers.bus_type = 'Sitting';

# f.What will be the Sitting and Sleeper bus charge for Pallavi to travel from Bangalore to Panaji?
set @pallavi_distance = (select Distance from passengers where passenger_name = 'Pallavi'); -- travelling from Bangalore to Panaji and passenger_name = 'Pallavi'
select bus_type, price from prices where distance = @pallavi_distance and bus_type in ('Sleeper','Sitting');

# g.List the distances from the "Passenger" table which are unique (non-repeated distances) in descending order. 
select distinct distance from passengers order by distance desc;

# h.Display the passenger name and percentage of distance traveled by that passenger from the total distance traveled by all passengers without using user variables 
select passenger_name, round((distance/(select sum(distance) from passengers))*100,2) as 'percentage' from passengers; -- keyword percentage of distance
select Passenger_name, round(sum(Distance)/(select sum(Distance) from Passengers)*100,2) as percentage from Passengers group by Passenger_name;















####################################Re-check/ Research/ Validating Result-Set####################################
-- Data
/*
select * from `Travego`.`Passengers`;
select * from `Travego`.`Prices`;

# Question : a
-- data
select * from passengers;

-- Females travelled a minimum distance of 600KMs
select *,(600 - Distance) from passengers where Gender = 'F';

-- Males travelled a minimum distance of 600KMs
select *,(600 - Distance) from passengers where Gender = 'M';

-- logic
the person whether male or female is at point 600KMs

-- final output
select *,abs(600 - Distance) as min_dist from Passengers order by Gender;

# Question : b
-- data
select * from prices;

-- Sleeper
select * from prices where Bus_Type = 'Sleeper';

-- Sitting
select * from prices where Bus_Type = 'Sitting';


# Question : d
can be solved in two method
	- left join
	- inner join (bus_type and distance)

# Question : e
-- prices for distance of 1000kms and bus_type is sitting
select * from prices where bus_type = 'Sitting' and Distance = 1000;

-- passengers who travelled 1000KMs on a Slepper bus
select passengers.*, prices.price 
from passengers inner join prices
on passengers.Distance = prices.Distance and passengers.bus_type = prices.bus_type and passengers.Distance = 1000;

-- passengers for distnace of 1000kms and bus_type is sitting
select * from passengers where bus_type = 'Sitting' and Distance = 1000; # there is no passenger who has travelled 1000kms sitting in a bus
select * from passengers where bus_type = 'Sitting' and Distance between 500 and 1000; # there is some passenger who has travelled atmost 1000kms sitting in a bus

# Question : f
select * from passengers;
select * from passengers where passenger_name = 'Pallavi';

-- sitting 
select passengers.*, prices.price from passengers inner join prices on passengers.Distance = prices.Distance and passengers.bus_type = prices.bus_type and passengers.bus_type = 'Sitting' and passengers.Distance = 600;

-- sleeping
select passengers.*, prices.price from passengers inner join prices on passengers.Distance = prices.Distance and passengers.bus_type = prices.bus_type and passengers.bus_type = 'Sleeper' and passengers.Distance = 600;

-- final output
passenger_name = 'Pallavi'
bus_type = Sleeper | Sitting
Prices	 =   1320      744

-- above analysis of the table : pallavi travelled from panaji to bangalore in a sleeper bus and inreturn pallavi calculating the bus_price 
select passengers.passenger_name, passengers.boarding_city, passengers.destination_city, passengers.distance, prices.price
from passengers inner join prices
on passengers.Distance = prices.Distance and passengers.bus_type = prices.bus_type and passengers.passenger_name = 'Pallavi';

# Question : h
method 1 : user variables where each distance divide by total distance
set @sum_distance = (select sum(distance) from passengers); -- sum of the passengers = 6500
select passenger_name, distance, round(distance/@sum_distance,2) as percentage from passengers;


method 2 : window functions
-- for individual distance
	Unique Distance  Count    Sum    percent
		350 		  1       350		1
		500 		  2       1000 		0.5
		600 		  1       600 		1
		700 		  3       2100 		0.3
		1000 		  1       1000 		1
		1500 		  1       1500		1

select distinct distance, count(distance) over(partition by distance) as 'Count', sum(distance) over(partition by distance) as 'Sum', distance/sum(distance) over(partition by distance) as 'percent' from passengers; 

*/





