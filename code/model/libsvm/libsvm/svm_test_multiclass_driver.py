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
	fieldnames = []
	
	numofcols = 0
	numofrows = 0
	for line in open(fn,'r').readlines():
		if line[0] == '#':
			fieldnames = line[1:].rstrip().rsplit(', ')
#			fieldnames = fieldnames[:-1]
			continue
		parts = line.rstrip().rsplit()
		numofcols = max(numofcols,int(parts[-1].rsplit(':')[0]))
		numofrows += 1
		
	input = zeros([numofrows,numofcols],dtype='float64')
	
	rowind = 0
	for line in open(fn,'r').readlines():
		if line[0] == '#':
			continue
		parts = line.rstrip().rsplit()
		
		output.append(float(parts[0]))
		for keyval in parts[1:]:
			key,val = keyval.rsplit(':')
			input[rowind,int(key)-1] = float(val)
		rowind += 1
		
	
	return output,input,fieldnames
		

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
	 
	 
def read_pcacoeffs(fn):
	coeffs = []
	for line in open(fn).readlines():
		parts = line.rstrip().rsplit(' ')
		coeffs.append([float(x) for x in parts])
	
	return array(coeffs)[0:-1,:],array(coeffs)[-1,:]
	
	
def main(args):
	paramsfn = args[0]
	exec(open(paramsfn,'r').read())
	
	pdfpages = PdfPages('%s.pdf' % (outputlog))
		
	output_test,input_test,fieldnames = load_data(testdatafilename)
		
	if doscale:
		maxinput,mininput = read_scale_data(scaledatafilename)
		input_test = (input_test-mininput)/(maxinput-mininput)
						
	if choose_specific_features:
		for specific_selected_choice in specific_selected_features:
			inputfiltered_test = input_test[:,specific_selected_choice]

			if dopca:
				coeffs,means = read_pcacoeffs(pcacoefffilename)
				temp = (inputfiltered_test-means).T
				inputfiltered_test = dot(coeffs.T,temp).T
				
			m = svm_load_model(modelfilename)
				
			pred_labels, (ACC, MSE, SCC), pred_values = svm_predict(output_test,[list(x) for x in inputfiltered_test],m,'-b %d' % (int(useprob)))
			labels = unique(output_test)
			ACC,confusionmatrix = mygrid.evaluations_classify_multi(output_test,pred_labels,labels)
			
			probchance = 0
			N = len(output_test)
			for i in xrange(len(labels)):
				nums_per_class_pred =sum(confusionmatrix[:,i])
				probchance += (sum(confusionmatrix[:,i])*sum(confusionmatrix[i,:]))*1.0/(N*N)

			kappa = (ACC/100-probchance)*1.0/(1-probchance);
				
			print 'Test optimized accuracy = %g' % (ACC)
			print 'Test optimized kappa = %g' % (kappa)
			sys.stdout.write('=======')
			for i in xrange(len(labels)):
				sys.stdout.write('=========')
			print '=========='
			print '||   ||',
			for i in xrange(len(labels)):
				print '%6d |' % labels[i],
			print '       ||'
			sys.stdout.write('||=====')
			for i in xrange(len(labels)):
				sys.stdout.write('=========')
			print '========||'
			for i in xrange(len(labels)):
				print '||%3d||' % labels[i],
				for j in xrange(len(labels)):
					print '%6g |' % confusionmatrix[i,j],
				print '%6g ||' % sum(confusionmatrix[i,:])
			sys.stdout.write('||-----')
			for i in xrange(len(labels)):
				sys.stdout.write('---------')
			print '--------||'

			print '||   ||',
			for i in xrange(len(labels)):
				print '%6g |' % sum(confusionmatrix[:,i]),
			print '%6g ||' % N
			sys.stdout.write('=======')
			for i in xrange(len(labels)):
				sys.stdout.write('=========')
			print '=========='


			if outputpredictions:
				fout = open(predictionslog,'w')
				for labelind in xrange(len(pred_labels)):
					print >> fout, output_test[labelind],pred_labels[labelind],pred_values[labelind]
				fout.close()
				
			if outputlog != '':
				fout = open(outputlog,'a')
				print >> fout, '========================='
				print >> fout, 'SPECIFIC FIELDS:'
				print >> fout, specific_selected_choice 
				for i in specific_selected_choice:
					print >> fout, fieldnames[i],
				print >> fout
				print >> fout, 'test: ACC=%g' % (ACC)
				fout.close()
	else:
		
		m = svm_load_model(modelfilename)
			
		pred_labels, (ACC, MSE, SCC), pred_values = svm_predict(output_test,[list(x) for x in input_test],m,'-b %d' % (int(useprob)))
		if testlabelspresent:
			labels = unique(output_test)
			ACC,confusionmatrix = mygrid.evaluations_classify_multi(output_test,pred_labels,labels)
			
			probchance = 0
			N = len(output_test)
			for i in xrange(len(labels)):
				nums_per_class_pred =sum(confusionmatrix[:,i])
				probchance += (sum(confusionmatrix[:,i])*sum(confusionmatrix[i,:]))*1.0/(N*N)

			kappa = (ACC/100-probchance)*1.0/(1-probchance);
				
			print 'Test optimized accuracy = %g' % (ACC)
			print 'Test optimized kappa = %g' % (kappa)
			sys.stdout.write('=======')
			for i in xrange(len(labels)):
				sys.stdout.write('=========')
			print '=========='
			print '||   ||',
			for i in xrange(len(labels)):
				print '%6d |' % labels[i],
			print '       ||'
			sys.stdout.write('||=====')
			for i in xrange(len(labels)):
				sys.stdout.write('=========')
			print '========||'
			for i in xrange(len(labels)):
				print '||%3d||' % labels[i],
				for j in xrange(len(labels)):
					print '%6g |' % confusionmatrix[i,j],
				print '%6g ||' % sum(confusionmatrix[i,:])
			sys.stdout.write('||-----')
			for i in xrange(len(labels)):
				sys.stdout.write('---------')
			print '--------||'

			print '||   ||',
			for i in xrange(len(labels)):
				print '%6g |' % sum(confusionmatrix[:,i]),
			print '%6g ||' % N
			sys.stdout.write('=======')
			for i in xrange(len(labels)):
				sys.stdout.write('=========')
			print '=========='


		if outputpredictions:
			fout = open(predictionslog,'w')
			for labelind in xrange(len(pred_labels)):
				if testlabelspresent:
					print >> fout, output_test[labelind],
				print >> fout, pred_labels[labelind],pred_values[labelind]
			fout.close()
			
		if outputlog != '':
			fout = open(outputlog,'a')
			print >> fout, '========================='
			print >> fout, 'test: ACC=%g' % (ACC)
			fout.close()
	
	pdfpages.close()

if __name__ == '__main__':
	main(sys.argv[1:])
