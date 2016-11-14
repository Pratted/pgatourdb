/**************************************************************
This package creates a view of the calculated hole statistics.
***************************************************************/
  
create or replace view hole_statistic as
	select 
		h.course_id,
		h.hole_num,
		h.hole_length,
		h.hole_par,
		
		--Count the number of albatross (-3)
			NVL((select count(*) from player_hole_score phs
				where
					h.course_id = phs.course_id and
					h.hole_num = phs.hole_num
					and phs.score = h.hole_par - 3
					group by h.course_id, h.hole_num), 0) -- NVL(count(*),0) replaces null counts with 0
		as hole_num_alba,
		
		--Count the number of eagle (-2)
			NVL((select count(*) from player_hole_score phs
				where
					h.course_id = phs.course_id and
					h.hole_num = phs.hole_num
					and phs.score = h.hole_par - 2
					group by h.course_id, h.hole_num), 0)
		as hole_num_eagle,
		
		--Count the number of birdie (-1)
			NVL((select count(*) from player_hole_score phs
				where
					h.course_id = phs.course_id and
					h.hole_num = phs.hole_num
					and phs.score = h.hole_par - 1
					group by h.course_id, h.hole_num), 0) 
		as hole_num_birdie,
			NVL((select count(*) from player_hole_score phs
				where
					h.course_id = phs.course_id and
					h.hole_num = phs.hole_num
					and phs.score = h.hole_par
					group by h.course_id, h.hole_num), 0) 
		as hole_num_par,
			NVL((select count(*) from player_hole_score phs
				where
					h.course_id = phs.course_id and
					h.hole_num = phs.hole_num
					and phs.score = h.hole_par + 1
					group by h.course_id, h.hole_num), 0) 
		as hole_num_bogey,
			NVL((select count(*) from player_hole_score phs
				where
					h.course_id = phs.course_id and
					h.hole_num = phs.hole_num
					and phs.score = h.hole_par + 2
					group by h.course_id, h.hole_num), 0) 
		as hole_num_dbl_bogey,
			NVL((select count(*) from player_hole_score phs
				where
					h.course_id = phs.course_id and
					h.hole_num = phs.hole_num
					and phs.score > h.hole_par + 2
					group by h.course_id, h.hole_num), 0) 
		as hole_num_trp_or_worse,
		
		--Find the hole's average score. Use total strokes / times played
			round((select sum(phs.score) / count(phs.score) as avg_score from player_hole_score phs
				where 
					phs.hole_num = h.hole_num and
					phs.course_id = h.course_id
					group by h.hole_num, h.course_id), 3) -- round to 3 digits
		as hole_avg_score,
		
		--Find the stroke differential. Used to rank hole difficulty
			hole_avg_score - h.hole_par 
		as hole_stroke_diff
from hole h;