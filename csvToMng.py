import pymongo
# import pandas as pd
# import numpy as np

myclient = pymongo.MongoClient("mongodb://localhost:27017/")
mydb = myclient["test2"]
# cntfile=open("cntfile.txt","+w")
cntfile=open("cntfile.txt","+r")
reader1=cntfile.readline()

try:
    c=int(reader1)+1
except:
    c=1
collection_name=f"testcol{c}"
mycol = mydb[collection_name]
cntfile.close()
cntfile1=open("cntfile.txt","w")
cntfile1.write(str(c))
#filename=input("Enter file name with extention")
# print(myclient.list_database_names())
# print(mydb.list_collection_names())
#f=open(filename)
try:
    f=open('input.csv')
except:
    f=open('mock_data.csv')
    
header=list(f.readline().split(sep=","))
reader=f.readlines()
i=0
print(header)
for r in reader:
    row=r.split(",")
    dict={}
    dict[header[0]]=row[0]
    dict[header[1]]=row[1]
    dict[header[2]]=row[2]
    dict[header[3]]=row[3]
    # print(dict)
    mycol.insert_one(dict)

   
#    print(row) # dict[]=
# pd.options.display.max_rows = 5

# df  = pd.read_csv('Tech.csv')  
# arr=/df.values
# print(arr)
# mycol.insert_many()
# for x in range(0,5):
    # print(k[x])
    # mycol.insert_one()
# mydataset = {
#   'cars': ["BMW", "Volvo", "Ford"],
#   'passings': [3, 7, 2]
# }
# myvar = pandas.DataFrame(mydataset)