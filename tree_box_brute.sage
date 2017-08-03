from itertools import combinations

# On explore l'hypercube de facon brute

def solve(k):
# generer les solutions
# renvoie un iterateur
    l = 2**(k-1) + 1 
    g = graphs.CubeGraph(k)
    it = combinations(g.vertices(), l) 

    while True:
    
        t = g.subgraph(vertices=next(it))
        
        if t.is_tree():

            #print('Vertices : ')
            #print(t.vertices())
            #print('Edges : ')
            #print(t.edges(labels=False))
            #t.show()
            yield t

def find_forest(cc_nb, k):
    # cherche une foret de cc_nb composantes connexe dans un hypercube de dimension k
    g = graphs.CubeGraph(k)
    l = 2**(k-1) # moitie des sommets
    it = combinations(g.vertices(), l)

    while True:
        
        sg = g.subgraph(vertices=next(it))
        
        if sg.is_forest() and (sg.connected_components_number() == cc_nb):
            
            yield sg
