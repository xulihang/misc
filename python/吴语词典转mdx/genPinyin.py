#coding=utf-8

shengmu=[]
yunmu=[]
pinyin=[]

f=open("shengmu.txt","r",encoding="utf-8")
for item in f.readlines():
    item=item.replace("\n","")
    shengmu.append(item)
f.close()

f=open("yunmu.txt","r",encoding="utf-8")
for item in f.readlines():
    item=item.replace("\n","")
    yunmu.append(item)
f.close()


for s in shengmu:
    for y in yunmu:
        pinyin.append(s+y)

f=open("pinyin.txt","w",encoding="utf-8")
for p in pinyin:
    f.write(p+"\n")
f.close()
