#coding="utf-8"

f=open("stevejobs.txt","r",encoding="utf-8")

chapters={}
currentChapter=0

for line in f.readlines():
    line=line.strip()
    if line.startswith("CHAPTER"):
        currentChapter=currentChapter+1
        chapterName="chapter"+str(currentChapter)
        chapters[chapterName]=line+"\n"
    else:

        chapters[chapterName]=chapters[chapterName]+line+"\n"

f.close()

for chapter in chapters:
    file=open(chapter+".txt","w")
    file.write(chapters[chapter])
    file.close()
