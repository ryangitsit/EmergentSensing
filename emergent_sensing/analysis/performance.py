import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib
import csv

"""
 - This python file executes experimental analysis for a given input csv.
 - Uses standard pandas, numpy, csv, and matplotlib libraries
 - Thanks for reading!
"""

lines = list()

name = "final_dynamic_speed" # provide csv name (no suffix)

# this rewrites the file to a new csv to exclude all rows length < 10
with open(name + '.csv', 'r') as readFile:
    reader = csv.reader(readFile)
    for row in reader:
        lines.append(row)
        if len(row) < 10:
            lines.remove(row)

# the output csv is ready for analysis with only viable rows
with open('dat_clean_' + name + '.csv', 'w') as writeFile:
    writer = csv.writer(writeFile)
    writer.writerows(lines)

# the new csv is named with a prefix of dat_clean
perf = pd.read_csv('dat_clean_' + name + '.csv')

# the light count column is given a name
perf["[run number]"][15] = "light_count"

# transpose to make suitable for pandas dataframe
perf = perf.set_index('[run number]').transpose() 
del perf['[initial & final values]']
print(perf)

# compile a lise of all population values
pops_list = perf.population.unique()
pops = []
for pop in pops_list:
    pops.append(int(pop))
pops = np.array(pops)

# ensure all relevant cells are read as integers
for i in range(len(perf["population"])):
    perf["population"][i] = int(perf["population"][i])
    perf["light_count"][i] = float(perf["light_count"][i])

# average light count for each run over population size and ticks
# note the first 100 ticks are always zero because recording not started
# subtract thos ticks from averaging value to get true time average
light_avg = (perf["light_count"]) / (perf["population"]*(int(perf['[steps]'][1])-100))


# the following block of code loops over all experiments
# collects experminets with same population into pop_collect list
# appends average of pop_collect to pops_means for each run value
# take standard deviation for each group of population runs 
pops_means = []
pops_std = []
for i in range(len(pops)):
    pop_collect = []
    for j in range(len(perf["population"])):
        if perf["population"][j] == pops[i]:
            pop_collect.append(light_avg[j])
    print("pop_collect = ", pop_collect) 
    pops_means.append(np.mean(pop_collect))
    pops_std.append(np.std(pop_collect))
light_per_fishtime = pops_means 

# simple plot of performance = light per fish per time averaged over runs
# x-axis is each population value for experiments 
fig1, ax1 = plt.subplots()
ax1.errorbar(x=pops, y=light_per_fishtime, yerr=pops_std, ecolor="black", capsize=0, elinewidth=1)
# scaling the x-axis in the same way as the Berdalh et al results
ax1.set_xscale('log')
ax1.set_xticks(pops)
ax1.get_xaxis().set_major_formatter(matplotlib.ticker.ScalarFormatter())

# Change title depending on experiment
plt.title("Average Performance Metric Per Group Size (ten runs) for dynamic light based speed", fontsize=9)
plt.xlabel("Population", fontsize=8)
plt.ylabel("Performance (Avg Darkness-Value of Fish and Time)", fontsize=8)
plt.show()

# enjoy!