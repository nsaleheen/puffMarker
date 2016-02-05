import sys

import svm
import svmutil
from svmutil import *

import os
import time

import mygrid
from multiprocessing import Pool
from scipy import *
from numpy import *
import matplotlib
#matplotlib.use("Agg")
#from pylab import *
from matplotlib.backends.backend_pdf import PdfPages


def load_data(fn):
	output = []
	
	numofcols = 0
	numofrows = 0
	for line in open(fn,'r').readlines():
		parts = line.rstrip().rsplit()
		numofcols = max(numofcols,int(parts[-1].rsplit(':')[0]))
		numofrows += 1
		
	input = zeros([numofrows,numofcols],dtype='float64')
	
	rowind = 0
	for line in open(fn,'r').readlines():
		parts = line.rstrip().rsplit()
		
		output.append(float(parts[0]))
		for keyval in parts[1:]:
			key,val = keyval.rsplit(':')
			input[rowind,int(key)-1] = float(val)
		rowind += 1
		
	
	return output,input
		

class Timer():
   def __enter__(self): self.start = time.time()
   def __exit__(self, *args): print 'Entire Parameter Searching Experiment took %d seconds' % (time.time() - self.start)

   
     

def read_scale_data(fn):
	minvals = []
	maxvals = []
	for line in open(fn).readlines():
		parts = line.rstrip().rsplit(',')
		minvals.append(float(parts[0]))
		maxvals.append(float(parts[1]))

	return array(maxvals),array(minvals)
	 
def main(args):
	paramsfn = args[0]
	exec(open(paramsfn,'r').read())
	
	pdfpages = PdfPages('%s.pdf' % (outputlog))
		
	output_test,input_test = load_data(testdatafilename)
		
	if doscale:
		maxinput,mininput = read_scale_data(scaledatafilename)
		input_test = (input_test-mininput)/(maxinput-mininput)
						
	if choose_specific_features:
		for specific_selected_choice in specific_selected_features:
			inputfiltered_test = input_test[:,specific_selected_choice]

			m = svm_load_model(modelfilename)
			if posclass == 'auto':
				posclass = m.get_labels()
				posclass = posclass[0]
				

			pred_labels, (ACC, MSE, SCC), pred_values = svm_predict(output_test,[list(x) for x in inputfiltered_test],m)
			ACC,confusionmatrix = mygrid.evaluations_classify(output_test, [x[0] for x in pred_values],posclass,optbias)
			db = array([[output_test[i],pred_values[i][0]] for i in range(len(output_test))])
			
			neg = len([x for x in output_test if x != posclass])
			pos = len(output_test)-neg;
			if neg != 0 and pos != 0:
				auc,topacc,optbias,top_tps_bias,top_fps = mygrid.calc_AUC(db,neg,pos,posclass,[],True,pdfpages,'Test ROC curve')

			print 'Test optimized accuracy = %g' % (ACC)
			print '================================'
			print '||   ||%6d |%6d |       ||' % (m.get_labels()[0],m.get_labels()[1])
			print '================================'
			print '||%3d||%6g |%6g |%6g ||' % (m.get_labels()[0],confusionmatrix[0,0],confusionmatrix[0,1],pos)#confusionmatrix[0,0]+confusionmatrix[0,1])
			print '||%3d||%6g |%6g |%6g ||' % (m.get_labels()[1],confusionmatrix[1,0],confusionmatrix[1,1],neg)#confusionmatrix[1,0]+confusionmatrix[1,1])
			print '||----------------------------||'
			print '||   ||%6g |%6g |%6g ||' % (confusionmatrix[0,0]+confusionmatrix[1,0],confusionmatrix[0,1]+confusionmatrix[1,1],pos+neg)#confusionmatrix[1,0]+confusionmatrix[1,1])
			print '================================'

			if outputpredictions:
				fout = open(predictionslog,'w')
				for label in pred_labels:
					print >> fout, label
				fout.close()
				
			if outputlog != '':
				fout = open(outputlog,'a')
				print >> fout, '========================='
				print >> fout, specific_selected_choice
				print >> fout, ACC,auc
				fout.close()
	else:
		

		m = svm_load_model(modelfilename)
		if posclass == 'auto':
			posclass = m.get_labels()
			posclass = posclass[0]

		pred_labels, (ACC, MSE, SCC), pred_values = svm_predict(output_test,[list(x) for x in input_test],m)
		ACC,confusionmatrix = mygrid.evaluations_classify(output_test, [x[0] for x in pred_values],posclass,optbias)
		db = array([[output_test[i],pred_values[i][0]] for i in range(len(output_test))])
		neg = len([x for x in output_test if x != posclass])
		pos = len(output_test)-neg;
		if neg != 0 and pos != 0:
			auc,topacc,optbias,top_tps_bias,top_fps = mygrid.calc_AUC(db,neg,pos,posclass,[],True,pdfpages,'Test ROC curve')
		
		print 'Test optimized accuracy = %g' % (ACC)
		print '================================'
		print '||   ||%6d |%6d |       ||' % (m.get_labels()[0],m.get_labels()[1])
		print '================================'
		print '||%3d||%6g |%6g |%6g ||' % (m.get_labels()[0],confusionmatrix[0,0],confusionmatrix[0,1],pos)#confusionmatrix[0,0]+confusionmatrix[0,1])
		print '||%3d||%6g |%6g |%6g ||' % (m.get_labels()[1],confusionmatrix[1,0],confusionmatrix[1,1],neg)#confusionmatrix[1,0]+confusionmatrix[1,1])
		print '||----------------------------||'
		print '||   ||%6g |%6g |%6g ||' % (confusionmatrix[0,0]+confusionmatrix[1,0],confusionmatrix[0,1]+confusionmatrix[1,1],pos+neg)#confusionmatrix[1,0]+confusionmatrix[1,1])
		print '================================'

		
		
		if outputpredictions:
			fout = open(testdatafilename + '_predictions.dat','w')
			for label in pred_labels:
				print >> fout, label
			fout.close()
			
		if outputlog != '':
			fout = open(outputlog,'a')
			print >> fout, '========================='
			print >> fout, ACC
			fout.close()
	
	pdfpages.close()

if __name__ == '__main__':
	main(sys.argv[1:])
