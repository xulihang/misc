#coding="utf-8"
import sys
import re


fw=open("out.txt","w",encoding="utf-8")
f=open("all","r",encoding="utf-8")
huiRex=re.compile(r"“.*?”")


for line in f.readlines():
    for sentence in huiRex.findall(line):
        print(sentence)
        fw.write(sentence+"\n")
    
#for sentence in huiRex.findall(f.read()):
#    print(sentence)

f.close()

fw.close()
    
