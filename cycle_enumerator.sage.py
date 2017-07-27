# -*- coding: utf-8 -*-

# This file was *autogenerated* from the file cycle_enumerator.sage
from sage.all_cmdline import *   # import sage library

_sage_const_3 = Integer(3); _sage_const_2 = Integer(2); _sage_const_1 = Integer(1); _sage_const_0 = Integer(0); _sage_const_7 = Integer(7); _sage_const_6 = Integer(6); _sage_const_5 = Integer(5); _sage_const_4 = Integer(4); _sage_const_9 = Integer(9); _sage_const_8 = Integer(8); _sage_const_12 = Integer(12); _sage_const_11 = Integer(11); _sage_const_10 = Integer(10)####### D'après l'article : https://arxiv.org/pdf/1205.2766.pdf #######

def is_back_edge(edge, seen):
	return edge[_sage_const_1 ] in seen


r"""
def all_cycles_iterator(g):
	root = g.vertices()[0]
	dfs = g.depth_first_search(root, ignore_direction=True)

	for vertex in dfs:
"""



def naive_all_cycles_iterator(g):
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
			cycles = g2.all_paths(edge[_sage_const_0 ], edge[_sage_const_1 ])
			for c in cycles:
				c = sorted(c)
				#print c
				#yield c
				ret.add(tuple(c))
		seen.add(edge[_sage_const_1 ])

	return ret



########## testing graphs ##########
g = Graph()
g.add_vertices([_sage_const_1 ,_sage_const_2 ,_sage_const_3 ,_sage_const_4 ,_sage_const_5 ,_sage_const_6 ,_sage_const_7 ,_sage_const_8 ,_sage_const_9 ])
g.add_edges([(_sage_const_1 ,_sage_const_2 ), (_sage_const_2 ,_sage_const_3 ), (_sage_const_3 ,_sage_const_4 ), (_sage_const_4 ,_sage_const_9 ), (_sage_const_4 ,_sage_const_5 ), (_sage_const_5 ,_sage_const_6 ), (_sage_const_6 ,_sage_const_2 ), (_sage_const_1 ,_sage_const_7 ), (_sage_const_7 ,_sage_const_8 ), (_sage_const_8 ,_sage_const_9 )])

g2 = Graph()
g2.add_vertices(range(_sage_const_1 ,_sage_const_12 ))
g2.add_edges([(_sage_const_1 ,_sage_const_2 ), (_sage_const_2 ,_sage_const_3 ), (_sage_const_3 ,_sage_const_4 ), (_sage_const_3 ,_sage_const_1 ), (_sage_const_4 ,_sage_const_5 ), (_sage_const_5 ,_sage_const_6 ), (_sage_const_6 ,_sage_const_7 ), (_sage_const_7 ,_sage_const_8 ), (_sage_const_8 ,_sage_const_9 ), (_sage_const_9 ,_sage_const_10 ), (_sage_const_10 ,_sage_const_11 ), (_sage_const_11 ,_sage_const_4 )])

g3 = graphs.CompleteGraph(_sage_const_8 )

g4 = graphs.PetersenGraph()

cycles = naive_all_cycles_iterator(g3)
for i, c in enumerate(cycles):
	print "{} : {}".format(i, c)
