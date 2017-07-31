from itertools import chain, combinations

def list_to_set(l):
# prend une liste representant un cycle et renvoie un ensemble d'ensembles
# Les petits ensembles representent chacun une arete
    return frozenset([frozenset([l[i-1], l[i]]) for i in range(len(l))])

def has_intersection(a,b):
# renvoie Vrai si les ensembles a et b on au moins un element en commun
    return any(e in a for e in b)

def symmetric_differences(s):
# Renvoie la difference symmetrique de tout les elements de l'ensemble
# On note le s a differences
    if len(s) >= 1:
        res = s[0]
    else:
        return set()  

    if len(s) >= 2:
    
        for i in range(1, len(s)):
            if has_intersection(res, s[i]):
                res = res.symmetric_difference(s[i])
            else:
                return set()
    return res

def all_subsets(s):
# renvoie toutes les sous-ensembles d'un ensemble
    return chain.from_iterable(combinations(s, r) for r in range(len(s)+1))

def cycle_space(g):
# renvoie tous les cycles du graphe g
    
    basis = g.cycle_basis()
    basis_f = set()
    # traitement ...
    for e in basis:
        basis_f.add(list_to_set(e))

    space = [] # cycle space    

    # premiere idee pour generer l'espace a partir de la base
    for s in all_subsets(basis_f):
        space.append(symmetric_differences(s))   
 
    return space

def show_space(space, graph):
# affichage du cycle space avec des graphes
#variable graph pour l'affichage
    for cycle in space:
        g = Graph()
        for edge in cycle:
            g.add_vertices(edge)
            g.add_edge(edge)
        graph.subgraph(g).show() 
