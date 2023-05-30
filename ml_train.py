import numpy as np
from sklearn.linear_model import LogisticRegression
from sklearn.inspection import DecisionBoundaryDisplay
import pandas as pd
import matplotlib.pyplot as plt

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

# new_data = np.array([[123123, 1000]])
# pred = model.predict(new_data)

display = DecisionBoundaryDisplay(
    xx0 = sal, xx1 = pos, response = y
)

display.plot()