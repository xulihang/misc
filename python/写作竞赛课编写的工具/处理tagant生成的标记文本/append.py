#coding=utf-8
import sys
category=[]
lines=[]
fr=open(sys.argv[1],"r",encoding="utf-8")

f=open("out.txt","r",encoding="utf-8")

for category in f.readlines():
    head=fr.readline()
    head=head.replace("\n","")
    if head.split(" ")[-1].find("_NN")==-1:
        head=head.split(" ")[:-2]
    else:
        head=head.split(" ")[:-1]
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
