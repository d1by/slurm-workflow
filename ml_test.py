from ml_train import *

try:
    test_df = pd.read_csv('skills_data.csv')
except:
    test_df = pd.read_csv('mock_data.csv')
    
test_num = df.shape[0]

test_sal = np.array(df['salary'])
test_pos = np.array(df['openings'])
test_skill = np.array(df['skill'])

test_list = []

for i in range(test_num):
    test_list.append([test_sal[i], test_pos[i]])

test_vals = np.array(test_list)

pred = model.predict(test_vals)

pred_final = {}
for i in range(np.shape(pred)[0]):
    pred_final[test_skill[i]] = pred[i]

f = open("useful_skills.txt", "a+")

# print("Skills worth learning: ")
# print("-----")

for key in pred_final:
    if(pred_final[key] == 1):
        #print(key)
        f.write(f"{key}\n")