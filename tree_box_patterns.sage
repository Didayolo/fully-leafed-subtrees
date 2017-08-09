# -*- coding: utf-8 -*-

from itertools import product
from math import log
load("forest_box.sage")
load("tree_box.sage")

# On separe les sous-cubes en patterns
# On essaie de les combiner pour obtenir un arbre
# On peut combiner en essayant tout ou par backtracking
# En gros, prend le probleme de plus haut

#def rotation(pattern):
# a commenter
# utiliser les automorphismes plutot que des rotations
#    tab1 = ['000', '001', '011', '010']
#    tab2 = ['100', '101', '111', '110']
#    rotated = []
#    for v in pattern:
#        if v in tab1:
#            i = tab1.index(v)
#            rotated.append(tab1[i-1])
#        if v in tab2:
#            i = tab2.index(v)
#            rotated.append(tab2[i-1])
#    return rotated

#def generate_patterns_from_roots(roots):
# a commenter
#    patterns = []
#    for r in roots:
#        for i in range(len(r)):
#            
#            p = set(r[:i] + r[i+1:]) # on genere un pattern en enlevant un sommet a un racine
#                       
#            if not p in patterns:
#                patterns.append(p) # on l'ajoute
# 
#            for _ in range(3): # 3 rotations
#                p = set(rotation(p))
#                if not p in patterns:
#                    patterns.append(p)
#    return patterns

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
    solutions = list(find_tree_iterative(k, l))
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


def selected_patterns_to_vertices(selected_patterns, dim):
# on part d'une liste de patterns 
# et on renvoie l'ensemble des sommets selectionnes
    vertices = []
    it_prefixes = product('01', repeat=(dim)) # tkt
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

    pattern_k = len(roots[0][0])
    solution = True
    
    if k <= pattern_k:
        print("k has to be greater than 3")
        solution = False
        #return Graph()

    selected_patterns = [roots[0]] 
    bt = False

    cubes = 2**(k - pattern_k)
    g = graphs.CubeGraph(k)

    vertices = selected_patterns_to_vertices(selected_patterns, k - pattern_k)
    t = g.subgraph(vertices)
   
    while solution:
    
        vertices = selected_patterns_to_vertices(selected_patterns, k - pattern_k)
        t = g.subgraph(vertices)
            
        if t.is_tree() and (not bt): # ok

            if len(selected_patterns) == cubes: # solution 
                #return t
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

  
def solve_recursive(k):

    if k < 4:
        print("k has to be greater than 3")
        return Graph()

    def slv_bt(k, selected_patterns, bt): # avec k > 3
        #selected_patterns est la 'pile'
        #bt est un booleen qui indique qu'il faut changer le haut de la pile

        g = graphs.CubeGraph(k)
        vertices = selected_patterns_to_vertices(selected_patterns, k) # le probleme vient sans doute d'ici
        # le prefixe donne ne sera pas forcement celui qui rend connexe le sous-graphe
        # idee : 
        # liste des prefixes restants, on selectionne jusqu'a ce que ca donne un arbre ou on laisse tomber le pattern
        t = g.subgraph(vertices)
        cubes = 2**(k-3)
        len_sp = len(selected_patterns)
       
        if t.is_tree() and (not bt): # on est dans la course
     
            if len_sp == cubes:
                # solution !
                t.show()
                print(t.order())
                print(t.vertices())
                print("\n")
                return t
            
            else: # on veux ajouter un pattern
                #roots et patterns 
                # on choisit un pattern
                selected_patterns.append(patterns[0])
                return slv_bt(k, selected_patterns, False)

        else: # il faut changer le dernier pattern
            last_try = selected_patterns[-1] # haut de la pile 
            if len_sp == 1: # il s'agissait d'une racine
                i = roots.index(last_try)
                if i == (len(roots) - 1): # plus de changements possibles
                    # pas de solutions
                    # plus de racines
                    return Graph()

                else: # changement
                    selected_patterns = [roots[i+1]]
                    return slv_bt(k, selected_patterns, False)
            else: # il s'agissait d'un pattern 
                i = patterns.index(last_try)
                if i == (len(patterns) - 1): # plus de changements possibles
                    # on revient en arriere
                    selected_patterns = selected_patterns[:-1]
                    return slv_bt(k, selected_patterns, True)
                else: # changement
                    selected_patterns[-1] = patterns[i+1]
                    return slv_bt(k, selected_patterns, False)

    return slv_bt(k, [roots[0]], False)


# racines
# solution du probleme pour k = 3 (sans les rotations d'un meme schema)
# a generer et enlever automorphismes 
#r0 = ['000', '100', '110', '111', '011']
#r1 = ['000', '001', '011', '111', '110']
#r2 = ['000', '001', '101', '111', '110']
#r3 = ['000', '100', '001', '011', '111']
# on ne prend pas les rotations en compte car c'est la racine
#roots = [r0, r1, r2, r3]

# Les patterns avec 1, 2 et 4 composantes connexes sont dans la generation

# Il n'existe pas de patterns avec 3 composantes connexes
# (Prouve avec forest_box.sage dans find_forest_cc())

#it = find_forest_cc(3, 4) # 4 cc dans le cube k = 3
#d0 = next(it).vertices()
##d0 = ['000', '011', '110', '101']
#d1 = rotation(d0)

# meme avec ceux la en plus, pas de soluions a k = 7 et l = 65
# si tous les patterns y sont, on peux sans doute demontrer que 65 est une borne superieur pour k = 7

#patterns = generate_patterns_from_roots(roots)
#patterns.append(set(d0))
#patterns.append(set(d1))

roots = generate_roots(3)
patterns = generate_patterns(3)
