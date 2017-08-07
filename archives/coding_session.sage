from itertools import chain, combinations

def tree_iterator(g):

    vertices = g.vertices()
    subset_it = chain.from_iterable(combinations(vertices, r) for r in range(len(vertices)+1))

    while True:
        
        sg = g.subgraph(next(subset_it))
        
        if sg.is_tree():
            yield sg


g = graphs.PetersenGraph()
it = tree_iterator(g)
#next(it).show()
