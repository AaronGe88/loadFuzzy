from odbAccess import *
import matlab.engine
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
	print centers
	