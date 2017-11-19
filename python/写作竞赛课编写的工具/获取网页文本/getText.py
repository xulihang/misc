#coding=utf-8
from bs4 import BeautifulSoup
import urllib.request
import sys

def getHtml(url):
    req = urllib.request.Request(url)
    response = urllib.request.urlopen(req)
    the_page = response.read()
    return the_page


def getInnerText(html):
    #print(html)
    soup = BeautifulSoup(html, 'lxml')
    for toRemove in soup(["script", "style","header","footer"]):
        toRemove.extract()    
    text=soup.get_text()
    text=dropBlankLines(text)
    title=soup.title.text
    title=changeNames(title)
    saveToFile(text,title)


def dropBlankLines(text):
    textlist=text.split("\n")
    newlist=[]
    for item in textlist:
        if item!='':
            newlist.append(item)
    return "\n".join(newlist)

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

def saveToFile(text,title):

    f=open(title+".txt","w",encoding="utf-8")
    f.write("url:"+sys.argv[1]+"\n")
    f.write(text)
    f.close()
    print("file is saved")

if __name__ == '__main__':
    if len(sys.argv)==2:
        html=getHtml(sys.argv[1])
        getInnerText(html)
    else:
        print("usage: getText.py [url] ")
    
