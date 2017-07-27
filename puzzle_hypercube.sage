from itertools import product

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

# solve
k = 7 # avec k > 3
g = graphs.CubeGraph(k)
cubes = 2**(k-3)
selected_patterns = [] # len(selected_patterns = cubes)

# une racine + (cubes - 1) patterns
# methode brute
for r in roots:
    it_patterns = product(patterns, repeat=(cubes - 1))
    for p in it_patterns:
        selected_patterns = [r]
        selected_patterns += list(next(it_patterns))

        vertices = []
        it_prefixes = product('01', repeat=(k-3))
        for p in selected_patterns:
            prefixe = ''.join(next(it_prefixes))
            vertices += [prefixe + w for w in p]

        t = g.subgraph(vertices)
        if(t.is_tree()):
            t.show()
            print(t.order())
            #print(t.vertices())
            #print(t.edges(labels=False)) 
            #print("\n")

# methode backtracking
# on part de la racine
# on ajoute des patterns voisins tant qu'on obtient un arbre
# sinon on revient et on tente d'autres patterns, etc.


