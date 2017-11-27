#coding=utf-8
import sys
longmandict={}


def loadDict():
    fd=open("dict/chinese.txt","r",encoding="utf-8")
    for line in fd.readlines():
        if line!="":
            try:
                word=line.split("	")[0]
                explaination=line.split("	")[1]
                longmandict[word]=explaination
            except:
                print(line)
    
        
print("loding dict...")
loadDict()
print("done")


f=open(sys.argv[1],"r",encoding="utf-8")
fw=open("out.txt","a",encoding="utf-8")
for line in f.readlines():
    word=line.split("  ")[0]
    try:
        explaination=longmandict[word]
    except:
        explaination="Null"
    fw.write(word+"\t"+explaination.replace("\n","")+"\n")
fw.close()
f.close()

