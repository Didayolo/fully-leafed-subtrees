# -*- coding: utf-8 -*-

from itertools import product
from math import log

# On separe les sous-cubes en patterns
# On essaie de les combiner pour obtenir un arbre
# On peut combiner en essayant tout ou par backtracking
# En gros, prend le probleme de plus haut

# racines
r0 = ['000', '100', '110', '111', '011']
r1 = ['000', '001', '011', '111', '110']
r2 = ['000', '001', '101', '111', '110']
r3 = ['000', '100', '001', '011', '111']
# on ne prend pas les rotations en compte car c'est la racine
roots = [r0, r1, r2, r3]

# patterns avec 2 composantes connexes
p00 = ['010', '011', '100', '101'] # + 3 rotations
p01 = ['110', '100', '011', '001']
p02 = ['110', '111', '000', '001']
p03 = ['111', '101', '010', '000']
p10 = ['010', '110', '101', '001'] # + 1 rotation
p11 = ['000', '100', '111', '011']

patterns = [p00, p01, p02, p03, p10, p11]

# patterns avec 1 composante connexe
b0 = [] # + 3 rotations
b1 = [] # + 3 rotations
b2 = [] # + 3 rotations
b3 = [] # + 3 rotations 
b4 = [] # + 3 rotations
# on verra plus tard pour ceux là
# de toute facon on les genere

# 4 composantes connexes
d0 = ['000', '011', '110', '101']
d1 = rotation(d0)
# meme avec ceux la en plus, pas de soluions a k = 7 et l = 65
# si tous les patterns y sont, on peux sans doute demontrer que 65 est une borne superieur pour k = 7

def rotation(pattern):
# a commenter
    tab1 = ['000', '001', '011', '010']
    tab2 = ['100', '101', '111', '110']
    rotated = []
    for v in pattern:
        if v in tab1:
            i = tab1.index(v)
            rotated.append(tab1[i-1])
        if v in tab2:
            i = tab2.index(v)
            rotated.append(tab2[i-1])
    return rotated

def generate_patterns(roots):
# a commenter
    patterns = []
    for r in roots:
        for i in range(len(r)):
            
            p = set(r[:i] + r[i+1:])
            
            for _ in range(3): # 3 rotations
                if not p in patterns:
                    patterns.append(p)
                p = set(rotation(p))
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
        return Graph()

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
                t.show()
                print(t.order())
                print(t.vertices())
                #print(t.edges(labels=False)) 
                print("\n")
                # yield t

    print(str(solutions) + " solutions trouvees.")

# methode backtracking
# on part de la racine
# on ajoute des patterns voisins tant qu'on obtient un arbre
# sinon on revient et on tente d'autres patterns, etc.

def solve_bt_iterative(k):
# version iterative
# voir solve_bt

    if k < 4:
        print("k has to be greater than 3")
        return Graph()

    selected_patterns = [roots[0]] 
    bt = False

    cubes = 2**(k-3)
    g = graphs.CubeGraph(k)

    vertices = selected_patterns_to_vertices(selected_patterns, k)
    t = g.subgraph(vertices)
   
    while True:
    
        vertices = selected_patterns_to_vertices(selected_patterns, k)
        t = g.subgraph(vertices)
            
        if t.is_tree() and (not bt): # ok

            if len(selected_patterns) == cubes: 
                # solutions !
                t.show()
                print(t.order())
                print(t.vertices())
                print("\n")
                return t
                # yield t

            else: # ajout
                selected_patterns.append(patterns[0])

        else: # changement

            last_try = selected_patterns[-1]
            if len(selected_patterns) == 1: # root
                i = roots.index(last_try)
                if i == (len(roots) - 1): # end
                    return Graph()
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

  

def solve_bt_recursive(k):

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
                # yield t
            
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

# faire une version iterative du backtracking !

# exemples d'utilisations
# solve(6)
# solve_bt(5, [roots[0]], False)