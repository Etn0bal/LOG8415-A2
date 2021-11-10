import re
import sys

dir_name = sys.argv[1]
file_name = sys.argv[2]

with open(dir_name + "/" + file_name, "r") as f:
    regex = re.compile(r"(?<=user\t)(.*?)(?=\n)")
    ungroup = regex.findall(f.read())
    
with open(dir_name + "/" + "results.csv", "w") as f:
    for res in ungroup:
        f.write(f"{file_name},{res}\n")
