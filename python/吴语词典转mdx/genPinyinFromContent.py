#coding=utf-8
from bs4 import BeautifulSoup
import re
import os



def getContent(html):
    soup = BeautifulSoup(html, 'lxml')
    global div
    div=soup.find_all("div","box-body")[1]
    #print(div)
    traWord=""
    simWord=""
    pinyin=""
    rex=re.compile(r"<h3>.*?<small>",re.S)
    traWord=rex.findall(str(div))[0]
    traWord=traWord.replace("<h3>","")
    traWord=traWord.replace("<small>","")
    traWord=traWord.strip()
    #print(traWord)
    simWord=div.find_all("small")[0].string
    #print(simWord)
    pinyin=div.find_all("small")[1].string
    #print(pinyin)
    content=traWord+"\t"+simWord+"\t"+pinyin+"\n"
    
    j=0
    if len(div.find_all("h3"))>1:
        for i in div.find_all("h3"):
            if j==0:
                j=j+1
                continue
            pinyin=i.find_all("small")[1].string
            content=content+traWord+"\t"+simWord+"\t"+pinyin+"\n"
    #print(content)
    return content

fw=open("out.txt","w",encoding="utf-8")
for file in os.listdir("./"):
    if file.find("html")!=-1:
        print(file)
        f=open(file,"r",encoding="utf-8")
        content=f.read()
        if content.find("发音表")==-1:
            continue
        fw.write(getContent(content))
        f.close()
fw.close()
        
