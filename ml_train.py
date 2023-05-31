import numpy as np
from sklearn.linear_model import LogisticRegression
import pandas as pd

try:
    df = pd.read_csv('skills_data.csv')
except:
    df = pd.read_csv('mock_data.csv')

exmpl_num = df.shape[0]
feats_num = df.shape[1]

sal = np.array(df['salary'])
pos = np.array(df['openings'])
x_lst = []

for i in range(exmpl_num):
    x_lst.append([sal[i], pos[i]])

x = np.array(x_lst)
y = np.array(df['targets_training'])

model = LogisticRegression()
model.fit(x, y)