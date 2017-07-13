# -*- coding: utf-8 -*-
class Graph:
    def __init__(self, size):
        self.__adjacency_matrix = [[False for i in range(size)] for j in range(size)]

    def __len__(self):
        return len(self.__adjacency_matrix)

    def link(self, first, second):
        self.__adjacency_matrix[first][second] = True
        self.__adjacency_matrix[second][first] = True

    def are_linked(self, first, second):
        return self.__adjacency_matrix[first][second]

    def get_neighbors(self, node):
        rtn = []
        for i in range(len(self)):
            if self.are_linked(i, node):
                rtn.append(i)
        return rtn

    def get_edges(self):
        rtn = []
        for i in range(len(self)):
            for j in range(i + 1):
                if self.are_linked(i, j):
                    rtn.append((i, j))
        return rtn

    def get_directed_edges(self):
        rtn = []
        for i in range(len(self)):
            for j in range(len(self)):
                if self.are_linked(i, j):
                    rtn.append((i, j))
        return rtn

    def get_degree(self, node):
        rtn = 0
        for i in range(len(self)):
            rtn += self.are_linked(node, i)
        return rtn

