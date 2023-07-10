# AaDS 5 Graph Damian Kościelny
import copy
import sys
import numpy as np
from prettytable import PrettyTable
from collections import defaultdict, deque
from queue import Queue

def floyd_warshall(filename):
    with open(filename, "r") as file:
        nodes, edges = [int(x) for x in next(file).split()]
        inf = sys.maxsize
        graph = np.full((nodes, nodes), inf)
        np.fill_diagonal(graph, 0)
        for line in file:
            source, target, weight = [int(n) for n in line.split()]
            graph[source - 1, target - 1] = weight
    # print(graph)

    distance = copy.copy(graph)
    path = copy.copy(graph)
    for i in range(nodes):
        for j in range(nodes):
            distance[i][j] = graph[i][j]
            if distance[i][j] != inf and i != j:
                path[i][j] = j
            else:
                path[i][j] = -1
    solution = ""
    iterations = 0
    for inter in range(nodes):
        if nodes >= 100:
            print(f"checkin {inter} out of {nodes}")
        for src in range(nodes):
            for dst in range(nodes):
                if distance[src][inter] != inf and distance[inter][dst] != inf and distance[src][inter] + \
                        distance[inter][dst] < distance[src][dst]:
                    distance[src][dst] = distance[src][inter] + distance[inter][dst]
                    path[src][dst] = path[src][inter]
                iterations += 1

    # print(path)
    routes = 0
    file_fw_output = open(filename.split(".")[0] + "_output.txt", "w")
    for src in range(nodes):
        for dst in range(nodes):
            solution = "d[" + str(src + 1) + "," + str(dst + 1) + "] = " + str(distance[src][dst]) + "; PATH: " + str(
                src + 1)
            i = src
            j = dst
            if i != j:
                while i != j:
                    original_i = i
                    i = path[i][j]
                    if original_i == i:
                        solution = "d[" + str(src + 1) + "," + str(dst + 1) + "] = INF; PATH: NO PATH"
                        break
                    solution += "-" + str(i + 1)
                solution += "\n"
                routes += 1
                file_fw_output.write(solution)
    file_fw_output.write(
        "\nNODES: " + str(nodes) + "\nEDGES: " + str(edges) + "\nROUTES: " + str(routes) + "\nITERATIONS: " + str(
            iterations))
    file_fw_output.close()
    return file_fw_output.name, nodes, edges, routes, iterations


def breadth_first_search(graph, end_points):
    start, end = end_points
    queue = deque([(start, [start])])
    visited = {start}
    iterations = 1
    while queue:
        node, path = queue.popleft()

        if node == end:
            return path, iterations

        for neighbor in graph[node]:
            if neighbor not in visited:
                visited.add(neighbor)
                queue.append((neighbor, path + [neighbor]))
            iterations += 1
    return None


def graph_from_file(filename):
    graph = defaultdict(list)
    with open(filename, "r") as file:
        num_nodes, num_edges = map(int, file.readline().split())
        for i in range(num_edges):
            source, target = map(int, file.readline().split())
            graph[source].append(target)
    return graph

def maze(filename):

    with open(filename, "r") as file:
        width, height = map(int, file.readline().split())
        maze = [list(file.readline().strip()) for i in range(height)]
    directions = [(-1, 0), (1, 0), (0, -1), (0, 1)]
    height, width = len(maze), len(maze[0])
    start, end = None, None

    for i in range(height):
        for j in range(width):
            if maze[i][j] in "IO":
                if maze[i][j] == "I":
                    start = (i, j)
                if maze[i][j] == "O":
                    end = (i, j)

    parent_map = {}
    queue = Queue()
    visited = set()

    queue.put(start)
    visited.add(start)

    iterations = 0
    while not queue.empty():
        current = queue.get()
        iterations += 1
        if current == end:
            break

        for direction in directions:
            new_x, new_y = current[0] + direction[0], current[1] + direction[1]

            if 0 <= new_y < width and 0 <= new_x < height and maze[new_x][new_y] in ".O" and (new_x, new_y) not in visited:
                neighbor = (new_x, new_y)
                parent_map[neighbor] = current
                queue.put(neighbor)
                visited.add(neighbor)
    path = []
    current = end

    while current:
        path.append(current)
        current = parent_map.get(current)

    path.reverse()

    if not path:
        print("No path found.")
    else:
        print("Shortest path:")
        for point in path:
            print(f"[{point[0]}, {point[1]}]")

        print("\nOriginal maze:")
        for row in maze:
            print("".join(row))

        for point in path:
            maze[point[0]][point[1]] = "*"
        output_filename = filename.split(".txt")[0] + "_output.txt"
        with open(output_filename, "w") as output_file:
            print("\nSolved maze:")
            for row in maze:
                output = "".join(row)
                print(output)
                output_file.write(output + "\n")
    return output_filename, width, height, path, iterations
# Driver's code
if __name__ == "__main__":

    fw = True
    bfs = True
    m = True
    if fw:
        fw_data = ["Lab5/g5.txt", "Lab5/g10.txt", "Lab5/g100.txt", "Lab5/g200.txt", "Lab5/g500.txt", "Lab5/g1000.txt"]
        fw_table = PrettyTable()
        fw_table.field_names = ["Input", "Output", "Nodes", "Edges", "Routes", "Iterations"]
        for i in range(len(fw_data)):
            results_fw = floyd_warshall(fw_data[i])
            print(results_fw)
            fw_table.add_row(
                [fw_data[i].split("/")[1], results_fw[0].split("/")[1], results_fw[1], results_fw[2], results_fw[3],
                 results_fw[4]])
        print(fw_table)
    if bfs:
        bfs_data = [["Lab5/b10.txt", [3, 9]], ["Lab5/b10.txt", [8, 9]], ["Lab5/b20.txt", [10, 11]],
                    ["Lab5/b20.txt", [5, 7]], ["Lab5/b50.txt", [5, 7]], ["Lab5/b50.txt", [7, 9]], ["Lab5/b100.txt", [6, 9]],
                    ["Lab5/b100.txt", [99, 100]]]
        bfs_table = PrettyTable()
        bfs_table.field_names = ["Input file", "Start", "End", "Path", "Length", "Iterations"]
        for i in range(len(bfs_data)):
            graph = graph_from_file(bfs_data[i][0])
            results_bfs = breadth_first_search(graph, bfs_data[i][1])
            bfs_table.add_row(
                [bfs_data[i][0].split("/")[1], bfs_data[i][1][0], bfs_data[i][1][1], results_bfs[0], len(results_bfs[0]),
                 results_bfs[1]])
            # print(f"Path from {bfs_data[i][1][0]} to {bfs_data[i][1][1]}: {results[0]}, iterations: {results[1]}")
        print(bfs_table)
    if m:
        m_data = ["Lab5/m5x5.txt", "Lab5/m15x8.txt", "Lab5/m15x15.txt"]
        m_table = PrettyTable()
        m_table.field_names = ["Input file", "Output file", "Width", "Height", "Path", "Length", "Iterations"]
        for i in range(len(m_data)):
            results_m = maze(m_data[i])
            m_table.add_row([m_data[i].split("/")[1], results_m[0], results_m[1], results_m[2], results_m[3], len(results_m[3]), results_m[4]])
        print(m_table)