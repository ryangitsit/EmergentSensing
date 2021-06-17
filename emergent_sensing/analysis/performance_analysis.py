import numpy as np
import pandas as pd
import matplotlib.pyplot as plt



import csv

lines = list()

with open('Emergent_Sensing_Accel experiment-spreadsheet.csv', 'r') as readFile:
    reader = csv.reader(readFile)
    for row in reader:
        lines.append(row)
        if len(row) < 10:
            lines.remove(row)

with open('dat_clean.csv', 'w') as writeFile:
    writer = csv.writer(writeFile)
    writer.writerows(lines)



# with open('Emergent_Sensing_Accel experiment-spreadsheet.csv', 'rb') as inp, open('Emergent_Sensing_Accel_clean.csv', 'wb') as out:
#     writer = csv.writer(out)
#     print(csv.reader(inp))
#     for row in csv.reader(inp):
#         if len(row) > 10:
#             writer.writerow(row)

perf = pd.read_csv("Emergent_Sensing_Accel experiment-spreadsheet.csv")

perf = perf.T
# perf = perf.iloc[1: , :]
print(perf.header())

# print(perf[str(1)][15])

# pops = [10, 50, 100, 200]
# lights = []
# for cond in range(4):
#     runs = []
#     for run in range(10):
#         if cond*10+run != 0:
#             runs.append(int(perf[str(cond*10+run)][15]))
#         #print(runs)
#     lights.append(np.mean(np.array(runs)))
# print(pops, "\n", lights, "\n")

# for i in range(len(pops)):
#     print(lights[i]/pops[i])