load("forest_box.sage")
load("tree_box_patterns.sage")


# methode 1

# on cherche les forets

#it = find_forest(k-1, optimum)


# methode 2

# on part des solutions de k-1 et on enleve des sommets (non exhaustif)

#it = solve_iterative(k-1)
#take_off_vertex(next(it))




def union(vertices_a, vertices_b):
# on reuni deux sous graphes au seins d'un hypercube de dimension superieure
    
    vertices = []
    vertices += ['0' + w for w in vertices_a]  
    vertices += ['1' + w for w in vertices_b]

    return vertices



#def forests(k, l):
#    if k == 3:
#        find_forest(k, 

# test
#k = 6
#g = graphs.CubeGraph(k)

#forests_i = find_forest(k-1, 17)
#forests_j = find_forest(k-1, 16)

#for forest_i in forests_i:
#    for forest_j in forests_j:
#        ve_i = forest_i.vertices()
#        ve_j = forest_j.vertices()
#        t = g.subgraph(union(ve_i, ve_j))

#        if t.is_tree():
#            print("lah")

forests = dict()

# initialisation
forests[(3,5)] = []
for f in find_forest(3,5):
    forests[(3,5)].append(f.vertices())

forests[(3,4)] = [] 
for f in find_forest(3,4):
    forests[(3,4)].append(f.vertices())

# algo
for k in range(4,6):

    l = 2**(k - 1) + 1

    forests[(k, l)] = []
    forests[(k, l-1)] = []

    g = graphs.CubeGraph(k)

    for fi in forests[(k-1, 2**(k-2))]:
        for fj in forests[(k-1, 2**(k-2)+1)]:
            
            fu = union(fi, fj)
            sg = g.subgraph(fu)
            if sg.is_forest():
                forests[(k,l)].append(fu)

        for fk in forests[(k-1, 2**(k-2))]:
            
            fu = union(fi, fk)
            if g.subgraph(fu).is_forest():
                
                forests[(k, l-1)].append(fu)


