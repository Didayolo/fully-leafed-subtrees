# -*- coding: utf-8 -*-
from graph import Graph
from weight import Weight


class MaxLeaves:
    def __init__(self, g):
        self._graph = g
        self._weights = {}
        self._toCheck = []

    def __getitem__(self, item):
        return self._weights[item]

    def find_max_leaves(self):
        #Ajoute les poids aux arêtes au bout d'une feuille
        #Empile toutes les arêtes
        self._weight_leaves()
        #Vide la pile en calculant si possible les poids des arêtes
        self._empty_tocheck()
        #Convertis les poids sur chaque arête en fonction feuille
        self._compile_weights()

    def _empty_tocheck(self):
        while len(self._toCheck) > 0:
            edge = self._toCheck[0]
            del self._toCheck[0]
            #Si l'arête n'a pas de poids
            if edge not in self._weights:
                neighbors = [(edge[1], prec) for prec in self._graph.get_neighbors(edge[1]) if
                                           prec != edge[0]]
                #Si tous les parents de l'arête ont un poids on fixe le poids comme la somme des poids
                if all([key in self._weights for key in neighbors]):
                    self._weights[edge] = self._weights[neighbors.pop()]
                    for neighbor in neighbors:
                        self._weights[edge] = self._weights[edge] + self._weights[neighbor]
                    self._weights[edge] = self._weights[edge].increment()
                else:
                    self._toCheck.extend(filter(lambda x: x not in self._toCheck, neighbors))
                    self._toCheck.append(edge)

    def _weight_leaves(self):
        #Ajoute toutes les arêtes à la pile
        self._toCheck.extend(self._graph.get_directed_edges())
        for edge in self._graph.get_directed_edges():
            #Si le bout de l'arête est une feuille, on fixe le poids à [0,1]
            if self._graph.get_degree(edge[1]) == 1:
                self._weights[edge] = Weight([0, 1])
                to_add = [(next_edge, edge[0]) for next_edge in self._graph.get_neighbors(edge[0])]
                self._toCheck.extend(filter(lambda x: x[0] != edge[1] and x not in self._toCheck, to_add))

    def _compile_weights(self):
        #Compile la fonction feuille à partir des poids
        fonctionfeuille = [0 for _ in range(len(self._graph)+1)]
        for edge in self._graph.get_edges():
            curfoncfeuille = self._weights[edge] + self._weights[(edge[1], edge[0])]
            for i in range(len(curfoncfeuille)):
                if curfoncfeuille[i] > fonctionfeuille[i]:
                    fonctionfeuille[i] = curfoncfeuille[i]
        diff = []
        for i in range(len(fonctionfeuille)-1):
            diff.append(1 if fonctionfeuille[i] < fonctionfeuille[i+1] else 0)
        #Affiche la fonction feuille et la suite de différences
        print(fonctionfeuille)
        print(diff)
