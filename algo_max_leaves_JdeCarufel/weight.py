# -*- coding: utf-8 -*-
class Weight:
    def __init__(self, weight):
        self.__weight = weight if weight is not None else [0, 1]

    def __getitem__(self, index):
        return self.__weight[index] if 0 <= index < len(self) else 0

    def __str__(self):
        return str(self.__weight)

    def __len__(self):
        return len(self.__weight)

    def increment(self):
        return Weight([0, 1] + [self.__weight[i + 1] for i in range(len(self.__weight) - 1)])

    def __add__(self, other):
        new_weight = [[] for _ in range(len(self) + len(other)-1)]
        for i in range(len(self)):
            for j in range(len(other)):
                new_weight[i + j].append(self[i] + other[j])
        return Weight(list(map(max, new_weight)))
