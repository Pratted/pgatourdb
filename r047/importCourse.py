import os
import glob
import json

file = open('course.json')
out = open('course_insert.sql', 'w')

data = json.load(file)

course_id = str(data["courses"][0]["course_id"])
course_name = str(data["courses"][0]["course_name"])

total_length = 0
course_par = 0

for i in range(0, 18):
	hole_num = str(data["courses"][0]["holes"][i]["hole"])
	hole_par = int(data["courses"][0]["holes"][i]["par"])
	hole_length = int(data["courses"][0]["holes"][i]["distance"])
	total_length += hole_length
	course_par += hole_par

	out.write("insert into hole (hole_num, course_id, hole_par, hole_length) values(" + hole_num + "," + course_id + "," + str(hole_par) + "," + str(hole_length) + ");\n")
	
out.write("\ninsert into course (course_id, course_name, par, length) values(" + course_id + ",'" + course_name +  "',"+ str(course_par) + "," + str(total_length) + ");\n\n")