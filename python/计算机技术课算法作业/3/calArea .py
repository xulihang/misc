#coding=utf-8

import input_radius

def calArea(radius):
    if not radius:
        return 0
    print("The circular area is "+str(radius**2)+".")

if __name__=="__main__":
    calArea(input_radius.getRadius())
