# programme lineaire sage

# On se place dans le cas particulier dans lequel le graphe 
# est un arbre a n sommets, et on cherche parmis les sous-arbre 
# de taille k celui qui a le plus de feuilles

# on veux generer le programme lineaire a partir d'un graphe

# declaration du graphe
g = Graph()
g.add_vertices([0, 1, 2, 3, 4])
g.add_edges([(0, 1), (1, 2), (1, 3), (3, 4)])
g.show()

n = g.order() # taille de l'arbre
a = g.size() # nombre d'arete
k = 4 # taille du sous-arbre (arbitraire)

p = MixedIntegerLinearProgram()

# aretes, sommets et feuilles
x = p.new_variable(binary = True)
y = p.new_variable(binary = True)
f = p.new_variable(integer = True, nonnegative = False)

# objectif
p.set_objective(p.sum(f[i] for i in range(n)) + p.sum(x[i,j] for i in range(n) for j in range(n)) )

# contraintes
p.add_constraint(p.sum(y[i] for i in range(n)) == k)  # k la taille du sous arbre 

# contraintes aretes (generer)
for edge in g.edges():
    edge[0], edge[1]
    p.add_constraint(x[edge[0], edge[1]] <= (y[edge[0]] + y[edge[1]])/2)  # presence d'une arete
    # c'est ici qu'il y a un probleme

p.add_constraint(p.sum(y[i] for i in range(n)) == p.sum(x[i,j] for i in range(n) for j in range(n)) + 1)  # arbre, connexe

for i in range(n):
        p.add_constraint(f[i] <= 2 - (p.sum(x[i,j] for j in range(n))) )  # contraintes sur les feuilles
        p.add_constraint(f[i] <= 1 + (p.sum(x[i,j] for j in range(n))) )  # necessite d'associer aretes et sommets
        p.add_constraint(f[i] <= y[i]) # une feuille est un sommet 
        # contraintes utiles ou redondantes ?
        p.add_constraint(x[i,i] == 0) # pas d'arete vers sois-meme

# resolution
print("Solve")
print(p.solve())
print("Aretes x")
print(p.get_values(x))
print("Sommets y")
print(p.get_values(y))
print("Feuilles f")
print(p.get_values(f))
