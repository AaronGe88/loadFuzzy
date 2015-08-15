from odbAccess import *
import matlab.engine
import math
def sthVol (index):
	jobname = 'Job-'+str(index)+'.odb'
	stepname = 'Step-'+str(index)
	odb = openOdb(path = jobname)
	p = odb.rootAssembly.instances['TUBE-1']
	lastFrame = odb.steps[stepname].frames[-1]
	coordinates = lastFrame.fieldOutputs['COORD']
	flsds = lastFrame.fieldOutputs['FLDCRT']
	
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
	tubeFlsds = flsds.getSubset(region = body)
	thickness = []
	eleLabels = []
	volume = []
	flsdList = []
	for v in tubeSTH.values:
		thickness.append(v.data)
		eleLabels.append(v.elementLabel)
	for v in tubeEVOL.values:
		volume.append(v.data)
	
	
	for f in tubeFlsds.values:
		flsdList.append(f)
	flsdList.sort(lambda x,y:cmp(x.elementLabel,y.elementLabel))
	e0Label = flsdList[0].elementLabel
	
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
	
	mxEvol = matlab.double(volume)
	mxThickness = matlab.double(thickness)
	sa = eng.mxShellArea(mxEvol, mxThickness)
	
	ratio = sa / float (partVolume)

	
	eles = matlab.double([thickness])
	labels = matlab.double([eleLabels])
	thinmost = eng.mxThinmost(eles, labels)
	thin = thinmost[0][0]
	eng.quit()
	

	thinmostLabel = thinmost[0][1] - e0Label
	thinmostLabel = int(thinmostLabel)

	
	flsdValue = flsdList[thinmostLabel].data
	odb.close()
	return ratio, thin, flsdValue
	
def centroids (index):
	jobname = 'Job-'+str(index)+'.odb'
	stepname = 'Step-'+str(index)
	odb = openOdb(path = jobname)
	p = odb.rootAssembly.instances['TUBE-1']
	lastFrame = odb.steps[stepname].frames[-1]
	
	evol = lastFrame.fieldOutputs['EVOL']
	body =  p.elementSets['SET-ELEMENT']
	tubeEVOL = evol.getSubset(region = body)
	es = []
	for e in tubeEVOL.values:
		es.append(e)
	es.sort(lambda x,y:cmp(x.elementLabel,y.elementLabel))
	
	escon = []
	for e in p.elements:
		escon.append(e)
	escon.sort(lambda x,y:cmp(x.label,y.label))
	
	coordinates = lastFrame.fieldOutputs['COORD']
	nset = p.nodeSets['SET-NODES']
	
	tubeCoordinates = coordinates.getSubset(region = nset)
	# nodelist = []
	# for v in tubeCoordinates.values:
		# nodeList.append([v.data[0],v.data[1],v.data[2]],v.nodeLabel)
	ns = []
	for n in tubeCoordinates.values:
		ns.append(n)
	ns.sort(lambda x,y:cmp(x.nodeLabel,y.nodeLabel))
	
	n0 = ns[0].nodeLabel
	nodeLen = len(ns)

	nodeMass = [0]
	nodeMass = nodeMass * nodeLen
	for e, ec in zip(es, escon):
		n2e = ec.connectivity
		divMass = e.data / len(n2e)
		for n in n2e:
			nodeMass[n - n0] = nodeMass[n - n0] + divMass
			
	nodeList = []
	for n in ns:
		nodeList.append([n.data[0],n.data[1],n.data[2]])
	odb.close()

	eng = matlab.engine.start_matlab()
	coordMat = matlab.double(nodeList)
	massMat = matlab.double(nodeMass)
	centers = eng.mxCentroids(coordMat, massMat)
	eng.quit()
	return centers