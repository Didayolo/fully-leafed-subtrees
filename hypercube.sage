from itertools import combinations

# On explore l'hypercube de facon brute

k = 5
l = 2**(k-1) + 1 
g = graphs.CubeGraph(k)
it = combinations(g.vertices(), l) 

g2 = Graph()

while not g2.is_tree():
    # try except ?
    g2 = g.subgraph(vertices=next(it))

print('Vertices : ')
print(g2.vertices())
print('Edges : ')
print(g2.edges(labels=False))
g2.show()
