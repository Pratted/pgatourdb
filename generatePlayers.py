import os
import glob
import json

file = open('all-players.json')
out = open("script_generated\\player_inserts.sql", 'w')
data = json.load(file)

num_players = len(data["players"])

for i in range(0, num_players):
	player_id = data["players"][i]["pid"]
	player_ln = str(data["players"][i]["last_name"])
	player_fn = str(data["players"][i]["first_name"])
	player_country = str(data["players"][i]["country"])
	player_city = str(data["players"][i]["birthcity"])
	
	player_ln = player_ln.replace('\'', '') #remove all single quotes from last name, (i.e. O'Hair)
	
	out.write("insert into player values(" + player_id + ",'" + player_ln + "','" + player_fn + "','" + player_city + "','" + player_country + "');\n")
	out.write("insert into statistic values(" + player_id + ",0,0,0,0,0,0,0,0,0,0,0,0,0,0);\n")

file.close()
out.close()