/***********************************************************
Counts the number of eagles, birdies, pars, etc. on each 
hole and updates the corresponding attribute in table Hole
We skip course_id 733 because it has invalid data.
************************************************************/


--Albatross
merge into hole
  using 
  (select phs.course_id, phs.hole_num, count(*) as ct from player_hole_score phs
    join hole h on 
      phs.hole_num = h.hole_num and
      phs.course_id = h.course_id
      where phs.score = h.hole_par - 3
      group by phs.hole_num, phs.course_id
      order by phs.course_id, phs.hole_num)
  q
  on (hole.course_id = q.course_id and hole.hole_num = q.hole_num)
  when matched 
    then update set hole.hole_num_alba = q.ct
    where course_id != 733;

--Eagles
merge into hole
  using 
  (select phs.course_id, phs.hole_num, count(*) as ct from player_hole_score phs
    join hole h on 
      phs.hole_num = h.hole_num and
      phs.course_id = h.course_id
      where phs.score = h.hole_par - 2
      group by phs.hole_num, phs.course_id
      order by phs.course_id, phs.hole_num)
  q
  on (hole.course_id = q.course_id and hole.hole_num = q.hole_num)
  when matched 
    then update set hole.hole_num_eagle = q.ct
    where course_id != 733;

--Birdies
merge into hole
  using 
  (select phs.course_id, phs.hole_num, count(*) as ct from player_hole_score phs
    join hole h on 
      phs.hole_num = h.hole_num and
      phs.course_id = h.course_id
      where phs.score = h.hole_par - 1
      group by phs.hole_num, phs.course_id
      order by phs.course_id, phs.hole_num)
  q
  on (hole.course_id = q.course_id and hole.hole_num = q.hole_num)
  when matched 
    then update set hole.hole_num_birdie = q.ct
    where course_id != 733;
 
--Pars
merge into hole
  using 
  (select phs.course_id, phs.hole_num, count(*) as ct from player_hole_score phs
    join hole h on 
      phs.hole_num = h.hole_num and
      phs.course_id = h.course_id
      where phs.score = h.hole_par
      group by phs.hole_num, phs.course_id
      order by phs.course_id, phs.hole_num)
  q
  on (hole.course_id = q.course_id and hole.hole_num = q.hole_num)
  when matched 
    then update set hole.hole_num_par = q.ct
    where course_id != 733;
	
--Bogeys
merge into hole
  using 
  (select phs.course_id, phs.hole_num, count(*) as ct from player_hole_score phs
    join hole h on 
      phs.hole_num = h.hole_num and
      phs.course_id = h.course_id
      where phs.score = h.hole_par + 1
      group by phs.hole_num, phs.course_id
      order by phs.course_id, phs.hole_num)
  q
  on (hole.course_id = q.course_id and hole.hole_num = q.hole_num)
  when matched 
    then update set hole.hole_num_bogey = q.ct
    where course_id != 733;
  
--Double Bogeys
merge into hole
  using 
  (select phs.course_id, phs.hole_num, count(*) as ct from player_hole_score phs
    join hole h on 
      phs.hole_num = h.hole_num and
      phs.course_id = h.course_id
      where phs.score = h.hole_par + 2
      group by phs.hole_num, phs.course_id
      order by phs.course_id, phs.hole_num)
  q
  on (hole.course_id = q.course_id and hole.hole_num = q.hole_num)
  when matched 
    then update set hole.hole_num_dbl_bogey = q.ct
    where course_id != 733;
	
--Double Bogeys or worse
merge into hole
  using 
  (select phs.course_id, phs.hole_num, count(*) as ct from player_hole_score phs
    join hole h on 
      phs.hole_num = h.hole_num and
      phs.course_id = h.course_id
      where phs.score > h.hole_par + 2
      group by phs.hole_num, phs.course_id
      order by phs.course_id, phs.hole_num)
  q
  on (hole.course_id = q.course_id and hole.hole_num = q.hole_num)
  when matched 
    then update set hole.hole_num_dbl_or_worse = q.ct
    where course_id != 733;
	
	
commit;

select h.hole_num, h.hole_par,

  (select score from player_hole_score phs
  where phs.hole_num = h.hole_num
  and phs.course_id = h.course_id
  and phs.round_id = 1
  and phs.player_id = 12716) "Round 1",
  
  (select score from player_hole_score phs
  where phs.hole_num = h.hole_num
  and phs.course_id = h.course_id
  and phs.round_id = 2
  and phs.player_id = 12716) "Round 2",
  
  (select score from player_hole_score phs
  where phs.hole_num = h.hole_num
  and phs.course_id = h.course_id
  and phs.round_id = 3
  and phs.player_id = 12716) "Round 3",
  
  (select score from player_hole_score phs
  where phs.hole_num = h.hole_num
  and phs.course_id = h.course_id
  and phs.round_id = 4
  and phs.player_id = 12716) "Round 4"
  
  from hole h  
  where course_id = 538; --(select course_id from course where tournament_id = 'r060');



