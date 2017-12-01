#coding=utf-8
"""

A [...X...Y...]

M [X...Y]

P<=sum(A)<=Q

"""
import itertools 


#preset the values for test purpose
M=3

X=3
Y=6

P=5
Q=20



possibleLists=[]
leftPossilbeLists=[]
midPossilbeLists=[]
rightPossibleLists=[]

for i in range(1,X): #i控制的是数字个数
    for combination in itertools.combinations(list(range(X)), i): #利用python的itertools找出所有的可能组合
        leftPossilbeLists.append(combination)                     #得到左边部分可能的组合



for combination in itertools.combinations(list(range(X,Y+1)),M):
    midPossilbeLists.append(combination)                         #得到中间部分可能的组合


for combination in leftPossilbeLists:
    for combination2 in midPossilbeLists:
        total=sum(combination)+sum(combination2)
        if total>=P and total <=Q:
            maxNum=combination2[-1]+1
            while total+maxNum>=P and total+maxNum<=Q:
                maxNum=maxNum+1    #因为右边的部分不知道数字数量，先算出右边只有一个数的话，这个数有多大
            for i in range(1,maxNum): 
                for combination3 in itertools.combinations(list(range(combination2[-1]+1,maxNum)), i):
                    if sum(combination3)+total>=P and sum(combination3)+total<=Q:
                        rightPossibleLists.append(combination3)
                        possibleLists.append(combination+combination2+combination3) #得到左中右部分合起来后符合条件的可能的组合
                    else:
                        break

if possibleLists==[]:
    print("No matching combinations.")
else:
    for combination in possibleLists:
        print(combination)


