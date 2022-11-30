use ipl;

# 1.	Show the percentage of wins of each bidder in the order of highest to lowest percentage.
select bidder_name,
       count(if(bid_status = 'won',1,null)) as won,
       count(A.BIDDER_ID) as total,
       round(count(if(bid_status = 'won',1,null))/count(A.bidder_id)*100,2) as win_percentage
from IPL_BIDDING_DETAILS A inner join IPL_BIDDER_DETAILS B
on A.BIDDER_ID = B.BIDDER_ID
group by A.BIDDER_ID
order by win_percentage desc;

# 2.	Display the number of matches conducted at each stadium with the stadium name and city.
select STADIUM_NAME, CITY, count(*) as no_of_matches
from IPL_MATCH A inner join IPL_MATCH_SCHEDULE B inner join IPL_STADIUM C
on A.MATCH_ID = B.MATCH_ID and B.STADIUM_ID = C.STADIUM_ID
group by C.STADIUM_ID;

# 3.	In a given stadium, what is the percentage of wins by a team which has won the toss?

-- analysis
# Edge Case: where count of ipl_match is 120 but count of ipl_match_schedule is 122 (where 2 scheduled matches got cancelled)
# scheduled_id = (10082, 10008)  and match_id = (1110, 1016) are cancelled but count in the total column to get the percentage

-- win by a team and won the toss : calculated by win_team and win_toss / total(win_team and win_toss | lost_team and lost_toss | got_cancelled)
select C.STADIUM_NAME,
       count(if(match_winner = TOSS_WINNER, 1, null)) as won,
       count(*) as total,
       round((count(if(MATCH_WINNER = TOSS_WINNER,1,null))/count(*))*100,2) as won_percentage
from IPL_MATCH A inner join IPL_MATCH_SCHEDULE B inner join IPL_STADIUM C
on A.MATCH_ID = B.MATCH_ID and B.STADIUM_ID = C.STADIUM_ID
group by C.STADIUM_ID;

# 4.	Show the total bids along with the bid team and team name.
select A.bid_team, B.TEAM_NAME, count(*) as total_bids
from IPL_BIDDING_DETAILS A inner join IPL_TEAM B
on A.BID_TEAM = B.TEAM_ID
group by A.BID_TEAM;

# 5.	Show the team id who won the match as per the win details.
select TEAM_ID, TEAM_NAME,WIN_DETAILS
from IPL_MATCH A inner join IPL_TEAM B
on trim(left(substr(WIN_DETAILS,6),position(' ' in substr(win_details,6)))) = B.REMARKS; -- won the match as per win_details

-- another approach : using where clause
select TEAM_ID, TEAM_NAME,WIN_DETAILS
from IPL_MATCH A inner join IPL_TEAM B
on A.WIN_DETAILS like concat('%',B.REMARKS,'%');

# 6.	Display total matches played, total matches won and total matches lost by the team along with its team name.

-- analysis
# Edge Case1 : some of the match_winner having the team_id instead of team_id1 or team_id2
# Edge Case2 : approach1 is based on ipl_team_standings and approach2 is based on ipl_match table

-- approach1 : IPL_TEAM_STANDINGS has total matches_played, matches_won, matches_lost
select B.TEAM_NAME, sum(MATCHES_WON) as won, sum(MATCHES_LOST) as lost, sum(MATCHES_PLAYED) as total
from IPL_TEAM_STANDINGS A inner join IPl_TEAM B
on A.TEAM_ID = B.TEAM_ID
group by A.TEAM_ID;

-- approach2 : IPL_MATCH has team_id1 and team_id2 based on that total, won, lost can be calculated
with wontb as (select (case when MATCH_WINNER = 1 then TEAM_ID1 when MATCH_WINNER = 2 then TEAM_ID2 else MATCH_WINNER end) as won, count(*) as wct from IPL_MATCH group by won),
     losttb as (select (case when MATCH_WINNER = 1 then TEAM_ID2 when MATCH_WINNER = 2 then TEAM_ID1 else if(MATCH_WINNER = TEAM_ID1,TEAM_ID2, TEAM_ID1) end) as lost, count(*) as lct from IPL_MATCH group by lost)

select TEAM_NAME, wct as won, lct as lost, wct+lct as total
from wontb inner join losttb inner join IPL_TEAM
on wontb.won = losttb.lost and IPL_TEAM.TEAM_ID = wontb.won
order by wontb.won;

# 7.	Display the bowlers for the Mumbai Indians team.
-- Edge Case: the team_id is different from the remarks column (best practice is using remarks is reliable)
select team_id, A.PLAYER_ID, PERFORMANCE_DTLS
from IPL_TEAM_PLAYERS A inner join IPL_PLAYER B
on A.PLAYER_ID = B.PLAYER_ID and A.REMARKS like '%MI%' and A.PLAYER_ROLE like '%Bowler%';

# 8.	How many all-rounders are there in each team, Display the teams with more than 4 all-rounders in descending order.
select replace(REMARKS,'TEAM - ','') as REMARKS, count(*) as total
from IPL_TEAM_PLAYERS
where PLAYER_ROLE like '%All-Rounder%'
group by REMARKS
having total > 4
order by total desc;

# 9.	Write a query to get the total bidders points for each bidding status of those bidders who bid on CSK
#       when it won the match in M. Chinnaswamy Stadium bidding year-wise.
# 		Note the total bidders’ points in descending order and the year is bidding year.
# 		Display columns: bidding status, bid date as year, total bidder’s points

-- won the match = ipl_stadium.stadium_name = 'M. Chinnaswamy Stadium'
-- total bidder points for each bidding status = ipl_match.bid_status('Bid','Won','Lost','Cancelled') => group by bid_status, bidder_id and count
-- condition only csk
select bidder_id,
       if(bid_status = 'Won',BID_STATUS, 'Lost') as Bid_status,
       count(if(BID_STATUS = 'Won',1,null)) as won,
       count(if(BID_STATUS != 'Won',1,null)) as lost
from IPL_BIDDING_DETAILS inner join IPL_MATCH_SCHEDULE
on IPL_BIDDING_DETAILS.SCHEDULE_ID = IPL_MATCH_SCHEDULE.SCHEDULE_ID and
    IPL_BIDDING_DETAILS.BID_TEAM = (select team_id from ipl_team where TEAM_NAME like '%Chennai Super Kings%') and
   IPL_MATCH_SCHEDULE.STADIUM_ID = (select STADIUM_ID from IPL_STADIUM where STADIUM_NAME like '%M. Chinnaswamy Stadium%')
group by bid_status, bidder_id
order by won desc, BIDDER_ID desc;

-- another approach
select A.BID_STATUS, count(*) as ct
from IPL_BIDDING_DETAILS A inner join IPL_MATCH_SCHEDULE B inner join IPL_STADIUM C
on A.SCHEDULE_ID = B.SCHEDULE_ID and B.STADIUM_ID = C.STADIUM_ID and
    A.BID_TEAM = (select team_id from IPL_TEAM where REMARKS like '%CSK%') and
    C.STADIUM_NAME like '%M. Chinnaswamy Stadium%'
group by A.BID_STATUS;



# 10.	Extract the Bowlers and All Rounders those are in the 5 highest number of wickets.
# 		Note 
#			1. use the performance_dtls column from ipl_player to get the total number of wickets
#			2. Do not use the limit method because it might not give appropriate results when players have the same number of wickets
#			3.	Do not use joins in any cases.
#			4.	Display the following columns team_name, player_name, and player_role.
with players as (select B.TEAM_NAME,
                        A.PLAYER_NAME,
                        C.PLAYER_ROLE,
                        trim(replace(substr(PERFORMANCE_DTLS, position('Wkt' in PERFORMANCE_DTLS), position(' Dot' in PERFORMANCE_DTLS)-position('Wkt' in PERFORMANCE_DTLS)),'Wkt-','')) as wkts
                 from IPL_PLAYER A,
                      ipl_team B,
                      IPL_TEAM_PLAYERS C
                 where A.PLAYER_ID = C.PLAYER_ID
                   and replace(C.REMARKS, 'TEAM - ', '') = B.REMARKS
                   and C.PLAYER_ROLE not in ('Wicket Keeper', 'Batsman')
                 order by wkts desc),
    highest as (select
        TEAM_NAME,
        PLAYER_NAME,
        PLAYER_ROLE,
        wkts,
        nth_value(PLAYER_NAME,5) over w as '5th_highest_wkts'
    from players
    window w as (partition by player_role order by wkts desc, TEAM_NAME range between unbounded preceding and unbounded following)
    order by PLAYER_ROLE
)

select TEAM_NAME, PLAYER_NAME, PLAYER_ROLE from highest
where 5th_highest_wkts = PLAYER_NAME;

# 11.	show the percentage of toss wins of each bidder and display the results in descending order based on the percentage
select C.BIDDER_ID,
       count(if(if(A.TOSS_WINNER = 1, A.TEAM_ID1, A.TEAM_ID2) = C.BID_TEAM,1,null)) as toss_wins,
       count(if(if(A.TOSS_WINNER = 1, A.TEAM_ID1, A.TEAM_ID2) != C.BID_TEAM,1,null)) as toss_lost,
       count(*) as total,
       round((count(if(if(A.TOSS_WINNER = 1, A.TEAM_ID1, A.TEAM_ID2) = C.BID_TEAM,1,null))/count(*))*100,2) as toss_percentage
from IPL_MATCH A inner join IPL_MATCH_SCHEDULE B inner join IPL_BIDDING_DETAILS C
on C.SCHEDULE_ID = B.SCHEDULE_ID and B.MATCH_ID = A.MATCH_ID
group by C.BIDDER_ID
order by toss_percentage desc;

# 12.	find the IPL season which has min duration and max duration.
# Output columns should be like the below:
# Tournment_ID, Tourment_name, Duration column, Duration

select TOURNMT_ID, TOURNMT_NAME,
       date(FROM_DATE) as min_duration, date(TO_DATE) as max_duration,
       datediff(TO_DATE,FROM_DATE) as duration
from IPL_TOURNAMENT
order by duration, TOURNMT_ID;

# 13.	Write a query to display to calculate the total points month-wise for the 2017 bid year.
#       sort the results based on total points in descending order and month-wise in ascending order.
# 		Note: Display the following columns:
# 		1.	Bidder ID, 2. Bidder Name, 3. bid date as Year, 4. bid date as Month, 5. Total points
# 		Only use joins for the above query queries.

select B.BIDDER_ID, C.BIDDER_NAME,
       year(A.BID_DATE) as bid_year,
       month(A.BID_DATE) as bid_month,
       sum(B.TOTAL_POINTS) as total_pts
from IPL_BIDDING_DETAILS A inner join IPL_BIDDER_POINTS B inner join IPL_BIDDER_DETAILS C
on A.BIDDER_ID = B.BIDDER_ID and B.BIDDER_ID = C.BIDDER_ID and year(A.BID_DATE) = 2017
group by B.BIDDER_ID, C.BIDDER_NAME, year(A.BID_DATE), month(A.BID_DATE)
order by total_pts desc, bid_month;


# 14.	Write a query for the above question using sub queries by having the same constraints as the above question.
select
    A.bidder_id,
    (select BIDDER_NAME from IPL_BIDDER_DETAILS C where C.BIDDER_ID = A.BIDDER_ID) as bidder_name,
    year(BID_DATE) as bid_year,
    month(BID_DATE) as bid_month,
    sum((select TOTAL_POINTS from IPL_BIDDER_POINTS B where B.BIDDER_ID = A.BIDDER_ID)) as total_pts
from IPL_BIDDING_DETAILS A
where year(A.BID_DATE) = 2017
group by BIDDER_ID, bidder_name, bid_year, bid_month
order by total_pts desc, bid_month;

# 15.	Write a query to get the top 3 and bottom 3 bidders based on the total bidding points for the 2018 bidding year.
# 		Output columns should be like:
# 		Bidder Id, Ranks (optional), Total points, Highest_3_Bidders --> columns contains name of bidder, Lowest_3_Bidders  --> columns contains name of bidder;
with bidder_ranks as (
    select
        A.BIDDER_ID,
        sum(B.TOTAL_POINTS) as total_pts,
       dense_rank() over(order by sum(TOTAL_POINTS)) as rank_lowest,
       dense_rank() over(order by sum(TOTAL_POINTS) desc) as rank_highest
from IPL_BIDDING_DETAILS A inner join IPL_BIDDER_POINTS B
on A.BIDDER_ID = B.BIDDER_ID and year(A.BID_DATE) = 2018
group by A.BIDDER_ID
order by total_pts)

select A.BIDDER_ID, A.rank_lowest, A.rank_highest, A.total_pts,
       if(rank_lowest <=3,B.BIDDER_NAME,null) as 'Highest_3_Bidders',
       if(rank_highest <=3,B.BIDDER_NAME,null) as 'Lowest_3_Bidders'
from bidder_ranks A inner join IPL_BIDDER_DETAILS B
on A.BIDDER_ID = B.BIDDER_ID
where (if(rank_lowest <=3,B.BIDDER_NAME,null) is not null and if(rank_highest <=3,B.BIDDER_NAME,null) is null) -- removing the middle nulls
or (if(rank_lowest <=3,B.BIDDER_NAME,null) is null and if(rank_highest <=3,B.BIDDER_NAME,null) is not null);

# 16.   Create two tables called Student_details and Student_details_backup.
create table Student_details(
  roll_number int primary key,
  name varchar(30),
  age int,
  marks int check(marks >=0 and marks <=100)
);

create table Student_details_backup as select * from Student_details;

create trigger backup_students
after insert on Student_details
for each row
insert into Student_details_backup values(new.roll_number, new.name, new.age, new.marks);


#################################Research#######################################
-- 1. Show the percentage of wins of each bidder in the order of highest to lowest percentage.
/*
Tables : IPL_BIDDING_DETAILS | IPL_BIDDER_DETAILS
Query performed : SubQuery and Join

PseudoCode
	- question itself states percentage of wins of each bidder (this can be achieved by bidder_id in the IPL_BIDDING_DETAILS)
	- the percentage of wins can be calculated by bid_status who has won (IPL_BIDDING_DETAILS)

With clause having two sub_queries which is independent to each other and joined two tables with the matching column bidder_id
	- the first_sub_query is calculating the total bids of each bidder_id (IPL_BIDDING_DETAILS)
	- the second_sub_query is calculating the only win bids of each bidder_id (IPL_BIDDING_DETAILS)

outer query
	- selecting the bidder_id, bidder_won, bidder_won / bidder_total as percentage from the two subqueries

final query
	- selecting the bidder_id, bidder_name, percentage (concatenate with %) from the IPL_BIDDER_DETAILS table and with_clause_subquery
	- sorting percentage in descending order
*/

with pt_bid as (select b.BIDDER_ID,
       ifnull(bwon.ct,0) as 'won',
       b.nct as 'total',
       round((ifnull(bwon.ct,0)/b.nct),2)*100 as pt
from
     (select bidder_id, count(*)  as nct from IPL_BIDDING_DETAILS group by bidder_id) as b left join
     (select bidder_id, count(*) as ct from IPL_BIDDING_DETAILS where BID_STATUS = 'Won' group by bidder_id) as bwon
on b.BIDDER_ID = bwon.BIDDER_ID)

select bt.BIDDER_ID ,BIDDER_NAME, pt_bid.won, pt_bid.total - pt_bid.won as lost,
       pt_bid.total as total,
       concat(round((pt_bid.total - pt_bid.won)/pt_bid.total,2)*100,'%') as lost_percentage,
       concat(pt_bid.pt,'%') as win_percentage from IPL_BIDDER_DETAILS as bt, pt_bid
where bt.BIDDER_ID = pt_bid.BIDDER_ID and
      (pt_bid.pt >= 67 and pt_bid.pt <=100)
order by pt_bid.pt desc, total desc, bt.BIDDER_ID desc;

-- another approach
with t1 as
(select bidder_id, count(*) as ct from ipl_bidding_details where bid_status = 'Won' group by bidder_id),
 t2 as (select bidder_id, count(*) as ct from ipl_bidding_details group by bidder_id)

select tb1.bidder_name, ifnull(tb2.percentage,0) as percentages from ipl_bidder_details as tb1 left join
(select t1.bidder_id, round(t1.ct / t2.ct,2)*100 as percentage
from t1, t2
where t1.bidder_id = t2.bidder_id) as tb2
on tb1.bidder_id = tb2.bidder_id
order by tb2.percentage desc;

/*
Tables: IPL_BIDDER_DETAILS, subquery1 as bwon for counting IPL_BIDDER_DETAILS.BID_STATUS = 'Won' and group by IPL_BIDDER_DETAILS.BIDDER_ID
        and subquery2 as b for counting respective IPL_BIDDER_DETAILS.BIDDER_ID
Step 1: Joining subquer1(bwon) and subquery2(b) based on left join where we get the bidder who didn't done bidding for them we are putting 0 instead of null
Step 2: Percentage formula = won / no_of_total('won','Lost','Cancelled','Bidding') where if the numerator having null we are putting 0 to avoid any null constraints
Step 3: Selecting IPL_BIDDER_DETAILS.BIDDER_ID, IPL_BIDDER_DETAILS.BIDDER_NAME, percentage as pt with symbol add-on
        based on condition IPL_BIDDER_DETAILS.BIDDER_ID = pt_bid.BIDDER_ID(subquery)
        and sorting by percentage in descending, total in descending and IPL_BIDDER_DETAILS.BIDDER_ID in descending
*/

-- 2. Display the number of matches conducted at each stadium with stadium name, city from the database.
/*
Tables : IPL_BIDDING_DETAILS | IPL_TEAM | IPL_MATCH_SCHEDULE
Query performed : Inner Join

PseudoCode
	- Joining the two tables
		IPL_BIDDING_DETAILS
				|				-> IPL_BIDDING_DETAILS.MATCH_ID = IPL_MATCH_SCHEDULE.MATCH_ID
		IPL_MATCH_SCHEDULE
				|				-> IPL_MATCH_SCHEDULE.STADIUM_ID = IPL_TEAM.STADIUM_ID
			IPL_TEAM

	- grouping the final query with IPL_TEAM.STADIUM_ID and counting the IPL_BIDDING_DETAILS.MATCH_ID

final query
	- selecting the IPL_TEAM.STADIUM_NAME, IPL_TEAM.CITY, COUNT
*/

select t3.STADIUM_NAME, t3.CITY, count(t1.MATCH_ID) as 'no of matches'
from IPL_MATCH as t1 inner join IPL_MATCH_SCHEDULE as t2 inner join IPL_STADIUM as t3
on t1.match_id = t2.MATCH_ID and t2.STADIUM_ID = t3.STADIUM_ID
group by t2.STADIUM_ID;
/*
Tables: IPL_MATCH, IPL_MATCH_SCHEDULE, IPL_STADIUM
Step 1: Joining the three table with their respective matching columns as
        IPL_MATCH.MATCH_ID = IPL_MATCH_SCHEDULE.MATCH_ID and IPL_STADIUM.STADIUM_ID = IPL_MATCH_SCHEDULE.STADIUM_ID
Step 2: Grouping by IPL_STADIUM.STADIUM_ID and selecting IPL_STADIUM.STADIUM_NAME, IPL_STADIUM.city
        and count of respective IPL_MATCH.MATCH_ID
*/

-- 3. In a given stadium, what is the percentage of wins by a team which has won the toss?
with matched as (
    select STADIUM_NAME, count(IF(TOSS_WINNER = MATCH_WINNER, 1, null)) as wins, count(IF(TOSS_WINNER != MATCH_WINNER, 1, null)) as lost
    from IPL_MATCH t1 inner join IPL_MATCH_SCHEDULE t2 inner join IPL_STADIUM as t3 on t1.MATCH_ID = t2.match_id and t2.STADIUM_ID = t3.STADIUM_ID
    group by STADIUM_NAME
)

select STADIUM_NAME, round(wins/(wins+lost),2)*100 as percentage from matched order by percentage desc;
/*
Tables: IPL_MATCH, IPL_MATCH_SCHEDULE, IPL_STADIUM
Step 1: Joining three tables and filtering based on match_id in both tables(IPL_MATCH, IPL_MATCH_SCHEDULE)
        and stadium_id in both tables(IPL_MATCH_SCHEDULE, IPL_STADIUM)
Step 2: Grouping by IPL_STADIUM.STADIUM_NAME and selecting IPL_STADIUM.STADIUM_NAME, counts of wins and loses
Step 3: wins_count as wins by giving the 1 as value whose team has won the toss and won the match(58)
Step 4: lost_counts as lost by giving the 1 as value whose teams doesn't won the toss and lost the match (64)
Step 5: naming the subquery as matched and selecting IPL_STADIUM.STADIUM_NAME, wins_percentage as percentage and order by percentage
*/

-- another approach
select * from ipl_match inner join ipl_match_schedule inner join ipl_stadium
on ipl_match.MATCH_ID = ipl_match_schedule.MATCH_ID and ipl_match_schedule.STADIUM_ID = ipl_stadium.STADIUM_ID;

-- percentage of wins by a team which has won the toss : team won the match and won the toss
create view matches as
(select match_id,
		if(toss_winner = 1, team_id1, team_id2) as team_toss_win,
        if(toss_winner = 1, team_id2, team_id1) as team_toss_lost,
        case when match_winner = 1 then team_id1 when match_winner = 2 then team_id2 else match_winner end as team_match_won, -- edge case in the match_winner
        case when match_winner = 1 then team_id2 when match_winner = 2 then team_id1 else match_winner end as team_match_lost
from ipl_match);

with mt as
(select ipl_stadium.STADIUM_NAME, matches.team_toss_win, matches.team_match_won
from matches inner join ipl_match_schedule inner join ipl_stadium
on matches.match_id = ipl_match_schedule.match_id and ipl_match_schedule.stadium_id = ipl_stadium.STADIUM_ID)

select stadium_name, count(win) as win, count(lost) as lost, count(win) + count(lost) as total, round(count(win)/(count(win)+count(lost)),2)*100 as win_percentage, round(count(lost)/(count(win)+count(lost)),2)*100 as lost_percentage
from
(select mt.stadium_name, case when team_toss_win = team_match_won then 1 else null end as win, case when team_toss_win != team_match_won then 1 else null end as lost
from mt) tb
group by stadium_name;

-- ----------------------------------------------------------------------------------------------------------------------------------

with
won as (select match_id, team_match_won as team_id, count(team_match_won) as ct from matches where team_match_won = team_toss_win group by team_match_won),
lost as (select match_id, team_match_lost as team_id, count(team_match_lost) as ct from matches where team_match_won != team_toss_win group by team_match_lost)

-- for each team_id who much win and lost and percentages
select won.team_id, won.ct as won, lost.ct as lost, won.ct+lost.ct as total, round(won.ct/(won.ct+lost.ct),2) as win_percentage, round(lost.ct/(won.ct+lost.ct),2) as lost_percentage
from won,lost where won.team_id = lost.team_id order by team_id;

-- 4. Show the total bids along with bid team and team name.
select count(*) as total,
       TEAM_ID,
       TEAM_NAME
from IPL_BIDDING_DETAILS left join IPL_TEAM on IPL_BIDDING_DETAILS.BID_TEAM = IPL_TEAM.TEAM_ID
group by IPL_TEAM.TEAM_ID;
/*
Tables: IPL_BIDDING_DETAILS, IPL_TEAM
Step 1: Joining two tables with the condition of IPL_BIDDING_DETAILS.BID_TEAM = IPL_TEAM.TEAM_ID
Step 2: Selecting IPL_TEAM.TEAM_NAME, IPL_TEAM.TEAM_ID and
Step 3: counting each IPL_TEAM.TEAM_ID as total and sorting in descending order
*/


-- 5. Show the team id who won the match as per the win details.
select if(MATCH_WINNER = 1, TEAM_ID1, TEAM_ID2) as team_id, count(*) as 'won'
from IPL_MATCH
group by team_id
order by team_id;
/*
Tables: IPL_MATCH
Step1: grouping by team_id where team_id is the modification of IPL_MATCH.match_winner which puts the team_ID's
Step2: Selecting team_id, counts for the respective wining team in the IPL_MATCH table
*/

-- another approach
select team_name,
		case when match_winner = 1 then team_id1
			 when match_winner = 2 then team_id2
             else match_winner end
	    as team_id,
		win_details
from ipl_match,ipl_team
where substr(win_details,6,position(' ' in substr(win_details,6))-1) = ipl_team.remarks and ipl_team.team_id = team_id;

-- 6. Display total matches played, total matches won and total matches lost by team along with its team name.
with wt as (select if(MATCH_WINNER=1,TEAM_ID1, TEAM_ID2) as teams, count(*) as total from IPL_MATCH group by teams order by teams),
     lt as (select if(MATCH_WINNER=1,TEAM_ID2, TEAM_ID1) as teams, count(*) as total from IPL_MATCH group by teams order by teams)

select tm.TEAM_NAME, wt.total as win, lt.total as lost, wt.total+lt.total as total  from lt, wt, IPL_TEAM as tm
where lt.teams = wt.teams and tm.TEAM_ID = lt.teams;
/*
Tables: IPL_MATCH, IPL_TEAM
Note: In the IPL_MATCH.MATCH_WINNER column, there are team_ids which is representing the IPL_MATCH.team_id1 or IPL_MATCH.team_id2
      and grouping by respective team_id
Step 1: Subquery 1: wt(wins_total), pointing to the which IPL_MATCH.TEAM_ID1 if its 1 then points to IPL_MATCH.TEAM_ID1 otherwise IPL_MATCH.TEAM_ID2
Step 2: Subquery 2: lt(lost_total), pointing to the which IPL_MATCH.TEAM_ID1 if its 1 then points to IPL_MATCH.TEAM_ID2 otherwise IPL_MATCH.TEAM_ID1
Step 3: joining subquery-1 and subquery-2 on basis of team_id column which is having slight modification in IPL_MATCH.MATCH_WINNER
Step 4: joining previous query with IPL_TEAM.team_id and selecting IPL_TEAM.TEAM_NAME, subquery1.total, subquery2.total, addition of subquery1.total and subquery2.total as total
*/

-- 7. Display the bowlers for both Mumbai Indians and Chennai Super Kings teams.
select PLAYER_NAME, PERFORMANCE_DTLS from IPL_PLAYER where PLAYER_ID in
(select PLAYER_ID from IPL_TEAM_PLAYERS
where TEAM_ID in (select TEAM_ID from IPL_TEAM where TEAM_NAME like '%Mumbai Indians%' or TEAM_NAME like '%Chennai%')
and PLAYER_ROLE like '%Bowler%');

select * from ipl_team_players p, ipl_team t
Where p.team_id = t.team_id and (p.team_id = 5 or p.team_id = 1) and player_role='bowler';
/*
Tables: IPL_TEAM_PLAYERS, IPL_PLAYER, TEAM_NAME
Step 1: first_level_inner query, fetching the IPL_TEAM.TEAM_ID those IPL_TEAM.TEAM_NAME having 'Mumbai Indians'
Step 2: second_level_inner query, fetching the IPL_TEAM_PLAYERS.PLAYER_ID those IPL_TEAM_PLAYERS.TEAM_ID having inner_query result IPL_TEAM.TEAM_ID
        and another filter by IPL_TEAM_PLAYERS.PLAYER_ROLE having 'Bowler'
Step 3: third_level_outer query, selecting PLAYER_NAME, PERFORMANCE_DTLS from the IPL_TEAM_PLAYERS.PLAYER_ID in IPL_PLAYER.PLAYER_ID(second_level_inner_query)
*/

-- 8. How many all-rounders are there in each team, Display the teams with more than 4 all-rounder in descending order.
# approach 1 : using respective team_id column
select TEAM_NAME, count(*) as total
from IPL_TEAM_PLAYERS, IPL_TEAM
where PLAYER_ROLE like '%All-Rounder%' and IPL_TEAM.TEAM_ID = IPL_TEAM_PLAYERS.TEAM_ID
group by IPL_TEAM_PLAYERS.TEAM_ID
having total > 4
order by total desc;

# approach 2 : using respective remarks column
select t1.TEAM_NAME, count(*) as total
from IPL_TEAM as t1, (select *, replace(REMARKS,'TEAM - ','') as remark from IPL_TEAM_PLAYERS) as t2
where PLAYER_ROLE like '%All-Rounder%' and t1.REMARKS = t2.remark
group by t1.TEAM_Name
having total > 4
order by total desc;
/*
Tables: IPL_TEAM_PLAYERS, IPL_TEAM
Step 1: filtering IPL_TEAM_PLAYERS.PLAYER_ROLE having All-Rounder
Step 2: grouping IPL_TEAM_PLAYERS.TEAM_ID and counting the each of player_role in respective IPL_TEAM
Step 3: Selecting IPL_TEAM.TEAM_NAME and count from IPL_TEAM_PLAYERS.TEAM_ID grouping column
Step 4: filtering count more than 4 and sorting in descending order
*/

#################################### Research #############################################
/*
# Q1
    percentage of wins of each bidder = no of win count / no of counts
    order of highest to lowest percentage = whole window to be highest and lowest
    tables:
        - ipl_bidder_details
        - ipl_bidding_details
        - ipl_bidder_points

-- ipl_bidding_details            | ipl_bidder_details
-- count : 200 | won_count : 98   | count : 30
select * from IPL_BIDDING_DETAILS;

-- combining ipl_bidder_details, ipl_team, ipl_bidding_details
select BIDDER_NAME, CONTACT_NO, EMAIL_ID, b.BID_DATE, b.REMARKS
from IPL_BIDDER_DETAILS, (select BIDDER_ID, REMARKS, BID_DATE
                          from IPL_TEAM, IPL_BIDDING_DETAILS
                          where IPL_BIDDING_DETAILS.BID_TEAM = IPL_TEAM.TEAM_ID) as b
where b.BIDDER_ID = IPL_BIDDER_DETAILS.BIDDER_ID;

-- another approach 2
-- task 1 : percentage of wins of each bidder / total no of bidding of each bidder
with t1 as
(select bidder_id, count(*) as ct from ipl_bidding_details where bid_status = 'Won' group by bidder_id),
 t2 as (select bidder_id, count(*) as ct from ipl_bidding_details group by bidder_id)

select tb1.bidder_name, ifnull(tb2.percentage,0) as percentages from ipl_bidder_details as tb1 left join
(select t1.bidder_id, round(t1.ct / t2.ct,2)*100 as percentage
from t1, t2
where t1.bidder_id = t2.bidder_id) as tb2
on tb1.bidder_id = tb2.bidder_id
order by tb2.percentage desc;

-- another approach
select * from IPL_BIDDING_DETAILS;
select * from IPL_TEAM;
select TEAM_NAME,
       count(if(won != 0, 1,null)) as won,
       count(if(total != 0, 1, null)) as total
from
(select BIDDER_NAME,
       count(IF(BID_STATUS = 'Won', 1, null)) over(partition by t1.bidder_id) as won,
       count(bid_status) over(partition by t1.BIDDER_ID)                      as total
from IPL_BIDDING_DETAILS as t1 join IPL_BIDDER_DETAILS as t2
on t1.BIDDER_ID = t2.BIDDER_ID) t
group by t.TEAM_NAME;

# Q2
    tables:
        - ipl_match
        - match_schedule
        - stadium
    joins
        - ipl_match.matchid = match_schedule.matchid
        - match_schedule.stadiumid = stadium.stadiumid

select * from IPL_MATCH;
select * from IPL_MATCH_SCHEDULE;
select * from IPL_STADIUM;

-- joining the ipl_match and ipl_match_schedule
select t1.match_id, t2.STADIUM_ID
from IPL_MATCH as t1 inner join IPL_MATCH_SCHEDULE as t2
on t1.match_id = t2.MATCH_ID;

-- joining the ipl_statdium and ipl_match_schedule
select t1.match_id, t2.STADIUM_ID, t3.STADIUM_NAME, t3.CITY
from IPL_MATCH as t1 inner join IPL_MATCH_SCHEDULE as t2 inner join IPL_STADIUM as t3
on t1.match_id = t2.MATCH_ID and t2.STADIUM_ID = t3.STADIUM_ID;

# Q3
-- --------------------------------------------------------------------------
# Total Percentage  : team particular won toss and won match divides team particular won toss and won match + lost toss and lost match
# Total Probability : team won toss and won match | team lost toss and won match | team won toss and lost match | team lost toss and lost match
# condition probability : P(team win | won toss) = P(team win) * P(won toss) / P(lost toss)
-- --------------------------------------------------------------------------
create view matches as (
select t2.STADIUM_ID, t1.MATCH_ID, if(MATCH_WINNER = 1, TEAM_ID1, TEAM_ID2) as MATCH_WINNER,
       if(MATCH_LOSER = 1, TEAM_ID1, TEAM_ID2) as MATCH_LOSER,
       if(TOSS_WINNER = 1, TEAM_ID1, TEAM_ID2) as TOSS_WINNER,
       if(TOSS_LOSER = 1, TEAM_ID1, TEAM_ID2) as TOSS_LOSER
from
(select *,
       if(TOSS_WINNER = 1, 2, 1) as TOSS_LOSER,
       if(MATCH_WINNER = 1, 2, 1) as MATCH_LOSER
from IPL_MATCH) t1 inner join IPL_MATCH_SCHEDULE t2
on t1.MATCH_ID = t2.MATCH_ID);

-- data
select * from matches; -- total : 122
select * from IPL_MATCH; -- total : 120

-- --------------------------------------------------------------------------
# Probability
-- --------------------------------------------------------------------------
# team won the toss and won match
select * from matches where MATCH_WINNER = TOSS_WINNER; -- total : 58
# team lost toss and won match
select * from matches where TOSS_LOSER = MATCH_WINNER; -- total : 64
# team won toss and lost match
select * from matches where TOSS_WINNER = MATCH_LOSER; -- total : 64
# team lost toss and lost match
select * from matches where TOSS_LOSER = MATCH_LOSER; -- total : 58
-- --------------------------------------------------------------------------
-- --------------------------------------------------------------------------
# Percentage
-- --------------------------------------------------------------------------
# team won match and won toss from each stadium and team counts
select t2.STADIUM_NAME, count(*) as ct
from matches as t1, IPL_STADIUM as t2
where t1.STADIUM_ID = t2.STADIUM_ID and t1.MATCH_WINNER = t1.TOSS_WINNER
group by t2.STADIUM_NAME
order by ct desc;

# team lost match and lost toss for each stadium and team counts
select t2.STADIUM_NAME, count(*) as ct
from matches as t1, IPL_STADIUM as t2
where t1.STADIUM_ID = t2.STADIUM_ID and t1.MATCH_WINNER != t1.TOSS_WINNER
group by t2.STADIUM_NAME
order by ct desc;

-- combining the won and lost match and toss
select t3.STADIUM_NAME,
       t1.ct as 'win',
       t2.ct as 'loss',
       round((t1.ct/(t2.ct+t1.ct)),2)*100 as percentage
from
(select STADIUM_ID, count(*) as ct from matches where MATCH_WINNER = TOSS_WINNER group by STADIUM_ID) as t1,
(select STADIUM_ID, count(*) as ct from matches where MATCH_WINNER != TOSS_WINNER group by STADIUM_ID) as t2,
IPL_STADIUM as t3
where t1.STADIUM_ID = t2.STADIUM_ID and t2.STADIUM_ID = t3.STADIUM_ID;

# Q4
select BIDDER_ID, count(*) over(partition by BIDDER_ID) as total, BID_TEAM, TEAM_NAME
from IPL_BIDDING_DETAILS left join IPL_TEAM on IPL_BIDDING_DETAILS.BID_TEAM = IPL_TEAM.TEAM_ID order by total desc;

# Q6

-- total matches played
select teams, count(*) as total
from
(select TEAM_ID1 as teams from IPL_MATCH
union all
select TEAM_ID2 from IPL_MATCH) t
group by teams;

-- total matches won
select if(MATCH_WINNER=1,TEAM_ID1, TEAM_ID2) as teams, count(*) as total from IPL_MATCH group by teams order by teams;
-- total matches lost
select if(MATCH_WINNER=1,TEAM_ID2, TEAM_ID1) as teams, count(*) as total from IPL_MATCH group by teams order by teams;
-- team name
select TEAM_NAME from IPL_TEAM;


-- final
with mt as (
select t2.TEAM_NAME,
       if(t1.MATCH_WINNER=1, TEAM_ID1, TEAM_ID2) as win,
       if(t1.MATCH_WINNER=1, TEAM_ID2, TEAM_ID1) as lost
from IPL_TEAM as t2 inner join IPL_MATCH as t1
on t2.TEAM_ID = if(t1.MATCH_WINNER=1, TEAM_ID1, TEAM_ID2))

select TEAM_NAME, count(win) over w, count(lost) over w, count(*) over() as total
from mt
group by team_name
window w as (partiton by win order by win);

select win, count(win) over(partition by win order by win) as won_total,
       lost, count(lost) over(partition by lost order by lost) as lost_total
from (select if(MATCH_WINNER=1, TEAM_ID1, TEAM_ID2) as win,
       if(MATCH_WINNER=1, TEAM_ID2, TEAM_ID1) as lost
from IPL_MATCH) as t;

# Q7
-- approach 1 : IPL_TEAM.TEAM_ID like 'Mumbai Indians' = IPL_TEAM_PLAYERS.TEAM_ID and fetching those IPL_TEAM_PLAYERS.player_id = IPL_PLAYER.player_id
select PLAYER_NAME, PERFORMANCE_DTLS from IPL_PLAYER where PLAYER_ID in
(select PLAYER_ID from IPL_TEAM_PLAYERS
where TEAM_ID = (select TEAM_ID from IPL_TEAM where TEAM_NAME like '%Mumbai Indians%')
and PLAYER_ROLE like '%Bowler%');

-- approach 2 : IPL_TEAM_PLAYERS.REMARKS = 'MI' and fetching those IPL_TEAM_PLAYERS.player_id = IPL_PLAYER.player_id
select PLAYER_NAME, PERFORMANCE_DTLS from IPL_PLAYER
where PLAYER_ID in
(select PLAYER_ID from IPL_TEAM_PLAYERS where REMARKS like '%MI%' and PLAYER_ROLE like '%Bowler%');
*/