#coding=utf-8

pinyinDict={}

f=open("ci.txt","r",encoding="utf-8")
for line in f.readlines():
    pinyin=line.split("\t")[2]
    traWords=line.split("\t")[0]
    simWords=line.split("\t")[1]
    if pinyin not in pinyinDict:
        pinyinDict[pinyin]="<p>"+traWords+" "+simWords+"</p>"
    else:
        pinyinDict[pinyin]=pinyinDict[pinyin]+"<p>"+traWords+" "+simWords+"</p>"
f.close()

f=open("zi.txt","r",encoding="utf-8")
for line in f.readlines():
    pinyin=line.split("\t")[2]
    traWords=line.split("\t")[0]
    simWords=line.split("\t")[1]
    if pinyin not in pinyinDict:
        pinyinDict[pinyin]="<p>"+traWords+" "+simWords+"</p>"
    else:
        pinyinDict[pinyin]=pinyinDict[pinyin]+"<p>"+traWords+" "+simWords+"</p>"
f.close()


fw=open("all.txt","w",encoding="utf-8")
for key in pinyinDict.keys():
    print(key)
    fw.write(key+"\n"+"<p>"+key+"</p>"+pinyinDict[key]+"\n"+"</>\n")
fw.close()

