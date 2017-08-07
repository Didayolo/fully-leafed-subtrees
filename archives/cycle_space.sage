from itertools import chain, combinations

def list_to_set(l):
# Prend une liste representant un cycle et renvoie un ensemble d'ensembles
# Les petits ensembles representent chacun une arete
    return frozenset([frozenset([l[i-1], l[i]]) for i in range(len(l))])

def has_intersection(a,b):
# Renvoie Vrai si les ensembles a et b on au moins un element en commun
    return any(e in a for e in b)

def symmetric_differences(s):
# Renvoie la difference symmetrique de tout les elements de l'ensemble
# On note le s a differences
    
    res = frozenset()  

    if len(s) >= 2:
        res = s[0]
    
        for i in range(1, len(s)):
            #if has_intersection(res, s[i]):
            res = res.symmetric_difference(s[i])
            #else: # deux elements sont disjoints
                # cela pose un probleme !
            #    return frozenset()
    return res

def all_subsets(s):
# Renvoie toutes les sous-ensembles d'un ensemble
    return chain.from_iterable(combinations(s, r) for r in range(len(s)+1))

def cycle_space(g):
# Renvoie tous les cycles du graphe g
    
    basis = g.cycle_basis()
    basis_f = set()
    # Traitement ...
    for e in basis:
        basis_f.add(list_to_set(e))
    basis_f = frozenset(basis_f)    

    #space = set() # Cycle space    
    space = []

    # Premiere idee pour generer l'espace a partir de la base
    for s in all_subsets(basis_f):
        #space.add(symmetric_differences(s))   
        space.append(symmetric_differences(s))

    return space

def show_space(space, graph):
# Affichage du cycle space avec des graphes
# La variable graph permet d'afficher proprement les sous-graphes
    for cycle in space:
        g = Graph()
        for edge in cycle:
            g.add_vertices(edge)
            g.add_edge(edge)
        graph.subgraph(g).show() 
