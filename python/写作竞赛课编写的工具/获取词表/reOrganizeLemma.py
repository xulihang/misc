#coding=utf-8
'''将->去掉，改为tab'''
newList=[]
f=open("AntBNC_lemmas_ver_001.txt","r")
fw=open("lemma.txt","w",encoding="utf-8")
for line in f.readlines():
    line=line.replace("->","")
    line=line.replace("\n","")
    line=line.split("	")
    while "" in line:
        line.remove("")
    fw.write("   ".join(line)+"\n")

fw.close()
f.close()

