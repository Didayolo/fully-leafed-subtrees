# -*- coding: utf-8 -*-

# This file was *autogenerated* from the file cycle_iterator.sage
from sage.all_cmdline import *   # import sage library

_sage_const_3 = Integer(3); _sage_const_2 = Integer(2); _sage_const_1 = Integer(1); _sage_const_0 = Integer(0); _sage_const_5 = Integer(5); _sage_const_4 = Integer(4)#!/usr/bin/env python

def all_cycle(g):
    basic_cycles = g.cycle_basis()
    n = len(basic_cycles)
    basic_cycles_tmp = [] #temporary list to make the frozenset

    cycles = set()
    cycle_already_done = set() #keep couple of symmetric_differences already calculated

    #initialisation : adding basis cycles in set and in the result
    for c in basic_cycles:
        cycle_tmp = cycle_with_edges(c) #set of edges (tuples) of the cycle c
        cycles.add(cycle_tmp)
        basic_cycles_tmp.append(cycle_tmp)

    set_basic_cycles = frozenset(basic_cycles_tmp)

    #generating all cycles from the basis
    while(len(cycles) < (_sage_const_2 **n) - _sage_const_1 ):       
        cycle_tmp = cycles.copy()
        for i, c in enumerate(cycle_tmp):
            for j, c2 in enumerate(set_basic_cycles):
                if c.intersection(c2) and i != j and (c,c2) not in cycle_already_done:
                    cycles.add(c.symmetric_difference(c2))
                    cycle_already_done.add((c,c2))

    cycles.discard(frozenset([])) #removing empty set

    return cycles


def display_all_cycle(cycles):
    for c in cycles:
        print str(c).replace('frozenset([','{').replace('])','}')
    print "There are {} cycles." .format(len(cycles))


def cycle_with_edges(l):
    """ return set containing edges of the cycle list l """
    li = []
    for i, v in enumerate(l):
        if i + _sage_const_1  < len(l):
            li.append((v, l[i + _sage_const_1 ]))
            continue

    li.append((l[_sage_const_0 ], l[-_sage_const_1 ])) #edge between the first vertex and the last one
    ret = frozenset(tuple(li))

    return ret

def build_particular_graph():
    g = Graph()
    g.add_vertices([_sage_const_1 ,_sage_const_2 ,_sage_const_3 ,_sage_const_4 ,_sage_const_5 ])
    g.add_edges([(_sage_const_1 ,_sage_const_2 ), (_sage_const_2 ,_sage_const_3 ), (_sage_const_3 ,_sage_const_4 ), (_sage_const_4 ,_sage_const_5 ), (_sage_const_5 ,_sage_const_1 ), (_sage_const_1 ,_sage_const_3 ), (_sage_const_1 ,_sage_const_4 )])

    return g



g = graphs.CompleteGraph(_sage_const_4 )
#g = graphs.PetersenGraph()
ac = all_cycle(g)
display_all_cycle(ac)



