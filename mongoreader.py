import pymongo
# import pandas as pd
# import numpy as np

myclient = pymongo.MongoClient("mongodb://localhost:27017/")
mydb = myclient["test2"]
f1=open("Output_CSV_File.csv","+a")
# cntfile=open("cntfile.txt","+r")
# reader1=cntfile.readline()
# c=int(reader1)

collection_name="testcol3"
mycol = mydb[collection_name]   
# print(mycol.find_one())
i=0
for row in mycol.find():
    
    # print(list(row.values()))
    x=list(row.values())[1:]
    f1.write(x[0]+","+x[1]+","+x[2])

    


