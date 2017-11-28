#coding=utf-8
#将Dive_NN in_IN !_SENT 感叹句_NN 转成 Dive_NN in_IN !_SENT	感叹句
import sys
category=[]
lines=[]
fr=open(sys.argv[1],"r",encoding="utf-8") #用tagAnt标注过的目标文件

f=open("out.txt","r",encoding="utf-8") #含有对应每个句子的分类信息的文件

for category in f.readlines():
    head=fr.readline()
    head=head.replace("\n","")
    head=head.split(" ")[:-2]
    print(head)
    head=" ".join(head)
    lines.append(head+"\t"+category)

f.close()
fr.close()
print(lines)
f=open("out2.txt","w",encoding="utf-8")
for line in lines:
    f.write(line)
f.close()
