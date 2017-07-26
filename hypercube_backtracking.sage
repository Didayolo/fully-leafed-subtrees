from itertools import combinations

# On explore l'hypercube
# On veux toujours avoir un arbre au cours de la construction
# Backtracking

# (iterateur ?)

#def solve():

    # initialisation de la premiere reponse qui satisfait forcement le systeme 
 #   x = vertices[0]
 ##   res = [x]
 #  i = vertices.index(x)
 #   V = vertices[:i] + vertices[i+1:] # vertices prive de x

 #   x = V[0]

def afficher(g):
# fonction basique d'affichage d'un graphe
    print('Vertices : ')
    print(g.vertices())
    print('Edges : ')
    print(g.edges(labels=False))
    g.show()

def suivant(sommet, i):
    return sommet[:i] + str(1 - int(sommet[i])) + sommet[i+1:]

def solve(g, selected, tab):
# resolution avec backtracking

    # tab : [0, 0, 0 ...]
    # vertices : ['000', '001', ...]
    # selected : ['000' ... ] (PILE)
    
    vertices = g.vertices()
    g2 = g.subgraph(vertices=selected) # candidat
    # print("selected : " + str(selected)) ##

    sommet_courant = selected[-1] # haut de la pile
    # print("sommet courant : " + str(sommet_courant)) ##
    # utilisation hashmap possible
    i = vertices.index(sommet_courant) # indice du sommet courant dans tab
    print("i : " + str(i)) ##
   
    if g2.is_tree() and (tab[i] != k): # accept. Arbre et tab[i] != k !
        print("tree") ##
        print("selected : "+ str(selected)) ##
        if g2.order() == l: # solution
            afficher(g2) ##
            return True # end of movie
 
        else: # ajout sommet
            print("ajout") ##
            print("tab : " + str(tab)) ##
                
            suiv = suivant(sommet_courant, tab[i]) 

            b = True
            while b:
                if not suiv in selected:
                    print('suivant : ' + str(suiv))
                    b = False 
                else:
                    print("Modification i") ##
                    tab[i] = tab[i] + 1 # si tab[i] == k on rejete ?
                    if(tab[i] == k): # toutes les voisins de ce sommet ont ete testes
                        print("i trop grand, reject") ##
                        return solve(g, selected, tab)
                    
                    else:
                        print("on change de suivant") ##
                        suiv = suivant(sommet_courant, tab[i])

            return solve(g, selected + [suiv], tab) 
     
    else: # reject
            print("reject") ##
            tab[i] = 0 # le rejet 
            previous_i = vertices.index(selected[len(selected) - 2]) # on recupere l'avant dernier
            tab[previous_i] = tab[previous_i] + 1
            return solve(g, selected[:-1], tab) # on depile et on incremente

    return False

 
k = 3
n = 2**k
l = 2**(k-1) + 1 
g = graphs.CubeGraph(k)
selected = [g.vertices()[0]]
solve(g, selected, [0 for _ in range(n)])

