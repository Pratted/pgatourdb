import os
import glob
import json

out = open("script_generated\\course_insert.sql", 'w')

def loadCourseAndHoles(file, tournament_id):
	data = json.load(file)

	course_id = str(data["courses"][0]["course_id"])
	course_name = str(data["courses"][0]["course_name"])
	
	total_length = 0
	course_par = 0
	
	out.write("\ninsert into course (course_id, tournament_id, course_name) values(" + course_id + ",'" + tournament_id + "','" + course_name + "');\n\n")
	
	for i in range(0, 18):
		hole_num = str(data["courses"][0]["holes"][i]["hole"])
		hole_par = int(data["courses"][0]["holes"][i]["par"])
		hole_length = int(data["courses"][0]["holes"][i]["distance"])
		total_length += hole_length
		course_par += hole_par
	
		out.write("insert into hole (hole_num, course_id, hole_par, hole_length) values(" + hole_num + "," + course_id + "," + str(hole_par) + "," + str(hole_length) + ");\n")
		
	out.write("update course set length = " + str(total_length) + ", par = " + str(course_par) + " where course_id = " + course_id + ";\n")
		

for dir in glob.glob('*/'):
	if(str(dir) != "script_generated\\"):
		file = open(dir + "course.json", 'r')
		tournament_id = str(dir.replace("\\", ''))
		
		loadCourseAndHoles(file, tournament_id)
		file.close()

out.close()