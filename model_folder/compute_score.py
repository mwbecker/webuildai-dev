from argparse import ArgumentParser
import numpy as np
from sys import exit
import scipy.stats
import itertools
from math import sqrt
from scipy.optimize import minimize
import json, pickle


def parse_input(input_instance):
	split = input_instance.split(",")
	feature = []
	for i in range(len(split)):
		feature.append(float(split[i]))

	feature = np.array(feature)

	return feature


def compute_score(input_instance, model_weights):
	d=len(input_instance)
	k=1
	
	feat_trans = set([])
	feat_trans_dup = list(itertools.product(range(d + 1), repeat=k))
	for t in feat_trans_dup:
		feat_trans.add(tuple(sorted(t)))

	feat_trans = list(feat_trans)
	#feat_trans.remove(tuple([d] * k))

	# Fixing N to be equal to 1 SINCE we do it per user & Not for all X users together.
	N =  1

	d_ext = len(feat_trans)
	learnt_beta = model_weights

	k_instance = []
	
	altA = input_instance
	altA = list(altA)
	altA.append(1)
	
	for t in feat_trans:
		this_prod = 1
		for index in t:
			this_prod *= altA[index]
		k_instance.append(this_prod)

	k_instance = np.array(k_instance)
	#print(learnt_beta.shape)
	#print(k_instance.shape)

	mean_util_0 = np.dot(learnt_beta, k_instance)

	#print(learnt_beta)
	#print(input_instance)
	#print(k_instance)
	#print(mean_util_0)
	return mean_util_0

if __name__ == '__main__':
	parser = ArgumentParser(description="Inputs.")
	parser.add_argument('-w', type=str, default='None', help='weight file pickled')
	parser.add_argument('-i', type=str, default='None', help='Enter the input data point in a csv format. Make sure that the feature order is the same used to train the model.')
	args = parser.parse_args()
	
	input_instance = parse_input(args.i)
	model = pickle.load(open(args.w, 'rb'))

	score = compute_score(input_instance, model)
	print(score)