# On se place dans le cas particulier dans lequel le graphe 
# est un arbre a n sommets, et on cherche parmis les sous-arbre 
# de taille k celui qui a le plus de feuilles

# On veux generer le programme lineaire a partir d'un graphe

def solve(g, k):
# Resolution du probleme pour un graphe g et une constante k 
# k est la taille du sous arbre

# Dans le cas general, on pourrait verifier si le graphe est un arbre et executer cette fonction si c'est le cas
    
    g.show() # on visualise l'entree

    if not g.is_tree():
        print("Graph is not a tree")
    
    else:
    
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
        p.add_constraint(p.sum(y[i] for i in range(n)) == k)  # k la taille du sous arbre 
        p.add_constraint(p.sum(x[e] for e in edges) == k - 1)  # arbre connexe (m = n + 1)

        # contraintes aretes (generer)
        for i,j in edges:
            p.add_constraint(x[i, j] <= (y[i] + y[j])/2)  # presence d'une arete

        for i in range(n): # parcours des sommets pour determiner les feuilles
            p.add_constraint(f[i] <= y[i]) # une feuille est un sommet 

            degree = p.sum( (x[i,j] + x[j,i]) for j in g.neighbors(i)) # degre du sommet i dans le sous-arbre
 
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
            g2 = Graph()
            
            #liste de sommets du sous-arbre induit
            ve = []
            for k, v in p.get_values(y).iteritems():
                if v == 1:
                    ve.append(k)

            #liste d'aretes du sous-arbre induit
            ed = []
            for k, v in p.get_values(x).iteritems():
                if v == 1:
                    ed.append(k)

            #sous-graphe avec les sommets et aretes choisies
            g2 = g.subgraph(vertices=ve, edges=ed)
            g2.show()
            print("Solved.")
        
        except:
            print("Impossible to solve.")

