# -*- coding: utf-8 -*-
####### D'après l'article : https://arxiv.org/pdf/1205.2766.pdf #######

def is_back_edge(edge, seen):
	return edge[1] in seen


def recursive_cycles_iterator(g):
	def slave(g, acc):
		edges = g.edges()
		cut_edges = g.bridges()

		seen = set()

		print "##### RECURSIVE CALL #####"
		if(len(edges) > 2): #no cycles with less than 3 edges
			if len(cut_edges) > 0: #there is at least one articulation point
				new_edges = filter(lambda x: x not in cut_edges, edges)
				sccs = g.subgraph(edges=new_edges)
				slave(sccs, acc)
			else:
				for e in edges:
					if is_back_edge(e, seen):
						print "{} is a back edge".format(e)
						edges_copy = g.edges()
						edges_copy.remove(e)
						g2 = g.subgraph(edges=edges_copy)
						cycles = g2.all_paths(e[0], e[1])
						print "### cycles : {}".format(cycles)
						for c in cycles:
							c = sorted(c)
							#yield c
							acc.add(tuple(c))
						slave(g2, acc)
					seen.add(e[1])
			return acc
		else:
			return set()


	return slave(g, set())


def cycles_iterator(g):
	seen = set()
	same_cycle_different_paths = set()

	cut_edges = g.bridges()
	if len(cut_edges) > 0: #there is at least one articulation point
		g.delete_edges(cut_edges)

	ccs = g.connected_components() #fill the connected components list

	for cc in ccs:
		cc_edges = [e for e in g.edges() if e[0] in cc and e[1] in cc] #useful if ccs has more than 1 cc
		for e in cc_edges:
			if is_back_edge(e, seen): #faster without function ??
				g.delete_edge(e)
				cycles = g.all_paths(e[0], e[1])

				for c in cycles:
					sorted_cycle = tuple(sorted(c))
					if sorted_cycle not in same_cycle_different_paths:
						same_cycle_different_paths.add(sorted_cycle)
						yield c
				cycles = []
			seen.add(e[1])

		#there are more than 2 edges and at least one cycle found, either way there are no more cycles
		#if(len(g.edges()) > 2 and cycles != []): 
		#	ccs.append(g.vertices())
		#	seen = set()


########## testing graphs ##########
g = Graph()
g.add_vertices([1,2,3,4,5,6,7,8,9])
g.add_edges([(1,2), (2,3), (3,4), (4,9), (4,5), (5,6), (6,2), (1,7), (7,8), (8,9)])

g2 = Graph()
g2.add_vertices(range(1,18))
g2.add_edges([(1, 2),(1, 3),(2, 3),(3, 4),(4, 5),(4, 11),(5, 6),(5, 13),(5, 15),(6, 7),(7, 8),(8, 9),(9, 10),(10, 11),(12, 13),(12, 14),(13, 14),(15, 16),(15, 17),(16, 17)])

g3 = Graph()
g3.add_vertices(range(1,18))
g3.add_edges([(1, 2),(1, 3),(2, 3),(3, 4),(4, 5),(4, 11),(5, 6),(5, 13),(5, 15),(6, 7),(7, 8),(8, 9),(9, 10),(10, 11),(12, 13),(12, 14),(13, 14),(15, 16),(15, 17),(16, 17)])
g3.add_edges([(6,10), (7,10)])

g4 = graphs.CompleteGraph(9)

g5 = graphs.PetersenGraph()

def test1():
	cycles = cycles_iterator(g5)
	for i, c in enumerate(cycles):
		print "{} : {}".format(i+1, c)


def main():
	test1()

main()