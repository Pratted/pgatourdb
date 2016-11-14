/**************************************************************
This package creates a view of Player Statistics. It includes:
	-tournaments played
	-earnings
	-scoring average
	-low round
	-number of wins
	-number of 2nd place
	-number of 3rd place
	-number of top 5
	-number of top 10
	-number of cuts made
	-number of cuts missed

***************************************************************/

create view player_statistic as
	select 
		player_id,
		sum(player_tournament_fedex_pt) as fedex_pts,
		
		--fedex pt across all tournament
		count(*) as tournaments_played,
		
		--Total earnings from all tournaments
			(select sum(player_tournament_earnings) from field f
				where f.player_id = ff.player_id)
		as earnings,

		--Scoring Average across all tournaments
			(select round(sum(sum(score) / (count(*) / 18)) / count(*), 3) from player_hole_score phs
				where player_id = ff.player_id
        group by phs.course_id)
		as scoring_avg,
			(select min(sum(score)) from player_hole_score phs
				where player_id = ff.player_id
				group by phs.course_id, round_id)
		as low_round,
    
		--number of 1st place finishes
			(select count(*) from field f
				where 
					--Regular Expression to find valid tournament position (i.e No MC or WD)
					REGEXP_LIKE(player_tournament_pos, 'T?[0-9]+') and
					
					--remove the T from position in case of tie. (i.e. T3 place)
					(to_number(replace(f.player_tournament_pos, 'T', ''), '99') = 1) and 
					f.player_id = ff.player_id)
		as wins,
			(select count(*) from field f
				where 
					REGEXP_LIKE(player_tournament_pos, 'T?[0-9]+') and
					(to_number(replace(f.player_tournament_pos, 'T', ''), '99') = 2) and 
					f.player_id = ff.player_id)
		as seconds,
			(select count(*) from field f
				where 
					REGEXP_LIKE(player_tournament_pos, 'T?[0-9]+') and
					(to_number(replace(f.player_tournament_pos, 'T', ''), '99') = 3) and 
					f.player_id = ff.player_id)
		as thirds,
			(select count(*) from field f
				where 
					REGEXP_LIKE(player_tournament_pos, 'T?[0-9]+') and
					(to_number(replace(f.player_tournament_pos, 'T', ''), '99') <= 5) and 
					f.player_id = ff.player_id)
		as num_top_5,
			(select count(*) from field f
				where 
					REGEXP_LIKE(player_tournament_pos, 'T?[0-9]+') and
					(to_number(replace(f.player_tournament_pos, 'T', ''), '99') <= 10) and 
					f.player_id = ff.player_id)
		as num_top_10,
			(select count(*) from field f
				where 
					REGEXP_LIKE(player_tournament_pos, 'T?[0-9]+') and
					f.player_id = ff.player_id)
		as cuts_made,
			(select count(*) from field f 
				where 
					(f.player_tournament_pos = 'CUT' or f.player_tournament_pos = 'MDF') and 
					f.player_id = ff.player_id)
		as cuts_missed,
		    (select count(*) from field f
				where 
					f.player_tournament_pos = 'W/D' and 
					f.player_id = ff.player_id)
		as wds
		
	from field ff		
	group by player_id;

