import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import csv

lines = list()

name = "accel_lightspeed_delay"

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
#print(perf["[run number]"][15])



perf = perf.set_index('[run number]').transpose() 
del perf['[initial & final values]']
# print(list(perf.columns.values))
# print(perf["light_count"])
# print(perf)
# print(perf.population.unique())



pops_list = perf.population.unique()
pops = []
for pop in pops_list:
    pops.append(int(pop))
pops = np.array(pops)

for i in range(len(perf["population"])):
    perf["population"][i] = int(perf["population"][i])
    perf["light_count"][i] = float(perf["light_count"][i])

light_avg = (perf["light_count"]) / (perf["population"]*(int(perf['[steps]'][1])))

pops_means = []
for i in range(len(pops)):
    pop_collect = []
    for j in range(len(perf["population"])):
        if perf["population"][j] == pops[i]:
            pop_collect.append(light_avg[j]) ########
            #pop_collect.append(perf["light_count"][j]) 
    pops_means.append(np.mean(pop_collect))
#print(pops_means)
#light_per_fish = pops_means /(pops*(int(perf['[steps]'][1])))
light_per_fish = pops_means # /(pops*(int(perf['[steps]'][1]))) #########


print(light_per_fish)

plt.plot(pops, light_per_fish)
plt.title("Average Performance Metric Per Group Size (ten runs)")
plt.xlabel("Population")
plt.ylabel("Performance (Avg Darkness of Fish and Time)")
plt.show()


