#coding=utf8
import os
import sys
from bs4 import BeautifulSoup

def clean(filename):
    f=open(filename,"r",encoding="utf-8")
    path=os.path.join("out", filename)
    fw=open(path,"a",encoding="utf-8")
    for line in f.readlines():
        line=removeHtml(line)
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

def removeHtml(line):
    line=line.replace("<br>","  ")
    soup = BeautifulSoup(line, 'lxml')
    line=soup.get_text()
    return line
    

if sys.argv[1]=="*.txt":
    for file in os.listdir("./"):
        if file.find(".txt")!=-1:
            clean(file)
else:
    clean(sys.argv[1])
