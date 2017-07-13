# -*- coding: utf-8 -*-
from graph import Graph


def is_tree(g):
    pass


def to_dot(g):
    rtn = ''
    rtn += 'graph {\n'
    edges = g.get_edges()
    for i in range(len(g)):
        rtn += '    ' + 'n' + str(i) + '[label=\"\"]\n'
    for edge in edges:
        rtn += '    ' + 'n' + str(edge[0]) + ' -- ' + 'n' + str(edge[1]) + '\n'
    rtn += '}'
    return rtn


def to_dot_with_weights(g, m):
    rtn = ''
    rtn += 'graph {\n'
    edges = g.get_edges()
    for i in range(len(g)):
        rtn += '    ' + 'n' + str(i) + '[label=\"\"]\n'
    for edge in edges:
        rtn += '    ' + 'n' + str(edge[0]) + ' -- ' + 'n' + str(edge[1]) + '[shape=point,label=\"' + \
            str(m[(edge[0], edge[1])]) + ', ' + str(m[(edge[1], edge[0])]) + '\"]\n'
    rtn += '}'
    return rtn
