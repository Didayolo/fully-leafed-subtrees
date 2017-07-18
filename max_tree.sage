# On cherche le plus grand sous-arbre induit dans un graphe donné

# On veux generer le programme lineaire a partir d'un graphe

def solve(g):
# Resolution du probleme pour un graphe g 

    g.show() # on visualise l'entree

    print("Generating linear program...")

    # constantes
    edges = g.edges(labels=False) # liste de couples representants les aretes
    vertices = g.vertices()
    n = g.order() # taille du graphe
    a = g.size() # nombre d'arete
    m = n - 1 # borne sup du degre max du graphe (a paufiner et renommer) 
        
    p = MixedIntegerLinearProgram()  

    # variables du PL
    e = p.new_variable(binary=True) # edges, e[i] si l'arete i presente dans le sous-arbre selectionne 
    v = p.new_variable(binary=True) # vertices, v[i] si le sommet i est present dans le sous-arbre

    # fonction objectif
    p.set_objective(p.sum(v[i] for i in vertices)) # on souhaite maximiser le nombre de sommets

    # contraintes
    p.add_constraint(p.sum(e[i] for i in edges) == p.sum(v[j] for j in vertices) + 1 )  # arbre connexe (m = n + 1)

    # contraintes aretes (generer)
    for i,j in edges:
        p.add_constraint(e[i, j] <= (v[i] + v[j])/2)  # presence d'une arete

    # resolution
    print("Solving...")
    
    try:
        print(p.solve())
        print("Edges e")
        print(p.get_values(e))
        print("Vertices v")
        print(p.get_values(v))

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
        g2 = g.subgraph(vertices=ve) #, edges=ed) # si on ne precise pas les aretes, subgraph renvoie le sous-graphe induit par les sommets
        g2.show()
        print("Solved.")
    
    except:
        print("Impossible to solve.")

