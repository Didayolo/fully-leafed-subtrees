from itertools import combinations

# A commenter

# On explore l'hypercube de facon brute

def find_forest(k, l):
# methode brute
# generer les solutions
# renvoie un iterateur
# foret de taille l dans l'hypercube de dimension k

    g = graphs.CubeGraph(k)
    it = combinations(g.vertices(), l) 

    while True:
    
        t = g.subgraph(vertices=next(it))
        
        if t.is_forest():

            yield t

def find_forest_cc(k, cc_nb):
    # cherche une foret de cc_nb composantes connexe dans un hypercube de dimension k
    g = graphs.CubeGraph(k)
    l = 2**(k-1) # moitie des sommets
    it = combinations(g.vertices(), l)

    while True:
        
        sg = g.subgraph(vertices=next(it))
        
        if sg.is_forest() and (sg.connected_components_number() == cc_nb):
            
            yield sg


def find_forest_n(k, l, cc_nb):
    # cherche une foret de cc_nb composantes connexes et taille l dans un hypercube de dimension k
    g = graphs.CubeGraph(k)
    it = combinations(g.vertices(), l)

    while True:
        
        sg = g.subgraph(vertices=next(it))
        
        if sg.is_forest() and (sg.connected_components_number() == cc_nb):
            
            yield sg

# On explore l'hypercube
# On veux toujours avoir un arbre au cours de la construction
# Dans cette construction on veux tester tous les arbres
# Backtracking

# (iterateur ?)

def display(g):
# fonction basique d'affichage d'un graphe
# utile pour debugger
    print('Vertices : ')
    print(g.vertices())
    print('Edges : ')
    print(g.edges(labels=False))
    g.show()


def next_neighbor(sommet, i):
    # (000,0) -> 100    (100, 1) -> 010    (010, 2) -> 001
    return sommet[:i] + str((1 - int(sommet[i])) ) + sommet[i+1:]
    

def find_forest_iterative(k, l):
    # version iterative
    # a commenter (meme fonctionnement que solve() )

    g = graphs.CubeGraph(k)
    vertices = g.vertices()
    selected = [vertices[0]]
    tab = [1]
    
    bt = False
   
    solution = True
 
    while solution:
    
        deja_vu = selected[-1] in selected[:-1]
        forest = True
        count = 0
        for x in range(k):
            if next_neighbor(selected[-1], x) in selected[:-1]:
                count += 1
    
        if count > 1: # presence d'un cycle
            # count peut etre egale a 0 puisqu'on cherche une foret
            forest = False

        if len(selected) == 1: ## inutile ?
            forest = True

        if (forest) and (not bt) and (not deja_vu):
        # Dans la course
            if len(selected) == l: # solution trouvee
                t = g.subgraph(selected)
                yield t
                bt = True

            else: # ajout
                i = tab[-1]
                suivant = vertices[i]
                selected.append(suivant)

                if i == 0: 
                    tab.append(1)
                else:
                    tab.append(0)

                tab[-2] += 1

        else: # c'est chaud
            
            last_i = tab[-2]

            if last_i == 2**k: # plus de changements
                selected = selected[:-1]
                tab = tab[:-1]
                if len(selected) == 1: # fin
                    solution = False

                else:
                    bt = True
                
            else: # changement
                last_last_try = selected[-2]
                suivant = vertices[last_i]
                selected[-1] = suivant
                tab[-2] += 1
                tab[-1] = 0
                bt = False
                    

def find_forest_recursive(k, l):

    def slv(k, g, l, selected, tab, bt):
        # resolution avec backtracking
        # tab est une deuxieme pile pour garder le choix auquel on est
        # solve(k, [graphs.CubeGraph(k).vertices()[0]], [0], False)

        len_pile = len(selected)
        vertices = g.vertices()        
  
        last_try = selected[len_pile - 1] # haut de la pile
        i = tab[len_pile - 1] # haut de la pile tab
        last_i = tab[len_pile - 2] # mouais
         
        #debug
        #print("selected : " + str(selected))
        #print("tab : " + str(tab))
        
        deja_vu = last_try in selected[:-1]
        forest = True        

        # plutot que t.is_tree()
        count = 0
        for x in range(k):
            if next_neighbor(last_try, x) in selected[:-1]:
                count += 1
       
        if count > 1:
        # i > 1 on a un cycle
        # i < 1 on est pas connexe (pas grave poour foret)
            forest = False
        
        if len_pile == 1: # test debug
            forest = True

        if (forest) and (not bt) and (not deja_vu): 
        # on est dans la course: arbre, pas de retour en arriere et 
        # le dernier sommet n'etait pas deja selectionne
            
            if len_pile == l:
                # solution !
                t = g.subgraph(selected)
                print("Problem solved")
                t.show()
                print(t.order())
                print(t.vertices())
                print("\n")
                return t

            else: # on ajoute un sommet
                # print("ajout\n")
                # voisin = suivant(last_try, i)
                suivant = vertices[i]
                selected.append(suivant)
                
                if i == 0: # legere optimisation
                    tab.append(1) # pour ne pas reproposer le pere
                else:
                    tab.append(0)
                
                tab[len_pile - 1] += 1 # on incremente le precedent 
                # len_pile n'a pas ete incremente donc on parle bien de l'avant der
                return slv(k, g, l, selected, tab, False)

        else: # il faut changer le dernier sommet selectionne
            last_i = tab[len_pile - 2]
            
            if last_i == 2**k: # plus de changements possibles (len(vertices))
                # print("backtrack\n")
                # on revient en arriere
                selected = selected[:-1]
                tab = tab[:-1]
                if len(selected) == 0: # end of movie
                    #print("Problem has no solution")
                    return Graph()
                else: # on continue
                    #tab[-2] = tab[-2] + 1 # on incremente i pour ne pas retenter idem
                    return slv(k, g, l, selected, tab, True)

            else: # changement
                # print("changement\n")
                last_last_try = selected[len_pile - 2]
                # voisin = next_neighbor(last_last_try, last_i)
                suivant = vertices[last_i]
                selected[-1] = suivant
                tab[-2] = tab[-2] + 1 # on incremente i
                tab[-1] = 0 # i du nouveau candidat
                
                return slv(k, g, l, selected, tab, False)
    
    g = graphs.CubeGraph(k)
    return slv(k, g, l, [g.vertices()[0]], [1], False)
    
