import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import csv

lines = list()

name = "metric_model6"

with open(name + '.csv', 'r') as readFile:
    reader = csv.reader(readFile)
    for row in reader:
        lines.append(row)
        if len(row) < 10:
            lines.remove(row)

with open('dat_clean_' + name + '.csv', 'w') as writeFile:
    writer = csv.writer(writeFile)
    writer.writerows(lines)


perf = pd.read_csv('dat_clean_' + name + '.csv')
perf["[run number]"][15] = "light_count"

lines_mat = list()
with open(name + '.csv', 'r') as readFile:
    reader = csv.reader(readFile)
    for row in reader:
        lines_mat.append(row)
        # for i in range(29):
        #     lines.remove(row)

lines_mat = lines_mat[29:len(lines_mat)]

with open('dat_mat_' + name + '.csv', 'w') as writeFile:
    writer = csv.writer(writeFile)
    writer.writerows(lines_mat)



perf = pd.read_csv('dat_mat_' + name + '.csv')


# perf = pd.read_csv('dat_clean_' + name + '.csv')
# perf["[run number]"][15] = "light_count"


# perf = perf.set_index('[run number]').transpose() 
# del perf['[initial & final values]']
# print(perf)

# pops_list = perf.population.unique()
# pops = []
# for pop in pops_list:
#     pops.append(int(pop))
# pops = np.array(pops)

# for i in range(len(perf["population"])):
#     perf["population"][i] = int(perf["population"][i])
#     perf["light_count"][i] = float(perf["light_count"][i])

# light_avg = (perf["light_count"]) / (perf["population"]*(int(perf['[steps]'][1])-100))

# pops_means = []
# for i in range(len(pops)):
#     pop_collect = []
#     for j in range(len(perf["population"])):
#         if perf["population"][j] == pops[i]:
#             pop_collect.append(light_avg[j]) ########
#             #pop_collect.append(perf["light_count"][j])
#     print("pop_collect = ", pop_collect) 
#     pops_means.append(np.mean(pop_collect))
# #print(pops_means)
# #light_per_fish = pops_means /(pops*(int(perf['[steps]'][1])))
# light_per_fish = pops_means # /(pops*(int(perf['[steps]'][1]))) #########


# print(light_per_fish)

# plt.plot(pops, light_per_fish)
# plt.title("Average Performance Metric Per Group Size (ten runs)")
# plt.xlabel("Population")
# plt.ylabel("Performance (Avg Luminosity of Fish and Time)")
# plt.show()

# print(perf["population"])