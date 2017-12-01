#coding=utf-8
while True:
    grades=input("请输入成绩：")
    if grades.isdigit()==False:
        print("请输入整数")
    else:
        grades=int(grades)
        if grades>0 and grades<=100: 
            break
        else:
            print("请输入0-100的成绩")
        
if grades>60:
    if grades>=90:
        print("优秀!")
    else:
        print("及格")
else:
    print("不及格")
