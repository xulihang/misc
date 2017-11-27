# -*- coding:utf-8 -*-
'''
按照江南大学外国语学院的本科毕业论文参考文献格式修改endnote按国家标准导出的文本，主要是增加作者拼音，添加需要的一些符号
例：
之前：
[23] 俞敬松, 韩林涛, 赵玉涛. 翻译教学平台CATTP与学生翻译作用互评[A]. 中国应用翻译论文专辑（第一辑）[C], 2016: 266-280.
之后：
[23] Yu, Jingsong; Han, Lintao; Zhao, Yutao. [俞敬松, 韩林涛, 赵玉涛]. 翻译教学平台CATTP与学生翻译作用互评[A]. 中国应用翻译论文专辑（第一辑）[C], 2016: 266-280.
'''

from xpinyin import Pinyin
import string   
import re   

content=""

def isChinese(text):
    X,Y = ['\u4e00','\u9fa5']
    if X<=text[0]<=Y:
        return True

def main():
    global content
    f=open("reference.txt",encoding='utf-8')
    for i in f.readlines():
        parts=i.split(".")
        authorWithNumber=parts[0]
        number=authorWithNumber.split(" ")[0]
        author=authorWithNumber.replace(number+" ","")
        #print(author)
        rightpart=""
        if isChinese(author)==True: # 判断是否为中文文献，是则进行添加拼音的处理
            if author.find(" ")!=-1: #存在多个作者
                authors=author.split(", ")
                authorsConnected=""
                for oneAuthor in authors:
                    if authorsConnected=="":
                        authorsConnected=authorsConnected+postEdit(oneAuthor)
                    else:
                        authorsConnected=authorsConnected+"; "+postEdit(oneAuthor)
                for j in parts[1:]:
                    rightpart=rightpart+"."+j
                #print(number+" "+authorsConnected+". ["+author+"]."+rightpart)
                content=content+number+" "+authorsConnected+". ["+author+"]"+rightpart
            else:          
                for j in parts[1:]:
                    rightpart=rightpart+"."+j
                #print(number+" "+postEdit(author)+". ["+author+"]."+rightpart)
                content=content+number+" "+postEdit(author)+". ["+author+"]"+rightpart
        else:
            #print(i)
            content=content+i

def postEdit(author): #将姓名处理为模板需要的格式
    p = Pinyin()
    pinyins=p.get_pinyin(author,splitter=", ").split(", ") #汉字转拼音
    
    #姓名首字母大写
    familyName=pinyins[0]
    familyNameInitialCapitaled=familyName[0].upper()+familyName[1:] 
    givenName=""
    for n in pinyins[1:]:
        givenName=givenName+n
    givenNameInitialCapitaled=givenName[0].upper()+givenName[1:]
    
    return familyNameInitialCapitaled+", "+givenNameInitialCapitaled


main()
print(content)
