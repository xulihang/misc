#coding=utf-8
from bs4 import BeautifulSoup
import os
import sys



def getArticles(html):
    articles=""
    html=html.replace("<!--","")
    html=html.replace("-->","") #遇到注释时beautifulsoup会出错
    soup = BeautifulSoup(html, 'html.parser')
    ul=soup.find("ul")
    for a in ul.find_all("a"):
        articles=articles+a.get_text().replace("\n","").strip()+"\t"+a.get('href').replace("\n","").strip()+"\n"
    return articles



for file in os.listdir(sys.argv[1]):
    print(file)
    path=os.path.join(sys.argv[1],file)
    f=open(path,encoding="utf-8")
    articles=getArticles(f.read())

    fw=open(file.replace(".htm",".txt"),"w",encoding="utf-8")
    fw.write(articles)
    fw.close()
    
    f.close()



