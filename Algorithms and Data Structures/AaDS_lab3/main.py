#AaDS 3 Hash tables Damian Kościelny

import hashlib
import sys

from prettytable import PrettyTable

class HashNode:

    def __init__(self, k, v):
        self.key = k
        self.value = v


class HashMap:

    def __init__(self, number_of_elements, load_factor, double_hashing, is_string):
        self.load_factor = load_factor
        self.capacity = round(number_of_elements/load_factor)
        self.method = double_hashing
        self.string = is_string
        self.num = 2137 #prime number
        #print(self.capacity)
        self.size = 0
        self.hit = 0
        self.miss = 0
        self.table = [None] * self.capacity

    def H1(self, k):
        if strings:
            h = 0
            c1 = 31415
            c2 = 27183
            for letter in range(len(k)):
                h = (c1 * h + ord(k[letter])) % self.capacity
                c1 = (c1*c2) % (self.capacity - 1)
            if h < 0:
                return h + self.capacity
            else:
                return h
        else:
            return k % self.capacity

    def H2(self, k):
        if strings:
            h = 0
            c1 = 31415
            c2 = 27183
            for letter in range(len(k)):
                h = (c1 * h + ord(k[letter])) % self.capacity
                c1 = (c1*c2) % (self.capacity - 1)
            if h < 0:
                return 1 + ((h + self.capacity) % self.num)
            else:
                return 1 + (h % self.num)
        else:
            return 1 + (k % self.num)

    def InsertNode(self, k, v):
        if self.size == self.capacity:
            print("Table is full")
            return 0
        inserted = HashNode(k, v)
        hash_index = self.H1(k)
        if double_hashing:
            hash_index2 = self.H2(k)
        while self.table[hash_index] is not None and self.table[hash_index].key != k:
            if double_hashing:
                hash_index = (hash_index + hash_index2) % self.capacity
            else:
                hash_index += 1
                hash_index %= self.capacity
        if self.table[hash_index] is None:
            self.size += 1
            self.table[hash_index] = inserted

    def Search(self, k):
        hash_index = self.H1(k)
        hash_index2 = 0
        counter = 0
        if double_hashing:
            counter +=1
            if self.table[hash_index] is not None and self.table[hash_index].key == k:
                self.hit += counter
                return self.table[hash_index].value
            hash_index2 = self.H2(k)
            hash_index = (hash_index + hash_index2) % self.capacity
        while self.table[hash_index] is not None:
            counter += 1
            if self.table[hash_index].key == k:
                self.hit += counter
                #print("hit: " + str(self.hit) + " hash index: " + str(hash_index)+ " key: " + str(self.table[hash_index].key))
                return self.table[hash_index].value
            if double_hashing:
                hash_index = (hash_index + hash_index2) % self.capacity
            else:
                hash_index = (hash_index + 1) % self.capacity
        self.miss += counter
        #print("miss: " + str(self.miss) + " hash index: " + str(hash_index))
        return 0

    def GetMapSize(self):
        return self.size

    def Display(self):
        for i in range(self.capacity):
            if self.table[i] is not None and self.table[i].key != -1:
                print("index = ", i, "key = ", self.table[i].key, " value = ", self.table[i].value)

    def HitMiss(self):
        return self.hit/self.size, self.miss/self.size

if __name__ == "__main__":
    size = 0
    h = [0, 0, 0, 0]
    file1 = open("set_of_1050000_random_numbers.txt", "r")
    for size, val in enumerate(file1):
        pass
    load_factors = [0.5, 0.6, 0.7, 0.8, 0.9]
    double_hashing_arr = [False, True]
    strings = False                          #CHANGE FOR STRINGS
    T = PrettyTable()
    if strings:
        T.field_names = ["load factor", "h1 string hits", "h1 string misses", "h2 string hits", "h2 string misses"]
    else:
        T.field_names = ["load factor", "h1 int hits", "h1 int misses", "h2 int hits", "h2 int misses"]
    for j, load_factor in enumerate(load_factors):
        for l, double_hashing in enumerate(double_hashing_arr):
            for i in range(2):
                Hashing = HashMap(size + 1, load_factor, double_hashing, strings)
                if i == 0:
                    file1 = open("set_of_1050000_random_numbers.txt", "r")
                    file2 = open("set_of_1050000_random_numbers.txt", "r")
                else:
                    file1 = open("set_of_1050000_random_numbers.txt", "r")
                    file2 = open("set_of_1050000_random_numbers_for_search_miss.txt", "r")
                file1.seek(0)
                file2.seek(0)
                if strings:
                    for inserted_val in file1:
                        Hashing.InsertNode(hashlib.md5(inserted_val.encode('utf-8')).hexdigest(), inserted_val)
                else:
                    for inserted_val in file1:
                        Hashing.InsertNode(hash(inserted_val), inserted_val)
                    # print("count: " + str(inserted_val))
                # Hashing.Display()
                # Hashing.GetMapSize()
                if strings:
                    for searched_val in file2:
                        Hashing.Search(hashlib.md5(searched_val.encode('utf-8')).hexdigest())
                else:
                    for searched_val in file2:
                        Hashing.Search(hash(searched_val))
                if i == 0:
                    h[2 * l] = Hashing.HitMiss()[0]
                    print("Misses for load factor " + str(load_factor) + " and counting hits (should be 0): " + str(Hashing.HitMiss()[1]))
                else:
                    h[2 * l + 1] = Hashing.HitMiss()[1]
                    print("Hits for load factor " + str(load_factor) + " and counting misses (should be 0): " + str(Hashing.HitMiss()[0]))
                del Hashing
        T.add_row([load_factor, h[0], h[1], h[2], h[3]])

    print(T)