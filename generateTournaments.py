import os
import glob
import json

tournamentInserts = open("script_generated\\tournamentInserts.sql", 'w')

file = open('schedule.json')
data = json.load(file)

num_tournament = len(data["schedule"])

for i in range(0, num_tournament):
	tournament_id = str(data["schedule"][i]["tournament_id"])
	location = str(data["schedule"][i]["location"])
	name = str(data["schedule"][i]["tournament"])
	prev_winner = str(data["schedule"][i]["defending_champions"][0]["name"])
	start_date = str(data["schedule"][i]["start_date"])
	end_date = str(data["schedule"][i]["end_date"])

	tournamentInserts.write("insert into tournament (tournament_id, name, location, start_date, end_date, prev_winner) values('"
	+ tournament_id + "','" + name + "','" + location + "',TO_DATE('" + start_date + "', 'yyyy/mm/dd'),TO_DATE('" + end_date + "','yyyy/mm/dd'),'" + prev_winner + "');\n")
