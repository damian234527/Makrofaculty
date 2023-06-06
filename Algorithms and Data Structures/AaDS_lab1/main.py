import random
import time
import numpy as np
from prettytable import PrettyTable
import sys

sys.setrecursionlimit(2000)

lab_1 = False
lab_2 = True

# integer section
lower_range = 0
upper_range = 10000
if lab_1:
    size = 250
    np.int_list = [random.sample(range(lower_range, upper_range), 2 ** 2 * size),
                   random.sample(range(lower_range, upper_range), 2 ** 3 * size),
                   random.sample(range(lower_range, upper_range), 2 ** 4 * size),
                   random.sample(range(lower_range, upper_range), 2 ** 5 * size),
                   random.sample(range(lower_range, upper_range), 2 ** 6 * size)]

if lab_2:
    size = 8000
    np.int_list = [np.random.randint(lower_range, upper_range, 2 ** 2 * size),
                  np.random.randint(lower_range, upper_range, 2 ** 3 * size),
                  np.random.randint(lower_range, upper_range, 2 ** 4 * size),
                  np.random.randint(lower_range, upper_range, 2 ** 5 * size),
                  np.random.randint(lower_range, upper_range, 2 ** 6 * size)]

# strings section
words_file = open("count_1w.txt", "r")
words = words_file.read().split()[::2]
words_list = [random.choices(words, k=2 * size), random.choices(words, k=2 ** 2 * size),
              random.choices(words, k=2 ** 3 * size), random.choices(words, k=2 ** 4 * size),
              random.choices(words, k=2 ** 5 * size)]


# words_list = [random.sample(words, 2*size), random.sample(words, 2**2*size), random.sample(words, 2**3*size),
# random.sample(words, 2**4*size), random.sample(words, 2**5*size)]

def check_if_sorted(arr):
    n = len(arr)
    i = 1
    is_sorted = 1
    while (i < n) and is_sorted:
        if arr[i - 1] > arr[i]:
            is_sorted = 0
            break
        i += 1
    return is_sorted


# Selection (basic)
def selection_sort(sorted_data):
    if check_if_sorted(sorted_data):
        return 111
    arr_len = len(sorted_data) - 1
    start = time.time()
    for i in range(arr_len):
        min_index = i
        for j in range(i + 1, arr_len):
            if sorted_data[j] < sorted_data[min_index]:
                min_index = j
        sorted_data[i], sorted_data[min_index] = sorted_data[min_index], sorted_data[i]
    end = time.time()
    if check_if_sorted(sorted_data) == 1:
        return end - start
    else:
        return 0


# Insertion (basic)
def insertion_sort(sorted_data):
    arr_len = len(sorted_data) - 1
    start = time.time()
    for i in range(arr_len):
        j = i
        while j > 0 and sorted_data[j - 1] > sorted_data[j]:
            sorted_data[j - 1], sorted_data[j] = sorted_data[j], sorted_data[j - 1]
            j = j - 1
    end = time.time()
    if check_if_sorted(sorted_data) == 1:
        return end - start
    else:
        return 0


# Bubble (basic)
def bubble_sort(sorted_data):
    arr_len = len(sorted_data) - 1
    start = time.time()
    for i in range(arr_len):
        swapped = False
        for j in range(0, arr_len - i):
            if sorted_data[j] > sorted_data[j + 1]:
                sorted_data[j], sorted_data[j + 1] = sorted_data[j + 1], sorted_data[j]
                swapped = True
        if not swapped:
            break
    end = time.time()
    if check_if_sorted(sorted_data) == 1:
        return end - start
    else:
        return 0


# Binary sort (Improved Insertion)
def binary_search(array, value, beginning, end):
    if beginning == end:
        if array[beginning] > value:
            return beginning
        else:
            return beginning + 1
    if beginning > end:
        return beginning
    half = beginning + ((end - beginning) // 2)
    if array[half] < value:
        return binary_search(array, value, half + 1, end)
    elif array[half] > value:
        return binary_search(array, value, beginning, half - 1)
    else:
        return half


def binary_sort(sorted_data):
    start = time.time()
    for i in range(len(sorted_data)):
        value = sorted_data[i]
        j = binary_search(sorted_data, value, 0, i - 1)
        sorted_data = sorted_data[:j] + [value] + sorted_data[j:i] + sorted_data[i + 1:]
    end = time.time()
    if check_if_sorted(sorted_data) == 1:
        return end - start
    else:
        return 0


# Cocktail Shaker (Improved Bubble)
def cocktail_shaker_sort(sorted_data):
    arr_len = len(sorted_data) - 1
    beginning = 0
    start = time.time()
    swapped = True
    while swapped:
        swapped = False
        for i in range(beginning, arr_len):
            if sorted_data[i] > sorted_data[i + 1]:
                sorted_data[i], sorted_data[i + 1] = sorted_data[i + 1], sorted_data[i]
                swapped = True
        if not swapped:
            break
        swapped = False
        arr_len -= 1
        for i in range(arr_len - 1, beginning - 1, -1):
            if sorted_data[i] > sorted_data[i + 1]:
                sorted_data[i], sorted_data[i + 1] = sorted_data[i + 1], sorted_data[i]
                swapped = True
        beginning += 1
    end = time.time()
    if check_if_sorted(sorted_data) == 1:
        return end - start
    else:
        return 0


# Comb sort (Improved Bubble)
def comb_sort(sorted_data):
    arr_len = len(sorted_data) - 1
    gap = arr_len
    swapped = True
    start = time.time()
    while gap != 1 or swapped == 1:
        gap = gap * 10 // 13
        if gap < 1:
            gap = 1
        swapped = False
        for i in range(arr_len - gap):
            if sorted_data[i] > sorted_data[i + gap]:
                sorted_data[i], sorted_data[i + gap] = sorted_data[i + gap], sorted_data[i]
                swapped = True
    end = time.time()
    if check_if_sorted(sorted_data) == 1:
        return end - start
    else:
        return 0


# checking
result_table = PrettyTable()
result_table_words = PrettyTable()

# lab 1
if lab_1:
    result_table.add_column("Algorithm name", ["Selection", "Insertion", "Bubble", "Binary", "Cocktail Shaker", "Comb"])
    result_table_words.add_column("Algorithm name",
                                  ["Selection", "Insertion", "Bubble", "Binary", "Cocktail Shaker", "Comb"])
    total_time_start = time.time()
    for i in range(len(np.int_list)):
        result_column = np.around([selection_sort(np.int_list[i].copy()), insertion_sort(np.int_list[i].copy()),
                                   bubble_sort(np.int_list[i].copy()), binary_sort(np.int_list[i].copy()),
                                   cocktail_shaker_sort(np.int_list[i].copy()), comb_sort(np.int_list[i].copy())],
                                  decimals=8)
        result_table.add_column(str(len(np.int_list[i])), result_column)
        # plt.scatter(np.full(len(result_column), len(np.int_list[i])), result_column)

    total_time_end = time.time()
    print("Integers:")
    print(result_table)
    print("Elapsed time: " + str(total_time_end - total_time_start))

    total_time_start = time.time()
    for i in range(len(np.int_list)):
        result_column_words = np.around([selection_sort(words_list[i].copy()), insertion_sort(words_list[i].copy()),
                                         bubble_sort(words_list[i].copy()), binary_sort(words_list[i].copy()),
                                         cocktail_shaker_sort(words_list[i].copy()), comb_sort(words_list[i].copy())],
                                        decimals=8)
        result_table_words.add_column(str(len(words_list[i])), result_column_words)

    total_time_end = time.time()

    print("Strings:")
    print(result_table_words)
    print("Elapsed time: " + str(total_time_end - total_time_start))


# lab 2

# Shellsort
def shellsort(sorted_data, predefined_gaps):
    arr_len = len(sorted_data)
    if predefined_gaps:
        k = 0
        gaps = [701, 301, 132, 57, 23, 10, 4, 1, 0]
        gap = gaps[k]
    else:
        gap = arr_len // 2
    start = time.time()
    while gap > 0:
        for i in range(gap, arr_len):
            temp = sorted_data[i]
            j = i
            while j >= gap and sorted_data[j - gap] > temp:
                sorted_data[j] = sorted_data[j - gap]
                j -= gap
            sorted_data[j] = temp
        if predefined_gaps:
            gap = gaps[k]
            k += 1
        else:
            gap //= 2
    end = time.time()
    if check_if_sorted(sorted_data) == 1:
        return end - start
    else:
        return 0

# Quicksort
def partitioning(data, first, last, version):
    if version == 1:
        pivot = data[first]
    elif version == 2:
        pivot = data[(first + last) // 2]
        data[first], data[(first + last) // 2] = data[(first + last) // 2], data[first]
    else:
        pivot_index = random.randint(first, last)
        pivot = data[pivot_index]
        data[first], data[pivot_index] = data[pivot_index], data[first]
    s = first + 1
    e = last
    while True:
        while s <= e and data[e] >= pivot:
            e -= 1
        while s <= e and data[s] <= pivot:
            s += 1
        if s <= e:
            data[s], data[e] = data[e], data[s]
        else:
            break
    data[first], data[e] = data[e], data[first]
    return e

def quicksort(sorted_data, first, last, version, original):
    if original:
        start = time.time()
    if first < last:
        pivot = partitioning(sorted_data, first, last, version)
        quicksort(sorted_data, first, pivot - 1, version, False)
        quicksort(sorted_data, pivot + 1, last, version, False)
        if original:
            end = time.time()
            if check_if_sorted(sorted_data) == 1:
                return end - start
            else:
                return 0


def quicksort_insertion(sorted_data, first, last, original):
    if original:
        start = time.time()
    while first < last:
        if last - first + 1 < 10:
            for i in range(first + 1, last + 1):
                val = sorted_data[i]
                j = i
                while j > first and sorted_data[j - 1] > val:
                    sorted_data[j] = sorted_data[j - 1]
                    j -= 1
                sorted_data[j] = val
            break
        else:
            pivot = partitioning(sorted_data, first, last, 1)
            if pivot - first < last - pivot:
                quicksort_insertion(sorted_data, first, pivot - 1, False)
                first = pivot + 1
            else:
                quicksort_insertion(sorted_data, pivot + 1, last, False)
                last = pivot - 1
    if original:
        end = time.time()
        if check_if_sorted(sorted_data) == 1:
            return end - start
        else:
            return 0


if lab_2:

    result_table.add_column("Algorithm name", ["Quicksort (first)", "Quicksort (random)", "Quicksort (median)",
                                               "Quicksort with Insertion", "Shellsort", "Shellsort (Ciura gap)"])
    result_table_words.add_column("Algorithm name", ["Quicksort (first)", "Quicksort (random)", "Quicksort (median)",
                                                     "Quicksort with Insertion", "Shellsort", "Shellsort (Ciura gap)"])
    """
    print(len(np.int_list[2]))
    print(quicksort(np.int_list[2].copy(), 0, len(np.int_list[2]) - 1, 1, True))
    print(quicksort(np.int_list[2].copy(), 0, len(np.int_list[2]) - 1, 2, True))
    print(quicksort(np.int_list[2].copy(), 0, len(np.int_list[2]) - 1, 3, True))
    print(quicksort_insertion(np.int_list[2].copy(), 0, len(np.int_list[2]) - 1, True))
    print(shellsort(np.int_list[2].copy(), False))
    print(shellsort(np.int_list[2].copy(), True))
    sys.exit()
    """
    total_time_start = time.time()
    for i in range(len(np.int_list)):
        result_column = np.around([quicksort(np.int_list[i].copy(), 0, len(np.int_list[i]) - 1, 1, True),
                                   quicksort(np.int_list[i].copy(), 0, len(np.int_list[i]) - 1, 2, True),
                                   quicksort(np.int_list[i].copy(), 0, len(np.int_list[i]) - 1, 3, True),
                                   quicksort_insertion(np.int_list[i].copy(), 0, len(np.int_list[i]) - 1, True),
                                   shellsort(np.int_list[i].copy(), False), shellsort(np.int_list[i].copy(), True)],
                                  decimals=8)
        result_table.add_column(str(len(np.int_list[i])), result_column)
    total_time_end = time.time()
    print("Integers:")
    print(result_table)
    print("Elapsed time: " + str(total_time_end - total_time_start))

    total_time_start = time.time()
    for i in range(len(words_list)):
        result_column_words = np.around([quicksort(words_list[i].copy(), 0, len(words_list[i]) - 1, 1, True),
                                   quicksort(words_list[i].copy(), 0, len(words_list[i]) - 1, 2, True),
                                   quicksort(words_list[i].copy(), 0, len(words_list[i]) - 1, 3, True),
                                   quicksort_insertion(words_list[i].copy(), 0, len(words_list[i]) - 1, True),
                                   shellsort(words_list[i].copy(), False), shellsort(words_list[i].copy(), True)],
                                  decimals=8)
        result_table_words.add_column(str(len(words_list[i])), result_column_words)

    total_time_end = time.time()
    print("Strings:")
    print(result_table_words)
    print("Elapsed time: " + str(total_time_end - total_time_start))
