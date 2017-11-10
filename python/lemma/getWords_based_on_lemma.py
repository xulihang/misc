#coding=utf-8
import sys
import os

def getNewWords(filename):
    #wordlist=[] 该脚本不去除简单词
    newWordlist=[]
    '''
    f=open("WordList.txt","r")
    for word in f.readlines():
        word=word.replace("\n","")
        word=word.strip()
        wordlist.append(word)
    f.close()'''

    f=open(filename,"r",encoding="utf-8")
    for line in f.readlines():
        words=line.split(" ")
        for word in words:
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
            newWordlist.append(word)
    f.close()
    while '' in newWordlist:
        newWordlist.remove('')

    
    lemmatize(newWordlist)
    newFilename=filename.replace(".txt","_wordlist.txt")
    f=open(newFilename,"w",encoding="utf-8")
    for word in newWordlist:
        f.write(word+"\n")
    f.close()

def lemmatize(newWordlist):
    lemmadict={}

    f=open("lemma.txt","r",encoding="utf-8")
    for line in f.readlines():
        line=line.replace("\n","")
        lemma=line.split("   ")
        for i in range(1,len(lemma)):
            wd=lemma[i].strip()
            lemmadict[wd]=lemma[0]
    f.close()


    for word in newWordlist[:]:
        if word in lemmadict:
            if lemmadict[word]!=word:
                newWordlist.remove(word)
                newWordlist.append(lemmadict[word])

    return newWordlist    
        
if __name__ == '__main__':
    if sys.argv[1].find("*.txt")!=-1:
        for file in os.listdir("./"):
            if file.endswith(".txt"):
                getNewWords(file)
    else:
        getNewWords(sys.argv[1])
    
