import json
import glob
import os

player_results = open("script_generated\\player_results.sql", 'w')
fieldInserts = open("script_generated\\fieldInserts.sql", 'w')

def readLeaderBoard(leaderboard, tournament_id):
	file = open(leaderboard)
	data = json.load(file)
	
	num_players = len(data["years"][0]["tours"][0]["trns"][0]["plrs"])
	
	for i in range(0, num_players):
		position = str(data["years"][0]["tours"][0]["trns"][0]["plrs"][i]["finPos"]["finPosValue"])
		pid = data["years"][0]["tours"][0]["trns"][0]["plrs"][i]["plrNum"]
		course_id = data["years"][0]["tours"][0]["trns"][0]["courses"][0]["courseNum"]
		score = data["years"][0]["tours"][0]["trns"][0]["plrs"][i]["relParScrTot"]
		money = str(data["years"][0]["tours"][0]["trns"][0]["plrs"][i]["money"])
		fedex_pt = str(data["years"][0]["tours"][0]["trns"][0]["plrs"][i]["EventFedExPoints"])
		
		
		money = money.replace(',','')
		money = money.replace('-', '0')
		money = money.replace(".**", '')
		
		if(money == ""):
			money = "0"
		
		if(fedex_pt == ""):
			fedex_pt = "0"
		
		player_results.write("insert into field values(" + str(pid) + ", '" + str(tournament_id) + "', '" + str(score) + "','" + str(position) + "'," + str(money) + "," + str(fedex_pt) + ");\n") 

	
def readTournaments():
	for dir in glob.glob('*/'):
		if(str(dir) != "script_generated\\"):
			player_results.write("-- NEW TOURNAMENT\n\n\n")
		
			tournament_id = dir.replace("\\", '')
			
			readLeaderBoard(str(dir) + "tournsum.json", tournament_id)

		

readTournaments()

fieldInserts.close()
player_results.close()