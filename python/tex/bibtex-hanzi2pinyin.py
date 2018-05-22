#coding=utf-8
#本脚本把endnote导出的bibtex中的作者的中文名转为拼音
from xpinyin import Pinyin
import bibtexparser


def isChinese(text):
    X,Y = ['\u4e00','\u9fa5']
    if X<=text[0]<=Y:
        return True
    else:
        return False

def authorToPinyin(author):
    if author.find(" and ")!=-1:
        names=author.split(" and ")
    else:
        names=[author]
    newNamesList=[]
    for name in names:
        newNamesList.append(nameToPinyin(name))
    return " and ".join(newNamesList)
      

def nameToPinyin(text):
    p=Pinyin()
    pinyins=p.get_pinyin(text, ', ').split(", ")
    #姓名首字母大写
    familyName=pinyins[0]
    familyNameInitialCapitaled=familyName[0].upper()+familyName[1:] 
    givenName=""
    for n in pinyins[1:]:
        givenName=givenName+n
    givenNameInitialCapitaled=givenName[0].upper()+givenName[1:]
    return familyNameInitialCapitaled+", "+givenNameInitialCapitaled


f=open("thesis.bib","r",encoding="utf-8")
bibtex=f.read()
bib_database = bibtexparser.loads(bibtex)

for entry in bib_database.entries:
    if "author" in entry:
        if isChinese(entry["author"]):
            entry["author"]=authorToPinyin(entry["author"])
            print(entry["author"])

with open('bibtex.bib', 'w',encoding="utf-8") as bibtex_file: #保存结果
    bibtexparser.dump(bib_database, bibtex_file)
    print("已保存为bibtex.bib文件")