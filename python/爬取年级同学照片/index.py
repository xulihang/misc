# -*- coding: utf-8 -*-  
from bottle import route, run, template, request, static_file, error
import urllib
import urllib2
import cookielib
import sqlite3
import os,shutil

@error(404)
def error404(error):
    return 'Nothing here, sorry'

@route('/genlist')
def genlist():
    if os.path.exists('list.db')==False:
        conn = sqlite3.connect('list.db')
        c = conn.cursor()
        c.execute("CREATE TABLE statics (id,name,sex,class,major,college,other)")
    else:
        conn = sqlite3.connect('list.db')
        c = conn.cursor()
    i=1
    f=open('list.csv')
    for line in f.readlines():
        if i>1:
            result=line.split(',')
            studentid=result[0]
            studentname=result[1]
            studentclass=result[2]
            studentmajor=result[3]
            studentcollege=result[4]
            print studentid
            URL="http://exercise.jiangnan.edu.cn/u/"+str(studentid)+"/UserInfo.aspx"
            print URL
            cj = cookielib.CookieJar()
            opener = urllib2.build_opener(urllib2.HTTPCookieProcessor(cj))
            opener.addheaders = [('User-agent','Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1)')]
            urllib2.install_opener(opener)
            req = urllib2.Request(URL)
            req.add_header("Referer","http://exercise.jiangnan.edu.cn/")
            resp = urllib2.urlopen(req)
            result=resp.read()
            ub=result.find("name='sex'")
            studentsex=result[ub+11:ub+14]
            print studentsex.decode('utf8')
            c.execute("insert into statics values ('"+studentid+"','"+studentname+"','"+studentsex+"','"+studentclass+"','"+studentmajor+"','"+studentcollege+"','0')")
        i=i+1
    conn.commit()
    c.close()
    conn.close()
    return "成功"

@route('/sort')
def sortimage():
    conn = sqlite3.connect('list.db')
    c = conn.cursor()
    c.execute("select * from statics")
    for line in c.fetchall():
        print line[0]
        print line[1]
        print line[2] #sex
        shutil.copy("./images/"+line[0]+".jpg", "./images/"+line[2]+"/"+line[0]+".jpg")        
    conn.commit()
    c.close()
    conn.close()

@route('/download')
def downloadimage():
    conn = sqlite3.connect('list.db')
    c = conn.cursor()
    c.execute("select * from statics")
    for line in c.fetchall():
        print line[0]
        print line[1]
        print line[2]
        link="http://ihome.jiangnan.edu.cn/ihome/file/get_portrait_url?id="+line[0]
        data = urllib.urlretrieve(link,"./images/"+line[0]+".jpg")
    conn.commit()
    c.close()
    conn.close()

@route('/regen')
def regendb():
    collegeid=100
    conn = sqlite3.connect('list.db')
    c = conn.cursor()
    c.execute("select * from statics")
    if os.path.exists('list2.db')==False:
        conn2 = sqlite3.connect('list2.db')
        c2 = conn2.cursor()
        c2.execute("CREATE TABLE statics (id,name,sex,class,major,college,collegeid)")
    else:
        conn2 = sqlite3.connect('list2.db')
        c2 = conn2.cursor()
    
    for result in c.fetchall():
        studentid=result[0]
        studentname=result[1]
        studentsex=result[2]
        studentclass=result[3]
        studentmajor=result[4]
        studentcollege=result[5]

        print studentcollege
        ll="法学院".decode("utf8")
        print ll
        if studentcollege.find("法学院".decode("utf8"))!=-1:
            collegeid=0
        elif studentcollege.find("纺织服装学院".decode("utf8"))!=-1:
            collegeid=1
        elif studentcollege.find("化学与材料工程学院".decode("utf8"))!=-1:
            collegeid=2
        elif studentcollege.find("环境与土木工程学院".decode("utf8"))!=-1:
            collegeid=3
        elif studentcollege.find("机械工程学院".decode("utf8"))!=-1:
            collegeid=4
        elif studentcollege.find("理学院".decode("utf8"))!=-1:
            collegeid=5
        elif studentcollege.find("人文学院".decode("utf8"))!=-1:
            collegeid=6
        elif studentcollege.find("商学院".decode("utf8"))!=-1:
            collegeid=7
        elif studentcollege.find("设计学院".decode("utf8"))!=-1:
            collegeid=8
        elif studentcollege.find("生物工程学院".decode("utf8"))!=-1:
            collegeid=9
        elif studentcollege.find("食品学院".decode("utf8"))!=-1:
            collegeid=10
        elif studentcollege.find("数字媒体学院".decode("utf8"))!=-1:
            collegeid=11
        elif studentcollege.find("外国语学院".decode("utf8"))!=-1:
            collegeid=12           
        elif studentcollege.find("物联网工程学院".decode("utf8"))!=-1:
            collegeid=13
        elif studentcollege.find("药学院".decode("utf8"))!=-1:
            collegeid=14
        elif studentcollege.find("医学院".decode("utf8"))!=-1:
            collegeid=15
        c2.execute("insert into statics values ('"+studentid+"','"+studentname+"','"+studentsex+"','"+studentclass+"','"+studentmajor+"','"+studentcollege+"','"+str(collegeid)+"')")

    conn2.commit()
    c2.close()
    conn2.close() 
    conn.commit()
    c.close()
    conn.close()

@route('/regen2')
def regendb2():

    conn = sqlite3.connect('list2.db')
    c = conn.cursor()
    c.execute("select * from statics")
    if os.path.exists('list3.db')==False:
        conn2 = sqlite3.connect('list3.db')
        c2 = conn2.cursor()
        c2.execute("CREATE TABLE statics (id,name,sex,class,major,college,collegeid)")
    else:
        conn2 = sqlite3.connect('list3.db')
        c2 = conn2.cursor()
    
    for result in c.fetchall():
        studentid=result[0]
        studentname=result[1]
        studentsex=result[2]
        studentclass=result[3]
        studentmajor=result[4]
        studentcollege=result[5]
        collegeid=result[6]
        if studentsex=="男".decode("utf8"):
            ensex=0
        elif studentsex=="女".decode("utf8"):
            ensex=1
        c2.execute("insert into statics values ('"+studentid+"','"+studentname+"','"+str(ensex)+"','"+studentclass+"','"+studentmajor+"','"+studentcollege+"','"+str(collegeid)+"')")

    conn2.commit()
    c2.close()
    conn2.close() 
    conn.commit()
    c.close()
    conn.close() 

if __name__ == '__main__':
    run(host='0.0.0.0', port=80)
