#!/usr/bin/env python
# -*- coding: utf-8 -*-

def all_cycle(g):
    basic_cycles = g.cycle_basis()
    n = len(basic_cycles) #there are n - 1 step to generate all cycles
    basic_cycles_tmp = [] #temporary list to make the frozenset

    cycles = set()
    cycle_already_done = set() #keep couple of symmetric_differences already calculated

    #initialisation : adding basis cycles in set and in the result
    for c in basic_cycles:
        cycle_tmp = cycle_with_edges(c) #set of edges of the cycle c
        cycles.add(cycle_tmp)
        basic_cycles_tmp.append(cycle_tmp)

    set_basic_cycles = frozenset(basic_cycles_tmp)

    #generating all cycles from the basis
    while(n - 1 > 0):
        cycle_tmp = cycles.copy()
        for i, c in enumerate(cycle_tmp):
            for j, c2 in enumerate(set_basic_cycles):
                if c.intersection(c2) and c != c2 and (c,c2) not in cycle_already_done:
                    cycles.add(c.symmetric_difference(c2))
                    cycle_already_done.add((c,c2)) #add and in/not in a set : O(1)
        n -= 1

    cycles.discard(frozenset([])) #removing empty set

    return cycles


def display_all_cycle(cycles):
    for i, c in enumerate(cycles):
        print str(i+1) + " : " + str(c).replace('frozenset([','{').replace('])','}')
    #print "There are {} cycles." .format(len(cycles))


def cycle_with_edges(l):
    r"""
        INPUT   : list representing a cycle
        OUTPUT  : (frozen)set containing edges of the cycle list l
        EXAMPLE : cycle_with_edges([0,1,2]) ==> {{0,1}, {1,2}, {2,0}}
    """
    li = []
    for i, v in enumerate(l):
        if i + 1 < len(l):
            li.append(frozenset([v, l[i + 1]]))
            continue

    li.append(frozenset([l[0], l[-1]])) #edge between the first vertex and the last one
    ret = frozenset(li)

    return ret


def cycle_iterator(g):
    basic_cycles = g.cycle_basis()
    n = len(basic_cycles)
    basic_cycles_tmp = [] #temporary list to make the frozenset

    cycles = set()
    cycle_already_done = set() #keep couple of symmetric_differences already calculated

    #initialisation : adding basis cycles in set and in the result
    for c in basic_cycles:
        cycle_tmp = cycle_with_edges(c) #set of edges of the cycle c
        cycles.add(cycle_tmp)
        basic_cycles_tmp.append(cycle_tmp)
        #yield cycle_tmp

    set_basic_cycles = frozenset(basic_cycles_tmp)

    #generating all cycles from the basis
    while(n - 1 > 0):
        cycle_tmp = cycles.copy()
        for i, c in enumerate(cycle_tmp):
            for j, c2 in enumerate(set_basic_cycles):
                if c.intersection(c2) and i != j and (c,c2) not in cycle_already_done:
                    #print "c : "+str(c).replace('frozenset([','{').replace('])','}')
                    #print "c2 : "+str(c2).replace('frozenset([','{').replace('])','}')
                    new_cycle = c.symmetric_difference(c2)
                    cycles.add(new_cycle)
                    cycle_already_done.add((c,c2))
                    yield new_cycle
        n -= 1


#r"""
g = graphs.CompleteGraph(5)
#g = graphs.PetersenGraph()
#g = Graph()
#g.add_vertices([1,2,3,4,5])
#g.add_edges([(1,2), (2,3), (3,4), (4,5), (5,1), (1,3), (1,4)])
ac = all_cycle(g)
display_all_cycle(ac)
"""
print "########################################"
it = cycle_iterator(g)
try:
    while(True):
        #print next(it)
        print "### "+str(next(it)).replace('frozenset([','{').replace('])','}')
except StopIteration:
    print "No more cycles"
finally:
    del it
    
"""