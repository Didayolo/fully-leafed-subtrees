from itertools import combinations

# On explore l'hypercube
# On veux toujours avoir un arbre au cours de la construction
# Backtracking

# (iterateur ?)

def afficher(g):
# fonction basique d'affichage d'un graphe
# utile pour debugger
    print('Vertices : ')
    print(g.vertices())
    print('Edges : ')
    print(g.edges(labels=False))
    g.show()

def suivant(sommet, i):
    return sommet[:i] + str(1 - int(sommet[i])) + sommet[i+1:]


def voisin_suivant_old(sommet, i, g):
    voisins = g.neighbors(sommet)
    return voisins[i]

def voisin_suivant(sommet, i):
    # (000,0) -> 100    (100, 1) -> 010    (010, 2) -> 001
    return sommet[:i] + str((1 - int(sommet[i])) ) + sommet[i+1:]
    

def solve(k, l):

    def slv(k, g, l, selected, tab, bt):
        # resolution avec backtracking
        # tab est une deuxieme pile pour garder le choix auquel on est
        # solve(k, [graphs.CubeGraph(k).vertices()[0]], [0], False)

        len_pile = len(selected)
          
        last_try = selected[len_pile - 1] # haut de la pile
        i = tab[len_pile - 1] # haut de la pile tab
        last_i = tab[len_pile - 2] # mouais
        
        #debug
        #print("selected : " + str(selected))
        #print("tab : " + str(tab))
        
        deja_vu = last_try in selected[:-1]
        tree = True        

        # plutot que t.is_tree()
        for x in range(k):
            if voisin_suivant(last_try, x) in selected[:-2]:
                # on a un cycle
                tree = False

        if (tree) and (not bt) and (not deja_vu): 
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
                voisin = voisin_suivant(last_try, i)
                selected.append(voisin)
                
                if i == 0: # legere optimisation
                    tab.append(1) # pour ne pas reproposer le pere
                else:
                    tab.append(0)
                
                tab[len_pile - 1] += 1 # on incremente le precedent 
                # len_pile n'a pas ete incremente donc on parle bien de l'avant der
                return slv(k, g, l, selected, tab, False)

        else: # il faut changer le dernier sommet selectionne
            last_i = tab[len_pile - 2]
            
            if last_i == k: # plus de changements possibles
                # print("backtrack\n")
                # on revient en arriere
                selected = selected[:-1]
                tab = tab[:-1]
                if len(selected) == 1: # end of movie
                    print("Problem has no solution")
                    return Graph()
                else: # on continue
                    #tab[-2] = tab[-2] + 1 # on incremente i pour ne pas retenter idem
                    return slv(k, g, l, selected, tab, True)

            else: # changement
                # print("changement\n")
                last_last_try = selected[len_pile - 2]
                voisin = voisin_suivant(last_last_try, last_i)
                selected[-1] = voisin
                tab[-2] = tab[-2] + 1 # on incremente i
                tab[-1] = 0 # i du nouveau candidat
                
                return slv(k, g, l, selected, tab, bt)
    
    g = graphs.CubeGraph(k)
    return slv(k, g, l, [g.vertices()[0]], [0], False)
    
