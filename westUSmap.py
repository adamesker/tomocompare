#shows map of extent of study

import pygmt
import numpy as np

#filename to load
fileName = r'models/westus.txt'

#loads data
data = np.loadtxt(fileName)
data = np.dstack(data)

#flattes to 2d to 1d for plotting
lat = data[:,3].flatten()
long = data[:,4].flatten()

fig = pygmt.Figure()
#Mercator projection 8inch
fig.basemap(region=[-138, -90, 27, 55], projection="M8i", frame=True)
#country(1) boundaries and state(2) boundaries
fig.coast(shorelines=True,borders=["1,black","2,black"])
#plot circles 0.08cm in blue
fig.plot(long,lat, style="c0.08c", color="blue")
fig.savefig("dataWestUS.png")
