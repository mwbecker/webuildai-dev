from argparse import ArgumentParser
import numpy as np
from sys import exit
import scipy
import scipy.stats
import itertools
from math import sqrt
from scipy.optimize import minimize
import json
import pickle
import os
import psycopg2
import pandas.io.sql as sqlio


get_local_path = lambda s: os.path.join(os.path.dirname(os.path.realpath(__file__)), s)

def connect():
    connection = None
    try:
        connection = psycopg2.connect(user="mwbecker", host = "127.0.0.1", database="WeBuildAi_development")
        print("Connection Successful")
    except Exception:
        print("Connection ERROR")
        exit(0)

    return connection

def get_possible_feature_values(connection):
    cursor = connection.cursor()
    query = "SELECT * from categorical_data_options"
    df = sqlio.read_sql_query(query, connection)

    possible_values = {}

    data_range_id_values = df['data_range_id'].values
    option_values = df['option_value'].values

    for i in range(len(option_values)):
        try:
            possible_values[int(data_range_id_values[i])].append(option_values[i])
        except KeyError as e:
            possible_values[int(data_range_id_values[i])] = [option_values[i]]

    return possible_values

def convert_categorical_features(feature):
    value = feature['feat_value']
    possible_values = feature['possible_values']

    if (("High" in possible_values) and ("Med" in possible_values) and ("Low" in possible_values)):
        if value == "High":
            mod_value = 1.0
        elif value == "Med":
            mod_value = 0.5
        elif value == "Low":
            mod_value = 0.0

        return mod_value

    elif (("Yes" in possible_values) and ("No" in possible_values)):
        if value == "Yes":
            mod_value = 1.0
        elif value == "No":
            mod_value = 0.0

        return mod_value

    else:
        arr = [0.0] * len(possible_values)
        arr[possible_values.index(value)] = 1.0

    return arr

def scale(feature, is_scale):
    '''
	:param feature: JSON object for the feature
	:param is_scale: Whether to scale OR not.
	:return: scaled OR unscaled value of the feature
	'''
    if (feature['feat_type'] == 'categorical'):
        mod_feature = convert_categorical_features(feature)
        return mod_feature
    else:
        value = float(feature['feat_value'])
        if (is_scale == False):
            mod_value = float(value)
        elif ((is_scale == True) and (feature['feat_type'] == 'continuous')):
            mod_value = float(value)
            mod_value = (value - float(feature['feat_min'])) / (float(feature['feat_max']) - float(feature['feat_min']))
        else:
            print("Not Implemented Yet- Scale")
            exit(0)

    return mod_value

def get_candidates(connection, pid, fid, possible_values, is_scale):

    cursor = connection.cursor()
    query = """
    SELECT a.group_id AS group_id, a.feature_id, a.feature_value,
    b.id AS feature_id, b.name AS feature_name, b.description AS description, b.category AS feat_category,
    c.is_categorical AS categories, c.lower_bound AS lb, c.upper_bound AS ub
    FROM ranklist_samples a, features b, data_ranges c
    WHERE a.pid=%s AND a.round=%s
    AND b.id = a.feature_id
    AND c.feature_id = a.feature_id;         
    """%(str(pid), str(fid))

    all_samples = []
    df = sqlio.read_sql_query(query, connection)

    grouped_df = df.groupby('group_id')
    groups = grouped_df.groups.keys()

    for groupID in groups:
        print("Doing for sample="+str(groupID))
        group_info = grouped_df.get_group(groupID)

        feature_arr= []
        for i in range(len(group_info)):
            feature_obj = {}
            feature_id = group_info.iloc([i])['feature_id']
            feature_value = group_info.iloc([i])['feature_value']
            feature_name = group_info.iloc([i])['feature_name']
            feature_category = group_info.iloc([i])['feat_category']
            feature_type = group_info.iloc([i])['categories']
            if (feature_type == True):
                feature_type = "categorical"
            elif (feature_type == False):
                feature_type = "continuous"
            feature_min = group_info.iloc([i])['lb']
            feature_max = group_info.iloc([i])['ub']
            if (feature_type == 'categorical'):
                f_poss_values = possible_values[feature_id]
            else:
                f_poss_values = []
            feature_obj['possible_values'] = f_poss_values
            feature_arr.append(feature_obj)

        feature_arr = sorted(feature_arr, key=lambda elem: elem["feat_id"])
        num_features = len(feature_arr)

        array_f = []  # Actual Values

        for f1 in feature_arr:
            modified_features = scale(f1, is_scale)

            if (type(modified_features) is list):
                for mf in modified_features:
                    array_f.append(mf)
            else:
                array_f.append(modified_features)


        all_samples.append(array_f)

    return all_samples

def score_model(args):
    connection = connect()
    pid = args.pid
    fid = args.fid
    pairwise_type = args.type
    data_type = args.d
    normalize = args.n
    k = args.k
    loss_fun = args.l
    num_iters = args.num
    size_type = args.sz
    test_frac = args.tf

    #Load Model
    model = pickle.load(
        open('./RESULT/betas/Participant_' + str(pid) + '_' + str(pairwise_type) + '_BETA_Round' + str(fid) + '.pkl',
             'rb'))
    #Score using this model
    possible_values = get_possible_feature_values(connection)
    candidates, imp_features = get_candidates(pid, fid, connection)

    lambda_reg = 1
    d = len(imp_features)

    feat_trans = set([])
    feat_trans_dup = list(itertools.product(range(d + 1), repeat=k))
    for t in feat_trans_dup:
        feat_trans.add(tuple(sorted(t)))

    feat_trans = list(feat_trans)
    feat_trans.remove(tuple([d] * k))

    N = 1
    d_ext = len(feat_trans)
    learnt_beta = np.zeros((N, d_ext))

    score_arr = []
    for i in range(len(candidates)):
        altA = candidates[i][0]
        altA = list(altA)
        altA.append(1)
        k_altA = []
        for t in feat_trans:
            this_prod = 1
            for index in t:
                this_prod *= altA[index]
            k_altA.append(this_prod)

        k_altA = np.array(k_altA)
        score = np.dot(model, k_altA)
        score_arr.append(score)

    return score_arr

if __name__ == '__main__':
    parser = ArgumentParser(description="Inputs.")
    parser.add_argument('-pid', type=str, default='None', help='participant_id')
    parser.add_argument('-fid', type=str, default=0, help='feedback round number')
    parser.add_argument('-type', type=str, default='driver', help='Running model for social/individual preferences')
    args = parser.parse_args()

    score_arr = score_model(args)
    insert_score_arr(connection, score_arr, args)