# programme lineaine sage

# arbre a 3 sommets


p = MixedIntegerLinearProgram()

# arete
x = p.new_variable(binary = True)
x = p.new_variable(binary = True)

# sommets
y = p.new_variable(binary = True)
y = p.new_variable(binary = True)
y = p.new_variable(binary = True)

# feuilles
f = p.new_variable(integer = True)
f = p.new_variable(integer = True)
f = p.new_variable(interger = True)

# objectif
p.set_objective(f[1] + f[2] + f[3] + x[1] = x[2])

# contraintes
p.add_constraint(y[1] + y[2] == 1)  # k la taille du sous arbre 
p.add_constraint(x[1] <= (y[1] + y[2])/2)  # presence d'une arete
p.add_constraint(y[1] + y[2] == x[1] + 1)  # arbre, connexe

p.add_constraint(f[1] <= 2 - x[1])  # contraintes sur les feuilles
p.add_constraint(f[2] <= 2 - x[1])
p.add_constraint(f[1] <= x[1] + 1)
p.add_constraint(f[2] <= x[1] + 1)

# contraintes utiles ou redondantes ?
p.add_constraint(f[1] <= x[1])
p.add_constraint(f[2] <= x[2])

# resolution
print(p.solve())
print(p.get_values(x))
print(p.get_values(y))
print(p.get_values(f))
