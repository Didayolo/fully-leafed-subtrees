from itertools import combinations

# On explore l'hypercube de facon brute

def solve(k):
# generer les solutions
# renvoie un iterateur
    l = 2**(k-1) + 1 
    g = graphs.CubeGraph(k)
    it = combinations(g.vertices(), l) 

    t = Graph()
    
    while True:
    
        t = g.subgraph(vertices=next(it))
        
        if t.is_tree():

            #print('Vertices : ')
            #print(t.vertices())
            #print('Edges : ')
            #print(t.edges(labels=False))
            #t.show()
            yield t

