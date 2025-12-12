from csv import reader
from sys import stdin
from z3 import *

total = 0
reader = reader(stdin)
rows = []

for row in reader:
    if len(row) == 1 and row[0] == " ":
        var_count = len(rows[0]) - 1
        vars = [Int(chr(ord('a') + x)) for x in range(var_count)]
        s = Solver()
        for var in vars:
            s.add(var >= 0)
        for eq in rows:
            s.add(int(eq[0]) == sum(vars[i - 1] for i in range(1, len(eq)) if eq[i] == "1"))
        s.check()
        m = s.model()
        rows = []
        for var in vars:
            long_var = m[var].as_long()
            total += long_var
    else:
        rows.append(row)

print("total:", total)
