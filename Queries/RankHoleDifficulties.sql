/*************************************************************
Find the most difficult holes on a given course.
Holes ranked by degree of difficulty (i.e strokes over par)
*************************************************************/

select rank() over ( order by hole_stroke_diff desc) "Rank" ,hole_num "Hole", hole_stroke_diff "Stroke Differential", hole_par "Par" from hole_statistic
where course_id = 538;