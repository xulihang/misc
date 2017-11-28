#coding=utf-8
import sys
longmandict={}


def loadDict():
    alphabet="abcdefghijklmnopqrstuvwxyz"
    for character in alphabet:
        fd=open("dict_en/"+character+".txt","r",encoding="utf-8")
        characterDict={}
        for line in fd.readlines():
            if line!="":
                try:
                    word=line.split("	")[0]
                    explaination=line.split("	")[1]
                    characterDict[word]=explaination
                except:
                    print(line)
        longmandict[character]=characterDict
        
print("loding dict...")
loadDict()
print("done")


f=open(sys.argv[1],"r",encoding="utf-8")
fw=open("out.txt","w",encoding="utf-8")
for line in f.readlines():
    word=line.split("  ")[0]
    try:
        explaination=longmandict[word[0:1].lower()][word]
    except:
        explaination="Null"
    if explaination=="Null":
        try:
            explaination=longmandict[word[0:1].lower()][word.lower()]
        except:
            explaination="Null"        
    fw.write(word+"\t"+explaination.replace("\n","")+"\n")
fw.close()
f.close()

