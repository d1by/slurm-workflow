from ml_train import *
import matplotlib.pyplot as plt
 
b = model.intercept_[0]
w1, w2 = model.coef_.T

c = -b/w2
m = -w1/w2
xmin, xmax = 20000, 150000
ymin, ymax = 0, 7000
xd = np.array([xmin, xmax])
yd = m*xd + c
plt.plot(xd, yd, 'k', lw=1, ls='--')
plt.fill_between(xd, yd, ymin, color='tab:blue', alpha=0.2)
plt.fill_between(xd, yd, ymax, color='tab:orange', alpha=0.2)

plt.scatter(*x[y==0].T, s=8, alpha=0.5)
plt.scatter(*x[y==1].T, s=8, alpha=0.5)
plt.xlim(xmin, xmax)
plt.ylim(ymin, ymax)
plt.ylabel(r'$x_2$')
plt.xlabel(r'$x_1$')

plt.show()