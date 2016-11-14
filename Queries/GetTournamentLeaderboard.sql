select f.player_tournament_pos "Position", p.player_fn || ' ' || p.player_ln "Player", f.player_tournament_score "Score" from field f
	join player p on p.player_id = f.player_id
	where TOURNAMENT_ID = :tournament_id --uses bind to manually insert tournament_id
	order by to_number(replace(f.player_tournament_pos, 'T', ''), '99'); --hide the T to make ordering easier.