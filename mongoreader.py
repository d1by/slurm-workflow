import pymongo
# import pandas as pd
# import numpy as np

myclient = pymongo.MongoClient("mongodb://localhost:27017/")
mydb = myclient["test2"]
f1=open("skills_data.csv","+w")
# cntfile=open("cntfile.txt","+r")
# reader1=cntfile.readline()
# c=int(reader1)

cntfile=open("cntfile.txt","+r")
reader1=cntfile.readline()
try:
    c=int(reader1)+1
except:
    c=1
collection_name=f"testcol{c+1}"

mycol = mydb[collection_name]   
# print(mycol.find_one())
i=0

for row in mycol.find():
    if(i==0):
        x=list(row.keys())[1:]
        f1.write(x[0]+","+x[1]+","+x[2]+","+x[3]+"\n")
   
    x=list(row.values())[1:]
    i+=1        
    if(x[3][len(x[3])-1]!="\n"):
        f1.write(x[0]+","+x[1]+","+x[2]+","+x[3]+"\n")
    else:
        f1.write(x[0]+","+x[1]+","+x[2]+","+x[3])