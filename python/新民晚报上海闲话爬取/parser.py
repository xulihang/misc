#coding=utf-8
from bs4 import BeautifulSoup
import os
import sys




def getArticles(html):
    articles=""
    html=html.replace("<!--","")
    html=html.replace("-->","") #遇到注释时beautifulsoup会出错
    soup = BeautifulSoup(html, 'html.parser')
    tables=soup.find_all('table')
    for table in tables:
        if table.find("table") is not None: #保证table里没有嵌套table
            continue
        if table.parent.name=="li": #排除另一个含有上海闲话的table
            continue
        tableText=table.get_text()
        
        if tableText.find("上海闲话")!=-1 and tableText.find("版")!=-1:
            entireTable=table.parent.parent.parent
            for a in entireTable.find_all("a"):
                if a.get("href").find("#down")!=-1:
                    continue
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



