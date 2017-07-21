def chordless_cycles(g):

	degree_labelling(g)
	T, C = triplets(g)

	while(T):
		p = T.pop() #p is a chordless path
		print "path : " + str(p)
		block_neighbors(p[1])
		C = CC_visit(p, C, label[p[1]])
		unblock_neighbors(p[1])

	return C


def adjency_matrix(g):
	ret = {}
	for v in vertices:
		ret[v] = g.neighbors(v)
	#ret = numpy.array(ret)

	return ret

def degree_labelling(g):
	global label
	global visited
	global blocked
	global degree

	for v in vertices:
		degree[v] = 0
		visited[v] = False
		blocked[v] = 0
		for u in adj[v]:
			degree[v] += 1

	#print "degree : " + str(degree)

	for i in range(n):
		min_degree = n
		for v in vertices:
			if (visited[v] == False and degree[v] < min_degree):
				current_vertex = v
				min_degree = degree[v]

		label[current_vertex] = i
		visited[current_vertex] = True

		for u in adj[vertices[i]]:
			if visited[u] == False:
				degree[u] -= 1


def triplets(g):
	T = set()
	C = set()

	for v in vertices:
		#Generate all triplets on form (x,y,z)
		for x in adj[v]:
			for y in adj[v]:
				if x != y and label[v] < label[x] < label[y]:
					if is_edge(x, y):
						C.add((x,v,y))
					else:
						T.add((x,v,y))

	print "T : " + str(T) + ", C : " + str(C)
	return (T, C)


def CC_visit(p, C, key):
	u = p[-1]
	block_neighbors(u)

	for v in adj[u]:
		if label[v] > key and blocked[v] == 1:
			np = p + (v,) # <==> extend pour un tuple : (1,2) + (3,) = (1,2,3)
			#print "new path : " + str(np)
			if is_edge(v, p[0]):
				#print "adding cycle " + str(np)
				C.add(np)
			else:
				#print "looking for larger cycles..."
				C = CC_visit(np, C, key)

	unblock_neighbors(u)

	return C


def block_neighbors(v):
	for u in adj[v]:
		blocked[u] += 1


def unblock_neighbors(v):
	for u in adj[v]:
		if blocked[u] > 0:
			blocked[u] -= 1

def is_edge(x, y):
	return (x,y) in edges or (y,x) in edges



#g = graphs.PetersenGraph()
g = graphs.CompleteGraph(4)
vertices = g.vertices()
edges = g.edges(labels=False)
n = len(vertices)
m = len(edges)

degree = {}
visited = {}
blocked = {}
label = {}

adj = adjency_matrix(g)
cycles = chordless_cycles(g)

for i, c in enumerate(cycles):
	print "{} : {}".format(i, c)