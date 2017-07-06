def list_to_set(l):
# prend une liste representant un cycle et renvoie un ensemble d'ensembles
# Les petits ensembles representent chacun une arete
    return set(frozenset([l[i-1], l[i]]) for i in range(len(l)))

def cycle_space(g):
# renvoie tous les cycles du graphe g
    
    basis = g.cycle_basis()
    
        
    # s.symmetric_difference(t)

