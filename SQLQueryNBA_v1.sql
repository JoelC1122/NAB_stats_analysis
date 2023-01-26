--view data
SELECT TOP 10*
FROM NBA_Data.dbo.games$

SELECT TOP 10*
FROM NBA_Data.dbo.game_details$

SELECT TOP 10*
FROM NBA_Data.dbo.players$

SELECT TOP 10*
FROM NBA_Data.dbo.teams$

SELECT TOP 10*
FROM NBA_Data.dbo.ranking$

--what is the date range for our data? 2003 to 2022
SELECT MAX(STANDINGSDATE) as 'max_date', MIN(STANDINGSDATE) as 'min_date'
FROM NBA_Data.dbo.ranking$



--Create a sample of team stats over the past 10 seasons (2012 - 2022) to identify which stats is most important for a winning basketball team.
--Reformat data to get a table that shows each teams stats over the 10 season period.
--Seperate home team data.
With Home AS (
	SELECT 
		CONCAT(t.NICKNAME, g.SEASON) as TEAM,
		g.SEASON,
		COUNT(TEAM_ID_home) as total_games,
		SUM(HOME_TEAM_WINS)as H_wins,
		SUM(HOME_TEAM_WINS)/COUNT(TEAM_ID_home) as H_win_PCT,
		AVG(FG_PCT_home) as H_avg_fg_PCT,
		AVG(FT_PCT_home) as H_avg_ft_PCT,
		AVG(FG3_PCT_home) as H_avg_fg3_PCT,
		AVG(AST_home) as H_avg_AST,
		AVG(REB_home) as H_avg_REB,
		AVG(PTS_home) as H_avg_PTS
	FROM NBA_Data.dbo.games$ g
	JOIN NBA_Data.dbo.teams$ t on g.HOME_TEAM_ID = t.TEAM_ID
	WHERE SEASON >=2012 AND SEASON < 2022
	GROUP BY NICKNAME, TEAM_ID, SEASON
	),

	--Seperate Away teams data
	Away AS (
	SELECT 
		CONCAT(t.NICKNAME, g.SEASON) as TEAM,
		g.SEASON,
		COUNT(TEAM_ID_away) as total_games,
		COUNT(TEAM_ID_away) - SUM(HOME_TEAM_WINS)as A_wins,
		(COUNT(TEAM_ID_away) - SUM(HOME_TEAM_WINS))/COUNT(TEAM_ID_away) as A_win_PCT,
		AVG(FG_PCT_away) as A_avg_fg_PCT,
		AVG(FT_PCT_away) as A_avg_ft_PCT,
		AVG(FG3_PCT_away) as A_avg_fg3_PCT,
		AVG(AST_away) as A_avg_AST,
		AVG(REB_away) as A_avg_REB,
		AVG(PTS_away) as A_avg_PTS
	FROM NBA_Data.dbo.games$ g
	JOIN NBA_Data.dbo.teams$ t on g.TEAM_ID_away = t.TEAM_ID
	WHERE SEASON >=2012 AND SEASON < 2022
	GROUP BY NICKNAME, TEAM_ID, SEASON
	),

	--Combine home and away team tabble
	H_A as(
	SELECT 
		H.TEAM,
		H.SEASON,
		H.total_games + A.total_games as total_games,
		H.H_wins + A.A_wins as total_wins,
		(H.H_wins + A.A_wins)/(H.total_games + A.total_games) as win_PCT,
		H.H_avg_fg_PCT/2 + A.A_avg_fg_PCT/2 as avg_FG,
		H.H_avg_fg3_PCT/2 + A.A_avg_fg3_PCT/2 as avg_FG3,
		H.H_avg_ft_PCT/2 + A.A_avg_ft_PCT/2 as avg_FT,
		H.H_avg_AST/2 + A.A_avg_AST/2 as avg_AST,
		H.H_avg_PTS/2 + A.A_avg_PTS/2 as avg_PTS,
		H.H_avg_REB/2 + A.A_avg_REB/2 as avg_REB
	FROM Home H
	JOIN Away A on H.TEAM = A.TEAM
	)

--Create scoring system to identify and easily compare which teams have the strongest stats
	SELECT*,
		NTILE(100) OVER (ORDER BY avg_FG) as rate_fg,
		NTILE(100) OVER (ORDER BY avg_FT) as rate_ft,
		NTILE(100) OVER (ORDER BY avg_FG3) as rate_fg3,
		NTILE(100) OVER (ORDER BY avg_AST) as rate_AST,
		NTILE(100) OVER (ORDER BY avg_REB) as rate_REB,
		NTILE(100) OVER (ORDER BY avg_PTS) as rate_PTS
	FROM H_A
	--WHERE win_PCT > 0.7
	ORDER BY win_PCT DESC