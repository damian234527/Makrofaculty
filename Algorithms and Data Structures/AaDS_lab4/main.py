# AaDS 4 Dynamic Programming Damian Kościelny
import sys

from prettytable import PrettyTable
import time

iterations = 1


def LCS_REC(stringA, stringB, a_len=0, b_len=0, original=False):
    if original:
        global iterations
        iterations = 1
        a_len = len(stringA)
        b_len = len(stringB)
    else:
        iterations += 1
    if a_len == 0 or b_len == 0:
        return 0
    if stringA[a_len - 1] == stringB[b_len - 1]:
        return 1 + LCS_REC(stringA, stringB, a_len - 1, b_len - 1)
    return max(LCS_REC(stringA, stringB, a_len, b_len - 1), LCS_REC(stringA, stringB, a_len - 1, b_len))


def LCS_DP(stringA, stringB, display=False):
    start = time.time()
    subsequence = ""
    iterations = 0
    a_len = len(stringA)
    b_len = len(stringB)
    L = [[None] * (b_len + 1) for i in range(a_len + 1)]
    for i in range(a_len + 1):
        for j in range(b_len + 1):
            if i == 0 or j == 0:
                L[i][j] = 0
            elif stringA[i - 1] == stringB[j - 1]:
                L[i][j] = L[i - 1][j - 1] + 1

            else:
                L[i][j] = max(L[i - 1][j], L[i][j - 1])
            iterations += 1
    stop = time.time()
    i = a_len
    j = b_len
    while i > 0 and j > 0:
        if stringA[i - 1] == stringB[j - 1]:
            subsequence += stringA[i - 1]
            i -= 1
            j -= 1
        elif L[i - 1][j] > L[i][j - 1]:
            i -= 1
        else:
            j -= 1
    subsequence = subsequence[::-1]
    if display:
        L_table = PrettyTable()
        L_table.add_column("", list("Ø" + stringA))
        L_table.add_column("Ø", [column[0] for column in L])
        for j in range(b_len):
            L_table.add_column(stringB[j], [column[j + 1] for column in L])
        print(L_table)
    elapsed = stop - start
    return L[a_len][b_len], subsequence, iterations, elapsed


def ED_REC(stringA, stringB, a_len=0, b_len=0, original=False):
    if original:
        global iterations
        iterations = 1
        a_len = len(stringA)
        b_len = len(stringB)
    else:
        iterations += 1
    if a_len == 0:
        return b_len
    if b_len == 0:
        return a_len
    if stringA[a_len - 1] == stringB[b_len - 1]:
        return ED_REC(stringA, stringB, a_len - 1, b_len - 1,)
    return 1 + min(ED_REC(stringA, stringB, a_len, b_len - 1), ED_REC(stringA, stringB, a_len - 1, b_len),
                   ED_REC(stringA, stringB, a_len - 1, b_len - 1))


def ED_DP(stringA, stringB, display=False):
    a_len = len(stringA)
    b_len = len(stringB)
    iterations = 0
    operations = ""
    E = [[None] * (b_len + 1) for i in range(a_len + 1)]
    for i in range(a_len + 1):
        for j in range(b_len + 1):
            if i == 0:
                E[i][j] = j  # insert
            elif j == 0:
                E[i][j] = i  # delete
            elif stringA[i - 1] == stringB[j - 1]:
                E[i][j] = E[i - 1][j - 1]  # substitute
            else:
                E[i][j] = 1 + min(E[i][j - 1], E[i - 1][j], E[i - 1][j - 1])
                                    # insert       #remove       #replace
            iterations += 1
    i = a_len
    j = b_len
    while i > 0 and j > 0:
        if stringA[i - 1] == stringB[j - 1]:
            operations = stringA[i - 1] + operations
            i -= 1
            j -= 1
        elif E[i][j] == E[i - 1][j] + 1:
            operations = " del(" + stringA[i - 1] + ") " + operations
            i -= 1
        elif E[i][j] == E[i][j - 1] + 1:
            operations = " ins(" + stringB[j - 1] + ") " + operations
            j -= 1
        elif E[i][j] == E[i - 1][j - 1] + 1:
            operations = " sub(" + stringA[i - 1] + "," + stringB[j - 1] + ") " + operations
            i -= 1
            j -= 1


    print(operations)
    if display:
        E_table = PrettyTable()
        E_table.add_column("", list("Ø" + stringA))
        E_table.add_column("Ø", [column[0] for column in E])
        for j in range(b_len):
            E_table.add_column(stringB[j], [column[j + 1] for column in E])
        print(E_table)
    return E[a_len][b_len], operations, iterations


lcs = True
ed = True

if lcs:
    LCS_table = PrettyTable()
    LCS_table.field_names = ["String A", "String B", "Length of LCS - DP", "Length of LCS - REC", "LCS", "DP iterations", "REC iterations"]
    LCS_words = [["ABCDGH", "AGGTAB", "ABCBDAB", "XMJYAUZ"], ["AEDFHR", "GXTXAYB", "BDCABA", "MZJAWXU"]]
    for i in range(len(LCS_words[0])):
        DP_results = LCS_DP(LCS_words[0][i], LCS_words[1][i], 1)
        REC_results = [LCS_REC(LCS_words[0][i], LCS_words[1][i], original=True), iterations]
        # if DP_results[0] == REC_results[0]:
        LCS_table.add_row(
            [LCS_words[0][i], LCS_words[1][i], DP_results[0], REC_results[0], DP_results[1], DP_results[2], REC_results[1]])
    #LCS_table.float_format = '.10'
    print(LCS_table)

if ed:
    ED_table = PrettyTable()
    ED_table.field_names = ["String A", "String B", "ED DP", "ED REC", "Operations", "Iterations DP", "Iterations REC"]
    ED_words = [["INTENTION", "SUNDAY", "CART", "QUARANTINE"], ["EXECUTION", "SATURDAY", "MARCH", "RUNTIME"]]
    for i in range(len(ED_words[0])):
        ED_DP_results = ED_DP(ED_words[0][i], ED_words[1][i], 1)
        ED_REC_results = [ED_REC(ED_words[0][i], ED_words[1][i], original=True), iterations]
        ED_table.add_row(
            [ED_words[0][i], ED_words[1][i], ED_DP_results[0], ED_REC_results[0], ED_DP_results[1], ED_DP_results[2], ED_REC_results[1]])
    print(ED_table)
