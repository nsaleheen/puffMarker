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
from pylab import *
from matplotlib.backends.backend_pdf import PdfPages

#from numpy import mean,cov,double,cumsum,dot,linalg,array,rank
#from pylab import plot,subplot,axis,stem,show,figure


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
				if val == 'nan':
					input[rowind,int(key)-1] = nan;
				else:
					input[rowind,int(key)-1] = float(val)
		else:
			for keyval in parts[1:]:
				key,val = keyval.rsplit(':')
				if val == 'nan':
					input[rowind,int(key)-1] = nan;
				else:
					input[rowind,int(key)-1] = float(val)
		rowind += 1
		
	
	return output,input,fieldnames,fold_inds
		

class Timer():
   def __enter__(self): self.start = time.time()
   def __exit__(self, *args): print 'Entire Parameter Searching Experiment took %d seconds' % (time.time() - self.start)

   
     
	 
def binarize_output(output,threshold,threshold_type):
	newoutput = []
	
	if threshold_type == 'percentile':
		n = len(output)
		temp = sorted(output)
		boundary = temp[n*(1-threshold)]
		newoutput = [1 if x > boundary else -1 for x in output]		
	else:
		newoutput = [1 if x > threshold else -1 for x in output]
		boundary = threshold
		
	return newoutput,boundary

def save_scale_data(fn,maxinput,mininput):
	finput = open(fn,'w')
	for ind in xrange(len(maxinput)):
		print >> finput, '%g, %g' % (mininput[ind],maxinput[ind])
	finput.close()


def save_zscore_data(fn,means,stds):
	finput = open(fn,'w')
	for ind in xrange(len(means)):
		print >> finput, '%g, %g' % (means[ind],stds[ind])
	finput.close()

	
def main(args):
	paramsfn = args[0]
	exec(open(paramsfn,'r').read())
	
	
	if len(args) > 1:
		gammarange = [float(args[1])]
		crange = [float(args[2])]
	
	output,input,fieldnames,fold_inds = load_data(datafilename,use_specific_fold_inds)
	sep_validation = False
	if separate_validation_set != '':
		output_valid,input_valid,fieldnames,fold_inds_valid = load_data(separate_validation_set,use_specific_fold_inds)
		sep_validation = True


	fold_start = [-1]
	if sep_validation:
		fold_start_valid = [-1]
	
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
		
		if sep_validation:
			unique_fold_ids_valid = unique(fold_inds_valid)
			row_inds = []
			outputcopy = []
			inputcopy = zeros([size(input_valid,0),size(input_valid,1)],dtype='float64')
			fold_start_valid = [0]
			
			curind = 0
			for ind in unique_fold_ids_valid:
				row_inds = [i for i in xrange(len(fold_inds_valid)) if fold_inds_valid[i] == ind]
				inputcopy[curind:curind+len(row_inds),:] = input_valid[row_inds,:]
				outputcopy.extend([output_valid[i] for i in row_inds])
				curind += len(row_inds)
				
				fold_start_valid.append(fold_start_valid[-1]+len(row_inds))
			input_valid = inputcopy
			output_valid = outputcopy
			nf = len(fold_start_valid)-1
		
	if binarizeoutput:
		output,boundary = binarize_output(output,binary_threshold,binary_boundary_type)
	
	
	if testdatafilename != '':
		output_test,input_test,fieldnames,fold_inds_test = load_data(testdatafilename,False)
		if binarizeoutput:
			output_test = [1 if x > boundary else -1 for x in output_test]
	
	
	if doscale:
		maxinput = input.max(0);
		mininput = input.min(0);
		input = (input-mininput)/(maxinput-mininput)
		
		if testdatafilename != '':
			input_test = (input_test-mininput)/(maxinput-mininput)

		if savemodel:
			save_scale_data(datafilename+'_scales.dat',maxinput,mininput)
			
		if sep_validation:
			input_valid = (input_valid-mininput)/(maxinput-mininput)



	if donormalize:
		means = input.mean(0)
		stds = sqrt(input.var(0))
		input = (input-means)/stds
		if testdatafilename != '':
			input_test = (input_test-means)/stds

		if savemodel:
			save_zscore_data(datafilename+'_meansstdevs.dat',means,stds)
	
		if sep_validation:
			input_valid = (input_valid-means)/stds
		
	if numcpus == 'auto':
		p = Pool()
	else:
		p = Pool(numcpus)
	
	
	if choose_specific_features:
		if choose_specific_features_increasing:
			specific_selected_features = [specific_selected_features[:i] for i in xrange(2,len(specific_selected_features),2)]
			
		for specific_selected_choice in specific_selected_features:
			inputfiltered = input[:,specific_selected_choice]
			if sep_validation:
				inputfiltered_valid = input_valid[:,specific_selected_choice]

			if dopca:
				coeff,temp,latent = princomp(inputfiltered)

				if savemodel:
					save_pca_coeffs(datafilename+'_pcacoeffs.dat',coeff,mean(inputfiltered.T,axis=1))
				inputfiltered = temp
				if sep_validation:
					return
							
			with Timer():
			
				if sep_validation:
					if use_specific_fold_inds:
						results = mygrid.grid_classify_sepvalid (crange,gammarange,output,[list(x) for x in inputfiltered],output_valid,[list(x) for x in inputfiltered_valid],nf,useprob,timeout,p,fold_start,fold_start_valid)
					else:
						results = mygrid.grid_classify_sepvalid (crange,gammarange,output,[list(x) for x in inputfiltered],output_valid,[list(x) for x in inputfiltered_valid],nf,useprob,timeout,p)
				else:
					if use_specific_fold_inds:
						results = mygrid.grid_classify (crange,gammarange,output,[list(x) for x in inputfiltered],nf,useprob,timeout,p,fold_start)
					else:
						results = mygrid.grid_classify (crange,gammarange,output,[list(x) for x in inputfiltered],nf,useprob,timeout,p)

				
			param = svm.svm_parameter('-c %g -g %g -b %d' % (results[-2],results[-1],int(useprob)))
			
			prob = svm.svm_problem(output, [list(x) for x in inputfiltered])
			fold_start_p = (c_int *len(fold_start))()
			for i in xrange(len(fold_start)):
				fold_start_p[i] = fold_start[i]
			if posclass == 'auto':
				posclass = output[0]

			if sep_validation:
				prob_valid = svm.svm_problem(output_valid, [list(x) for x in inputfiltered_valid])
				testlength = prob_valid.l
				fold_start_p_valid = (c_int *len(fold_start_valid))()
				for i in xrange(len(fold_start_valid)):
					fold_start_p_valid[i] = fold_start_valid[i]
			else:
				testlength = prob.l	
								
			target = (c_double * testlength)()
										
			#[maxauc,maxoptacc,maxphi,minfpfnration,maxf1,optbias,optc,optgamma]
			
			if sep_validation:
				libsvm.svm_cross_validation_sepsets(prob, prob_valid,fold_start_p, fold_start_p_valid,param, nf, target)
			else:
				libsvm.svm_cross_validation(prob, fold_start_p, param, nf, target)
				
				
			if sep_validation:
				ys = prob_valid.y[:testlength]
			else:
				ys = prob.y[:prob.l]
				
			db = array([[ys[i],target[i]] for i in range(testlength)])
				
			
			neg = len([x for x in ys if x != posclass])
			pos = testlength-neg;

			if len(specific_selected_features) == 1 or True:
				pdfpages = PdfPages('%s_train.pdf' % (outputlog))
#				auc,topacc,optaccbias,topphi,optphibias,top_tps_bias,top_fps = mygrid.calc_AUC(db,neg,pos,posclass,useprob,[],True,pdfpages,'Optimal Cross-Validation ROC curve')
				topacc,topphi,minfpfnratio,topf1,auc,optbias = mygrid.optimize_results(db,neg,pos,posclass,'F1')
				print [topacc,results[1]]
				print [topphi,results[2]]
				print [topf1,results[4]]
				print [auc,results[0]]
				pdfpages.close()
#				print target
				if sep_validation:
					ACC,PHI,confusionmatrix = mygrid.evaluations_classify(output_valid,target,posclass,results[-3])
				else:
					ACC,PHI,confusionmatrix = mygrid.evaluations_classify(output,target,posclass,results[-3])
				if posclass == 1:
					negclass = 0;
				else:
					negclass = 1;

				numpred_pos = confusionmatrix[0,0]+confusionmatrix[1,0]
				numpred_neg = confusionmatrix[0,1]+confusionmatrix[1,1]
				
				N = pos+neg
				probchance = (numpred_pos*pos+numpred_neg*neg)*1.0/(N*N)
				kappa = (topacc-probchance)*1.0/(1-probchance);
				
				print 'Train optimized accuracy = %g' % (topacc)
				print 'Train optimized Phi statistic = %g' % (topphi)
				print 'Train optimized kappa = %g' % (kappa)
				print 'Train optimized F1 score = %f' % (topf1)
				print 'Train optimized TP/RECALL = %g, FP = %g, PRECISION = %g' % (confusionmatrix[0,0]/pos,confusionmatrix[1,0]/neg,confusionmatrix[0,0]/(confusionmatrix[0,0]+confusionmatrix[1,0]))
				print '================================'
				print '||   ||%6d |%6d |       ||' % (posclass,negclass)
				print '================================'
				print '||%3d||%6g |%6g |%6g ||' % (posclass,confusionmatrix[0,0],confusionmatrix[0,1],pos)#confusionmatrix[0,0]+confusionmatrix[0,1])
				print '||%3d||%6g |%6g |%6g ||' % (negclass,confusionmatrix[1,0],confusionmatrix[1,1],neg)#confusionmatrix[1,0]+confusionmatrix[1,1])
				print '||----------------------------||'
				print '||   ||%6g |%6g |%6g ||' % (confusionmatrix[0,0]+confusionmatrix[1,0],confusionmatrix[0,1]+confusionmatrix[1,1],pos+neg)#confusionmatrix[1,0]+confusionmatrix[1,1])
				print '================================'
				
				
			else:
				auc,topacc,optaccbias,topphi,optphibias,top_tps_bias,top_fps = mygrid.calc_AUC(db,neg,pos,posclass,useprob,[],False,0,'Optimal Cross-Validation ROC curve')
			
			print 'Optimal gamma = %g\nOptimal c = %g\nOptimal Bias = %g' % (results[-1],results[-2],results[-3])
			print 'Top CV results: AUC = %g, OPTIMIZED ACC = %g, OPTIMIZED PHI = %g' % (auc,topacc,topphi)

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
				print >> fout, '    AUC=%g,ACC=%g,kappa=%g,phi=%g,f1=%g (g=%g,c=%g,bias=%g)' % (auc,topacc,kappa,topphi,topf1,results[-1],results[-2],results[-3])
				print >> fout, '    ||%3d||%6g |%6g |%6g ||' % (posclass,confusionmatrix[0,0],confusionmatrix[0,1],pos)#confusionmatrix[0,0]+confusionmatrix[0,1])
				print >> fout, '    ||%3d||%6g |%6g |%6g ||' % (negclass,confusionmatrix[1,0],confusionmatrix[1,1],neg)#confusionmatrix[1,0]+confusionmatrix[1,1])
				fout.close()
			
			if outputpredictions:
				fout = open(predictionslog,'w')
				if sep_validation:
					for ind in xrange(len(output_valid)):
						label = output_valid[ind]
						value = target[ind]
						oneinputrow = input_valid[ind,:]
						print >> fout, value, label,
						
						for j in xrange(len(oneinputrow)):
							print >> fout, '%d:%f' % (j+1,oneinputrow[j]),
						print >> fout
				else:
					for ind in xrange(len(output)):
						label = output[ind]
						value = target[ind]
						oneinputrow = input[ind,:]
						print >> fout, value, label,
						
						for j in xrange(len(oneinputrow)):
							print >> fout, '%d:%f' % (j+1,oneinputrow[j]),
						print >> fout
				fout.close()
			
			del target
		
				
			if savemodel:
				param = ('-c %g -g %g -b %d' % (results[-2],results[-1],int(useprob)))
				m = svm_train(output,[list(x) for x in inputfiltered],param)
				svm_save_model(datafilename + '.model',m)
				
				
			
			if testdatafilename != '':
				inputfiltered_test = input_test[:,specific_selected_choice]
				if dopca:
					M = (inputfiltered_test-mean(inputfiltered_test.T,axis=1)).T # subtract the mean (along columns)
					inputfiltered_test = dot(coeff.T,M).T # projection of the data in the new space

				param = ('-c %g -g %g -b %d' % (results[-2],results[-1],int(useprob)))
				m = svm_train(output,[list(x) for x in inputfiltered],param)
				pred_labels, (ACC, MSE, SCC), pred_values = svm_predict(output_test,[list(x) for x in inputfiltered_test],m,'-b %d' % (int(useprob)))
				ACC,PHI,confusionmatrix = mygrid.evaluations_classify(output_test, [x[0] for x in pred_values],posclass,results[-3])
				db = array([[output_test[i],pred_values[i][0]] for i in range(len(output_test))])
				neg = len([x for x in output_test if x != posclass])
				pos = len(output_test)-neg

				auctest = 0				
				if neg != 0 and pos != 0:
					auctest,topacctest,optaccbias,topphitest,optphibias,top_tps_bias,top_fps = mygrid.calc_AUC(db,neg,pos,posclass,useprob,[],False,pdfpages,'Test ROC curve',results[-3])

				numpred_pos = confusionmatrix[0,0]+confusionmatrix[1,0]
				numpred_neg = confusionmatrix[0,1]+confusionmatrix[1,1]
				
				N = pos+neg
				probchance = (numpred_pos*pos+numpred_neg*neg)*1.0/(N*N)
				testkappa = (ACC/100.0-probchance)*1.0/(1-probchance);

				
				print 'Test optimized accuracy = %g' % (ACC)
				print 'Test optimized Phi statistic = %g' % (PHI)
				print 'Test optimized kappa = %g' % (testkappa)
				print '================================'
				print '||   ||%6d |%6d |       ||' % (m.get_labels()[0],m.get_labels()[1])
				print '================================'
				print '||%3d||%6g |%6g |%6g ||' % (m.get_labels()[0],confusionmatrix[0,0],confusionmatrix[0,1],pos)#confusionmatrix[0,0]+confusionmatrix[0,1])
				print '||%3d||%6g |%6g |%6g ||' % (m.get_labels()[1],confusionmatrix[1,0],confusionmatrix[1,1],neg)#confusionmatrix[1,0]+confusionmatrix[1,1])
				print '||----------------------------||'
				print '||   ||%6g |%6g |%6g ||' % (confusionmatrix[0,0]+confusionmatrix[1,0],confusionmatrix[0,1]+confusionmatrix[1,1],pos+neg)#confusionmatrix[1,0]+confusionmatrix[1,1])
				print '================================'


				if outputlog != '':
					fout = open(outputlog,'a')
	
					print >> fout, 'test: '
					print >> fout, '   ACC=%g,AUC=%g,kappa=%g,phi=%g' % (ACC,auctest,testkappa,PHI)
					print >> fout, '   ||%3d||%6g |%6g |%6g ||' % (m.get_labels()[0],confusionmatrix[0,0],confusionmatrix[0,1],pos)#confusionmatrix[0,0]+confusionmatrix[0,1])
					print >> fout, '   ||%3d||%6g |%6g |%6g ||' % (m.get_labels()[1],confusionmatrix[1,0],confusionmatrix[1,1],neg)#confusionmatrix[1,0]+confusionmatrix[1,1])
	
					fout.close()
	else:
		
		with Timer():
			if use_specific_fold_inds:
				results = mygrid.grid_classify (crange,gammarange,output,[list(x) for x in input],nf,useprob,timeout,p,fold_start)
			else:
				results = mygrid.grid_classify (crange,gammarange,output,[list(x) for x in input],nf,useprob,timeout,p)

		param = svm.svm_parameter('-c %g -g %g -b %d' % (results[-2],results[-1],int(useprob)))
		prob = svm.svm_problem(output, [list(x) for x in input])
		target = (c_double * prob.l)()
		fold_start_p = (c_int *len(fold_start))()
		for i in xrange(len(fold_start)):
			fold_start_p[i] = fold_start[i]
		
		if posclass == 'auto':
			posclass = output[0]
			
		libsvm.svm_cross_validation(prob, fold_start_p, param, nf, target)
		ys = prob.y[:prob.l]
		db = [[ys[i],target[i]] for i in range(prob.l)]
		db = array(db)
		neg = len([x for x in ys if x != posclass])
		pos = prob.l-neg;
		
		pdfpages = PdfPages('%s_train.pdf' % (outputlog))
		auc,topacc,optaccbias,topphi,optphibias,top_tps_bias,top_fps = mygrid.calc_AUC(db,neg,pos,posclass,useprob,[],True,pdfpages,'Optimal Cross-Validation ROC curve')
		pdfpages.close()
		ACC,PHI,confusionmatrix = mygrid.evaluations_classify(output, target,posclass,results[-3])
		if posclass == 1:
			negclass = 0;
		else:
			negclass = 1;
			
		print 'Train optimized accuracy = %g' % (topacc)
		print 'Train optimized phi statististic = %g' % (topphi)
		print 'TP/RECALL = %g, FP = %g, PRECISION = %g' % (confusionmatrix[0,0]/pos,confusionmatrix[1,0]/neg,confusionmatrix[0,0]/(confusionmatrix[0,0]+confusionmatrix[1,0]))
		print '================================'
		print '||   ||%6d |%6d |       ||' % (posclass,negclass)
		print '================================'
		print '||%3d||%6g |%6g |%6g ||' % (posclass,confusionmatrix[0,0],confusionmatrix[0,1],pos)#confusionmatrix[0,0]+confusionmatrix[0,1])
		print '||%3d||%6g |%6g |%6g ||' % (negclass,confusionmatrix[1,0],confusionmatrix[1,1],neg)#confusionmatrix[1,0]+confusionmatrix[1,1])
		print '||----------------------------||'
		print '||   ||%6g |%6g |%6g ||' % (confusionmatrix[0,0]+confusionmatrix[1,0],confusionmatrix[0,1]+confusionmatrix[1,1],pos+neg)#confusionmatrix[1,0]+confusionmatrix[1,1])
		print '================================'
		
		if outputpredictions:
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
		del target
		
		print 'Optimal gamma = %g\nOptimal c = %g\nOptimal Bias = %g' % (results[-1],results[-2],optphibias)
		print 'Top CV results: AUC = %g, OPTIMIZED ACC = %g, OPTIMIZED PHI = %g' % (auc,topacc,topphi)
		if savemodel:
			param = ('-c %g -g %g -b %d' % (results[-2],results[-1],int(useprob)))
			m = svm_train(output,[list(x) for x in input],param)
			svm_save_model(datafilename+'.model',m)
		
		if testdatafilename != '':
			param = ('-c %g -g %g -b %d' % (results[-2],results[-1],int(useprob)))
			m = svm_train(output,[list(x) for x in input],param)

			pred_labels, (ACC, MSE, SCC), pred_values = svm_predict(output_test,[list(x) for x in input_test],m,'-b %d' % (int(useprob)))
			ACC,PHI,confusionmatrix = mygrid.evaluations_classify(output_test, [x[0] for x in pred_values],posclass,results[-3])

			db = array([[output_test[i],pred_values[i][0]] for i in range(len(output_test))])
			neg = len([x for x in output_test if x != posclass])
			pos = len(output_test)-neg;
			pdfpages = PdfPages('%s_test.pdf' % (outputlog))
			auctest = 0
			if neg != 0 and pos != 0:
				auctest,topacctest,optaccbias,topphitest,optphibias,top_tps_bias,top_fps = mygrid.calc_AUC(db,neg,pos,posclass,useprob,[],True,pdfpages,'Test ROC curve',results[-3])
			pdfpages.close()
			
			print 'Test accuracy = %g' % (ACC)
			print 'Test Phi statistic = %g' % (PHI)
			print 'TP/RECALL = %g, FP = %g, PRECISION = %g' % (confusionmatrix[0,0]/pos,confusionmatrix[1,0]/neg,confusionmatrix[0,0]/(confusionmatrix[0,0]+confusionmatrix[1,0]))
			print '================================'
			print '||   ||%6d |%6d |       ||' % (m.get_labels()[0],m.get_labels()[1])
			print '================================'
			print '||%3d||%6g |%6g |%6g ||' % (m.get_labels()[0],confusionmatrix[0,0],confusionmatrix[0,1],pos)#confusionmatrix[0,0]+confusionmatrix[0,1])
			print '||%3d||%6g |%6g |%6g ||' % (m.get_labels()[1],confusionmatrix[1,0],confusionmatrix[1,1],neg)#confusionmatrix[1,0]+confusionmatrix[1,1])
			print '||----------------------------||'
			print '||   ||%6g |%6g |%6g ||' % (confusionmatrix[0,0]+confusionmatrix[1,0],confusionmatrix[0,1]+confusionmatrix[1,1],pos+neg)#confusionmatrix[1,0]+confusionmatrix[1,1])
			print '================================'

		
		if outputlog != '':
			fout = open(outputlog,'a')
			print >> fout, '========================='
			print >> fout, fieldnames
			print >> fout, 'train: AUC=%g,ACC=%g,PHI=%g (g=%g,c=%g,bias=%g)' % (auc,topacc,topphi,results[-1],results[-2],results[-3])
			if testdatafilename != '':
				print >> fout, 'test: ACC=%g,AUC=%g,PHI=%g' % (ACC,auctest,PHI)
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
