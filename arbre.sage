# programme lineaire sage

# On se place dans le cas particulier dans lequel le graphe 
# est un arbre a n sommets, et on cherche parmis les sous-arbre 
# de taille k celui qui a le plus de feuilles

# on veux generer le programme lineaire a partir d'un graphe

# declaration du graphe
g = Graph()
# exemple 1
#g.add_vertices([0,1,2])
#g.add_edges([(0,1), (1,2)])

# exemple 2
g.add_vertices([0, 1, 2, 3, 4])
g.add_edges([(0, 1), (1, 2), (1, 3), (3, 4)])

g.show()

edges = [] # liste de couple, a voir si utile
for e in g.edges():
    edges.append((e[0], e[1]))

n = g.order() # taille de l'arbre
a = g.size() # nombre d'arete
k = 2 # taille du sous-arbre (arbitraire)

p = MixedIntegerLinearProgram()

# variables du PL
x = p.new_variable(binary = True) # aretes
y = p.new_variable(binary = True) # sommets
f = p.new_variable(integer = True, nonnegative = False) # feuilles

# fonction objectif
p.set_objective(p.sum(f[i] for i in range(n)) + p.sum(x[e] for e in edges) )

# contraintes
p.add_constraint(p.sum(y[i] for i in range(n)) == k)  # k la taille du sous arbre 
p.add_constraint(p.sum(y[i] for i in range(n)) == p.sum(x[e] for e in edges) + 1)  # arbre connexe (m = n + 1)

# contraintes aretes (generer)
for e in edges:
    p.add_constraint(x[e[0], e[1]] <= (y[e[0]] + y[e[1]])/2)  # presence d'une arete
    # c'est ici qu'il y a un probleme ?

for i in range(n): # parcours des sommets pour determiner les feuilles
    # contraintes utiles ou redondantes ?
    p.add_constraint(f[i] <= y[i]) # une feuille est un sommet 
    p.add_constraint(x[i,i] == 0) # pas d'arete vers sois-meme
    for e in edges: 
        p.add_constraint(f[i] <= 2 - (p.sum(x[i,j] for j in e)) )  # contraintes sur les feuilles
        p.add_constraint(f[i] <= 1 + (p.sum(x[i,j] for j in e)) )  # necessite d'associer aretes et sommets

# resolution
print("Solve")
print(p.solve())
print("Aretes x")
print(p.get_values(x))
print("Sommets y")
print(p.get_values(y))
print("Feuilles f")
print(p.get_values(f))
