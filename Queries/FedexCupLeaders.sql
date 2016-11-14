/***********************************************************
Display the Fedex Cup Leaderboard
*************************************************************/

select rank() over (order by s.fedex_pt desc) "Position", p.player_fn || ' ' || p.player_ln "Player", s.fedex_pt "Fedex Cup Points" from player p
  join statistic s on p.player_id = s.player_id;