# -*- coding: utf-8 -*-

from itertools import product
from math import log
load("forest_box.sage")
load("tree_box.sage")

# On separe les sous-cubes en patterns
# On essaie de les combiner pour obtenir une foret
# On peut combiner en essayant tout ou par backtracking
# En gros, prend le probleme de plus haut

def take_off_vertex(vertices):
    # iterateur qui renvoie le graphe avec un sommet de moins
    # vertices est une liste de sommet
    for i in range(len(vertices)):
        yield (vertices[:i] + vertices[i+1:])
    

def generate_roots(k):
    # toutes les solutions optimales de grand arbre dans l'hypercube de dimension k
    # modifier pour faire a automorphisme pres (pour k = 3 on veux 5 schemas differents)
    roots = []
    l = 2*(k-1) + 1
    solutions = list(find_forest(k, l))
    for s in solutions:
        roots.append(s.vertices())

    return roots


def generate_patterns(k):
    # toutes les forets dans le cube dimension k de taille 2**(k-1)
    patterns = []
    l = 2**(k-1)
    forests = list(find_forest(k, l))
    for f in forests:
        patterns.append(f.vertices())

    return patterns


def selected_patterns_to_vertices(selected_patterns, k):
# on part d'une liste de patterns 
# et on renvoie l'ensemble des sommets selectionnes
    vertices = []
    it_prefixes = product('01', repeat=(k-3)) # tkt
    for p in selected_patterns:
        prefixe = ''.join(next(it_prefixes))
        vertices += [prefixe + w for w in p]
    return vertices
   

# solve
def solve(k): # avec k > 3 (car les patterns sont dans des Q3)

    if k < 4:
        print("k has to be greater than 3")
        yield Graph()

    g = graphs.CubeGraph(k)
    cubes = 2**(k-3)
    selected_patterns = [] # len(selected_patterns) = cubes

    solutions = 0

    # une racine + (cubes - 1) patterns
    # methode brute
    for r in roots:
        it_patterns = product(patterns, repeat=(cubes - 1))
        for p in it_patterns:
            selected_patterns = [r]
            selected_patterns += list(next(it_patterns))

            vertices = selected_patterns_to_vertices(selected_patterns, k)

            t = g.subgraph(vertices)
            if(t.is_tree()): # une solution
                solutions += 1
                yield t

    print(str(solutions) + " solutions trouvees.")

# methode backtracking
# on part de la racine
# on ajoute des patterns voisins tant qu'on obtient un arbre
# sinon on revient et on tente d'autres patterns, etc.

def solve_iterative(k):
# version iterative
# voir solve_bt

    solution = True
    
    if k < 4:
        print("k has to be greater than 3")
        solution = False
        #return Graph()

    selected_patterns = [roots[0]] 
    bt = False

    cubes = 2**(k-3)
    g = graphs.CubeGraph(k)

    vertices = selected_patterns_to_vertices(selected_patterns, k)
    t = g.subgraph(vertices)
   
    while solution:
    
        vertices = selected_patterns_to_vertices(selected_patterns, k)
        t = g.subgraph(vertices)
            
        if t.is_forest() and (not bt): # ok

            if len(selected_patterns) == cubes: # solution 
                
                yield t
                bt = True # test

            else: # ajout
                selected_patterns.append(patterns[0])

        else: # changement

            last_try = selected_patterns[-1]
            if len(selected_patterns) == 1: # root
                i = roots.index(last_try)
                if i == (len(roots) - 1): # end
                    #return Graph()
                    solution = False

                else:
                    selected_patterns = [roots[i+1]] # next root
                    bt = False
            
            else: # pattern
                i = patterns.index(last_try)
                if i == (len(patterns) - 1): # last pattern
                # backtrack
                    selected_patterns = selected_patterns[:-1]
                    bt = True
                else: #changement
                    selected_patterns[-1] = patterns[i+1]
                    bt = False


roots = generate_roots(3)
patterns = generate_patterns(3)
