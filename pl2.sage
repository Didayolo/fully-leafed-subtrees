# programme lineaine sage

# arbre a deux sommets

p = MixedIntegerLinearProgram()

# arete
x = p.new_variable(binary = True)

# sommets
y = p.new_variable(binary = True)
y = p.new_variable(binary = True)

# feuilles
f = p.new_variable(integer = True)
f = p.new_variable(integer = True)

p.set_objective(f[0] + f[1] + x[0])

p.add_constraint(y[1] + y[1] == 1)  # k la taille du sous arbre 
p.add_constraint(x[1] <= (y[0] + y[1])/2)  # presence d'une arete
p.add_constraint(y[0] + y[1] == x[0] + 1)  # arbre, connexe
p.add_constraint(f[0] <= 2 - x[0])  # contraintes sur les feuilles
p.add_constraint(f[1] <= 2 - x[0])
p.add_constraint(f[0] <= x[0] + 1)
p.add_constraint(f[1] <= x[0] + 1)

# contraintes utiles ou redondantes ?
p.add_constraint(f[0] <= x[0])
p.add_constraint(f[1] <= y[1])

#p.solve()
p.show()
print(p.solve())
print(p.get_values(x))
print(p.get_values(y))
print(p.get_values(f))
