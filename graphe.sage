# On a un graphe a n sommets, et on cherche parmis les
# sous-arbres induits celui qui a le plus de feuilles

# On veux generer le programme lineaire a partir d'un graphe

def solve(g):
# Resolution du probleme pour un graphe g et une constante k 
# k est la taille du sous arbre

# On pourrait verifier si le graphe est un arbre et executer la fonction de arbre.sage

    g.show() # on visualise l'entree

    print("Generating linear program...")

    # constantes
    edges = g.edges(labels=False) # liste de couples representants les aretes
    n = g.order() # taille de l'arbre
    a = g.size() # nombre d'arete
    m = n - 1 # borne sup du degre max du graphe (a paufiner et renommer) 
    
    p = MixedIntegerLinearProgram() # tester des solvers 

    # variables du PL
    x = p.new_variable(binary = True) # aretes, x[e] si e arete presente dans le sous-arbre selectionne 
    y = p.new_variable(binary = True) # sommets y[i] si i est present dans le sous-arbre
    f = p.new_variable(binary = True) # feuilles f[i] si i est une feuille du sous-arbre

    # fonction objectif
    p.set_objective(p.sum(f[i] for i in range(n))) # + p.sum(x[e] for e in edges) )

    # contraintes
    p.add_constraint(p.sum(x[e] for e in edges) == p.sum(y[i] for i in range(n)) - 1)  # nb_aretes = nb_sommets - 1

    # ajouter contrainte connexite ou acyclicite

    # contraintes aretes (generer)
    for i,j in edges:
        p.add_constraint(x[i, j] <= (y[i] + y[j])/2)  # presence d'une arete

    for i in range(n): # parcours des sommets pour determiner les feuilles
        p.add_constraint(f[i] <= y[i]) # une feuille est un sommet 

        degree = sum( (x[i,j] + x[j,i]) for j in g.neighbors(i)) # degre du sommet i
 
        p.add_constraint(f[i] <= 1 + (1./m) - (degree * (1./m) ) )  # contraintes sur les feuilles
    
    # resolution
    print("Solving...")
    
    try:
        print(p.solve())
        print("Aretes x")
        print(p.get_values(x))
        print("Sommets y")
        print(p.get_values(y))
        print("Feuilles f")
        print(p.get_values(f))

        # affichage de la solution
        # on voudrait le meme layout que l'affichage du graphe d'entree
        g2 = Graph()

        # sommets
        for k, v in p.get_values(y).iteritems():
            if v == 1:
                g2.add_vertex(k)

        #aretes
        for k, v in p.get_values(x).iteritems():
            if v == 1:
                g2.add_edge(k)

        g2.show()
        print("Solved.")
    
    except:
        print("Impossible to solve.")

