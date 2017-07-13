#!/usr/bin/env python
# -*- coding: utf-8 -*-

def all_cycle(g):
    basic_cycles = g.cycle_basis()
    n = len(basic_cycles)
    basic_cycles_tmp = [] #set of set (cycles)

    cycles = set()
    cycle_already_done = set() #couples des cycles dont la diff symetrique a été faite

    for c in basic_cycles:
        cycle_tmp = cycle_with_edges(c) #set of edges (tuples) of the cycle c
        cycles.add(cycle_tmp)
        basic_cycles_tmp.append(cycle_tmp)

    set_basic_cycles = frozenset(basic_cycles_tmp)

    while(len(cycles) < (2^n) - 1):       
        cycle_tmp = cycles.copy()
        for i, c in enumerate(cycle_tmp):
            for j, c2 in enumerate(set_basic_cycles):
                #if has_intersection(c, c2) and i != j and (c,c2) not in cycle_already_done:
                if c.intersection(c2) and i != j and (c,c2) not in cycle_already_done:
                    #print "intersection btw {} and {}" .format(c, c2)
                    #tmp = c.symmetric_difference(c2)
                    #print tmp
                    cycles.add(c.symmetric_difference(c2))
                    cycle_already_done.add((c,c2))

    return cycles


def display_all_cycle(cycles):
    cycles.discard(frozenset([]))
    for c in cycles:
        print str(c).replace('frozenset([','{').replace('])','}')
    print "There are {} cycles." .format(len(cycles))


def cycle_with_edges(l):
    """ return set containing edges of the cycle list l """
    li = []
    for i, v in enumerate(l):
        if i + 1 < len(l):
            li.append((v, l[i + 1]))
            continue

    li.append((l[0], l[-1])) #ajout de l'arete du dernier au 1er sommet
    ret = frozenset(tuple(li))

    return ret

"""
g = graphs.CompleteGraph(5)
#g = graphs.PetersenGraph()
ac = all_cycle(g)
display_all_cycle(ac)
"""