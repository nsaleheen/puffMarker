from sqlite3 import *
from struct import *
import os
from datetime import *
import string
import sys
import fnmatch

def process_buffers(data):
	newdata = []
	for record in data:
		b_timestamps = record[4]
		b_sample = record[5]
		onerecord_vals = []
		for i in xrange(0,len(b_timestamps),8):
			temp = b_timestamps[i:i+8]
			temp = temp[::-1]
			onerecord_vals.append([unpack('q',temp)[0],0])
		
		ind = 0
		for i in xrange(0,len(b_sample),4):
			temp = b_sample[i:i+4]
			temp = temp[::-1]
			onerecord_vals[ind][1] = unpack('l',temp)[0]
			ind += 1
		
		newdata.extend(onerecord_vals)
	return newdata

def convert_one_linux_to_datetime(linuxtime):

    epoch = datetime(1970,1,1,0,0,0)
    return epoch + timedelta(seconds=linuxtime)



def locate(pattern, root=os.curdir):
    '''Locate all files matching supplied filename pattern in and below
    supplied root directory.'''
    for path, dirs, files in os.walk(os.path.relpath(root)):
        for filename in fnmatch.filter(files, pattern):
            yield os.path.join(path, filename)

			
def main(args):
	dbfilename = args[0]
	dbfolder = args[1]
#	outputfolder = args[1]
	starttime = args[2]
	endtime = args[3]
	tablenames = args[4].rsplit(',')


	dbfilenames = locate(dbfilename,dbfolder)
	
	for dbfilename in dbfilenames:
		print dbfilename
		pathparts = os.path.split(dbfilename)
		outputfolder = pathparts[0] + '\\' + pathparts[1].rsplit('.')[0]
		
		if not os.path.exists(outputfolder):
			os.mkdir(outputfolder)

		
		c = connect(dbfilename)
		r = c.cursor()

		r.execute('SELECT name FROM sqlite_master WHERE type="table"')
		x = r.fetchall()
		existingtablenames = [str(y[0]) for y in x]
		
		
		if tablenames[0] == '#INTER#':
			print 'Table names: ', existingtablenames
			tablenames = raw_input('Enter comma separated table names:\n').rsplit(',')
		elif tablenames[0] == '#ALL#':
			tablenames = existingtablenames
		elif tablenames[0] == '#SENS#':
			tablenames = [x for x in existingtablenames if x.find('sensor') != -1]
		elif tablenames[0] == '#NOSENS#':
			tablenames = [x for x in existingtablenames if x.find('sensor') == -1]
		elif tablenames[0] == '#NOSENSNOFEAT#':
			tablenames = [x for x in existingtablenames if x.find('sensor') == -1 and x.find('feature') == -1]
		elif tablenames[0] == '#NOSENSNOFEATNOMODEL#':
			tablenames = [x for x in existingtablenames if x.find('sensor') == -1 and x.find('feature') == -1 and x.find('model') == -1]
		
		for tablename in tablenames:
			if not tablename in existingtablenames:
				continue
			print tablename
			r.execute('PRAGMA TABLE_INFO(%s)' % (tablename))
			fieldnames = [str(x[1]) for x in r.fetchall()]
			if u'_id' in fieldnames:
				idfieldind = fieldnames.index(u'_id')
			else:
				idfieldind = -1
				
			fieldnames = [fieldnames[i] for i in xrange(len(fieldnames)) if i != idfieldind]
				
			fout = open(outputfolder + '\\' + tablename + '.txt','w')
			print fieldnames
			if 'start_timestamp' in fieldnames:
				r.execute('select * from %s where start_timestamp>=%s and start_timestamp<= %s' % (tablename,starttime,endtime))
			
				x = r.fetchall()
				x = process_buffers(x)
			
				fout = open(outputfolder + '\\' + tablename + '.txt','w')
				print >> fout, 'time,unix time,sample'
				for line in x:
					print >> fout, '%s,%ld,%d' % (convert_one_linux_to_datetime(line[0]/1000-6*60*60).strftime('%a %b %d %H:%M:%S CST %Y'),line[0], line[1])
				
				fout.close()
			else:	
				r.execute('select * from %s' % (tablename))
			
				x = r.fetchall()
				print >> fout, string.join(fieldnames,',')
				for line in x:
					stroutput = []
					for ind,part in enumerate(line):
						if ind == idfieldind:
							continue
						if isinstance(part,unicode):
							stroutput.append(str(part))
						elif isinstance(part,str):
							stroutput.append(part)
						elif isinstance(part,long):
							stroutput.append('%ld' % (part))
						elif isinstance(part,int):
							stroutput.append('%d' % (part))
						elif isinstance(part,float):
							stroutput.append('%f' % (part))

					print >> fout, '%s' % (string.join(stroutput,','))
				
				fout.close()
	

if __name__ == '__main__':
	main(sys.argv[1:])