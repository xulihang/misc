#coding=utf-8

pinyinDict={}

f=open("ci.txt","r",encoding="utf-8")
for line in f.readlines():
    pinyin=line.split("\t")[2]
    traWords=line.split("\t")[0]
    simWords=line.split("\t")[1]
    if pinyin not in pinyinDict:
        pinyinDict[pinyin]=traWords+" "+simWords+"\\n"
    else:
        pinyinDict[pinyin]=pinyinDict[pinyin]+traWords+" "+simWords+"\\n"
f.close()

f=open("zi.txt","r",encoding="utf-8")
for line in f.readlines():
    pinyin=line.split("\t")[2]
    traWords=line.split("\t")[0]
    simWords=line.split("\t")[1]
    if pinyin not in pinyinDict:
        pinyinDict[pinyin]=traWords+" "+simWords+"\\n"
    else:
        pinyinDict[pinyin]=pinyinDict[pinyin]+traWords+" "+simWords+"\\n"
f.close()


fw=open("all.txt","w",encoding="utf-8")
for key in pinyinDict.keys():
    print(key)
    fw.write(key+"\t"+"\\n"+pinyinDict[key]+"\n")
fw.close()

