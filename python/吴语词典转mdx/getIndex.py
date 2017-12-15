#coding=utf-8
import os
from bs4 import BeautifulSoup
import re

indexDict={}

def getContent(html):
    soup = BeautifulSoup(html, 'lxml')
    for a in soup.find_all("a","btn btn-default btn-block line2left"):
        link=a["href"]
        traWord=""
        simWord=""
        pinyin=""
        traWord=a.contents[0].split(" ")[0]
        small=str(a.small)
        small=small.replace("<small>","")
        small=small.replace("</small>","")
        small=small.strip()
        inBetween=False
        small=small.split(" ")
        while "" in small:
            small.remove("")
        simWord=small[0]
        pinyin=" ".join(small[1:])
        addToDict(traWord,simWord,pinyin,link)

def addToDict(traWord,simWord,pinyin,link):
    #dict[traWord]={"simWord":simWord,"pinyin":pinyin,"link":link}
    indexDict[traWord]=simWord+"\t"+pinyin+"\t"+link
    
def saveDict():
    f=open("result","w",encoding="utf-8")
    for key in indexDict.keys():
        f.write(key+"\t"+indexDict[key]+"\n")
    f.close()


for file in os.listdir("./"):
    if file.find("html")!=-1:
        print(file)
        f=open(file,"r",encoding="utf-8")
        content=f.read()
        getContent(content)
        f.close()
saveDict()
