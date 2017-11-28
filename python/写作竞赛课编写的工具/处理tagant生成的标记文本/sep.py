#coding=utf-8
#根据未标注文件生成只有句子分类的列表
import sys
category=[]

f=open(sys.argv[1],"r",encoding="utf-8")
for line in f.readlines():
    print(line.split("\t"))
    category.append(line.split("\t")[1])
f.close()

fw=open("out.txt","w",encoding="utf-8")
for item in category:
    fw.write(item)
fw.close()
