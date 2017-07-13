# -*- coding: utf-8 -*-

from random import randint

from graph import Graph


def rand_tree(size):
    rtn = Graph(size)
    for i in range(1,size):
        rtn.link(i, randint(0, i-1))
    return rtn
