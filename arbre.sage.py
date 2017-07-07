
# This file was *autogenerated* from the file arbre.sage
from sage.all_cmdline import *   # import sage library

_sage_const_2 = Integer(2); _sage_const_1 = Integer(1); _sage_const_1p = RealNumber('1.')# On se place dans le cas particulier dans lequel le graphe 
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
        m = n - _sage_const_1  # borne sup du degre max du graphe (a paufiner et renommer) 
            
        p = MixedIntegerLinearProgram() # tester des solvers 

        # variables du PL
        e = p.new_variable(binary=True) # edges, e[i] si i arete presente dans le sous-arbre selectionne 
        v = p.new_variable(binary=True) # vertices, v[i] si i est present dans le sous-arbre
        l = p.new_variable(binary=True) # leaves, f[i] si i est une feuille du sous-arbre

        # fonction objectif
        p.set_objective(p.sum(l[i] for i in range(n)))

        # contraintes
        p.add_constraint(p.sum(v[i] for i in range(n)) == k)  # k la taille du sous arbre 
        p.add_constraint(p.sum(e[i] for i in edges) == k - _sage_const_1 )  # arbre connexe (m = n + 1)

        # contraintes aretes (generer)
        for i,j in edges:
            p.add_constraint(e[i, j] <= (v[i] + v[j])/_sage_const_2 )  # presence d'une arete

        for i in range(n): # parcours des sommets pour determiner les feuilles
            p.add_constraint(l[i] <= v[i]) # une feuille est un sommet 

            degree = p.sum((e[i,j] + e[j,i]) for j in g.neighbors(i)) # degre du sommet i dans le sous-arbre
 
            p.add_constraint(l[i] <= _sage_const_1  + (_sage_const_1p /m) - (degree * (_sage_const_1p /m) ) )  # contraintes sur les feuilles
        
        # resolution
        print("Solving...")
        
        try:
            print(p.solve())
            print("Edges e")
            print(p.get_values(x))
            print("Vertices v")
            print(p.get_values(y))
            print("Leaves l")
            print(p.get_values(f))

            # affichage de la solution
            g2 = Graph()
            
            #liste de sommets du sous-arbre induit
            ve = []
            for i, x in p.get_values(v).iteritems():
                if x == _sage_const_1 :
                    ve.append(i)

            #liste d'aretes du sous-arbre induit
            ed = []
            for i, x in p.get_values(e).iteritems():
                if x == _sage_const_1 :
                    ed.append(i)

            #sous-graphe avec les sommets et aretes choisies
            g2 = g.subgraph(vertices=ve, edges=ed)
            g2.show()
            print("Solved.")
        
        except:
            print("Impossible to solve.")

