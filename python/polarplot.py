import numpy as np
import matplotlib.pyplot as plt
fig = plt.figure()

ax = fig.add_axes([0.1, 0.1, 0.8, 0.8], polar=True)
ax.plot(np.arange(30), np.arange(30) / 30. + 1)
ax.set_ylim(2, 1)  # out of order, and hence didn't draw properly.

plt.show()
