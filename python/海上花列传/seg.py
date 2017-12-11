#coding="utf-8"
import sys
import re


filename=sys.argv[1]
f=open(filename,"r",encoding="utf-8")
huiRex=re.compile(r"第.+回：")


huis={}
currentHui=0

for line in f.readlines():
    line=line.strip()
    if huiRex.match(line):
        print(line)
        currentHui+=1
        huis[currentHui]=line+"\n"
    else:
        huis[currentHui]+=line+"\n"

f.close()

for hui in huis:
    fw=open(str(hui)+".txt","w",encoding="utf-8")
    fw.write(huis[hui])
    fw.close()

