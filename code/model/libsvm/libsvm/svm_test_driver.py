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
	fieldnames = [];
	
	numofcols = 0
	numofrows = 0
	for line in open(fn,'r').readlines():
		if line[0] == '#':
			fieldnames = line[1:].rstrip().rsplit(',')
			continue
		parts = line.rstrip().rsplit()
		if parts[-1][0]=='#':
			numofcols = max(numofcols,int(parts[-2].rsplit(':')[0]))
		else:
			numofcols = max(numofcols,int(parts[-1].rsplit(':')[0]))
		numofrows += 1
		
	input = zeros([numofrows,numofcols],dtype='float64')
	fold_inds = []
		
	rowind = 0
	for line in open(fn,'r').readlines():
		if line[0] == '#':
			continue
		parts = line.rstrip().rsplit()
		output.append(float(parts[0]))
		if parts[-1][0] == '#':
			for keyval in parts[1:-1]:
				key,val = keyval.rsplit(':')
				if val == 'nan' or val == 'inf':
					input[rowind,int(key)-1] = nan;
				else:
					input[rowind,int(key)-1] = float(val)
		else:
			for keyval in parts[1:]:
				key,val = keyval.rsplit(':')
				if val == 'nan' or val == 'inf':
					input[rowind,int(key)-1] = nan;
				else:
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
	
def read_meansigma(fn):
	means = []
	sigmas = []
	for line in open(fn).readlines():
		parts = line.rstrip().rsplit(',')
		means.append(float(parts[0]))
		sigmas.append(float(parts[1]))
		
	return array(means),array(sigmas)

	
def main(args):
	paramsfn = args[0]
	exec(open(paramsfn,'r').read())
	
	pdfpages = PdfPages('%s.pdf' % (outputlog))
		
	output_test,input_test,fieldnames = load_data(testdatafilename)
	if binarizeoutput:
		output_test = [1 if x > boundary else -1 for x in output_test]
	
	if doscale:
		maxinput,mininput = read_scale_data(scaledatafilename)
		input_test = (input_test-mininput)/(maxinput-mininput)
		
	if donormalize:
		means,stds = read_meansigma(normalizationfilename)
		input_test = (input_test-means)/stds

						
	if choose_specific_features:
		for specific_selected_choice in specific_selected_features:
			inputfiltered_test = input_test[:,specific_selected_choice]

			if dopca:
				coeffs,means = read_pcacoeffs(pcacoefffilename)
				temp = (inputfiltered_test-means).T
				inputfiltered_test = dot(coeffs.T,temp).T
				
			m = svm_load_model(modelfilename)
			if posclass == 'auto':
				posclass = m.get_labels()[0]
				negclass = m.get_labels()[1]
				
			print posclass
			print negclass
			
#			print len(output_test)
			pred_labels, (ACC, MSE, SCC), pred_values = svm_predict(output_test,[list(x) for x in inputfiltered_test],m,'-b %d' % (int(useprob)))
			pred_labels = [posclass if pred_values[i][0] > optbias else negclass for i in xrange(len(output_test))]
#			print len(pred_labels)
			ACC,PHI,confusionmatrix = mygrid.evaluations_classify(output_test, [x[0] for x in pred_values],posclass,optbias)
			db = array([[output_test[i],pred_values[i][0]] for i in range(len(output_test))])
			
			neg = len([x for x in output_test if x != posclass])
			pos = len(output_test)-neg;
			
			
			
			
			
			if neg != 0 and pos != 0:
				auc,topacc,optaccbias,topphi,optphibias,top_tps_bias,top_fps = mygrid.calc_AUC(db,neg,pos,posclass,useprob,[],True,pdfpages,'Test ROC curve',optbias)

			numpred_pos = confusionmatrix[0,0]+confusionmatrix[1,0]
			numpred_neg = confusionmatrix[0,1]+confusionmatrix[1,1]
			
			N = pos+neg
			probchance = (numpred_pos*pos+numpred_neg*neg)*1.0/(N*N)
			kappa = (ACC/100.0-probchance)*1.0/(1-probchance);
			
			print 'Test optimized Phi statistic = %g' % (PHI)
			print 'Test optimized accuracy = %g' % (ACC/100.0)
			print 'Test optimized kappa = %g' % (kappa)
			if pos == 0 or neg == 0:
				print 'TP/RECALL = %g, FP = %g, PRECISION = %g' % (nan,nan,nan)
			else:
				print 'TP/RECALL = %g, FP = %g, PRECISION = %g' % (confusionmatrix[0,0]/pos,confusionmatrix[1,0]/neg,confusionmatrix[0,0]/(confusionmatrix[0,0]+confusionmatrix[1,0]))
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
				for ind in xrange(len(pred_values)):
					groundtruth = output_test[ind]
					label = pred_labels[ind]
					value = pred_values[ind][0]
					print >> fout, groundtruth,label,value,
					oneinputrow = input_test[ind,:]
					for j in xrange(len(oneinputrow)):
						print >> fout, '%d:%f' % (j+1,oneinputrow[j]),
					print >> fout
				fout.close()


				
			if outputlog != '':
				fout = open(outputlog,'a')
				print >> fout, '========================='
				print >> fout, 'SPECIFIC FIELDS:'
				print >> fout, specific_selected_choice 
				for i in specific_selected_choice:
					print >> fout, fieldnames[i],
				print >> fout
				if neg != 0 and pos != 0:
					print >> fout, 'test: ACC=%g,AUC=%g' % (ACC,auc)
				fout.close()
	else:
		

		m = svm_load_model(modelfilename)
		if posclass == 'auto':
			posclass = m.get_labels()
			posclass = posclass[0]

		pred_labels, (ACC, MSE, SCC), pred_values = svm_predict(output_test,[list(x) for x in input_test],m,'-b %d' % (int(useprob)))
		ACC,PHI,confusionmatrix = mygrid.evaluations_classify(output_test, [x[0] for x in pred_values],posclass,optbias)
		db = array([[output_test[i],pred_values[i][0]] for i in range(len(output_test))])
		neg = len([x for x in output_test if x != posclass])
		pos = len(output_test)-neg;
		if neg != 0 and pos != 0:
			auc,topacc,optaccbias,topphi,optphibias,top_tps_bias,top_fps = mygrid.calc_AUC(db,neg,pos,posclass,useprob,[],True,pdfpages,'Test ROC curve',optbias)
		

		numpred_pos = confusionmatrix[0,0]+confusionmatrix[1,0]
		numpred_neg = confusionmatrix[0,1]+confusionmatrix[1,1]
		
		N = pos+neg
		probchance = (numpred_pos*pos+numpred_neg*neg)*1.0/(N*N)
		testkappa = (ACC-probchance)*1.0/(1-probchance);

		print 'Test optimized Phi statistic = %g' % (PHI)
		print 'Test optimized accuracy = %g' % (ACC)
		print 'Test optimized kappa = %g' % (kappa)
		print 'TP/RECALL = %g, FP = %g, PRECISION = %g' % (confusionmatrix[0,0]/pos,confusionmatrix[1,0]/neg,confusionmatrix[0,0]/(confusionmatrix[0,0]+confusionmatrix[1,0]))
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
			for labelind in xrange(len(pred_labels)):
				print >> fout, output_test[labelind],pred_labels[labelind],pred_values[labelind][0]
			fout.close()
			
		if outputlog != '':
			fout = open(outputlog,'a')
			print >> fout, '========================='
			print >> fout, ACC
			fout.close()
	
	pdfpages.close()

if __name__ == '__main__':
	main(sys.argv[1:])
