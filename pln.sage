# programme lineaire sage

# arbre a n sommets

n = 5 # taille de l'arbre
k = 4 # taille du sous-arbre
a = 4 # nombre d'arete

p = MixedIntegerLinearProgram()

# aretes
# il faudrait faire [0, 1]
for i in range(a):
    x = p.new_variable(binary = True)

# sommets et feuilles
for i in range(n):
    y = p.new_variable(binary = True)
    f = p.new_variable(integer = True, nonnegative = False)

# objectif
p.set_objective(p.sum(f[i] for i in range(n)) + p.sum(x[j] for j in range(a)) )

# contraintes
p.add_constraint(p.sum(y[i] for i in range(n)) == k)  # k la taille du sous arbre 

p.add_constraint(x[0] <= (y[0] + y[1])/2)  # presence d'une arete
p.add_constraint(x[1] <= (y[1] + y[2])/2)  # on decrit chaque arete a la main
p.add_constraint(x[2] <= (y[1] + y[3])/2)  # necessite (i,j)
p.add_constraint(x[3] <= (y[3] + y[4])/2)  

p.add_constraint(p.sum(y[i] for i in range(n)) == p.sum(x[j] for j in range(a)) + 1)  # arbre, connexe

for i in range(n):
        p.add_constraint(f[i] <= 2 - (p.sum(x[j] for j in range(a))) )  # contraintes sur les feuilles
        p.add_constraint(f[i] <= 1 + (p.sum(x[j] for j in range(a))) )  # necessite d'associer aretes et sommets
        p.add_constraint(f[i] <= y[i]) # une feuille est un sommet 
        # contraintes utiles ou redondantes ?

# resolution
print("Solve")
print(p.solve())
print("Aretes x")
print(p.get_values(x))
print("Sommets y")
print(p.get_values(y))
print("Feuilles f")
print(p.get_values(f))