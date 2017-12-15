#coding=utf-8
from bs4 import BeautifulSoup
import re



def getContent(html):
    soup = BeautifulSoup(html, 'lxml')
    content=soup.find_all("div","box-body")[1]
    content=str(content)
    #print(content.find("audio"))
    if content.find("audio")!=-1:
        content=soup.find_all("div","box-body")[2]
        content=str(content)
    #print(content)
    return content


fw=open("out.txt","w",encoding="utf-8")


f=open("ci.txt","r",encoding="utf-8")
for line in f.readlines():
    line=line.split("\t")
    line=line[:-1]
    f2=open(line[0]+".html","r",encoding="utf-8")
    content=f2.read()
    if content.find("无返回结果")!=-1:
        continue
    content=getContent(content)
    print(line)
    f2.close()
    index=line[1].replace("（","")
    index=index.replace("）","")
    fw.write(index+"\n"+content+"\n"+"</>"+"\n")
    
f.close()
fw.close()
