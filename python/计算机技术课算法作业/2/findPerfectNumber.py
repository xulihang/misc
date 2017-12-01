perfectNums=[]
for i in range(1,10000):
    divisors=[]
    for j in range(1,i):
        if i % j==0:
            divisors.append(j)

    divisorSum=0
    for divisor in divisors:
        divisorSum+=divisor

    if divisorSum==i:
        perfectNums.append(i)
        print(str(i)+" is a perfect number. Appended!")
print(perfectNums)
