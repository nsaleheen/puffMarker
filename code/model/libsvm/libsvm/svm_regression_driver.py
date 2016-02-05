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
#from numpy import mean,cov,double,cumsum,dot,linalg,array,rank
#from pylab import plot,subplot,axis,stem,show,figure


def load_data(fn):
	output = []
	fieldnames = [];
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

   
     

def save_scale_data(fn,maxinput,mininput):
	finput = open(fn,'w')
	for ind in xrange(len(maxinput)):
		print >> finput, '%g, %g' % (mininput[ind],maxinput[ind])
	finput.close()

	 
def main(args):
	paramsfn = args[0]
	exec(open(paramsfn,'r').read())
	
	
	if len(args) > 1:
		nurange = [float(args[1])]
		crange = [float(args[2])]
		gammarange = [float(args[3])]
	
	output,input,fieldnames = load_data(datafilename)
	
	if testdatafilename != '':
		output_test,input_test,fieldnames = load_data(testdatafilename)
		
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
		p = Pool(numcpus)
	
	
	if usebins:
		maxout = max(output)
		minout = min(output)
		range = maxout-minout
		bins = arange(minout,maxout,range*1.0/numbins)
		newbins = [[bins[i],bins[i+1]] for i in xrange(len(bins)-1)]
		newbins.append([bins[-1],maxout])
		print newbins
	else:
		newbins = []

	if choose_specific_features:
		if choose_specific_features_increasing:
			specific_selected_features = [specific_selected_features[:i] for i in xrange(2,len(specific_selected_features),1)]
		
#		print specific_selected_features
		for specific_selected_choice in specific_selected_features:
#			print specific_selected_choice
			inputfiltered = input[:,specific_selected_choice]
#			print inputfiltered
			
			if dopca:
				
#				f1 = figure(1)
#				plot(inputfiltered[:,0],inputfiltered[:,1],'.');
#				coeff,score,latent = princomp(inputfiltered[:,range(2)])
#				score = array(score)
#				f1 = figure(2)
#				plot(score[:,0],score[:,1],'.');
#				show()
				coeff,temp,latent = princomp(inputfiltered)

				if savemodel:
					save_pca_coeffs(datafilename+'_pcacoeffs.dat',coeff,mean(inputfiltered.T,axis=1))
				inputfiltered = temp
			
			with Timer():
				results = mygrid.grid_regress (nurange,crange,gammarange,output,[list(x) for x in inputfiltered],nf,timeout,p,newbins)
				
			print 'CV Train optimized SCC = %g, MSE = %g (nu=%g,c=%g,g=%g)' % (results[0],results[1],results[2],results[3],results[4])
			
			if testdatafilename != '':
				inputfiltered_test = input_test[:,specific_selected_choice]
				param = '-s %d -t %d -n %g -c %g -g %g' % (svm.NU_SVR,svm.RBF,results[-3],results[-2],results[-1])
				m = svm_train(output,[list(x) for x in inputfiltered],param)
				pred_labels, (ACC, MSE, SCC), pred_values = svm_predict(output_test,[list(x) for x in inputfiltered_test],m)

				print 'Test optimized SCC = %g, MSE = %g )' % (SCC,MSE)
				if outputpredictions:
					fout = open(predictionslog,'w')
					for ind in xrange(len(output_test)):
						label = output_test[ind]
						value = pred_values[ind][0]
						oneinputrow = input_test[ind,:]
						print >> fout, value, label,
						
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
				print >> fout, 'train: SCC=%g,MSE=%g (nu=%g,c=%g,g=%g)' % (results[0],results[1],results[2],results[3],results[4])
				if testdatafilename != '':
					print >> fout, 'test: SCC=%g,MSE=%g' % (SCC,MSE)
				fout.close()
	else:
		
		with Timer():
			results = mygrid.grid_regress (nurange,crange,gammarange,output,[list(x) for x in input],nf,timeout,p)

		print 'CV Train optimized SCC = %g, MSE = %g (nu=%g,c=%g,g=%g)' % (results[0],results[1],results[2],results[3],results[4])

		if savemodel:
			param = '-s %d -t %d -n %g -c %g -g %g' % (svm.NU_SVR,svm.RBF,results[-3],results[-2],results[-1])
			m = svm_train(output,[list(x) for x in input],param)
			svm_save_model(datafilename+'.model',m)
		
		if testdatafilename != '':
			param = '-s %d -t %d -n %g -c %g -g %g' % (svm.NU_SVR,svm.RBF,results[-3],results[-2],results[-1])
			m = svm_train(output,[list(x) for x in input],param)
			pred_labels, (ACC, MSE, SCC), pred_values = svm_predict(output_test,[list(x) for x in input_test],m)

			print 'Test optimized SCC = %g, MSE = %g )' % (SCC,MSE)
			
			
			if outputpredictions:
				fout = open(predictionslog,'w')
				for ind in xrange(len(output_test)):
					label = output_test[ind]
					value = pred_values[ind]
					oneinputrow = input_test[ind,:]
					print >> fout, value, label,
					
					for j in xrange(len(oneinputrow)):
						print >> fout, '%d:%f' % (j+1,oneinputrow[j]),
					print >> fout
				fout.close()
		elif outputpredictions:
			fout = open(predictionslog,'w')
			for ind in xrange(len(output)):
				label = output[ind]
				value = target[ind]
				oneinputrow = input[ind,:]
				print >> fout, value, label,
				
				for j in xrange(len(oneinputrow)):
					print >> fout, '%d:%f' % (j+1,oneinputrow[j]),
				print >> fout
			fout.close()

		
		if outputlog != '':
			fout = open(outputlog,'a')
			print >> fout, '========================='
			for name in fieldnames:
				print >> fout, name,
			print >> fout
			print >> fout, 'train: SCC=%g,MSE=%g (nu=%g,c=%g,g=%g)' % (results[0],results[1],results[2],results[3],results[4])
			if testdatafilename != '':
				print >> fout, 'test: SCC=%g,MSE=%g (nu=%g,c=%g,g=%g)' % (SCC,MSE)
			fout.close()
	

def princomp(A):
	""" performs principal components analysis 
     (PCA) on the n-by-p data matrix A
     Rows of A correspond to observations, columns to variables. 

	Returns :  
	coeff :
		is a p-by-p matrix, each column containing coefficients 
		for one principal component.
	score : 
		the principal component scores; that is, the representation 
		of A in the principal component space. Rows of SCORE 
		correspond to observations, columns to components.

	latent : 
		a vector containing the eigenvalues 
		of the covariance matrix of A.
	"""
 # computing eigenvalues and eigenvectors of covariance matrix
	M = (A-mean(A.T,axis=1)).T # subtract the mean (along columns)
	[latent,coeff] = linalg.eig(cov(M))
	score = dot(coeff.T,M).T # projection of the data in the new space
	return coeff,score,latent

	
def save_pca_coeffs(fn,coeff,means):
	fout = open(fn,'w')
	for i in xrange(size(coeff,0)):
		for j in xrange(size(coeff,1)):
			print >> fout, coeff[i,j],
		print >> fout
	for i in xrange(len(means)):
		print >> fout, means[i],
		
	fout.close()
 

 
if __name__ == '__main__':
	main(sys.argv[1:])
