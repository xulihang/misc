#coding=utf-8

wordcount=0

f=open("stevejobs.txt","r",encoding="utf-8")
for line in f.readlines():
    list1=line.split(" ")
    wordcount+=len(list1)

f.close()

wordsPerPerson=wordcount/37
words=0
content={}
personOrder=1

f=open("stevejobs.txt","r",encoding="utf-8")
for line in f.readlines():
    list1=line.split(" ")
    words=words+len(list1)
    if str(personOrder) in content:
        
        content[str(personOrder)]=content[str(personOrder)]+line
    else:
        content[str(personOrder)]=line
    if words>=wordsPerPerson:
        words=0
        personOrder+=1

f.close()

for key in content:
    file=open(key+".txt","w")
    file.write(content[str(key)])
    file.close()
