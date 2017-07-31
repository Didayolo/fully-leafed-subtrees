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
        vertices = g.vertices()
        n = g.order() # taille de l'arbre
        a = g.size() # nombre d'arete
        m = n - 1 # borne sup du degre max du graphe (a paufiner et renommer) 
            
        p = MixedIntegerLinearProgram() # tester des solvers 

        # variables du PL
        e = p.new_variable(binary=True) # edges, e[i] si i arete presente dans le sous-arbre selectionne 
        v = p.new_variable(binary=True) # vertices, v[i] si i est present dans le sous-arbre
        l = p.new_variable(binary=True) # leaves, f[i] si i est une feuille du sous-arbre

        # fonction objectif
        p.set_objective(p.sum(l[i] for i in vertices))

        # contraintes
        p.add_constraint(p.sum(v[i] for i in vertices) == k)  # k la taille du sous arbre 
        p.add_constraint(p.sum(e[i] for i in edges) == k - 1)  # arbre connexe (m = n + 1)

        # contraintes aretes (generer)
        for i,j in edges:
            p.add_constraint(e[i, j] <= (v[i] + v[j])/2)  # presence d'une arete

        for i in range(n): # parcours des sommets pour determiner les feuilles
            p.add_constraint(l[i] <= v[i]) # une feuille est un sommet 

            degree = p.sum((e[i,j] + e[j,i]) for j in g.neighbors(i)) # degre du sommet i dans le sous-arbre
 
            p.add_constraint(l[i] <= 1 + (1./m) - (degree * (1./m) ) )  # contraintes sur les feuilles  Plus clair:  1 + (1-d)/m
        
        # resolution
        print("Solving...")
        
        try:
            print(p.solve())
            print("Edges e")
            print(p.get_values(e))
            print("Vertices v")
            print(p.get_values(v))
            print("Leaves l")
            print(p.get_values(l))

            # affichage de la solution
            g2 = Graph()
            
            #liste de sommets du sous-arbre induit
            ve = []
            for i, x in p.get_values(v).iteritems():
                if x == 1:
                    ve.append(i)

            #liste d'aretes du sous-arbre induit
            ed = []
            for i, x in p.get_values(e).iteritems():
                if x == 1:
                    ed.append(i)

            #sous-graphe avec les sommets et aretes choisies
            g2 = g.subgraph(vertices=ve) #, edges=ed) si on ne precise pas les aretes, subgraph renvoie le sous-graphe induit par les sommets
            g2.show()
            print("Solved.")
        
        except:
            print("Impossible to solve.")


