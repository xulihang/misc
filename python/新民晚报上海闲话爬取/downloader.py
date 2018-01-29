#coding=utf-8
import os
import sys
import requests


def changeNames(title):
    #\ / : * ? " < > |
    title=title.replace("\\","")
    title=title.replace("/","")
    title=title.replace(":","")
    title=title.replace("*","")
    title=title.replace("?","")
    title=title.replace("\"","")
    title=title.replace("<","")
    title=title.replace(">","")
    title=title.replace("|","")
    return title



for file in os.listdir(sys.argv[1]):
    print(file)
    path=os.path.join(sys.argv[1],file)

    year=file.split("-")[0]
    month=file.split("-")[1]
    day=file.split("-")[2].replace(".txt","")

    if int(year)>2011:
        url="http://xmwb.xinmin.cn/html/"+year+"-"+month+"/"+day+"/"
    else:
        url="http://xmwb.xinmin.cn/history/xmwb/html/"+year+"-"+month+"/"+day+"/"
    

    if os.path.exists(year)==False:
        os.mkdir(year)
    if os.path.exists(year+"/"+month+"-"+day)==False:
        os.mkdir(year+"/"+month+"-"+day)
    f=open(path,encoding="utf-8")
    
    for line in f.readlines():
        line=line.replace("\n","")
        title=line.split("\t")[0]
        filename=line.split("\t")[1]
        r = requests.get(url+filename)
        r.encoding="utf-8"
        title=changeNames(title)
        savedFileName=year+"/"+month+"-"+day+"/"+title+".htm"
        
        fw=open(savedFileName,"w",encoding="utf-8")
        fw.write(r.text)
        fw.close()
    f.close()
