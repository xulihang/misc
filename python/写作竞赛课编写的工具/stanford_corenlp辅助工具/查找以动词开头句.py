#coding=utf-8
f=open("all.out","r",encoding="utf-8")
isSentence=False
num=0
line=f.readline()
totalNum=0
keepSentence=""
while line!="":
    if line.find("Sentence")!=-1:
        keepSentence=f.readline()
        firstWord=f.readline()
        #print(firstWord)
        if firstWord.find("VB]")!=-1:
            totalNum+=1
            print(keepSentence)
            print(totalNum)
    line=f.readline()
            
f.close()

