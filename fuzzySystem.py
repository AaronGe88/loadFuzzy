import matlab.engine
from tubeload import *

sths = [0.3, 0.298708498478, 0.295405954123, 0.292129039764, 0.288336187601,0.283675402403,0.277786016464  ]
flsds = [0, 0.0654321089387, 0.262723356485,0.0428052209318,0.0448273979127, 0.047968339175,  0.392084300518]
wrinkles = [0.25,0.249128319319,0.252735789263,0.249351831066,0.249231428839,0.249, 0.249403056825]

def fuzzyCompute(index):
	wrinkle, sth, flsd = sthVol(index)
	print 'sth', sths[index - 1]
	print 'flsd', flsds[index -1]
	print 'wrinkle', wrinkles[index - 1]
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
	dw = 0.262795277084
	dt = sth - sths[index - 1]
	disp = centers[0][1] - centers[1][1]
	eng = matlab.engine.start_matlab()
	feather = matlab.double([dw, dt ,disp,flsd])
	dr = eng.fuzzyController(feather);
	eng.quit()
	dp, df, ratio = dr[0]
	right = df / (1 + ratio)
	left = right * ratio
	
	print 'dp, left, right'
	print dp, left, right