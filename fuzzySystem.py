import matlab.engine
from tubeload import *

sths = [0,0,0,0,0,0,0,0.2982]
flsds = [0,0,0,0,0,0,0,0.14]
wrinkles = [0,0,0,0,0,0,0,0.2543]
def fuzzyCompute(index):
	wrinkle, sth, flsd = sthVol(index)
	print 'wrinkle, sth, flsd'
	print wrinkle, sth, flsd
	centers = centroids(index)
	print 'centers'
	print centers
	global wrinkles
	wrinkles.append(wrinkle)
	global sths
	sths.append(sth)
	global flsds
	flsds.append(flsd)
	dw = wrinkle - wrinkles[index - 1]
	dt = sth - sths[index - 1]
	disp = centers[0][1] - centers[1][1]
	eng = matlab.engine.start_matlab()
	feather = matlab.double([dw, dt ,disp,flsd])
	dr = eng.fuzzyController(feather);
	eng.quit()
	dp, df, ratio = dr[0]
	left = df / (1 + ratio)
	right = left * ratio
	
	print 'dp, left, right'
	print dp, left, right