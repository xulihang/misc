#coding=utf-8

def getRadius():
    try:
        radius=input("Please input the radius:")
        radius=float(radius)
        return radius
    except:
        print("please input a num.")
        return None
    
