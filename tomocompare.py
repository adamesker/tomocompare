# python script for the previously created matlab script tomocompare
# core script for processing tomography models for comparison

import glob #for unix style stuff
import csv
import numpy as np
import matplotlib.pyplot as plt
import scipy.io as sio


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
#tomodata = [np.loadtxt(f) for f in allFiles]
#tomodata = np.dstack(tomodata)
loadin = sio.loadmat(path + "data" + wave,mdict=None)
tomodata = loadin['data']

#creates xy grid for easier cross section
xy = np.zeros((n1*n2*n3,2))
cnt = 0
for i in range(1,n1+1):
    for j in range(1,n2+1):
        for k in range(1,n3+1):
            xy[cnt][0] = j
            xy[cnt][1] = i
            cnt = cnt + 1
cord = np.column_stack((xy[:,0],xy[:,1],tomodata[:,3,0],tomodata[:,4,0],np.round(tomodata[:,6,0])))
np.set_printoptions(threshold=np.nan)
#print(cord)
#print(cord.shape)
tmpvalues = []
depthPerc = np.empty(shape=[n3,len(varNames)])
posvalues = []
#determines the percentile for each data set at each depth
for i in range(0,len(allFiles)): #loops through each tomo model
    for j in range(0,n3): #loops through each depth point
        tmpvalues = tomodata[j:-1:n3,7,i]#gets rel vel at each depth
        if sign == 1:
            for k in tmpvalues:
                if k > 0 and k != 1e7 and k != -1e7:
                    posvalues.append(k)
            if len(posvalues) != 0:
                depthPerc[j][i] = np.percentile(posvalues,perc)
            else:
                depthPerc[j][i] = 0
            posvalues = []
#very elegent solution to repeat depth like in imported tomo data.
#easier to process data set. noticed small rounding error compared to matlabs
#output but unlikey to affect final result
depthPercCat = np.transpose(np.tile(np.transpose(depthPerc),n1*n2))
posData = np.zeros((n1*n2*n3,len(allFiles)))
#determines 0 or 1 if new array meets percentile threshold
for i in range(0,len(allFiles)):
    tmp = tomodata[:,7,i]
    if sign==1:
        for j in range(0,len(tmp)):
            if tmp[j] >= depthPercCat[j,i] and tmp[j] != 1e7:
                posData[j,i] = 1

#sums up pos data and transform array from 1D to 2D so it can concatenate
modelSum = np.array(np.sum(posData,axis=1), copy=False, subok=True, ndmin=2).T
model = np.concatenate((cord,modelSum,posData),1)

#gets selected "latitude curve"
selCoord = model[model[:,0] == latCurve]
#plotting
#fig = plt.figure()
print("here")
x = np.linspace(min(selCoord[:,3]),max(selCoord[:,3]))
X,Y = np.meshgrid(selCoord[:,3],selCoord[:,4])


#fig1, ax2 = plt.subplots(constrained_layout=True)


#ax = fig.add_subplot(111)
#plt.scatter(selCoord[:,3],selCoord[:,4],c=selCoord[:,5],cmap='jet')
#plt.gca().invert_yaxis()
#plt.xlabel('Longitude')
#plt.ylabel('Depth(km)')
#savefig('foo.png')
#plt.show()
