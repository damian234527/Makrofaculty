# Damian Kościelny AaDS 6

import math
import time
import sys
from itertools import permutations
from prettytable import PrettyTable
from ortools.constraint_solver import routing_enums_pb2
from ortools.constraint_solver import pywrapcp

iterations = 0

def tsp(data, start_node=0):
    filename, points = data
    file_tsp = open(filename)
    # rows, columns = [int(x) for x in next(file_tsp).split()]
    rows = int(next(file_tsp))
    if points > rows:
        points = rows
    distances = [[None for columns in range(points)] for rows in range(points)]
    row = 0
    for line in file_tsp:
        distances[row] = line.split(maxsplit=points)
        if len(distances[row]) == points + 1:
            distances[row].pop()
        distances[row] = list(map(int, distances[row]))
        row += 1
        if row == points:
            break
    results_bf = tsp_bf(distances, start_node)
    results_dp = tsp_dp(distances, start_node)
    results_or = tsp_or(distances, start_node)
    return results_bf, results_dp, results_or

def tsp_bf(data, start_node):
    start_time = time.time()
    node = []
    for i in range(len(data)):
        if i != start_node:
            node.append(i)
    permutation = permutations(node)
    min_path_value = sys.maxsize
    global iterations
    for i in permutation:
        weight = 0
        k = start_node
        current_path = [k + 1]
        for j in i:
            weight += int(data[k][j])
            k = j
            current_path.append(k + 1)
        weight += int(data[k][start_node])
        if weight < min_path_value:
            min_path_value = weight
            min_path = current_path
        iterations += 1
    min_path.append(start_node + 1)
    end_time = time.time()
    execution_time = end_time - start_time
    return min_path, min_path_value, iterations, execution_time


def tsp_dp(data, start_node):
    start_time = time.time()
    length = len(data)
    global iterations
    iterations = 0
    subsets = [[0] * length for _ in range(1 << length)]
    dp = [[-1] * length for _ in range(1 << length)]

    def dp_recursion(mask, position):
        global iterations
        if mask == (1 << length) - 1:
            return data[position][start_node]
        if dp[mask][position] != -1:
            return dp[mask][position]
        min_path_value = sys.maxsize
        for node in range(length):
            if (mask >> node) & 1 == 0:
                path_value = data[position][node] + dp_recursion(mask | (1 << node), node)
                if path_value < min_path_value:
                    min_path_value = path_value
                    next_node = node
            iterations += 1
        dp[mask][position] = min_path_value
        subsets[mask][position] = next_node
        return min_path_value

    def dp_path():
        node = start_node
        min_path = [node + 1]
        mask = 1 << start_node
        n = 0
        while n < length:
            next_node = subsets[mask][node]
            min_path.append(next_node + 1)
            mask |= 1 << next_node
            node = next_node
            n += 1
        return min_path

    min_path_value = dp_recursion(1 << start_node, start_node)
    min_path = dp_path()
    end_time = time.time()
    execution_time = end_time - start_time
    return min_path, min_path_value, iterations, execution_time


def tsp_or(data, start_node, global_search=0):
    start_time = time.time()
    manager = pywrapcp.RoutingIndexManager(len(data), 1, start_node)
    routing = pywrapcp.RoutingModel(manager)
    def distance_between(start_index, end_index):
        start_node = manager.IndexToNode(start_index)
        end_node = manager.IndexToNode(end_index)
        return data[start_node][end_node]
    transit_index = routing.RegisterTransitCallback(distance_between)
    routing.SetArcCostEvaluatorOfAllVehicles(transit_index)
    search_parameters = pywrapcp.DefaultRoutingSearchParameters()
    if global_search:
        search_parameters.first_solution_strategy = (routing_enums_pb2.FirstSolutionStrategy.GLOBAL_CHEAPEST_ARC)
    else:
        search_parameters.first_solution_strategy = (routing_enums_pb2.FirstSolutionStrategy.PATH_CHEAPEST_ARC)

    solution = routing.SolveWithParameters(search_parameters)
    if solution:
        index = routing.Start(0)
        min_path = ""
        min_path_value = 0
        while not routing.IsEnd(index):
            min_path += '{}, '.format(manager.IndexToNode(index) + 1)
            previous_index = index
            index = solution.Value(routing.NextVar(index))
            min_path_value += routing.GetArcCostForVehicle(previous_index, index, 0)
        min_path += '{}'.format(manager.IndexToNode(index) + 1)
        end_time = time.time()
        execution_time = end_time - start_time
        return min_path, min_path_value, execution_time

def cnc(data, beginning_point=0):
    filename, points = data
    file_cnc = open(filename)
    rows = int(next(file_cnc))
    if points > rows:
        points = rows
    coordinates = [[None for columns in range(2)] for rows in range(points)]
    row = 0
    for line in file_cnc:
        coordinates[row] = line.split(maxsplit=2)
        coordinates[row] = list(map(int, coordinates[row]))
        row += 1
        if row == points:
            break
    distances = [[None for columns in range(len(coordinates))] for rows in range(len(coordinates))]
    for starting_point, starting_node in enumerate(coordinates):
        for destination_point, destination_node in enumerate(coordinates):
            if starting_point == destination_point:
                distances[starting_point][destination_point] = 0
            else:
                distances[starting_point][destination_point] = round(math.hypot((starting_node[0] - destination_node[0]), (starting_node[1] - destination_node[1])))

    results_cnc_1 = tsp_or(distances, beginning_point)
    output_points_1 = list(map(int, results_cnc_1[0].split(", ")))
    #output_filename_1 = filename.split(".")[0] + "v1.txt"
    output_filename_1 = filename.split("/")[0] + "/c" + str(points) +"v1.txt"
    cnc_output_1 = open(output_filename_1, "w")
    cnc_output_1.write("%s\n" % len(coordinates))
    for point in range(len(coordinates)):
        cnc_output_1.write("%s\n" % coordinates[output_points_1[point]-1])
    cnc_output_1.close()

    results_cnc_2 = tsp_or(distances, beginning_point, global_search=1)
    output_points_2 = list(map(int, results_cnc_2[0].split(", ")))
    output_filename_2 = filename.split("/")[0] + "/c" + str(points) +"v2.txt"
    cnc_output_2 = open(output_filename_2, "w")
    cnc_output_2.write("%s\n" % len(coordinates))
    for point in range(len(coordinates)):
        cnc_output_2.write("%s\n" % coordinates[output_points_2[point]-1])
    cnc_output_2.close()
    output_filename_1 = output_filename_1.split("/")[1]
    output_filename_2 = output_filename_2.split("/")[1]
    return results_cnc_1, results_cnc_2, output_filename_1, output_filename_2
if __name__ == "__main__":
    tsp_data = [["Lab6/g4.txt", 4], ["Lab6/g13.txt", 4], ["Lab6/g13.txt", 9], ["Lab6/g13.txt", 10],
                ["Lab6/g13.txt", 11]]
    cnc_data = [["Lab6/c280.txt", 35], ["Lab6/c280.txt", 70], ["Lab6/c280.txt", 140], ["Lab6/c280.txt", 280]]

    tsp_table = PrettyTable()
    tsp_table.field_names = ["Input", "Points", "Path BF", "Path DP", "Length BF", "Length DP", "Iterations BF",
                             "Iterations DP", "Time BF", "Time DP"]
    tsp_or_table = PrettyTable()
    tsp_or_table.field_names = ["Input", "Points", "Path ORT", "Length ORT", "Time ORT"]
    for i in range(len(tsp_data)):
        results = tsp(tsp_data[i])
        tsp_table.add_row([tsp_data[i][0].split("/")[1], tsp_data[i][1], results[0][0], results[1][0], results[0][1], results[1][1], results[0][2], results[1][2], results[0][3], results[1][3]])
        tsp_or_table.add_row([tsp_data[i][0].split("/")[1], tsp_data[i][1], results[2][0], results[2][1], results[2][2]])
    print(tsp_table)
    print(tsp_or_table)
    cnc_table = PrettyTable()
    cnc_table.field_names = ["Points", "Output OR1", "Output OR2", "Length OR1", "Length OR2", "Time OR1", "Time OR2"]
    for i in range(len(cnc_data)):
        results = cnc(cnc_data[i])
        cnc_table.add_row([cnc_data[i][1], results[2], results[3], results[0][1], results[1][1], results[0][2], results[1][2]])
    print(cnc_table)
