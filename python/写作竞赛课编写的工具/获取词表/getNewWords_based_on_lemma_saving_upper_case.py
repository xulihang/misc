#coding=utf-8
import sys
import os

lemmadict={}

f=open("lemma.dat","r",encoding="utf-8") #加载lemma词典。词的原型是value，而屈折变化后的是key。
for line in f.readlines():
    line=line.replace("\n","")
    lemma=line.split("   ")
    for i in range(1,len(lemma)):
        wd=lemma[i].strip()
        lemmadict[wd]=lemma[0]
f.close()

def getNewWords(filename):
    wordlist=[]
    newWordlist=[]
    f=open("WordList.dat","r")
    for word in f.readlines():
        word=word.replace("\n","")
        word=word.strip()
        wordlist.append(word)
    f.close()

    f=open(filename,"r",encoding="utf-8")
    for line in f.readlines():
        words=line.split(" ")
        for word in words:
            originalWord=word
            word=word.strip()
            word=word.lower()
            word=word.replace(":","")
            word=word.replace(",","")
            word=word.replace(".","")
            word=word.replace("!","")
            word=word.replace("?","")
            word=word.replace(";","")
            word=word.replace("\"","")
            word=word.replace("“","")
            word=word.replace("”","")
            word=word.replace("‘","")
            word=word.replace("’","")
            word=word.replace("'s","")
            word=word.replace("'","")
            lemmatizedWord=lemmatizeWord(word)
            if lemmatizedWord==word and word.lower() not in wordlist and originalWord[:1].isupper(): #人名和地名还是要首字母大写，但可能会加进去一些句首大写的词
                word=originalWord
            else:
                word=lemmatizedWord                
            if word not in wordlist: #去掉大学四级级别的简单词
                newWordlist.append(word)
    f.close()
    while '' in newWordlist:
        newWordlist.remove('')

    
    #lemmatize(newWordlist)
    newFilename=filename.replace(".txt","_newwordlist.txt")
    f=open(newFilename,"w",encoding="utf-8")
    for word in newWordlist:
        f.write(word+"\n")
    f.close()

def lemmatizeList(newWordlist):
    for word in newWordlist[:]:
        if word in lemmadict:
            if lemmadict[word]!=word:
                newWordlist.remove(word)
                newWordlist.append(lemmadict[word])

    return newWordlist

def lemmatizeWord(word):

    if word in lemmadict:
        if lemmadict[word]!=word:
            word=lemmadict[word]

    return word   
        
if __name__ == '__main__':
    if sys.argv[1].find("*.txt")!=-1:
        for file in os.listdir("./"):
            if file.endswith(".txt"):
                getNewWords(file)
    else:
        getNewWords(sys.argv[1])
    
