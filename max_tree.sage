load("cycle_iterator.sage")

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
    cycles = all_cycle(g) # fonction de cycle_iterator.sage   
     
    p = MixedIntegerLinearProgram()  

    # variables du PL
    e = p.new_variable(binary=True) # edges, e[i,j] si l'arete i,j presente dans le sous-arbre selectionne 
    v = p.new_variable(binary=True) # vertices, v[i] si le sommet i est present dans le sous-arbre

    # fonction objectif
    p.set_objective(p.sum(v[i] for i in vertices)) # on souhaite maximiser le nombre de sommets

    # contraintes aretes
    edge_sum = 0
    for i,j in edges:
        # on veux un sous-arbre INDUIT, donc forcer la presence de l'arete !
        # presence d'arete : 
        p.add_constraint(e[i, j] + 1 >= v[i] + v[j]) # v[i] and v[j] => e[i, j]
        p.add_constraint(e[i, j] <= (v[i] + v[j]) / 2) # e[i, j] => v[i] and v[j]
        edge_sum += e[i, j]

        # graphe non oriente
        p.add_constraint(e[i, j] == e[j, i])
    
    p.add_constraint(edge_sum == (p.sum(v[k] for k in vertices) - 1) )  # arbre connexe (m = n - 1) 
   
    # contraintes d'acyclicite (a ameliorer)
    for cycle in cycles: # pour chaque cycle
        length = 0 # taille du cycle
        sum = 0 # somme des aretes selectionnees
        for edge in cycle:
            i, j = list(edge)
            sum += e[i, j]
            length += 1

        p.add_constraint(sum + 1 <= length) # on ne doit pas selectionner un cycle

    # resolution
    print("Solving...")
    
    try:
        print(p.solve()) #objective_only=True))
        print("Vertices from LP (variable v)")
        print(p.get_values(v))
        print("Edges from LP (variable e)")
        print(p.get_values(e))

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
    #    g2 = g.subgraph(vertices=ve) #, edges=ed) # si on ne precise pas les aretes, subgraph renvoie le sous-graphe induit par les sommets
        g2.add_vertices(ve)
        g2.add_edges(ed)
        g2.show()
        print("Number of vertices : "+str(len(ve)))
        print("Number of edges : "+str(len(ed)/2))
        print("Vertices")
        print(ve)
        print("Edges")
        print(ed)
        print("Solved.")
    
    except:
        print("Impossible to solve.")

