# -*- coding: utf-8 -*-
import graph


def parse(path):
    file = open(path, 'r')
    size = int(file.readline())
    rtn = graph.Graph(size)
    curline = file.readline()
    while len(curline) != 0:
        nodes = curline.split(',')
        rtn.link(int(nodes[0]), int(nodes[1]))
        curline = file.readline()
    return rtn
