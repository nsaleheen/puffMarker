import sys
import io
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


def load_data(fn,use_specific_fold_inds):
	output = []
	fieldnames = [];
	
	numofcols = 0
	numofrows = 0
	for line in open(fn,'r').readlines():
		if line[0] == '#':
			fieldnames = line[1:].rstrip().rsplit(',')
#			fieldnames = fieldnames[:-1]
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
			if use_specific_fold_inds:
				fold_inds.append(int(parts[-1][1:]))
			
			for keyval in parts[1:-1]:
				key,val = keyval.rsplit(':')
				input[rowind,int(key)-1] = float(val)
		else:
			for keyval in parts[1:]:
				key,val = keyval.rsplit(':')
				input[rowind,int(key)-1] = float(val)
		rowind += 1
		
	
	return output,input,fieldnames,fold_inds

# def load_data(fn):
# 	output = []
# 	
# 	numofcols = 0
# 	numofrows = 0
# 	for line in open(fn,'r').readlines():
# 		parts = line.rstrip().rsplit()
# 		numofcols = max(numofcols,int(parts[-1].rsplit(':')[0]))
# 		numofrows += 1
# 		
# 	input = zeros([numofrows,numofcols],dtype='float64')
# 	
# 	rowind = 0
# 	for line in open(fn,'r').readlines():
# 		parts = line.rstrip().rsplit()
# 		
# 		output.append(float(parts[0]))
# 		for keyval in parts[1:]:
# 			key,val = keyval.rsplit(':')
# 			input[rowind,int(key)-1] = float(val)
# 		rowind += 1
# 		
# 	
# 	return output,input
		

class Timer():
   def __enter__(self): self.start = time.time()
   def __exit__(self, *args): print 'Entire Parameter Searching Experiment took %d seconds' % (time.time() - self.start)

   
     

def save_scale_data(fn,maxinput,mininput):
	finput = open(fn,'w')
	for ind in xrange(len(maxinput)):
		print >> finput, '%g, %g' % (mininput[ind],maxinput[ind])
	finput.close()

	 
def main(args):
	paramsfn = args[0]
	exec(open(paramsfn,'r').read())
	
	
	if len(args) > 1:
		crange = [float(args[1])]
		gammarange = [float(args[2])]
	
	output,input,fieldnames,fold_inds = load_data(datafilename,use_specific_fold_inds)
	fold_start = [-1]
	if use_specific_fold_inds:
		unique_fold_ids = unique(fold_inds)
		row_inds = []
		outputcopy = []
		inputcopy = zeros([size(input,0),size(input,1)],dtype='float64')
		fold_start = [0]
		
		curind = 0
		for ind in unique_fold_ids:
			row_inds = [i for i in xrange(len(fold_inds)) if fold_inds[i] == ind]
			inputcopy[curind:curind+len(row_inds),:] = input[row_inds,:]
			outputcopy.extend([output[i] for i in row_inds])
			curind += len(row_inds)
			
			fold_start.append(fold_start[-1]+len(row_inds))
		input = inputcopy
		output = outputcopy
		nf = len(fold_start)-1
	
	if testdatafilename != '':
		output_test,input_test,fieldnames,fold_inds_test = load_data(testdatafilename,False)
	
	if doscale:
		maxinput = input.max(0);
		mininput = input.min(0);
		input = (input-mininput)/(maxinput-mininput)
		
		if testdatafilename != '':
			input_test = (input_test-mininput)/(maxinput-mininput)

		if savemodel:
			save_scale_data(datafilename+'_scales.dat',maxinput,mininput)

	if donormalize:
		means = input.mean(0)
		stds = sqrt(input.var(0))
		input = (input-means)/stds
		if testdatafilename != '':
			input_test = (input_test-means)/stds

		if savemodel:
			save_zscore_data(datafilename+'_meansstdevs.dat',means,stds)

			
	if numcpus == 'auto':
		p = Pool()
	else:
		if numcpus == 1:
			p = ''
		else:
			p = Pool(numcpus)
	
	if choose_specific_features:
		for specific_selected_choice in specific_selected_features:
			inputfiltered = input[:,specific_selected_choice]
			
			with Timer():
				if use_specific_fold_inds:
					results = mygrid.grid_classify_multi (crange,gammarange,output,[list(x) for x in inputfiltered],nf,useprob,timeout,p,fold_start)				
				else:
					results = mygrid.grid_classify_multi (crange,gammarange,output,[list(x) for x in inputfiltered],nf,useprob,timeout,p)
				
			param = svm.svm_parameter('-c %g -g %g -b %d' % (results[-2],results[-1],int(useprob)))
			prob = svm.svm_problem(output, [list(x) for x in inputfiltered])
			target = (c_double * prob.l)()
			fold_start_p = (c_int *len(fold_start))()
			for i in xrange(len(fold_start)):
				fold_start_p[i] = fold_start[i]
			
			libsvm.svm_cross_validation_labeltargets(prob, fold_start_p,param, nf, target)
			labels = unique(output)
			ACC,confusionmatrix = mygrid.evaluations_classify_multi(output, target,labels)
			
			probchance = 0
			N = len(output)
			for i in xrange(len(labels)):
				nums_per_class_pred =sum(confusionmatrix[:,i])
				probchance += (sum(confusionmatrix[:,i])*sum(confusionmatrix[i,:]))*1.0/(N*N)

			kappa = (ACC/100-probchance)*1.0/(1-probchance);
				

			print 'Optimal gamma = %g\nOptimal c = %g' % (results[-1],results[-2])
			print 'Top CV ACC = %g' % (ACC)
			print 'Top CV kappa = %g' % (kappa)
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
			
			
			
			if savemodel:
				param = ('-c %g -g %g -b %d' % (results[-2],results[-1],int(useprob)))
				m = svm_train(output,[list(x) for x in inputfiltered],param)
				svm_save_model(datafilename + '.model',m)
				
								
			if outputlog != '':
				fout = open(outputlog,'a')
				print >> fout, '========================='
				print >> fout, datafilename
				print >> fout, doscale, donormalize, dopca, '(scale/norm/pca)'
				print >> fout, crange[0],crange[-1], gammarange[0], gammarange[-1], '(cs,gammas)'
				print >> fout, use_specific_fold_inds, nf, '(use specific folds, numfold)'
				print >> fout, 'SPECIFIC FIELDS:'
				print >> fout, specific_selected_choice
				if fieldnames != []:
					for i in specific_selected_choice:
						print >> fout, fieldnames[i],
					print >> fout
				print >> fout, 'train: '
				print >> fout, '    ACC=%g,kappa=%g (g=%g,c=%g)' % (ACC,kappa,results[-1],results[-2])
				fout.write('    =======')
				for i in xrange(len(labels)):
					fout.write('=========')
				print >> fout, '=========='
				print >> fout, '    ||   ||',
				for i in xrange(len(labels)):
					print >> fout, '%6d |' % labels[i],
				print >> fout, '       ||'
				fout.write('    ||=====')
				for i in xrange(len(labels)):
					fout.write('=========')
				print >> fout, '========||'
				for i in xrange(len(labels)):
					print >> fout, '    ||%3d||' % labels[i],
					for j in xrange(len(labels)):
						print >> fout, '%6g |' % confusionmatrix[i,j],
					print >> fout, '%6g ||' % sum(confusionmatrix[i,:])
				fout.write('    ||-----')
				for i in xrange(len(labels)):
					fout.write('---------')
				print >> fout, '--------||'
	
				print >> fout, '    ||   ||',
				for i in xrange(len(labels)):
					print >> fout, '%6g |' % sum(confusionmatrix[:,i]),
				print >> fout, '%6g ||' % N
				fout.write('    =======')
				for i in xrange(len(labels)):
					fout.write('=========')
				print >> fout, '=========='
				fout.close()
		
			if testdatafilename != '':
				inputfiltered_test = input_test[:,specific_selected_choice]
				param = ('-c %g -g %g -b %d' % (results[-2],results[-1],int(useprob)))
				m = svm_train(output,[list(x) for x in inputfiltered],param)	
				pred_labels, (ACC, MSE, SCC), pred_values = svm_predict(output_test,[list(x) for x in inputfiltered_test],m,'-b %d' % (int(useprob)))
				labels = m.get_labels()
				ACC,confusionmatrix = mygrid.evaluations_classify_multi(output_test, pred_labels, labels)
								
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

			
	else:
		
		with Timer():
			results = mygrid.grid_classify_multi (crange,gammarange,output,[list(x) for x in input],nf,useprob,timeout,p)

		param = svm.svm_parameter('-c %g -g %g -b %d' % (results[-2],results[-1],int(useprob)))
		prob = svm.svm_problem(output, [list(x) for x in input])
		target = (c_double * prob.l)()
		labels = unique(output)
		print 'Optimal gamma = %g\nOptimal c = %g' % (results[-1],results[-2])
		libsvm.svm_cross_validation_labeltargets(prob, param, nf, target)
		ACC,confusionmatrix = mygrid.evaluations_classify_multi(output, target,labels)
		print 'Top CV ACC = %g' % (ACC)

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
		print '%6g ||' % len(output)
		sys.stdout.write('=======')
		for i in xrange(len(labels)):
			sys.stdout.write('=========')
		print '=========='
			
		
		del target
		
		if savemodel:
			param = ('-c %g -g %g -b %d' % (results[-2],results[-1],int(useprob)))
			m = svm_train(output,[list(x) for x in input],param)
			svm_save_model(datafilename+'.model',m)
		
		if testdatafilename != '':
			param = ('-c %g -g %g -b %d' % (results[-2],results[-1],int(useprob)))
			m = svm_train(output,[list(x) for x in input],param)

			pred_labels, (ACC, MSE, SCC), pred_values = svm_predict(output_test,[list(x) for x in input_test],m,'-b %d' % (int(useprob)))
			labels = m.get_labels()
			ACC,confusionmatrix = mygrid.evaluations_classify_multi(output_test, pred_labels, labels)

			print 'Test optimized accuracy = %g' % (ACC)
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
			print '%6g ||' % len(output_test)
			sys.stdout.write('=======')
			for i in xrange(len(labels)):
				sys.stdout.write('=========')
			print '=========='

		
		if outputlog != '':
			fout = open(outputlog,'a')
			print >> fout, results#[:-1]
#			for key in results[-1].keys():
#				print >> fout, key, results[-1][key]
			fout.close()
	

if __name__ == '__main__':
	main(sys.argv[1:])
