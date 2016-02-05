import sys
sys.path.append('c:\\Users\\karen\\Dropbox\\DataQuality\\libsvm-3.1\\python')
sys.path.append('c:\\Users\\karen\\Dropbox\\DataQuality\\libsvm-3.1\\windows')

import svm
from svm import *
from multiprocessing import Pool
from numpy import *
import matplotlib
matplotlib.use("Agg")
from pylab import *
from itertools import imap
from operator import itemgetter, attrgetter

def grid_regress (nurange,crange,gammarange,output,input,nf,timeout,p,bins):
	params = []
	for nu in nurange:
		for c in crange:
			for gamma in gammarange:
				params.append([nu,c,gamma,nf,output,input,bins])

	N = len(params)
	results = p.imap(do_one_cv,params)

	del params
	maxscc = 0
	minerror = inf
	ind = 0
	optgamma = 0
	optc = 0
	optnu = 0
	mses = {}
	
	maximize_scc = True
	
	for nu in nurange:
		for c in crange:
			for gamma in gammarange:
				if ind % (N * 0.05) == 0:
					print '====== %%%g completed ======' % (float(ind)/N * 100)
				ind += 1
				try:
					mse,scc = results.next(timeout=timeout)
				except:
#					print '(%g,%g,%g)' % (nu,c,gamma),
#					print '* ',
					mse = inf
					scc = 0
#				mses[nu,c,gamma] = mse
				if maximize_scc:
					if scc > maxscc or scc == maxscc and gamma == optgamma and c < optc and nu < optnu:
						print scc, mse,gamma, c, nu
						minerror = mse
						maxscc = scc
						optc = c
						optgamma = gamma
						optnu = nu
				else:
					if mse < minerror or mse == minerror and gamma == optgamma and c < optc and nu < optnu:
						print scc, mse,gamma, c, nu
						minerror = mse
						maxscc = scc
						optc = c
						optgamma = gamma
						optnu = nu


	del results
	return [maxscc,minerror,optnu,optc,optgamma]

def grid_classify (crange,gammarange,output,input,nf,useprob,timeout,p,	fold_start=[], perfmetric = 'F1'):
	params = []

	if fold_start != []:
		for c in crange:
			for gamma in gammarange:
				params.append([c,gamma,nf,output,input,useprob,fold_start,perfmetric])
		results = p.imap(do_one_cv_classify_predeffolds,params)
	else:
		for c in crange:
			for gamma in gammarange:
				params.append([c,gamma,nf,output,input,useprob,perfmetric])
		results = p.imap(do_one_cv_classify,params)
		
	N = len(params)
	
	del params
	maxauc = 0
	maxphi = -1
	maxf1 = -1
	minfpfnratio = inf
	ind = 0
	optgamma = 0
	optc = 0
	optbias = 0.5
	maxoptacc = 0
	optacc = 0
	bias = 0
#	accs = {}

	

	for c in crange:
		for gamma in gammarange:
			if ind % int(ceil(N * 0.05)) == 0:				
				print '====== %%%g completed ======' % (floor(float(ind)/N * 100))
			ind += 1
			try:
				topacc,topphi,minfpfnratio,topf1,auc,bias = results.next(timeout=timeout)
#				print topf1, c, gamma
			except:
				auc = 0
				topf1 = -1
#				print '*'
			if perfmetric == 'F1':
				if topf1 > maxf1 or topf1 == maxf1 and gamma == optgamma and c < optc:
					print 'Max F1 = %g (gamma = %g, c = %g)' % (topf1,gamma,c)
					maxauc = auc
					maxphi = topphi
					maxoptacc = topacc
					minfpfnratio = minfpfnratio
					maxf1 = topf1
					optbias = bias
					optc = c
					optgamma = gamma					
			elif perfmetric == 'AUC':
				if auc > maxauc or auc == maxauc and gamma == optgamma and c < optc:
					print 'Max AUC = %g (gamma = %g, c = %g)' % (auc,gamma, c)
					maxauc = auc
					maxphi = topphi
					maxoptacc = topacc
					minfpfnratio = minfpfnratio
					maxf1 = topf1;
					optbias = optbias
					optc = c
					optgamma = gamma


	del results
	return [maxauc,maxoptacc,maxphi,minfpfnratio,maxf1,optbias,optc,optgamma]



def grid_classify_sepvalid (crange,gammarange,output,input,output_valid,input_valid,nf,useprob,timeout,p,fold_start=[],fold_start_valid=[],perfmetric = 'F1'):
	params = []

	if fold_start != []:
		for c in crange:
			for gamma in gammarange:
				params.append([c,gamma,nf,output,input,output_valid,input_valid,useprob,fold_start,fold_start_valid,perfmetric])
		results = p.imap(do_one_cv_classify_predeffolds_valid,params)
	else:
		for c in crange:
			for gamma in gammarange:
				params.append([c,gamma,nf,output,input,output_valid,input_valid,useprob,perfmetric])
		results = p.imap(do_one_cv_classify_valid,params)
		
	N = len(params)
	
	del params
	maxauc = 0
	maxphi = -1
	maxf1 = -1
	minfpfnratio = inf
	ind = 0
	optgamma = 0
	optc = 0
	optbias = 0.5
	maxoptacc = 0
	optacc = 0
	bias = 0
#	accs = {}

	

	for c in crange:
		for gamma in gammarange:
			if ind % int(ceil(N * 0.05)) == 0:				
				print '====== %%%g completed ======' % (floor(float(ind)/N * 100))
			ind += 1
			try:
				topacc,topphi,minfpfnratio,topf1,auc,bias = results.next(timeout=timeout)
#				print topf1, c, gamma
			except:
				auc = 0
				topf1 = -1
#				print '*'
			if perfmetric == 'F1':
				if topf1 > maxf1 or topf1 == maxf1 and gamma == optgamma and c < optc:
					print 'Max F1 = %g (gamma = %g, c = %g)' % (topf1,gamma,c)
					maxauc = auc
					maxphi = topphi
					maxoptacc = topacc
					minfpfnratio = minfpfnratio
					maxf1 = topf1
					optbias = bias
					optc = c
					optgamma = gamma					
			elif perfmetric == 'AUC':
				if auc > maxauc or auc == maxauc and gamma == optgamma and c < optc:
					print 'Max AUC = %g (gamma = %g, c = %g)' % (auc,gamma, c)
					maxauc = auc
					maxphi = topphi
					maxoptacc = topacc
					minfpfnratio = minfpfnratio
					maxf1 = topf1;
					optbias = optbias
					optc = c
					optgamma = gamma


	del results
	return [maxauc,maxoptacc,maxphi,minfpfnratio,maxf1,optbias,optc,optgamma]
	

def grid_classify_multi (crange,gammarange,output,input,nf,useprob,timeout,p,fold_start =[]):
	params = []
	
	if fold_start != []:
		for c in crange:
			for gamma in gammarange:
				params.append([c,gamma,nf,output,input,useprob,fold_start])
		if p == '':
			results = imap(do_one_cv_classify_predeffolds_multi,params)
		else:
			results = p.imap(do_one_cv_classify_predeffolds_multi,params)
	else:
		for c in crange:
			for gamma in gammarange:
				params.append([c,gamma,nf,output,input,useprob])
		if p == '':
			results = imap(do_one_cv_classify_multi,params)
		else:
			results = p.imap(do_one_cv_classify_multi,params)

	N = len(params)
	
	
	del params
	ind = 0
	optgamma = 0
	optc = 0
	maxacc = 0
	
	for c in crange:
		for gamma in gammarange:
			if ind % int(ceil(N * 0.05)) == 0:
				print '====== %%%g completed ======' % (floor(float(ind)/N * 100))
			ind += 1
			try:
				if p == '':
					acc = results.next()
				else:
					acc = results.next(timeout=timeout)
#				print 'ACC = %g (gamma = %g, c = %g)' % (acc,gamma, c)
			except:
				acc = 0
			if acc > maxacc or acc == maxacc and gamma == optgamma and c < optc:
				print 'Max ACC = %g (gamma = %g, c = %g)' % (acc,gamma, c)
				maxacc = acc
				optc = c
				optgamma = gamma


	del results
	return [maxacc,optc,optgamma]
	
	
	
def do_one_cv(theinput):
	nu = theinput[0]
	c = theinput[1]
	gamma = theinput[2]
	nf = theinput[3]
	output = theinput[4]
	input = theinput[5]
	bins = theinput[6]
	
	param = svm.svm_parameter('-s %d -t %d -n %g -c %g -g %g' % (svm.NU_SVR,svm.RBF,nu,c,gamma))

	prob = svm.svm_problem(output, input)
	target = (c_double * prob.l)()
	fold_start = (c_int *1)();
	fold_start[0] = -1;
	
	libsvm.svm_cross_validation_labeltargets(prob, fold_start,param, nf, target)	
	MSE,SCC = evaluations(prob.y[:prob.l],target[:prob.l],bins)
	del target
	return MSE,SCC

	
def do_one_cv_classify(theinput):
	c = theinput[0]
	gamma = theinput[1]
	nf = theinput[2]
	output = theinput[3]
	input = theinput[4]
	useprob = theinput[5]	
	perfmetric = theinput[6]

	param = svm.svm_parameter('-c %g -g %g -b %d' % (c,gamma,int(useprob)))

	prob = svm.svm_problem(output, input)
	target = (c_double * prob.l)()
	
	posclass = output[0]
	fold_start = (c_int *1)();
	fold_start[0] = -1;
	libsvm.svm_cross_validation(prob, fold_start, param, nf, target)
	ys = prob.y[:prob.l]
	db = array([[ys[i],target[i]] for i in range(prob.l)])
	
	del target
	
	neg = len([x for x in ys if x != posclass])
	pos = prob.l-neg
	
	
	
	[topacc,topphi,minfpfnratio,topf1,auc,optbias] = optimize_results(db,neg,pos,posval,perfmetric)
		
	return topacc,topphi,minfpfnratio,topf1,auc,optbias

	
def do_one_cv_classify_predeffolds(theinput):
	c = theinput[0]
	gamma = theinput[1]
	nf = theinput[2]
	output = theinput[3]
	input = theinput[4]
	useprob = theinput[5]
	fold_start = theinput[6]
	perfmetric = theinput[7]
	
	param = svm.svm_parameter('-c %g -g %g -b %d' % (c,gamma,int(useprob)))

	prob = svm.svm_problem(output, input)
	fold_start_p = (c_int *len(fold_start))()
	for i in xrange(len(fold_start)):
		fold_start_p[i] = fold_start[i]
		
	target = (c_double * prob.l)()
	posclass = output[0]
	
#	print prob
	libsvm.svm_cross_validation(prob, fold_start_p, param, nf, target)

	
	ys = prob.y[:prob.l]
	db = array([[ys[i],target[i]] for i in range(prob.l)])
#	print db
	del target
	del fold_start_p
	
	neg = len([x for x in ys if x != posclass])
#	print neg
	pos = prob.l-neg
#	print pos
		
#	print fb,neg,pos,posclass,perfmetric
	
	[topacc,topphi,minfpfnratio,topf1,auc,optbias] = optimize_results(db,neg,pos,posclass,perfmetric)
		
	return topacc,topphi,minfpfnratio,topf1,auc,optbias


def do_one_cv_classify_valid(theinput):
	c = theinput[0]
	gamma = theinput[1]
	nf = theinput[2]
	output = theinput[3]
	input = theinput[4]
	output_valid = theinput[5]
	input_valid = theinput[6]
	useprob = theinput[7]	
	perfmetric = theinput[8]

	param = svm.svm_parameter('-c %g -g %g -b %d' % (c,gamma,int(useprob)))

	prob = svm.svm_problem(output, input)
	
	prob_valid = svm.svm_problem(output_valid, input_valid)

	target = (c_double * prob_valid.l)()

	posclass = output[0]
	fold_start = (c_int *1)();
	fold_start[0] = -1;
	
	fold_start_valid = (c_int *1)();
	fold_start_valid[0] = -1;
	
	libsvm.svm_cross_validation_sepsets(prob, prob_valid,fold_start,fold_start_valid, param, nf, target)
	
	ys = prob.y[:prob_valid.l]
	db = array([[ys[i],target[i]] for i in range(prob_valid.l)])
	
	del target
	
	neg = len([x for x in ys if x != posclass])
	pos = prob_valid.l-neg
	
	
	
	[topacc,topphi,minfpfnratio,topf1,auc,optbias] = optimize_results(db,neg,pos,posval,perfmetric)
		
	return topacc,topphi,minfpfnratio,topf1,auc,optbias

	
def do_one_cv_classify_predeffolds_valid(theinput):
	c = theinput[0]
	gamma = theinput[1]
	nf = theinput[2]
	output = theinput[3]
	input = theinput[4]
	output_valid = theinput[5]
	input_valid = theinput[6]
	useprob = theinput[7]
	fold_start = theinput[8]
	fold_start_valid = theinput[9]
	perfmetric = theinput[10]
	
	param = svm.svm_parameter('-c %g -g %g -b %d' % (c,gamma,int(useprob)))

	prob = svm.svm_problem(output, input)
	fold_start_p = (c_int *len(fold_start))()
	for i in xrange(len(fold_start)):
		fold_start_p[i] = fold_start[i]
		
	prob_valid = svm.svm_problem(output_valid, input_valid)
	fold_start_p_valid = (c_int *len(fold_start_valid))()
	for i in xrange(len(fold_start_valid)):
		fold_start_p_valid[i] = fold_start_valid[i]


	target = (c_double * prob_valid.l)()
	posclass = output[0]
	
#	print prob
	libsvm.svm_cross_validation_sepsets(prob, prob_valid,fold_start_p, fold_start_p_valid,param, nf, target)

	
	ys = prob.y[:prob_valid.l]
	db = array([[ys[i],target[i]] for i in range(prob_valid.l)])
#	print db
	del target
	del fold_start_p
	del fold_start_p_valid
	
	neg = len([x for x in ys if x != posclass])
#	print neg
	pos = prob_valid.l-neg
#	print pos
		
#	print fb,neg,pos,posclass,perfmetric
	
	[topacc,topphi,minfpfnratio,topf1,auc,optbias] = optimize_results(db,neg,pos,posclass,perfmetric)
		
	return topacc,topphi,minfpfnratio,topf1,auc,optbias

	
	
def do_one_cv_classify_multi(theinput):
	c = theinput[0]
	gamma = theinput[1]
	nf = theinput[2]
	output = theinput[3]
	input = theinput[4]
	useprob = theinput[5]
		
		
		
	param = svm.svm_parameter('-c %g -g %g -b %d' % (c,gamma,int(useprob)))
	
	prob = svm.svm_problem(output, input)
	target = (c_double * prob.l)()
	posclass = output[0]
	fold_start = (c_int *1)();
	fold_start[0] = -1;
	libsvm.svm_cross_validation_labeltargets(prob, fold_start,param, nf, target)

	
	acc = len([i for i in xrange(len(output)) if output[i] == target[i]])*1.0/prob.l
	return acc



def do_one_cv_classify_predeffolds_multi(theinput):
	c = theinput[0]
	gamma = theinput[1]
	nf = theinput[2]
	output = theinput[3]
	input = theinput[4]
	useprob = theinput[5]
	fold_start = theinput[6]
			
		
		
	param = svm.svm_parameter('-c %g -g %g -b %d' % (c,gamma,int(useprob)))
	
	prob = svm.svm_problem(output, input)
	target = (c_double * prob.l)()
	posclass = output[0]
	fold_start_p = (c_int *len(fold_start))()
	for i in xrange(len(fold_start)):
		fold_start_p[i] = fold_start[i]
	libsvm.svm_cross_validation_labeltargets(prob, fold_start_p,param, nf, target)

	acc = len([i for i in xrange(len(output)) if output[i] == target[i]])*1.0/prob.l
	del target
	del fold_start_p
	return acc

	
def evaluations(ty, pv,bins):

	if len(ty) != len(pv):
		raise ValueError("len(ty) must equal to len(pv)")
	sumv = sumy = sumvv = sumyy = sumvy = 0
	total_error = 0

	if bins != []:
		for v, y in zip(pv, ty):
			pbin = which_bin(bins,v)
			tbin = which_bin(bins,y)
			total_error += (pbin-tbin)*(pbin-tbin)
			sumv += pbin
			sumy += tbin
			sumvv += pbin*pbin
			sumyy += tbin*tbin
			sumvy += pbin*tbin 
	else:
		for v, y in zip(pv, ty):
			total_error += (v-y)*(v-y)
			sumv += v
			sumy += y
			sumvv += v*v
			sumyy += y*y
			sumvy += v*y 
			
			
	l = len(ty)
	MSE = total_error*1.0/l
#	print MSE,sumvv,sumyy,sumv,sumy,sumvy,(l*sumvv-sumv*sumv)*(l*sumyy-sumy*sumy),(l*sumvy-sumv*sumy)*(l*sumvy-sumv*sumy)
	try:
		SCC = ((l*sumvy-sumv*sumy)*(l*sumvy-sumv*sumy))/((l*sumvv-sumv*sumv)*(l*sumyy-sumy*sumy))
	except:
		SCC = 0#float('nan')
	return (MSE, SCC)

def which_bin(bins,val):
	if val < bins[0][0]:
		return 0
	if val >= bins[-1][1]:
		return len(bins)+1
	for i,bin in enumerate(bins):
		if val>=bin[0] and val<bin[1]:
			return i+1
		

def evaluations_classify(ty, pv,posclass=-1,bias=0.5):

	if len(ty) != len(pv):
		raise ValueError("len(ty) must equal to len(pv)")
	sumv = sumy = sumvv = sumyy = sumvy = 0
	total_correct = 0
	
	confusionmatrix = zeros([2,2]);

	for v, y in zip(pv, ty):
		if y == posclass and v>bias: 
			confusionmatrix[0,0] += 1
			total_correct += 1
		elif y==posclass and v<=bias:
			confusionmatrix[0,1] += 1
		elif y!=posclass and v>bias:
			confusionmatrix[1,0] += 1
		elif y!=posclass and v<=bias:
			confusionmatrix[1,1] += 1
			total_correct += 1
			
	l = len(ty)
	numpos = sum([i for i in ty if i == posclass])
	if numpos == 0 or numpos == len(ty):
		PHI = nan;
		ACC = nan;
	else:
		PHI = (confusionmatrix[0,0]*confusionmatrix[1,1]-confusionmatrix[1,0]*confusionmatrix[0,1])*1.0/sqrt((confusionmatrix[0,0]+confusionmatrix[1,0])*(confusionmatrix[0,0]+confusionmatrix[0,1])*(confusionmatrix[1,1]+confusionmatrix[1,0])*(confusionmatrix[1,1]+confusionmatrix[0,1]))
		ACC = 100.0*total_correct/l
		
	return ACC,PHI,confusionmatrix

def evaluations_classify_multi(ty, py, labels):

	if len(ty) != len(py):
		raise ValueError("len(ty) must equal to len(pv)")
	total_correct = 0
	numclass = len(labels)
	
	confusionmatrix = zeros([numclass,numclass]);
	
	labelinds = {}
	for i in xrange(numclass):
		labelinds[labels[i]] = i

	for yhat, y in zip(py, ty):
		confusionmatrix[labelinds[y],labelinds[yhat]] += 1

		if y == yhat: 
			total_correct += 1
			
	ACC = 100.0*total_correct/len(ty)
	return ACC,confusionmatrix

	

def calc_AUC_old(db,neg,pos,posval,probabilistic=False,min_fps_in_tp=[],do_plot=False,pdfpage=0,pagetitle = '',custombias=nan):


	n = size(db,0)
	allNs = range(n)
	shuffle(allNs)

	db = db[allNs,:]
#	print db
	db1 = copy(db)
	db = db[argsort(db[:,1]),:]
	
#	print db
	
	xy_arr = [[1,1]]
	topacc = -1
	tp,fp = pos, neg
	#assure float division
	N = neg+pos
#	print N
	tn = neg-fp
	fn = pos-tp
#	print tp,fp,tn,fn,sqrt((tp+fp)*(tp+fn)*(tn+fp)*(tn+fn)),(tp*tn-fp*fn)
	accs = [[(tp+tn)*1.0/N,0,n]]
	phis = [[0,0,n]]
	default_bias_ind = -1
	if not isnan(custombias):
		custom_bias_ind = -1

	prev_tp = 1.0
	top_fps = []
	top_tps_bias = []
	min_fps_ind = -1
#	print posval
	for i in range(n):
		if db[i,0]==posval:                 #positive
			tp-=1.0
		else:
			fp-=1.0


		for min_fp_in_tp in min_fps_in_tp:
			if tp/pos < min_fp_in_tp and prev_tp >= min_fp_in_tp:
				if i == 0:
					top_tps_bias.append(0)
					top_fps.append(fp/neg)
					min_fps_ind = n-i-1
				else:
					top_tps_bias.append(db[i-1,1])
					top_fps.append(fp/neg)
					min_fps_ind = n-i-1

#               print tp/pos,fp/neg,prev_tp,min_fp_in_tp,min_fps_ind,i


		prev_tp = tp/pos

		xy_arr.insert(0,[fp/neg,tp/pos])
		tn = neg-fp
		fn = pos-tp
		accs.insert(0,[(tp+tn)*1.0/N,db[i,1],n-i-1])

		if tp == 0 and fp == 0:
			phis.insert(0,[0,db[i,1],n-i-1])
		else:
			phis.insert(0,[(tp*tn-fp*fn)*1.0/sqrt((tp+fp)*(tp+fn)*(tn+fp)*(tn+fn)),db[i,1],n-i-1])
			
		if not isnan(custombias):
			if db[i,1] > custombias and custom_bias_ind == -1:
				custom_bias_ind = n-i
				
		if ((db[i,1] > 0.5 and probabilistic) or (db[i,1] > 0 and not probabilistic)) and default_bias_ind == -1:
			default_bias_ind = n-i

			
	if isnan(custombias):
		
		topacc = max(accs)
#		print topacc
		topacc_bias = topacc[1]
		topacc_ind = topacc[2]
		topacc = topacc[0]
		
		topphi = max(phis)
#		print topphi
		topphi_bias = topphi[1]
		topphi_ind = topphi[2]
		topphi = topphi[0]
		
		
#	print phis
	auc = 0.
	prev_x = 0
	for x,y in xy_arr:
		if x != prev_x:
			auc += (x - prev_x) * y
			prev_x = x


#	print xy_arr
	if do_plot:
		f1 = figure(1)
		ax = f1.add_subplot(111)
		for tick in ax.xaxis.get_major_ticks():
			tick.label1.set_fontsize(15)
		for tick in ax.yaxis.get_major_ticks():
			tick.label1.set_fontsize(15)
					
		plot([x[0] for x in xy_arr],[x[1] for x in xy_arr],'k',linewidth=2)
#		ftemp = open('rocpoints.dat','w');
#		for ind in xrange(len(xy_arr)):
#			print >> ftemp, xy_arr[ind][0],',',xy_arr[ind][1],';'
#		ftemp.close()
		if isnan(custombias):
			plot(xy_arr[topacc_ind][0],xy_arr[topacc_ind][1],'ro',markersize=13,markeredgewidth=1.5)
			plot(xy_arr[topphi_ind][0],xy_arr[topphi_ind][1],'mo',markersize=13,markeredgewidth=1.5)
		else:
			plot(xy_arr[custom_bias_ind][0],xy_arr[custom_bias_ind][1],'ro',markersize=13,markeredgewidth=1.5)
		
		plot(xy_arr[default_bias_ind][0],xy_arr[default_bias_ind][1],'bs',markersize=13,markeredgewidth=1.5)
		if min_fps_in_tp != []:
			plot(xy_arr[min_fps_ind][0],xy_arr[min_fps_ind][1],'og')
		
		
#		text(xy_arr[default_bias_ind][0]+0.02,xy_arr[default_bias_ind][1]-0.06,'Default choice (ACC = %.4f)' % (accs[default_bias_ind][0]),fontsize=15)
#		if isnan(custombias):
#			text(xy_arr[topacc_bias[0]][0]+0.04,xy_arr[topacc_bias[0]][1]-0.04,'Optimal choice (ACC = %.4f)' % (topacc),fontsize=15)
#		else:
#			text(xy_arr[custom_bias_ind][0]+0.04,xy_arr[custom_bias_ind][1]-0.04,'Optimal choice (ACC = %.4f)' % (accs[custom_bias_ind][0]),fontsize=15)


		ylim([0,1.04])
		xlim([0,1.01])

		xlabel("False Positive Rate",fontsize=15)
		ylabel("True Positive Rate",fontsize=15)
		if isnan(custombias):
			title("%s (AUC = %.4f; ACC = (%.4f,%.4f)\nPHI = (%.4f,%.4f))" % (pagetitle,auc,accs[default_bias_ind][0],topacc,phis[default_bias_ind][0],topphi),fontsize=15)
		else:
			title("%s (AUC = %.4f; ACC = (%.4f,%.4f)\nPHI = (%.4f,%.4f))" % (pagetitle,auc,accs[default_bias_ind][0],accs[custom_bias_ind][0],phis[default_bias_ind][0],phis[custom_bias_ind][0]),fontsize=15)
#		grid()
#		f1.set_figwidth(6)
#		f1.set_figheight(6)

		pdfpage.savefig()
#		'%s_ROC.pdf' % (outputfn),format='pdf')
		close()

#	print auc,topacc,accs
	
#	print topacc,topphi,
#	print [auc,topacc,accs[topacc_bias][1],topphi,phis[topphi_bias][1],top_tps_bias,top_fps]
	if isnan(custombias):
		return [auc,topacc,topacc_bias,topphi,topphi_bias,top_tps_bias,top_fps]
	else:
		return [auc,accs[custom_bias_ind][0],custombias,phis[custom_bias_ind][0],custombias,top_tps_bias,top_fps]
#auc,topacc,optacc,bias,topphi,optphibias



def optimize_results(db,neg,pos,posval,perfmetric,beta=1,probabilistic=False):


#	print 'hey'
	n = size(db,0)
	allNs = range(n)
	shuffle(allNs)

	db = db[allNs,:]
	db1 = copy(db)
	db = db[argsort(db[:,1]),:]
	
	tp,fp = pos, neg
	N = neg+pos
	tn = neg-fp
	fn = pos-tp
		
	perf = [[(tp+tn)*1.0/N,0,inf,(1+beta)*tp/((1+beta)*tp+beta*fn+fp),0,n]]
#	print perf

	prev_tp = 1.0
	xy_arr = [[1,1]]
	for i in range(n):
		if db[i,0]==posval:                 #positive
			tp-=1.0
		else:
			fp-=1.0


		prev_tp = tp/pos
		xy_arr.insert(0,[fp/neg,tp/pos])

		tn = neg-fp
		fn = pos-tp
		if fp == 0:
			if tp == 0:
				perf.insert(0,[(tp+tn)*1.0/N,0,inf,0,db[i,1],n-i-1])
			else:
				perf.insert(0,[(tp+tn)*1.0/N,(tp*tn-fp*fn)*1.0/sqrt((tp+fp)*(tp+fn)*(tn+fp)*(tn+fn)),inf,(1+beta)*tp/((1+beta)*tp+beta*fn+fp),db[i,1],n-i-1])
		else:
			if fn == 0:
				perf.insert(0,[(tp+tn)*1.0/N,(tp*tn-fp*fn)*1.0/sqrt((tp+fp)*(tp+fn)*(tn+fp)*(tn+fn)),inf,(1+beta)*tp/((1+beta)*tp+beta*fn+fp),db[i,1],n-i-1])
			else:
				perf.insert(0,[(tp+tn)*1.0/N,(tp*tn-fp*fn)*1.0/sqrt((tp+fp)*(tp+fn)*(tn+fp)*(tn+fn)),abs(log((fn/pos)/(fp/neg)/beta)),(1+beta)*tp/((1+beta)*tp+beta*fn+fp),db[i,1],n-i-1])
				
#		print [tp,fp,tn,fn,perf[0][3]]			
#		print perf[0]

	auc = 0.
	prev_x = 0
	for x,y in xy_arr:
		if x != prev_x:
			auc += (x - prev_x) * y
			prev_x = x

#	print perf
	if perfmetric == 'F1':
		topperf = max(perf,key=itemgetter(3))
	elif perfmetric == 'ACC':
		topperf = max(perf,key=itemgetter(0))
	elif perfmatric == 'PHI':
		topperf = max(perf,key=itemgetter(1))
	elif perfmatric == 'FPFNRATIO':
		topperf = min(perf,key=itemgetter(2))

#	print topperf		
	return [topperf[0],topperf[1],topperf[2],topperf[3],auc,topperf[4]]
	

def calc_AUC(db,neg,pos,posval,probabilistic=False,min_fps_in_tp=[],do_plot=False,pdfpage=0,pagetitle = '',custombias=nan,fnfpratio=1):


	n = size(db,0)
	allNs = range(n)
	shuffle(allNs)

	db = db[allNs,:]
#	print db
	db1 = copy(db)
	db = db[argsort(db[:,1]),:]
	
#	print db
	
	xy_arr = [[1,1]]
	topacc = -1
	tp,fp = pos, neg
	#assure float division
	N = neg+pos
#	print N
	tn = neg-fp
	fn = pos-tp
#	print tp,fp,tn,fn,sqrt((tp+fp)*(tp+fn)*(tn+fp)*(tn+fn)),(tp*tn-fp*fn)
	accs = [[(tp+tn)*1.0/N,0,inf,0,n]]
	default_bias_ind = -1
	if not isnan(custombias):
		custom_bias_ind = -1

	if fnfpratio == 'phi' or fnfpratio == 'acc':
		fnfpratio = inf;
		

	prev_tp = 1.0
	top_fps = []
	top_tps_bias = []
	min_fps_ind = -1
#	print posval
	for i in range(n):
		if db[i,0]==posval:                 #positive
			tp-=1.0
		else:
			fp-=1.0


		for min_fp_in_tp in min_fps_in_tp:
			if tp/pos < min_fp_in_tp and prev_tp >= min_fp_in_tp:
				if i == 0:
					top_tps_bias.append(0)
					top_fps.append(fp/neg)
					min_fps_ind = n-i-1
				else:
					top_tps_bias.append(db[i-1,1])
					top_fps.append(fp/neg)
					min_fps_ind = n-i-1

#               print tp/pos,fp/neg,prev_tp,min_fp_in_tp,min_fps_ind,i


		prev_tp = tp/pos

		xy_arr.insert(0,[fp/neg,tp/pos])
		tn = neg-fp
		fn = pos-tp
		
		if fp == 0:
			if tp == 0:
				accs.insert(0,[(tp+tn)*1.0/N,0,inf,db[i,1],n-i-1])
			else:
				accs.insert(0,[(tp+tn)*1.0/N,(tp*tn-fp*fn)*1.0/sqrt((tp+fp)*(tp+fn)*(tn+fp)*(tn+fn)),inf,db[i,1],n-i-1])
		else:
			if fn == 0:
				accs.insert(0,[(tp+tn)*1.0/N,(tp*tn-fp*fn)*1.0/sqrt((tp+fp)*(tp+fn)*(tn+fp)*(tn+fn)),inf,db[i,1],n-i-1])
			else:
				accs.insert(0,[(tp+tn)*1.0/N,(tp*tn-fp*fn)*1.0/sqrt((tp+fp)*(tp+fn)*(tn+fp)*(tn+fn)),abs(log((fn/pos)/(fp/neg)/fnfpratio)),db[i,1],n-i-1])

		if not isnan(custombias):
								
			if db[i,1] > custombias and custom_bias_ind == -1:
				custom_bias_ind = n-i
				
		if ((db[i,1] > 0.5 and probabilistic) or (db[i,1] > 0 and not probabilistic)) and default_bias_ind == -1:
			default_bias_ind = n-i

			
	if isnan(custombias):
		topacc = max(accs,key=itemgetter(0))
#		print topacc
		topacc_bias = topacc[3]
		topacc_ind = topacc[4]
		topacc = topacc[0]
		
		topphi = max(accs,key=itemgetter(1))
#		print topphi
		topphi_bias = topphi[3]
		topphi_ind = topphi[4]
		topphi = topphi[1]

		topfair = min(accs,key=itemgetter(2))
#		print topfair
		topfair_bias = topfair[3]
		topfair_ind = topfair[4]
		topfair_acc = topfair[0]
		topfair_phi = topfair[1]
		
		
#	print phis
	auc = 0.
	prev_x = 0
	for x,y in xy_arr:
		if x != prev_x:
			auc += (x - prev_x) * y
			prev_x = x


#	print xy_arr
	if do_plot:
		f1 = figure(1)
		ax = f1.add_subplot(111)
		for tick in ax.xaxis.get_major_ticks():
			tick.label1.set_fontsize(15)
		for tick in ax.yaxis.get_major_ticks():
			tick.label1.set_fontsize(15)
					
		plot([x[0] for x in xy_arr],[x[1] for x in xy_arr],'k',linewidth=2)
#		ftemp = open('rocpoints.dat','w');
#		for ind in xrange(len(xy_arr)):
#			print >> ftemp, xy_arr[ind][0],',',xy_arr[ind][1],';'
#		ftemp.close()
		if isnan(custombias):
			plot(xy_arr[topacc_ind][0],xy_arr[topacc_ind][1],'ro',markersize=13,markeredgewidth=1.5)
			plot(xy_arr[topphi_ind][0],xy_arr[topphi_ind][1],'mo',markersize=13,markeredgewidth=1.5)
		else:
			plot(xy_arr[custom_bias_ind][0],xy_arr[custom_bias_ind][1],'ro',markersize=13,markeredgewidth=1.5)
		
		plot(xy_arr[default_bias_ind][0],xy_arr[default_bias_ind][1],'bs',markersize=13,markeredgewidth=1.5)
		if min_fps_in_tp != []:
			plot(xy_arr[min_fps_ind][0],xy_arr[min_fps_ind][1],'og')
		
		
#		text(xy_arr[default_bias_ind][0]+0.02,xy_arr[default_bias_ind][1]-0.06,'Default choice (ACC = %.4f)' % (accs[default_bias_ind][0]),fontsize=15)
#		if isnan(custombias):
#			text(xy_arr[topacc_bias[0]][0]+0.04,xy_arr[topacc_bias[0]][1]-0.04,'Optimal choice (ACC = %.4f)' % (topacc),fontsize=15)
#		else:
#			text(xy_arr[custom_bias_ind][0]+0.04,xy_arr[custom_bias_ind][1]-0.04,'Optimal choice (ACC = %.4f)' % (accs[custom_bias_ind][0]),fontsize=15)


		ylim([0,1.04])
		xlim([0,1.01])

		xlabel("False Positive Rate",fontsize=15)
		ylabel("True Positive Rate",fontsize=15)
		if isnan(custombias):
			title("%s (AUC = %.4f; ACC = (%.4f,%.4f)\nPHI = (%.4f,%.4f))" % (pagetitle,auc,accs[default_bias_ind][0],topacc,accs[default_bias_ind][1],topphi),fontsize=15)
		else:
			title("%s (AUC = %.4f; ACC = (%.4f,%.4f)\nPHI = (%.4f,%.4f))" % (pagetitle,auc,accs[default_bias_ind][0],accs[custom_bias_ind][0],accs[default_bias_ind][1],accs[custom_bias_ind][1]),fontsize=15)
#		grid()
#		f1.set_figwidth(6)
#		f1.set_figheight(6)

		pdfpage.savefig()
#		'%s_ROC.pdf' % (outputfn),format='pdf')
		close()

#	print auc,topacc,accs
	
#	print topacc,topphi,
#	print [auc,topacc,accs[topacc_bias][1],topphi,phis[topphi_bias][1],top_tps_bias,top_fps]
	if isnan(custombias):
		if fnfpratio == inf:
			return [auc,topacc,topacc_bias,topphi,topphi_bias,top_tps_bias,top_fps]
		else:
			return [auc,topfair_acc,topfair_bias,topfair_phi,topfair_bias,top_tps_bias,top_fps]
	else:
		return [auc,accs[custom_bias_ind][0],custombias,phis[custom_bias_ind][0],custombias,top_tps_bias,top_fps]


# def calc_F1(db,neg,pos,posval,probabilistic=False,pdfpage=0,betasqr = 1):
# 
# 
# 	n = size(db,0)
# 	allNs = range(n)
# 	shuffle(allNs)
# 
# 	db = db[allNs,:]
# #	print db
# 	db1 = copy(db)
# 	db = db[argsort(db[:,1]),:]
# 	
# #	print db
# 	
# 	topacc = -1
# 	tp,fp = pos, neg
# 	#assure float division
# 	N = neg+pos
# #	print N
# 	tn = neg-fp
# 	fn = pos-tp
# #	print tp,fp,tn,fn,sqrt((tp+fp)*(tp+fn)*(tn+fp)*(tn+fn)),(tp*tn-fp*fn)
# 	accs = [[(1+betasqr)*tp/((1+betasqr)*tp+betasqr*fn+fp),(tp+tn)/N,0,n]]
# 
# 	for i in range(n):
# 		if db[i,0]==posval:                 #positive
# 			tp-=1.0
# 		else:
# 			fp-=1.0
# 
# 		tn = neg-fp
# 		fn = pos-tp
# 				
# 		accs.insert(0,[(1+betasqr)*tp/((1+betasqr)*tp+betasqr*fn+fp),(tp+tn)/N,db[i,1],n-i-1])
# 
# 
# 	topf1 = max(accs,key=itemgetter(0));
# 	topf1_bias = topf1[2]
# 	topf1_ind = topf1[3]
# 	topf1 = topf1[0]
# 	topf1_acc = topf1[1]
# 	
# 	return [topf1,topf1_acc,topf1_bias]