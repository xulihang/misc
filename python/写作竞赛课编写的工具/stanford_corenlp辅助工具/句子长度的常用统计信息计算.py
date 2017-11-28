#coding=utf-8
f=open("all.out","r",encoding="utf-8")
line=f.readline()
totalNum=0
sentenceNum=0
tokensNumList=[]
while line!="":
    if line.find("Sentence")!=-1:
        sentenceNum+=1
        ub=line.find("(")+1
        lb=line.find("token")
        tokens=line[ub:lb]
        tokensNumList.append(int(tokens))
        totalNum=totalNum+int(tokens)
        print(sentenceNum)
        print(totalNum)
    line=f.readline()            
f.close()
tokensNumList.sort()
print("最小数："+str(tokensNumList[1]))
print("最大数："+str(tokensNumList[-1]))
if len(tokensNumList) % 2==0:
    print("偶数")
    firstNum=tokensNumList[int(len(tokensNumList)/2)]
    secondNum=tokensNumList[int(len(tokensNumList)/2)+1]
    print("中位数："+str((int(firstNum)+int(secondNum))/2))
else:
    print("奇数")
    print("中位数："+str(tokensNumList[int(len(tokensNumList)/2)]))

frequencyDict={}
for tokensNum in tokensNumList:
    if tokensNum not in frequencyDict:
        frequencyDict[tokensNum]=tokensNumList.count(tokensNum)

modeFrequency=0
mode=0

for key in frequencyDict.keys():
    if frequencyDict[key]>modeFrequency:
        modeFrequency=frequencyDict[key]
        mode=key

print("众数："+str(mode))

 








        
