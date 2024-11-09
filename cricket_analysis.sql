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
    
    
-- Select top 20 rows of deliveries.

Select *
From 
	deliveries
Limit 20;

-- Select top 20 rows of matches coloumn.

Select *
From
	matches
Limit 20;

/*
 Player performances :
	- Average runs scored by each batsmen.
    - Average wicket taken by each bowlers.
    - Top 10 highest run-scoring batsmen.
    - Top 10 highest wicket-taking bowlers.
    - Batsmen strike rate.
    - Bowlers economy rate.
    - Centuries and half-centuries scored.
*/

-- Average runs scored by each batsmen.

select batsman, avg(batsman_runs) as avg_runs
from deliveries
group by batsman
order by avg_runs desc;


-- Average wicket taken by each bowlers.

select bowler, avg(is_wicket) as avg_wickets_taken
from deliveries
group by bowler
order by avg_wickets_taken desc;


-- Top 10 highest run-scoring batsmen.

select batsman, sum(total_runs) as total_run_scored
from deliveries
group by batsman
order by total_run_scored desc
limit 10;


-- Top 10 highest wicket-taking bowlers.

select bowler, count(is_wicket) as total_wickets_taken
from deliveries
where is_wicket = 1
group by bowler
order by total_wickets_taken desc
limit 10;


-- Batsmen strike rate.

select
	batsman,
    (sum(batsman_runs)/count(*)) * 100 as strike_rate
from deliveries
group by batsman
order by strike_rate desc;


-- Bowlers economy rate.

select
	bowler,
    (sum(total_runs)/count(*)) * 100 as economy_rate
from deliveries
group by bowler
order by economy_rate desc;


-- Centuries and half-centuries scored.

with batsman_runs_CTE as
	(
    select
		id,
        batsman,
        sum(batsman_runs) as runs_scored 
	from deliveries
	group by id, batsman
	order by sum(batsman_runs) desc
    )
select 
	batsman,
    (case when runs_scored >= 100 then 1 else 0 end) as centuries,
    (case when runs_scored >= 50 and runs_scored <100 then 1 else 0 end) as half_centuries
from batsman_runs_CTE
group by batsman
order by centuries desc, half_centuries desc;



/* 
Team Statistics :
	- Total run scored by each team.
		-> Per match
        -> Per season
    - Total wicket taken by each team.
		-> Per match
        -> Per season
    - Winning team and Margin of victory.
    - Man of the match.
    - Win / Loss ratio for each team
*/

-- Total run scored by each team:
	-- Per Match

	select 
		id, 
		batting_team, 
		sum(total_runs) as total_runs
	from deliveries
	group by id, batting_team
	order by id, batting_team;

	--  Per Season

	select 
		m.id,
		year(m.date) as sesion,
        d.batting_team,
        sum(d.batsman_runs) as runs_scored
	from matches m
    join deliveries d
    on m.id = d.id
    group by m.id, year(m.date), d.batting_team
    order by year(m.date);
    

-- Total wickets taken by each team.
	-- Per Match

	select 
		id, 
        bowling_team, 
        count(is_wicket) as total_wickets
	from deliveries
	where is_wicket = 1
	group by id,bowling_team
	order by id, bowling_team;
    
    -- Per Season
    
    select 
		m.id,
		year(m.date) as sesion,
        d.bowling_team,
        count(is_wicket) as wickets_taken
	from matches m
    join deliveries d
    on m.id = d.id
    where is_wicket = 1
    group by m.id, year(m.date), d.bowling_team
    order by year(m.date);


-- Winning team and Margin of victory.

select 
	id,
	winner,
    result,
    result_margin
from matches
order by id;


-- Man of the match.

select 
	id as match_id,
    player_of_match
from matches
order by id;


-- Win / Loss ratio for each team

with total_wins as (
select 
	team,
	sum(win) as count_of_win
from (
	select team1 as team,count(team1_win) as win
	from
		(select 
			team1, 
            team2,
            winner,
			(case when team1 = winner then 1 else 0 end) as team1_win,
			(case when team2 = winner then 1 else 0 end) as team2_win
		from 
			matches
		) team_win
	where 
		team1_win = 1
	group by team1
	union all
	select team2 as team,count(team2_win) as win
	from (
		select 
			team1, 
            team2,
            winner,
			(case when team1 = winner then 1 else 0 end) as team1_win,
			(case when team2 = winner then 1 else 0 end) as team2_win
		from 
			matches
		) team_win
		where 
			team1_win = 1
		group by team2) win_table
group by team),

total_lose as (
select team, sum(lose) as count_of_lose
from(
select team1 as team,count(team1_win) as lose
from
(select 
	team1, team2,winner,
	case when team1 = winner then 1 else 0 end as team1_win,
    case when team2 = winner then 1 else 0 end as team2_win
from matches) team_win
where 
	team1_win = 0
group by team1
union all
select team2 as team,count(team2_win) as lose
from
(select 
	team1, team2,winner,
	case when team1 = winner then 1 else 0 end as team1_win,
    case when team2 = winner then 1 else 0 end as team2_win
from matches) team_win
where 
	team1_win = 0
group by team2) lose_table

group by team)

select tw.team,round((tw.count_of_win/tl.count_of_lose),2) as ratio
from total_wins as tw
join total_lose as tl
on tw.team = tl.team
order by ratio desc;


/*
Venue Analysis
	- Matches win/lose by each team at different venues.
    - Average score at each venues.
    - Best perfomance venue for each team.
    - Worst performance venue for each team.
*/

-- Total number of matches at each venues:

select venue, count(*) as number_match_played_at_each_venue
from matches 
group by venue
order by count(*) desc;

-- Matches win/lose by each team at different venues:

SELECT venue, team, 
       SUM(CASE WHEN winner = team THEN 1 ELSE 0 END) AS matches_won,
       SUM(CASE WHEN winner != team THEN 1 ELSE 0 END) AS matches_lost
FROM (
    SELECT venue, team1 AS team, winner FROM matches
    UNION ALL
    SELECT venue, team2 AS team, winner FROM matches
) AS venue_results
GROUP BY venue, team
ORDER BY venue, matches_won DESC;

-- Average score at each venue:

Select m.venue, avg(d.total_runs) as average_runs
from matches m
join deliveries d
on m.id = d.id
group by venue
order by average_runs desc;

-- Average score of each team at different venues:

Select m.venue, batting_team, avg(d.total_runs) as average_runs
from matches m
join deliveries d
on m.id = d.id
group by venue, batting_team
order by venue, average_runs;

-- Best perfomance venue for each team:

with avg_table as (
select 
	m.venue, 
    d.batting_team, 
    avg(d.total_runs) as avg_runs,
	rank() over( partition by venue order by avg(d.total_runs) desc) as rank_num
from matches m
join deliveries d
on m.id = d.id
group by m.venue, d.batting_team
order by m.venue,avg_runs desc)
select venue, batting_team, avg_runs
from avg_table
where rank_num = 1;

-- Worst performance venue for each team.

with avg_table as (
select 
	m.venue, 
    d.batting_team, 
    avg(d.total_runs) as avg_runs,
	rank() over( partition by venue order by avg(d.total_runs) asc) as rank_num
from matches m
join deliveries d
on m.id = d.id
group by m.venue, d.batting_team
order by m.venue,avg_runs desc)
select venue, batting_team, avg_runs
from avg_table
where rank_num = 1;


/*
Season Performance
	- Comparison of team per
*/

/*
Partnership
*/

/*
Extras
*/

/*
Toss Analysis
*/
