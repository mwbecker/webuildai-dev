from argparse import ArgumentParser
import numpy as np
from sys import exit
import scipy.stats
import itertools
from math import sqrt
from scipy.optimize import minimize
import json
import pickle


def setup():
	normalize = 1
	d = 8	# Number of Features
	k = 1	#Degree of Polynomial
	N = 1	#Number of Files
	
	choice_ind = 16	#Index for alternative(A or B

	# Indices for all the features (of the alternative A)
	size_ind = 1
	access_ind = 2
	income_ind = 3
	poverty_ind = 4
	lastDon_ind = 5
	totalDon_ind = 6
	dist_ind = 7

	# Offset from above ind's to get indices for the alternative B
	second_offset = 7

	# Scales of the feature values
	size_scale = 1
	access_scale = 1
	income_scale = 1
	poverty_scale = 1
	lastDon_scale = 1
	totalDon_scale = 1
	dist_scale = 1

	if normalize == 1:	# Scaling the features to [0,1]
		size_scale = 1000.0
		access_scale = 2.0
		income_scale = 110.0
		poverty_scale = 65.0
		lastDon_scale = 12.0
		totalDon_scale = 12.0
		dist_scale = 60.0

	totalDon_dict = {}
	ind_till_now = 0
	for tot_don in range(13):
		for rep in range(tot_don+1):
			totalDon_dict[str(ind_till_now)] = tot_don/totalDon_scale
			ind_till_now += 1

	totalDon_sep_dict = {}
	ind_till_now = 0
	for tot_don in range(13):
		for rep in range(tot_don + 1):
			totalDon_sep_dict[str(ind_till_now)] = (tot_don, rep / totalDon_scale, (tot_don - rep) / totalDon_scale)  # total donation, number of common donations, number of less common donations
			ind_till_now += 1

	dist_dict = {'0':15/dist_scale,'1':30/dist_scale,'2':45/dist_scale,'3':60/dist_scale}

	# added an extra dummy variable at index d to mean multiplication by 1
	feat_trans = set([])
	feat_trans_dup = list(itertools.product(range(d+1), repeat=k))
	for t in feat_trans_dup:
		feat_trans.add(tuple(sorted(t)))

	feat_trans = list(feat_trans)
	feat_trans.remove(tuple([d]*k))

	d_ext = len(feat_trans)
	learnt_beta = np.zeros((N,d_ext))

def normal_likeli(beta):	# negative of the log-likelihood
	# print(f'normal likeli: {-np.sum(scipy.stats.norm.logcdf(np.dot(this_diff, beta)))}')
	# L2 regularization
	reg_penalty = lambda_reg * np.dot(beta, beta)
	return -np.sum(scipy.stats.norm.logcdf(np.dot(this_diff, beta))) - reg_penalty

def der_normal_likeli(beta):
	dot_prod = np.dot(this_diff, beta)
	pdfs = scipy.stats.norm.pdf(dot_prod)
	cdfs = scipy.stats.norm.cdf(dot_prod)

	grad = np.zeros(d_ext)
	for j in range(n_train):
		grad += this_diff[j] * pdfs[j] / (max(cdfs[j], THRES))

	# print(f'normal grad: {grad}')
	reg_penalty = 2 * np.sum(beta)

	return -grad - reg_penalty

def logistic_likeli(beta):	# negative of the log-likelihood
	return np.sum(np.log(1 + np.exp(-np.dot(this_diff, beta))))

def der_logistic_likeli(beta):
	dot_prod = np.dot(this_diff, beta)
	grad = np.zeros(d_ext)
	for j in range(n_train):
		grad += this_diff[j] * np.exp(-dot_prod[j]) / (1 + np.exp(-dot_prod[j]))
	
	return -grad

#First Read Comparisons File
def read_file(in_file):

	compars_str = np.genfromtxt(in_file, dtype=str, delimiter=',', skip_header=0)
	compars = []

	for row in compars_str:
		# Do not read if there is nothing for the alternative
		if(row[choice_ind] == ''):
			continue

		if(row[poverty_ind]=='7' or row[poverty_ind + second_offset] == '7'): #Filtering all rows with 7
			continue

		# Extract Donation Types
		(totalDonA, totalCommonDonA, totalLessCommonDonA) = totalDon_sep_dict[row[totalDon_ind]]
		(totalDonB, totalCommonDonB, totalLessCommonDonB) = totalDon_sep_dict[row[second_offset + totalDon_ind]]

		don_type = None
		num_specific_don = 0
		if row[don_type_ind] == '0':
			don_type = 'common'
		elif row[don_type_ind] == '1':
			don_type = 'lesscommon'
		else:
			exit('Invalid donation type')


		altA = []
		altA.append(size_dict[row[size_ind]])
		altA.append(access_dict(row[access_ind]))
		altA.append(income_dict[row[income_ind]])
		altA.append(poverty_dict[row[poverty_ind]])
		altA.append(lastDon_dict(row[lastDon_ind]))
		altA.append(dist_dict[row[dist_ind]])
		altA.append(totalCommonDonA)
		altA.append(totalLessCommonDonA)

		altB = []
		altB.append(size_dict[row[size_ind + second_offset]])
		altB.append(access_dict(row[access_ind + second_offset]))
		altB.append(income_dict[row[income_ind + second_offset]])
		altB.append(poverty_dict[row[poverty_ind + second_offset]])
		altB.append(lastDon_dict(row[lastDon_ind + second_offset]))
		altB.append(dist_dict[row[dist_ind + second_offset]])
		altB.append(totalCommonDonB)
		altB.append(totalLessCommonDonB)

		if(row[choice_ind] == 'A'):
			compars.append([altA, altB])
		elif(row[choice_ind] == 'B'):
			compars.append([altB, altA])

	n = len(compars)
	compars = np.array(compars)

	return compars

def split_train_test(compars, test_frac, feat_trans):
	n = len(compars)
	np.random.shuffle(compars)

	n_test = int(test_frac * n)
	n_train = n - n_test
	
	train_comps = compars[:n_train,:,:]
	test_comps = compars[n_train:,:,:]

	k_train_comps = []
	for j in range(n_train):
		altA = train_comps[j,0,:]
		altA = list(altA)
		altA.append(1)
		k_altA = []
		for t in feat_trans:
			this_prod = 1
			for index in t:
				this_prod *= altA[index]
			k_altA.append(this_prod)

		altB = train_comps[j,1,:]
		altB = list(altB)
		altB.append(1)
		k_altB = []
		for t in feat_trans:
			this_prod = 1
			for index in t:
				this_prod *= altB[index]
			k_altB.append(this_prod)

		k_train_comps.append([k_altA, k_altB])
	k_train_comps = np.array(k_train_comps)


	k_test_comps = []
	for j in range(n_test):
		altA = test_comps[j,0,:]
		altA = list(altA)
		altA.append(1)
		k_altA = []
		for t in feat_trans:
			this_prod = 1
			for index in t:
				this_prod *= altA[index]
			k_altA.append(this_prod)

		altB = test_comps[j,1,:]
		altB = list(altB)
		altB.append(1)
		k_altB = []
		for t in feat_trans:
			this_prod = 1
			for index in t:
				this_prod *= altB[index]
			k_altB.append(this_prod)

		k_test_comps.append([k_altA, k_altB])
	k_test_comps = np.array(k_test_comps)

	return k_train_comps, k_test_comps, n_train, n_test

def model_running(k_train_comps, k_test_comps):
	
	n_test = len(k_test_comps)
	n_train = len(k_train_comps)
	
	THRES = 0.00001	#Threshold for CDF value

	# Learn parameters of voter i using his comparisons, by gradient descent
	this_diff = np.zeros((n_train,d_ext))

	for j in range(n_train):	# Pre-compute X_j - Z_j and store
		this_diff[j,:] = k_train_comps[j,0,:] - k_train_comps[j,1,:]

	this_beta = np.random.uniform(-0.001,0.001,d_ext)	# Initialize parameter randomly	# Could instead use np.zeros(d), since it's a convex program
	
	def normal_likeli(beta):	# negative of the log-likelihood
		# print(f'normal likeli: {-np.sum(scipy.stats.norm.logcdf(np.dot(this_diff, beta)))}')
		# L2 regularization
		reg_penalty = lambda_reg * np.dot(beta, beta)
		return -np.sum(scipy.stats.norm.logcdf(np.dot(this_diff, beta))) - reg_penalty

	def der_normal_likeli(beta):
		dot_prod = np.dot(this_diff, beta)
		pdfs = scipy.stats.norm.pdf(dot_prod)
		cdfs = scipy.stats.norm.cdf(dot_prod)

		grad = np.zeros(d_ext)
		for j in range(n_train):
			grad += this_diff[j] * pdfs[j] / (max(cdfs[j], THRES))

		# print(f'normal grad: {grad}')
		reg_penalty = 2 * np.sum(beta)

		return -grad - reg_penalty

	def logistic_likeli(beta):	# negative of the log-likelihood
		return np.sum(np.log(1 + np.exp(-np.dot(this_diff, beta))))

	def der_logistic_likeli(beta):
		dot_prod = np.dot(this_diff, beta)

		grad = np.zeros(d_ext)
		for j in range(n_train):
			grad += this_diff[j] * np.exp(-dot_prod[j]) / (1 + np.exp(-dot_prod[j]))

		return -grad
	
	if(loss_fun == 'normal'):
		likeli = normal_likeli
		der_likeli = der_normal_likeli
	elif(loss_fun == 'logistic'):
		likeli = logistic_likeli
		der_likeli = der_logistic_likeli

	res = minimize(likeli, this_beta, method='BFGS', jac=der_likeli, options={'gtol': 1e-10, 'disp': False})
	this_beta = res.x

	learnt_beta[0,:] = this_beta
	
	num_correct = 0
	soft_loss = 0
	incorrect_comps = []
	correct_comps = []
	for j in range(n_test):
		mean_util_0 = np.dot(this_beta, k_test_comps[j,0,:])
		mean_util_1 = np.dot(this_beta, k_test_comps[j,1,:])

		# Pr(A > B) = Pr(A - B > 0)
		# A - B ~ N(mu_A - mu_B, sigma_A^2 + sigma_B^2) <-- A, B independent so no correlation term in var
		prob_0_beats_1 = scipy.stats.norm.cdf(mean_util_0 - mean_util_1, scale=2)

		if(mean_util_0 > mean_util_1):	# Correct prediction
			num_correct += 1
			correct_comps.append([list(k_test_comps[j,0,:]), list(k_test_comps[j,1,:])])
		else:
			incorrect_comps.append([list(k_test_comps[j,0,:]), list(k_test_comps[j,1,:])])
			soft_loss += (1 - prob_0_beats_1)**2  # squared soft loss; else, best to predict 0/1

	# write incorrect comparisons out to file
	if len(incorrect_comps) > 0:
		#incorrect_comps_filename = f'DONTYPE/incorrect_comps/{data_files[i]}_{k}_{loss_fun}_{size_type}_{int(test_frac * 100)}_dt{dt}_errors.txt'
		incorrect_comps_filename = 'Incorrect_COMPARS.txt'
		with open(incorrect_comps_filename, 'w') as incorrect_outfile:
			for incorrect_comp in incorrect_comps:
				incorrect_outfile.write(str(incorrect_comp))
				incorrect_outfile.write('\n')

	# write correct comparisons out to file
	if len(correct_comps) > 0:
		#correct_comps_filename = f'DONTYPE/correct_comps/{data_files[i]}_{k}_{loss_fun}_{size_type}_{int(test_frac * 100)}_dt{dt}_errors.txt'
		correct_comps_filename = 'Correct_COMPARS.txt'
		with open(correct_comps_filename, 'w') as correct_outfile:
			for correct_comp in correct_comps:
				correct_outfile.write(str(correct_comp))
				correct_outfile.write('\n')

	return soft_loss, num_correct, n_test, correct_comps, incorrect_comps, indiv_acc, learnt_beta

def scale(feature, is_scale):
	'''
	:param feature: JSON object for the feature
	:param is_scale: Whether to scale OR not.
	:return: scaled OR unscaled value of the feature
	'''
	value = float(feature['feat_value'])
	if(is_scale==False):
		mod_value = value
	elif((is_scale==True) and (feature['feat_type']=='continuous')):
		mod_value = (value - float(feature['feat_min']))/(float(feature['feat_max']) - float(feature['feat_min']))
	else:
		print("Not Implemented Yet- Scale")
		exit(0)

	return mod_value

def read_input_file(json_file, is_scale=True):
	json_obj = json.load(open(json_file, 'r'))
	pid = json_obj['part_id']
	all_samples = json_obj['comparisons']
	num_samples = len(all_samples)

	imp_features = set()
	feature_array1 = []
	feature_array2 = []

	sample = []


	for pairwise_sample in all_samples:
		scenario_1 = pairwise_sample['scenario_1']
		scenario_2 = pairwise_sample['scenario_2']

		num_features1 = len(scenario_1)
		num_features2 = len(scenario_2)

		assert num_features1 == num_features2

		feat_ids1 = []
		feat_ids2 = []

		array_1 = []
		array_2 = []

		for f1 in scenario_1:
			feat_ids1.append(f1['feat_id'])
			array_1.append(scale(f1, is_scale))
			imp_features.add(f1['feat_id'])

		feature_array1.append(feat_ids1)

		for f2 in scenario_2:
			feat_ids2.append(f2['feat_id'])
			array_2.append(scale(f2, is_scale))
			imp_features.add(f2['feat_id'])

		feature_array2.append(feat_ids2)

		for k in range(len(feat_ids1)):
			assert feat_ids1[k] == feat_ids2[k]


		choice = pairwise_sample['choice']
		sample.append([array_1, array_2, choice])

	assert len(sample)==num_samples

	return pid, sample, imp_features, feature_array1

def main2(args):
	inp_file = args.file
	data_type = args.d
	normalize = args.n
	k = args.k
	loss_fun = args.l
	num_iters = args.num
	size_type = args.sz
	test_frac = args.tf

	pid, data,imp_features,feature_array1 = read_input_file(inp_file, is_scale=True)
	print("Data Read. Length="+str(len(data)))

	lambda_reg = 1
	d=len(imp_features)

	print("="*5+"IMP FEATURES"+"="*5)
	print(imp_features)
	print("="*10)
	print("="*3+"Feature Array"+"="*3)
	print(feature_array1)
	print("="*10)

	# Following assertion removed due to wrong sample data.
	#assert d == len(feature_array1[0])

	feat_trans = set([])
	feat_trans_dup = list(itertools.product(range(d + 1), repeat=k))
	for t in feat_trans_dup:
		feat_trans.add(tuple(sorted(t)))

	feat_trans = list(feat_trans)
	feat_trans.remove(tuple([d] * k))

	# Fixing N to be equal to 1 SINCE we do it per user & Not for all X users together.
	N =  1

	d_ext = len(feat_trans)
	learnt_beta = np.zeros((N, d_ext))

	compars = []
	for i in range(len(data)):
		print(i)
		altA = data[i][0]
		altB = data[i][1]
		choice = data[i][2]


		if(choice == 'A'):
			compars.append(np.array([altA, altB]))
		else:
			compars.append(np.array([altB, altA]))


	compars = np.array(compars)
	print("Length of comparisons="+str(len(compars)))

	for iter in range(num_iters):
		total_num_correct = 0
		total_test_compars = 0
		total_soft_loss = 0

		# compars[j,0,:] is first alternative of comparison j, and compars[j,1,:] is the other.
		# Storing such that the 0 alternative is chosen over 1 alternative.
		
		k_train_comps, k_test_comps, n_train, n_test  = split_train_test(compars, test_frac, feat_trans)		
		
		# ETA = 0.00000001	# Learning rate
		# EPS = 0.00005	# Stopping criteria parameter
		THRES = 0.00001  # Threshold for cdf value. If smaller than this, then just use this

		# Learn parameters of voter i using his comparisons, by gradient descent
		this_diff = np.zeros((n_train, d_ext))

		for j in range(n_train):  # Pre-compute X_j - Z_j and store
			this_diff[j, :] = k_train_comps[j, 0, :] - k_train_comps[j, 1, :]

		this_beta = np.random.uniform(-0.001, 0.001,
									  d_ext)  # Initialize parameter randomly	# Could instead use np.zeros(d), since it's a convex program

		'''
            REGULARIZATION
        '''

		def normal_likeli(beta):  # negative of the log-likelihood
			# print(f'normal likeli: {-np.sum(scipy.stats.norm.logcdf(np.dot(this_diff, beta)))}')

			# L2 regularization
			reg_penalty = lambda_reg * np.dot(beta, beta)

			return -np.sum(scipy.stats.norm.logcdf(np.dot(this_diff, beta))) - reg_penalty

		def der_normal_likeli(beta):
			dot_prod = np.dot(this_diff, beta)
			pdfs = scipy.stats.norm.pdf(dot_prod)
			cdfs = scipy.stats.norm.cdf(dot_prod)

			grad = np.zeros(d_ext)
			for j in range(n_train):
				grad += this_diff[j] * pdfs[j] / (max(cdfs[j], THRES))

			# print(f'normal grad: {grad}')
			reg_penalty = 2 * np.sum(beta)

			return -grad - reg_penalty

		def logistic_likeli(beta):  # negative of the log-likelihood
			return np.sum(np.log(1 + np.exp(-np.dot(this_diff, beta))))

		def der_logistic_likeli(beta):
			dot_prod = np.dot(this_diff, beta)

			grad = np.zeros(d_ext)
			for j in range(n_train):
				grad += this_diff[j] * np.exp(-dot_prod[j]) / (1 + np.exp(-dot_prod[j]))

			return -grad

		if (loss_fun == 'normal'):
			likeli = normal_likeli
			der_likeli = der_normal_likeli
		elif (loss_fun == 'logistic'):
			likeli = logistic_likeli
			der_likeli = der_logistic_likeli

		res = minimize(likeli, this_beta, method='BFGS', jac=der_likeli, options={'gtol': 1e-10, 'disp': False})
		this_beta = res.x

		# print("Learnt parameters for " + data_files[i] + ":", this_beta, '\n')
		learnt_beta[0, :] = this_beta	
	
	soft_loss, num_correct, n_test = test(this_beta, np.vstack((k_train_comps, k_test_comps)), n_test, pid, loss_fun, size_type, test_frac)
	print("FINAL LEARNT BETA")
	print(this_beta)

	print("Soft LOSS="+str(soft_loss))
	print("Accuracy="+str(float(num_correct)/n_test))
	pickle.dump(this_beta, open("RESULT/betas/Participant_"+str(pid)+"_BETA_Round0.pkl",'wb'))

	return this_beta, soft_loss, num_correct, n_test


def test(this_beta, k_test_comps, n_test, pid, loss_fun, size_type, test_frac):
	num_correct = 0
	soft_loss = 0
	incorrect_comps = []
	correct_comps = []

	for j in range(n_test):
		mean_util_0 = np.dot(this_beta, k_test_comps[j, 0, :])
		mean_util_1 = np.dot(this_beta, k_test_comps[j, 1, :])

		prob_0_beats_1 = scipy.stats.norm.cdf(mean_util_0 - mean_util_1, scale=2)

		if(mean_util_0 > mean_util_1):
			num_correct += 1
			correct_comps.append([list(k_test_comps[j,0,:]), list(k_test_comps[j,1,:])])
		else:
			incorrect_comps.append([list(k_test_comps[j,0,:]), list(k_test_comps[j,1,:])])

		soft_loss += (1 - prob_0_beats_1) ** 2

	if(len(incorrect_comps)>0):
		incorrect_comps_filename = "RESULT/incorrect_comps/Participant_"+str(pid)+"_"+str(loss_fun)+"_"+str(size_type)+"_"+str(int(test_frac)*100)+"_errors.txt"
		with open(incorrect_comps_filename, 'w') as incorrect_outfile:
			for incorrect_comp in incorrect_comps:
				incorrect_outfile.write(str(incorrect_comp))
				incorrect_outfile.write('\n')

	# write correct comparisons out to file
	if len(correct_comps) > 0:
		correct_comps_filename = "RESULT/correct_comps/Participant_"+str(pid)+"_"+str(loss_fun)+"_"+str(size_type)+"_"+str(int(test_frac)*100)+"_correct.txt"
		with open(correct_comps_filename, 'w') as correct_outfile:
			for correct_comp in correct_comps:
				correct_outfile.write(str(correct_comp))
				correct_outfile.write('\n')

	print("soft loss="+str(soft_loss)+" accuracy="+str(float(num_correct)/float(n_test)))
	return soft_loss, num_correct, n_test

if __name__ == '__main__':
	parser = ArgumentParser(description="Inputs.")
	parser.add_argument('-file', type=str, default='None', help='input participant file')
	parser.add_argument('-d', type=str, default='D', help='data type (str)')
	parser.add_argument('-n', type=int, default=1, help='normalize features (int)')
	parser.add_argument('-k', type=int, default=1, help='degree of polynomial (int)')
	parser.add_argument('-l', type=str, default='normal', help='loss function(str')
	parser.add_argument('-num', type=int, default=100, help='value of num iters>0 (int)')
	parser.add_argument('-sz', type=str, default='cardinalsizes', help='size type (str)')
	parser.add_argument('-tf', type=float, default=0.15, help = 'test frac (float)')
	args = parser.parse_args()
	
	beta, soft_loss, num_correct, n_test = main2(args)

