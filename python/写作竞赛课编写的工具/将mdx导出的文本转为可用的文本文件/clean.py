#coding=utf8
import os
import sys

def clean(filename):
    f=open(filename,"r",encoding="utf-8")
    path=os.path.join("out", filename)
    fw=open(path,"a",encoding="utf-8")
    for line in f.readlines():

        line=line.split("	")
        if len(line)>=2:
            if len(line[1].split("\\n"))>=2:
                meaning=line[1].split("\\n")
                newlist=[line[0],meaning[1]]
                newline="	".join(newlist)
                fw.write(newline+"\n")
            else:
                print(line)

    fw.close()
    f.close()
    

if sys.argv[1]=="*.txt":
    for file in os.listdir("./"):
        if file.find(".txt")!=-1:
            clean(file)
