# PGA Tour Database
## Background

This database is a mock-up database for school that I worked on. It contains real data courtesy of http://www.pgatour.com/data/repo/, however as of 4/21/17 this URL appears to have been changed to forbidden. In order to design it, I took data from the PGA Tour's repository and transformed it into several thousand insert statements that could be inserted into my database. The majority of the data I was looking for was stored in json objects. Consequently, I wrote several python scripts to parse them and push the data into insert statements. 

## Inserting the Data
Each of the folders in this main directory with format 'r###' refer to specific tournaments and contain all of the information pertaining to them. The majority of the tournament information consists of player scorecards found in the scorecards directory.  The python scripts parse these sub directories and generate insert statements based off of specific information. 

Below is an example of json scorecard transformed into an insert statement:

##### `01320.json`

```json
"scorecard": [{
		"round": "1",
		"total": "76",
		"course_id": "538",
		"in": "37",
		"out": "39",
		"current_hole": "",
		"holes": [{
			"par": "4",
			"hole": "1",
			"strokes": "4",
			"to_par": "E",
			"round_to_par": "E"
		}, {
			"par": "4",
			"hole": "2",
			"strokes": "4",
			"to_par": "E", ...
```

is transformed into: 
```sql
insert into player_hole_score values(01320,538,1,1,4);
insert into player_hole_score values(01320,538,2,1,4);
```

Likewise:

##### `allplayers.json`

```json
		"pid": "20098",
		"first_name": "Stuart",
		"last_name": "Appleby",
		"birthplace": "Cohuna, Australia",
		"birthcity": "Cohuna",
		"country": "AUS",
		"primary": "r",
```

into: 

```sql
insert into player values(20098,'Appleby','Stuart','Cohuna','AUS');
```
Needless to say, all of the inserts could have been done through the CLI, but I opted to output the insert statements instead in order to follow project guidelines.  
