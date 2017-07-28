# -*- coding: utf-8 -*-
####### D'après l'article : https://arxiv.org/pdf/1205.2766.pdf #######

def is_back_edge(edge, seen):
	return edge[1] in seen


r"""
def all_cycles_iterator(g):
	root = g.vertices()[0]
	dfs = g.depth_first_search(root, ignore_direction=True)

	for vertex in dfs:
"""



def naive_all_cycles_iterator(g):
	"""
		A AMELIORER :
			-passer des composantes connexes a la fonction au lieu d'un cycle ?
			-faire un générateur directement (sans passer par un set anti-doublon et un tri)
	"""
	edges = g.edges(labels=False)
	#print "edges : {}".format(edges)
	seen = set()
	ret = set()

	for edge in edges: 
		if g.is_cut_edge(edge):
			#print "{} is a cut edge".format(edge)
			edges_copy = g.edges(labels=False)
			edges_copy.remove(edge)
			g2 = g.subgraph(edges=edges_copy)
			naive_all_cycles_iterator(g2)

		elif is_back_edge(edge, seen):
			#print "{} is a back edge".format(edge)
			edges_copy = g.edges(labels=False)
			edges_copy.remove(edge)
			g2 = g.subgraph(edges=edges_copy)
			cycles = g2.all_paths(edge[0], edge[1])
			for c in cycles:
				c = sorted(c)
				#print c
				#yield c
				ret.add(tuple(c))
		seen.add(edge[1])

	return ret



########## testing graphs ##########
r"""
g = Graph()
g.add_vertices([1,2,3,4,5,6,7,8,9])
g.add_edges([(1,2), (2,3), (3,4), (4,9), (4,5), (5,6), (6,2), (1,7), (7,8), (8,9)])

g2 = Graph()
g2.add_vertices(range(1,12))
g2.add_edges([(1,2), (2,3), (3,4), (3,1), (4,5), (5,6), (6,7), (7,8), (8,9), (9,10), (10,11), (11,4)])

g3 = graphs.CompleteGraph(8)

g4 = graphs.PetersenGraph()

cycles = naive_all_cycles_iterator(g3)
for i, c in enumerate(cycles):
	print "{} : {}".format(i, c)
"""
