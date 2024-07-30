/*
   Project: Cricket Analysis

   This SQL script analyzes data from two datasets:
   - `matches`: Contains information about cricket matches, including match dates, venue, teams, umpires and results.
   - `deliveries`: Contains detailed ball-by-ball information for each match, including innings, overs, balls, runs_scored, wickets taken, and extras.

   The analysis aims to gain insights into team performance, player statistics, and match outcomes.
*/

-- Creating dataset for the project.

create database New_Project;

-- Setting New_Project dataset as default. 

Use New_Project;

/*
This table is created to import data from a CSV file into the 'matches' table.
The CSV file may contain null values and data in an incorrect format.
To accommodate this, the columns are initially defined as text data type.
After importing the data, we will format and adjust the data types as needed.
This approach allows us to import the data first and then perform necessary transformations.
*/

CREATE TABLE 
	matches (
		id text,
        city text,
        date text,
        player_of_match text,
        venue text,
        neutral_venue text,
        team1 text,
        team2 text,
        toss_winner text,
        toss_decision text,
        winner text,
        result text,
        result_margin text,
        eliminator text,
        method text,
        umpire1 text,
        umpire2 text
	);


/*
This table is created to import data from a CSV file into the 'deliveries' table.
The data in the CSV file does not contain null values and is correctly formatted.
Therefore, we can directly define the columns with appropriate data types.
This approach simplifies the import process and ensures data integrity from the outset.
*/
    
Create table deliveries (
	id int,
	inning int,
	`over` int, -- backtics use for reverse keywords
	ball int,
	batsman text,
	non_striker text,
	bowler text,
	batsman_runs int,
	extra_runs int,
	total_runs int,
	is_wicket int,
	dismissal_kind text,
	player_dismissed text,
	fielder text,
	extras_type text,
	batting_team text,
	bowling_team text
);


/*
Matches Table:
- The following SQL statement imports data from a CSV file into the 'matches' table.
- We use the LOAD DATA INFILE statement to efficiently load the data into the table.
- Special handling is required for null values and incorrectly formatted data.
- Initially, the columns are defined with a text data type to accommodate these issues.
- After importing the data, we will format and adjust the data types as needed.
*/

load data infile
	'C:/Users/Ahmad Humzah/OneDrive/Desktop/Projects for Portfolio/MySQL/IPL_matches.csv'
    
into table 
	matches
    
fields  terminated by ","          -- Specify delimiter in dataset

enclosed by '"'                    -- Specify the dataset enclosed by double qoutes

lines  terminated by "\n"          -- Specify line termination in dataset

ignore 1 lines                     -- Ignore first line of dataset(Header)

-- Specify temporary variable to store data:
(
	@id,
	@city,
	@date,
    @player_of_match,
    @venue,
    @neutral_venue,
    @team1,
    @team2,
    @toss_winner,
    @toss_decision,
    @winner,
    @result,
    @result_margin,
    @eliminator,
    @method,
    @umpire1,
    @umpire2
)

-- Set the empty value to null and assign to the table:
Set
	id = nullif(@id,''),
    city = nullif(@city,''),
    date = nullif(@date,''),
    player_of_match = nullif(@player_of_match,''),
    venue = nullif(@venue,''),
    neutral_venue = nullif(@neutral_venue,''),
    team1 = nullif(@team1,''),
    team2 = nullif(@team2,''),
    toss_winner = nullif(@toss_winner,''),
    toss_decision = nullif(@toss_decision,''),
    winner = nullif(@winner,''),
    result = nullif(@result,''),
    result_margin = nullif(@result_margin,''),
    eliminator = nullif(@eliminator,''),
    method = nullif(@method,''),
    umpire1 = nullif(@umpire1,''),
    umpire2 = nullif(@umpire2,'');
    
-- The following query will show first 100 rows of the table in results.
select * from matches
limit 100;

-- Following Query will adjust the data type.

Alter Table
	matches
modify column id int,
modify column neutral_venue int,
modify column result_margin int;

-- Following query will update the specifier and then adjust the data type of date column
UPDATE matches
SET date = STR_TO_DATE(date, '%d-%m-%Y');

Alter Table
	matches
modify column date date;  


/*
Deliveries Table:
- Similarly, the following SQL statement imports data from a CSV file into the 'deliveries' table.
- Unlike the 'matches' table, the data in the 'deliveries' CSV file does not contain null values 
  and is correctly formatted. Therefore, we can directly define the columns with appropriate data types.
- This simplifies the import process and ensures data integrity from the outset.
*/

load data infile
	'C:/Users/Ahmad Humzah/OneDrive/Desktop/Projects for Portfolio/MySQL/IPL_Ball.csv'

into table 
	deliveries
    
fields  terminated by ","          -- Specify delimiter in dataset

enclosed by '"'                    -- Specify the dataset enclosed by double qoutes

lines  terminated by "\n"          -- Specify line termination in dataset

ignore 1 lines;                    -- Ignore first line of dataset(Header)



-- The following query will show first 100 rows of the table in results.
select * from deliveries
limit 100;


-- The query will show all the rows where there is blank clolumn.

select * from matches
where
	id is null or
	city is null or
	date is null or
    player_of_match is null or
    venue is null or
    neutral_venue is null or
    team1 is null or
    team2 is null or
    toss_winner is null or
    toss_decision  is null or
    winner  is null or
    result is null or
    result_margin is null or
    eliminator is null or
    method is null or
    umpire1 is null or
    umpire2 is null
;

-- This query will give the count of the rows where there us null column.

select count(*) from matches
where
	id is null or
	city is null or
	date is null or
    player_of_match is null or
    venue is null or
    neutral_venue is null or
    team1 is null or
    team2 is null or
    toss_winner is null or
    toss_decision  is null or
    winner  is null or
    result is null or
    result_margin is null or
    eliminator is null or
    method is null or
    umpire1 is null or
    umpire2 is null
;

-- This query will replace all the null value with 0.

update 
	matches
set 
	result_margin = 0
where 
	result_margin is null;
    
    
-- Select top 20 rows after ordering the deliveries table by id,inning, over, ball in ascending order.

Select *
From
	(Select * From
		deliveries
	order by
		id, inning, `over`, ball) as sorted_table
Limit 20;

-- Select top 20 rows of matches coloumn.

Select *
From
	matches
Limit 20;

-- Fetch data of matches played on 2nd May 2013 from matches table.
select *
From
	matches
where
	date = '2013-05-02';

-- Fetch data where result = 'runs' and result_margin > 100
select *
from
	matches
where
	result = 'runs' and
    result_margin > 100
order by
	result_margin;
    

-- Fetch data where result is tie and sort by date column in descending order
select *
from
	matches
where
	result = 'tie'
order by
	date desc;
    
-- Count of the cities that hosted an IPL match
select count(distinct city) as Num_cities_hosted_IPL
from
	matches;

/*
- Create table deliveries_v02 from deliveries with all the column same as deliveries and a new col ball_result.
- ball_result contain values 'boundry','dot' and 'other' depending on total_runs col.
- Condition:
	- when total_runs > 4 then boundary
    - total_runs = 0 then dot
    - total_runs = any other number then other
*/

create table deliveries_v02 as
select *,
	case                                            -- case statement will help to add the condition in ball_result col
		when total_runs > 4 then 'boundary'
		when total_runs = 0 then 'dot'
		else 'other'
	end as ball_result
from
	deliveries;
    
-- Fetch total count of boundary and dot in ball_result col
select ball_result,count(ball_result)
from
	deliveries_v02
where
	ball_result in ('boundary','dot')
group by
	ball_result
order by
	ball_result;
    
-- Fetch the nymber of boundaries scored by each team
select 
	batting_team,
    count(ball_result) as num_of_boundaries
from
	deliveries_v02
where
	ball_result = 'boundary'
group by
	batting_team
order by 
	num_of_boundaries desc;
    
-- Fetch total number of dot balls
select
	bowling_team,
    count(ball_result) as num_of_dot_balls
from
	deliveries_v02
where
	ball_result = 'dot'
group by
	bowling_team
order by
	num_of_dot_balls desc;
    
-- Fetch total number of dismissal where dismissal_kind is not NA
select
	dismissal_kind,
    count(dismissal_kind) as Total_dismissal
from
	deliveries_v02
where
	dismissal_kind != 'NA'
group by
	dismissal_kind;
    
-- Fetch top 5 bowlers who conceded max extra run
Select 
	bowler,
    count(extra_runs) as total_num_extra_runs
from
	deliveries
group by
	bowler
order by
	total_num_extra_runs desc
limit 5;

/*
- Create table deliveries_v03 from deliveries_v02 with all the column same as deliveries_v02 and two new col venue and match_date.
- venue will contain the data from venue column of matches table and
- match_date will contain the data from date column of matches table.
*/

create table 
	deliveries_v03 as
select *
From
	(select d.*,
		m.venue,
		m.date as match_date
	from
		deliveries_v02 as d
	inner join
		matches m
	on
		d.id = m.id) as t
;

-- Fetch total runs scored in each venue

select
	venue,
    sum(total_runs) as total_runs_scored
from
	deliveries_v03
group by
	venue
order by
	total_runs_scored desc;
    
-- Fetch Year-wise total run scored at Eden Gardens
Select
	year(match_date) as `year`,
    sum(total_runs) as total_runs_scored
from
	deliveries_v03
where
	venue = 'Eden Gardens'
group by
	year(match_date)
order by
	total_runs_scored desc;

/*
This is the query to achieve following task:
	- Create a new table named 'matches_corrected' by copying the 'matches' table structure.
	- Update the 'team1_corr' and 'team2_corr' columns in the 'matches_corrected' table to replace occurrences of 'Rising Pune Supergiants' with 'Rising Pune Supergiant'.
	- Analyze the newly created columns 'team1_corr' and 'team2_corr'.
*/

-- Select unique team name
select distinct(team1) from matches;

-- Create table with the update coloumn
Create table 
	matches_corrected as
select *,
	replace(team1, 'Rising Pune Supergiants', 'Rising Pune Supergiant') AS team1_corr,
	replace(team2, 'Rising Pune Supergiants', 'Rising Pune Supergiant') AS team2_corr
from
	matches;

-- Analyzing team1_corr and team2_corr
    
select distinct(team1_corr) from matches_corrected;

select distinct(team2_corr) from matches_corrected;

/*
- Create a table deliveries_v04 from deliveries_v03.
- deliveries_v04 will contain the following rows:
	- First column is ball_id: a concatinated string ball_id containing information of match_id, inning, over and ball 
	  separated by ‘-’ (For ex. 335982-1-0-1 match_id-inning-over-ball)
	- Rest all columns from deliveries_v03
*/

create table
	deliveries_v04 as
select 
	concat_ws('-',id,inning,`over`,ball) as ball_id,
    batsman,
    non_striker,
    bowler,
    batsman_runs,
    extra_runs,
    total_runs,
    is_wicket,
    dismissal_kind,
    player_dismissed,
    fielder,
    extras_type,
    batting_team,
    bowling_team,
    ball_result,
    venue,
    match_date
From
	deliveries_v03;
    
-- Compare number of total rows with number of distinct ball_id.
Select
	count(*) as num_total_rows,
    count(distinct ball_id) as num_distinct_ball_id
from
	deliveries_v04;
    
/*
- Create deliveries_v05 table from deliveries_v04.
- Contains all the columns of deliveries_v04 and an adittional column with row numbers as r_num over ball_id.
*/

Create table
	deliveries_v05 as
Select *,
	row_number() over(partition by ball_id) as r_num
From 
	deliveries_v04;
    
-- Identify the intances where ball is repeating

select ball_id
from
	deliveries_v05
WHERE
	r_num=2;
    
-- Fetch data of the ball_id which is repeated by using subquerry methed
Select *
From
	deliveries_v05
Where
	ball_id in 
		(select 
			ball_id
		from 
			deliveries_v05 
		where 
			r_num = 2)
;