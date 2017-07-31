# -*- coding: utf-8 -*-
####### D'après l'article : https://arxiv.org/pdf/1205.2766.pdf #######


def cycles_iterator(g):
	seen = set()
	same_cycle_different_paths = set()

	#decomposition into biconnected components
	cut_edges = g.bridges()
	if len(cut_edges) > 0:
		#there is at least one articulation point
		g.delete_edges(cut_edges)

	ccs = g.connected_components() #fill the connected components list

	#for each connected component, we extract simple cycles by removing back edges
	#and listing all path from start to end of the removed edge
	for cc in ccs:
		cc_edges = [e for e in g.edges() if e[0] in cc and e[1] in cc]
		for e in cc_edges:
			if e[1] in seen: #e is a back edge
				g.delete_edge(e)
				cycles = g.all_paths(e[0], e[1])

				#there are duplicates for some simple cycles,
				#there can be 2 different paths for the same cycle
				for c in cycles:
					sorted_cycle = tuple(sorted(c))
					if sorted_cycle not in same_cycle_different_paths:
						same_cycle_different_paths.add(sorted_cycle)
						yield c
				cycles = []
			seen.add(e[1])



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

g4 = graphs.CompleteGraph(10)

g5 = graphs.PetersenGraph()

"""
def main():
	cycles = cycles_iterator(g4)
	for i, c in enumerate(cycles):
		print "{} : {}".format(i+1, c)

main()
"""