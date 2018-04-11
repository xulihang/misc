#coding=utf8
import os
from math import modf

def main(path):
    result=''
    f=open(path)
    line=0
    for i in f.readlines():
        print i
        if i.startswith("<p")==False:
            continue
        beginUb=i.find("begin=")+7
        beginLb=i.find("end=")-3
        endUb=i.find("end=")+5
        endLb=i.find("region=")-3
        print i[beginUb:beginLb]
        print i[endUb:endLb]
        begin=float(i[beginUb:beginLb])/10000000/60 #转换成分，带小数部分
        print begin
        end=float(i[endUb:endLb])/10000000/60
        print end
        print modf(begin)

        begintime=str(int(modf(begin)[1]))+":" #00:00:00,100中的第二部分

        if len(str(int(modf(begin)[0]*60)))==1: #秒数为个位数
            begintime=begintime+"0"+str(int(modf(begin)[0]*60))
        else:
            begintime=begintime+str(int(modf(begin)[0]*60))
        #获得毫秒部分 2018年新添加
        beginMM=int(modf(modf(begin)[0]*60)[0]*1000) 
        endMM=int(modf(modf(end)[0]*60)[0]*1000)
        print "MM:"+str(beginMM)
        print begintime #字幕开始时间
        endtime=str(int(modf(end)[1]))+":"
        if len(str(int(modf(end)[0]*60)))==1:
            endtime=endtime+"0"+str(int(modf(end)[0]*60))
        else:
            endtime=endtime+str(int(modf(end)[0]*60))
        print endtime #字幕结束时间
        captionUb=i.find("subtitle")+len(str(line))+2+8
        captionLb=len(i)-5
        caption=i[captionUb:captionLb]
        print caption
        line=line+1
        if len(str(int(modf(begin)[1])))==1:
            begintime="0"+begintime
        if len(str(int(modf(end)[1])))==1:
            endtime="0"+endtime
        if int(modf(begin)[1])>=60:
            begintime="01:"+str(int(modf(begin)[1])-60)+":"+str(int(modf(begin)[0]*60))
        else:
            begintime="00:"+begintime
        if int(modf(end)[1])>=60:
            endtime="01:"+str(int(modf(end)[1])-60)+":"+str(int(modf(end)[0]*60))
        else:
            endtime="00:"+endtime
        content=str(line)+"\n"
        content=content+begintime+","+str(beginMM) +"-->"+endtime+","+str(endMM)
        content=content+"\n"+caption+"\n"
        result=result+content+"\n"

    result=result.replace("<br/>"," ")
    result=result.replace('''<span style="s1_1">''',"")
    result=result.replace("</span>","")
    path=path.replace(".xml",".srt")
    fw=open(path,'w')
    fw.write(result)
    fw.flush()
    fw.close()

for i in os.listdir("./"):
    if i.find(".xml")!=-1:
        main(i)