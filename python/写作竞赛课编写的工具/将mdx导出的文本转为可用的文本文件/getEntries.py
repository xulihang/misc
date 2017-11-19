#coding=utf-8
from bs4 import BeautifulSoup
content=""
num=0
f=open("5.txt","r",encoding="utf-8")
for line in f.readlines():
    num+=1
    print(num)
    soup = BeautifulSoup(line, 'lxml')
    text=soup.get_text()
    fa=open(text[0:1]+".txt","a",encoding="utf-8")
    fa.write(text)
    fa.close()
f.close()

