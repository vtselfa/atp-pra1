import sys
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

assert(len(sys.argv) == 2)
df = pd.read_table(sys.argv[1], sep=",")
df.columns = ["benchmark", "stat", "value"]
df = df.pivot(index='stat', columns='benchmark', values='value')
df = df.div(df.sum(axis=0), axis=1)
print(df.tail(10))
df.T.plot(kind="bar", stacked=True)
plt.show()


