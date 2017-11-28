#coding=utf-8
#根据词表统计词频，并去除一些非单词的内容

import os
wordDict={}
for file in os.listdir("./"):
    if file.find("wordlist")!=-1:
        f=open(file,"r",encoding="utf-8")
        for word in f.readlines():
            word=word.replace("\n","")

            if word.isalpha() or word.find("-")!=-1:
                if len(word)!=1 and word.find("http")==-1:
                    if word in wordDict: #如果单词已经在dict里了，那就增加频数
                        wordDict[word]+=1 
                    else:
                        wordDict[word]=1
        f.close()
        
fw=open("./out/total.txt","w",encoding="utf-8")
for key in wordDict:
    fw.write(key+"  "+str(wordDict[key])+"\n")
fw.close()
            
