load("../cycle_iterator.sage")

# On a un graphe a n sommets, et on cherche parmis les
# sous-forets induites celle qui a le plus de feuilles

# On veux generer le programme lineaire a partir d'un graphe

# On enleve simplement la contrainte de connexite du probleme du sous-arbre

def solve(g):
# Resolution du probleme pour un graphe g  

# On pourrait verifier si le graphe est un arbre et executer la fonction de arbre.sage

    g.show() # on visualise l'entree

    print("Generating linear program...")

    # constantes
    edges = g.edges(labels=False) # liste de couples representants les aretes
    vertices = g.vertices()
    n = g.order() # taille de l'arbre
    a = g.size() # nombre d'arete
    m = n - 1 # borne sup du degre max du graphe (a paufiner et renommer) 
    cycles_vertices = list(cycles_iterator(g))
    cycles_edges = []
    for c in cycles_vertices:
        l = list_to_set(c)
        cycles_edges.append(l)   

    p = MixedIntegerLinearProgram() # tester des solvers 

    # variables du PL
    e = p.new_variable(binary = True) # edges, e[i,j] si l'arete i,j presente dans le sous-arbre selectionne 
    v = p.new_variable(binary = True) # vertices v[i] si le sommet i est present dans le sous-arbre
    l = p.new_variable(binary = True) # leaves l[i] si le sommet i est une feuille du sous-arbre

    # fonction objectif
    p.set_objective(p.sum(l[i] for i in vertices))

    # contraintes aretes

    edge_sum = 0
    for i,j in edges:
        # on veux un sous-arbre INDUIT, donc forcer la presence de l'arete
        # presence d'arete :
        p.add_constraint(e[i, j] + 1 >= v[i] + v[j]) # v[i] and v[j] => e[i, j]
        p.add_constraint(e[i, j] <= (v[i] + v[j]) / 2) # e[i, j] => v[i] and v[j]
        edge_sum += e[i, j]
        
        # graphe non oriente
        p.add_constraint(e[i, j] == e[j, i])


    p.add_constraint(edge_sum == p.sum(v[i] for i in vertices) - 1)  # nb_aretes = nb_sommets - 1

    # contraintes acyclicite
    for cycle in cycles_edges: # pour chaque cycle
        length = 0 # taille du cycle
        sum = 0 # somme des aretes selectionnees
        for edge in cycle:
            i, j = list(edge)             
            sum += e[i, j]
            length += 1
 
        p.add_constraint(sum + 1 <= length) # on ne doit pas selectionner un cycle

    # contraintes feuilles

    for i in vertices: # parcours des sommets pour determiner les feuilles
        p.add_constraint(l[i] <= v[i]) # une feuille est un sommet 

        degree = p.sum(e[i,j] for j in g.neighbors(i)) # degre du sommet i
 
        p.add_constraint(l[i] <= 1 + (1./m) - (degree * (1./m) ) )  # contraintes sur les feuilles
        #p.add_constraint(l[i] <= 1 + (1. - degree)/m)
    
    # resolution
    print("Solving...")
    
    try:
        print(p.solve())
        print("Sommets v")
        print(p.get_values(v))
        print("Aretes e")
        print(p.get_values(e))
        print("Feuilles l")
        print(p.get_values(l))

        # affichage de la solution
        # on voudrait le meme layout que l'affichage du graphe d'entree
        g2 = Graph()

        # sommets
        for key, val in p.get_values(v).iteritems():
            if val == 1:
                g2.add_vertex(key)

        #aretes
        for key, val in p.get_values(e).iteritems():
            if val == 1:
                g2.add_edge(key)

        g2.show()
        print("Solved.")
    
    except:
        print("Impossible to solve.")

