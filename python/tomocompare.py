# python script for the previously created matlab script tomocompare
# core script for processing tomography models for comparison

import glob #for unix style stuff
import csv
import numpy as np
import pandas as pd


#initial parameters (numbers are arbitary and do not have real units) all
#paremeters will be function later on
n1=80 #long
n2=80 #lat
n3=32 #depth

#"latitude curve" pick 1 - 50
latCurve = 35;
#pick P or S waveform
wave = 'P'
waveName = '*' + wave + 'west.txt' #for loading files
#pick percentile to calculate
perc = 30
#flag to see pos or neg velocity comparison pos=1 neg=0
sign = 1
#path for files to load
path = r'../'

#loads all files in a list
allFiles = glob.glob(path + waveName)
#create variable list
varNames = []

data = {}
for file in allFiles:
#finds string length for cutoff on snip (leaves off .txt)
    strLen = len(file) - 4
    varNames.append(file[3:strLen])
    data[file[3:strLen]] = None
varNames = list(data)

#loads tomography files
tomodata = [np.loadtxt(f) for f in allFiles]

#creates xy grid for easier cross section
xy = np.zeros((n1*n2*n3,2))
cnt = 0
for i in range(1,n1+1):
    for j in range(1,n2+1):
        for k in range(1,n3+1):
            xy[cnt][0] = j
            xy[cnt][1] = i
            cnt = cnt + 1
cord = np.column_stack((xy[:,0],xy[:,1],tomodata[0][:,3],tomodata[0][:,4],np.round(tomodata[0][:,6])))
#np.set_printoptions(threshold=np.nan)
#print(cord)
#print(cord.shape)

#determines the percentile for each data set at each depth
for i in range(0,len(allFiles)+1): #loops through each tomo model
    for j in range(0,n3+1): #loops through each depth point
