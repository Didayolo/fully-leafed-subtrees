# -*- coding: utf-8 -*-
from graph_parser import parse
from max_leaves_algo import MaxLeaves
from graph_analyser import to_dot, to_dot_with_weights
from rand_tree import rand_tree

#Charger le graphe
graph = parse('graphtest')

#Générer un graphe aléatoire
#graph = rand_tree(10)

#Crée l'objet MaxLeaves qui calcule la fonction feuille
calc = MaxLeaves(graph)

#Calcule le nombre maximal de feuille
calc.find_max_leaves()

out = open('test.dot', 'w')
#Convertis le graphe en fichier .dot sans les poids
out.write(to_dot(graph))

#Convertis le graphe en fichier .dot avec les poids
#out.write(to_dot_with_weights(graph, calc))
out.close()
