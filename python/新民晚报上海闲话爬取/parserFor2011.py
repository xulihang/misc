#coding=utf-8
from bs4 import BeautifulSoup
import os
import sys
import requests




def getPageUrl(html):
    html=html.replace("<!--","")
    html=html.replace("-->","") #遇到注释时beautifulsoup会出错
    soup = BeautifulSoup(html, 'html.parser')
    for a in soup.find_all("a"):
        if a.find("a") is not None:
            continue
        if a.get_text().find("上海闲话")!=-1 and a.get_text().find("版")!=-1:
            return a.get("href")



for file in os.listdir(sys.argv[1]):

    path=os.path.join(sys.argv[1],file)
    f=open(path,encoding="utf-8")
    url=getPageUrl(f.read())


    year=file.split("-")[0]
    month=file.split("-")[1]
    day=file.split("-")[2].replace(".htm","")
    
    url="http://xmwb.xinmin.cn/history/xmwb/html/"+year+"-"+month+"/"+day+"/"+url
    print(url)
    r = requests.get(url)
    r.encoding="utf-8"

    fw=open(file,"w",encoding="utf-8")
    fw.write(r.text)
    fw.close()
    
    f.close()



