import cx_Oracle
import getpass
from pprint import pprint

ip = '209.50.138.132'
port = 1521
SID = 'oracle'
user_id = raw_input("Username: ")
password = getpass.getpass("Password: ")

dsn_tns = cx_Oracle.makedsn(ip, port, SID)

con = cx_Oracle.connect(user_id, password, dsn_tns)
curs = con.cursor()

score_types = {-3: 'alba', -2: 'eagle', -1: 'birdie', 0: 'par', 1: 'bogey', 2: 'dbl_bogey', 3: 'dbl_or_worse'}

def getCourseIDs():
	curs.execute('select count(*) from course')
	
	rows = curs.fetchone()[0]

	print 'There are %s rows' % rows
	course_ids = []	
	i = 0
	
	curs.execute('select course_id from course')
	
	while i < rows: 
		course_id = curs.fetchone()
		course_ids.append(course_id[0])
		i = i + 1
	
	for id in course_ids:
		print id
		
	return course_ids
	

def updateHoleInfo(course_id):
	for i in range(1,19): #holes 1 thru 18
		total_score = 0
		total_quantity = 0
		query = """select hole_par from hole where course_id = """ + str(course_id) + """ and hole_num = """ + str(i)
		
		curs.execute(query)
		hole_par = curs.fetchone()[0]
	
		for j in range(-3,4):#scores -3 to +3
			query = """
				select count (*) from player_hole_score phs
					join hole h on
					phs.course_id = h.course_id
					and phs.hole_num = h.hole_num
					where phs.course_id = """ + str(course_id) + """
					and phs.hole_num = """ + str(i) + """
					and phs.score = h.hole_par + """ + str(j)
					
			curs.execute(query)
			quantity = curs.fetchone()[0] #grabs 0 index of the first row
			total_quantity += quantity
			total_score += (quantity * (hole_par + j)) # running sum of total score for hole average score
			
			update = """update hole set hole_num_""" + str(score_types[j]) + """ = """ + str(quantity) + """
					where hole.course_id = """ + str(course_id) + """
					and hole.hole_num = """ + str(i)
			
			curs.execute(update)
			print "Hole %s has %s %s." % (str(i), str(quantity), score_types[j])
		
		avg = float(total_score) / float(total_quantity)
		r = round(avg, 4)
		
		query = "update hole set hole_avg_score = " + str(r) + " where hole.course_id = " + str(course_id) + " and hole.hole_num = " + str(i) 
		curs.execute(query)
		print "The average score for hole %d is: %f" % (i, r)
	
	curs.execute('commit')				

def main():
	print "In main\n"
	course_ids = getCourseIDs()
	
	for i in course_ids:
		if(i != 733):
			updateHoleInfo(i)

main()
		
con.close()