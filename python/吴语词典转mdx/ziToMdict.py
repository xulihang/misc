#coding=utf-8
from bs4 import BeautifulSoup
import re
import os


def getContent(html):
    soup = BeautifulSoup(html, 'lxml')
    content=soup.find_all("div","box-body")[1]
    content=str(content)
    rex=re.compile(r"<button.*?button>",re.S)
    for button in rex.findall(content):
        content=content.replace(button,"")
        content=content.replace("/main/Public/Dic/voice/wuu_haining/","sound://")
    rex2=re.compile(r"<audio.*?src=",re.S)
    for audio in rex2.findall(content):
        content=content.replace(audio,"<a href=")
    rex3=re.compile(" type=.*?/audio>",re.S)
    content=content.replace(rex3.findall(content)[0],"> 发音 </a>")
    #content=content.replace("<audio","<audio controls=\"controls\"")

    content=content.replace("mp3","wav")
    #print(content)
    return content


fw=open("out.txt","w",encoding="utf-8")


f=open("1.txt","r",encoding="utf-8")
for line in f.readlines():
    
    line=line.split("\t")
    line=line[:-1]
    print(line[0])
    if os.path.exists(line[0]+".html")==False:
        continue
    f2=open(line[0]+".html","r",encoding="utf-8")
    content=f2.read()
    if content.find("发音")==-1:
        continue
    content=getContent(content)
    print(line)
    f2.close()
    index=line[1].replace("（","")
    index=index.replace("）","")
    fw.write(index+"\n"+content+"\n"+"</>"+"\n")
    
f.close()
fw.close()
