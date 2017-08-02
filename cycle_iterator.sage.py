# -*- coding: utf-8 -*-

# This file was *autogenerated* from the file cycle_iterator.sage
from sage.all_cmdline import *   # import sage library

_sage_const_3 = Integer(3); _sage_const_2 = Integer(2); _sage_const_1 = Integer(1); _sage_const_0 = Integer(0); _sage_const_7 = Integer(7); _sage_const_6 = Integer(6); _sage_const_5 = Integer(5); _sage_const_4 = Integer(4); _sage_const_9 = Integer(9); _sage_const_8 = Integer(8); _sage_const_13 = Integer(13); _sage_const_12 = Integer(12); _sage_const_11 = Integer(11); _sage_const_10 = Integer(10); _sage_const_17 = Integer(17); _sage_const_16 = Integer(16); _sage_const_15 = Integer(15); _sage_const_14 = Integer(14); _sage_const_18 = Integer(18)####### D'après l'article : https://arxiv.org/pdf/1205.2766.pdf #######


def cycles_iterator(g):
	seen = set()
	same_cycle_different_paths = set()

	#decomposition into biconnected components
	cut_edges = g.bridges()
	if len(cut_edges) > _sage_const_0 :
		#there is at least one articulation point
		g.delete_edges(cut_edges)

	ccs = g.connected_components() #fill the connected components list

	#for each connected component, we extract simple cycles by removing back edges
	#and listing all path from start to end of the removed edge
	for cc in ccs:
		cc_edges = [e for e in g.edges() if e[_sage_const_0 ] in cc and e[_sage_const_1 ] in cc]
		for e in cc_edges:
			if e[_sage_const_1 ] in seen: #e is a back edge
				g.delete_edge(e)
				cycles = g.all_paths(e[_sage_const_0 ], e[_sage_const_1 ])

				#there are duplicates for some simple cycles,
				#there can be 2 different paths for the same cycle
				for c in cycles:
					sorted_cycle = tuple(sorted(c))
					#if sorted_cycle not in same_cycle_different_paths:
					same_cycle_different_paths.add(sorted_cycle)
					yield c
				cycles = []
			seen.add(e[_sage_const_1 ])



########## testing graphs ##########
g = Graph()
g.add_vertices([_sage_const_1 ,_sage_const_2 ,_sage_const_3 ,_sage_const_4 ,_sage_const_5 ,_sage_const_6 ,_sage_const_7 ,_sage_const_8 ,_sage_const_9 ])
g.add_edges([(_sage_const_1 ,_sage_const_2 ), (_sage_const_2 ,_sage_const_3 ), (_sage_const_3 ,_sage_const_4 ), (_sage_const_4 ,_sage_const_9 ), (_sage_const_4 ,_sage_const_5 ), (_sage_const_5 ,_sage_const_6 ), (_sage_const_6 ,_sage_const_2 ), (_sage_const_1 ,_sage_const_7 ), (_sage_const_7 ,_sage_const_8 ), (_sage_const_8 ,_sage_const_9 )])

a = Graph()
a.add_vertices([_sage_const_1 ,_sage_const_2 ,_sage_const_3 ,_sage_const_4 ])
a.add_edges([(_sage_const_1 ,_sage_const_2 ), (_sage_const_2 ,_sage_const_3 ), (_sage_const_3 ,_sage_const_4 ), (_sage_const_4 ,_sage_const_1 ), (_sage_const_2 ,_sage_const_4 )])

g2 = Graph()
g2.add_vertices(range(_sage_const_1 ,_sage_const_18 ))
g2.add_edges([(_sage_const_1 , _sage_const_2 ),(_sage_const_1 , _sage_const_3 ),(_sage_const_2 , _sage_const_3 ),(_sage_const_3 , _sage_const_4 ),(_sage_const_4 , _sage_const_5 ),(_sage_const_4 , _sage_const_11 ),(_sage_const_5 , _sage_const_6 ),(_sage_const_5 , _sage_const_13 ),(_sage_const_5 , _sage_const_15 ),(_sage_const_6 , _sage_const_7 ),(_sage_const_7 , _sage_const_8 ),(_sage_const_8 , _sage_const_9 ),(_sage_const_9 , _sage_const_10 ),(_sage_const_10 , _sage_const_11 ),(_sage_const_12 , _sage_const_13 ),(_sage_const_12 , _sage_const_14 ),(_sage_const_13 , _sage_const_14 ),(_sage_const_15 , _sage_const_16 ),(_sage_const_15 , _sage_const_17 ),(_sage_const_16 , _sage_const_17 )])

g3 = Graph()
g3.add_vertices(range(_sage_const_1 ,_sage_const_18 ))
g3.add_edges([(_sage_const_1 , _sage_const_2 ),(_sage_const_1 , _sage_const_3 ),(_sage_const_2 , _sage_const_3 ),(_sage_const_3 , _sage_const_4 ),(_sage_const_4 , _sage_const_5 ),(_sage_const_4 , _sage_const_11 ),(_sage_const_5 , _sage_const_6 ),(_sage_const_5 , _sage_const_13 ),(_sage_const_5 , _sage_const_15 ),(_sage_const_6 , _sage_const_7 ),(_sage_const_7 , _sage_const_8 ),(_sage_const_8 , _sage_const_9 ),(_sage_const_9 , _sage_const_10 ),(_sage_const_10 , _sage_const_11 ),(_sage_const_12 , _sage_const_13 ),(_sage_const_12 , _sage_const_14 ),(_sage_const_13 , _sage_const_14 ),(_sage_const_15 , _sage_const_16 ),(_sage_const_15 , _sage_const_17 ),(_sage_const_16 , _sage_const_17 )])
g3.add_edges([(_sage_const_6 ,_sage_const_10 ), (_sage_const_7 ,_sage_const_10 )])

g4 = graphs.CompleteGraph(_sage_const_10 )

g5 = graphs.PetersenGraph()


def main():
	cycles = cycles_iterator(a)
	for i, c in enumerate(cycles):
		print "{} : {}".format(i+_sage_const_1 , c)

main()
