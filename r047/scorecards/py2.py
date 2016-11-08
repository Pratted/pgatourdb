import json
import glob, os
from pprint import pprint




#for i in range(0,18):
	#print data["scorecard"][0]["holes"][i]["strokes"] #round 2, holes 1-18
	#print "there are %d scorecards " % len(data["scorecard"])

	
dump = open('holeInserts.sql', 'w')

def readScoreCard(data, player_id):
	for i in range(0, len(data["scorecard"])):
		for j in range(0, 18):
			score = data["scorecard"][i]["holes"][j]["strokes"]
			course_id = data["scorecard"][i]["course_id"]
			
			dump.write('insert into player_hole_score values(' + str(player_id) + ',' + str(course_id) + ',' + str(j + 1) + ',' + str(i+1) + ',' + str(score) + ');\n')





for file in glob.glob("*.json"):
	with open(file) as json_file:
		data = json.load(json_file)
		player_id = str(file)
		player_id = player_id.replace('.json', '')
		
		readScoreCard(data, player_id)
		
		
	print(file)

	
		#print "Round: %d\nHole: %d\nPar: %s\nScore:%s\n\n" % (i+1, j+1, data["scorecard"][i]["holes"][j]["par"], data["scorecard"][i]["holes"][j]["strokes"])
		
	

	
dump.close()
print "Done\n";