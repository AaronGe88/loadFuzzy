from odbAccess import *
import matlab.engine
import math
def loadPost (index):
	jobname = 'Job-'+str(index)+'.odb'
	stepname = 'Step-'+str(index)
	odb = openOdb(path = jobname)
	p = odb.rootAssembly.instances['TUBE-1']
	lastFrame = odb.steps[stepname].frames[-1]
	coordinates = lastFrame.fieldOutputs['COORD']
	n = p.nodeSets['SET-NODES']
	tubeCoordinates = coordinates.getSubset(region = n)
	nodeList = []
	for v in tubeCoordinates.values:
		nodeList.append([v.data[0],v.data[1],v.data[2]])
	
	nodeList.sort(lambda x,y:cmp(x[1],y[1]))
	# 0~ 61
	slideList = []
	for ii in range(0,236):
		slide = nodeList[ii*62:ii*62+61]
		slideList.append(slide)

	sth = lastFrame.fieldOutputs['STH']
	evol = lastFrame.fieldOutputs['EVOL']

	body =  p.elementSets['SET-ELEMENT']
	tubeSTH = sth.getSubset(region = body)
	tubeEVOL = evol.getSubset(region = body)
	thickness = []
	volume = []
	for v in tubeSTH.values:
		thickness.append(v.data)
	
	for v in tubeEVOL.values:
		volume.append(v.data)
	
	
	odb.close()
	
	eng = matlab.engine.start_matlab()

	slideArea = []
	axialPositions = []
	normals = []
	for slide in slideList:
		mxSlide = matlab.double(slide)
		s = eng.mxArea(mxSlide)

		slideArea.append(s)
		
		axialPos = eng.mxDistance(mxSlide)
		axialPositions.append(axialPos)
		
		nor = eng.mxNormal(mxSlide)
		normals.append(nor)
	
	mxSA = matlab.double(slideArea)
	mxAP = matlab.double(axialPositions)
	mxNm = matlab.double(normals)
	partVolume = eng.mxVolume(mxSA, mxAP, mxNm)
	
	print partVolume
	mxEvol = matlab.double(volume)
	mxThickness = matlab.double(thickness)
	sa = eng.mxShellArea(mxEvol, mxThickness)
	
	ratio = sa / float (partVolume)
	print ratio
	eng.quit()