# -*- coding: utf-8 -*-
from bottle import route, run, template, request, static_file, error
import urllib
import urllib2
import cookielib
import re
import json
from bs4 import BeautifulSoup


def getVIEW(Page):          # Get viewststes for login page
    view = r'name="__VIEWSTATE" value="(.+)" '
    view = re.compile(view)
    #print view.findall(Page)[0]
    return view.findall(Page)[0]

def gen(userid,passwd,realname):
    login(userid,passwd,realname)
    f=open('out')
    count=len(f.readlines())
    f=open('out')
    #print f.readline()
    result={}
    singleterm=[]
    termnum=1
    term="0"
    termname=""
    havingreadlines=0
    for line in f.readlines():
        #print line
        str2 = r"<td>(.+?)</td>"
        str2 = re.compile(str2)
        a = str2.findall(line)
        havingreadlines=havingreadlines+1
        if a!=[]:
            if a[0].find("java")==-1 and a[0].find("span")==-1:
                a.pop()                         #删除最后一项无用数据
                
                if a[1]!=term:                           #若某学年学期(1 or 2)改变，记录一学期成绩到字典
                    if term=="0":                        #第一学期需要初始一下
                        term=a[1]
                        singleterm.append(a)
                    else:
                        #termname=calculateterm(termnum)  #得到学期名(放弃使用中文，改用英文)
                        termname="TERM"+str(termnum)
                        result[termname]=singleterm      #记录一学期的成绩
                        termnum=termnum+1                #学期序数加一
                        term=a[1]                        #某学年学期改成新的
                        singleterm=[]                    #清空一学期的成绩记录
                        singleterm.append(a)
                else:                           
                    singleterm.append(a)
        if count==havingreadlines:                     #内容读到底了再记录一下
            termname="TERM"+str(termnum)           
            result[termname]=singleterm      

    result=json.dumps(result, ensure_ascii=False)
    return str(result)
        
def calculateterm(termnum):
    if termnum==1:
        return "大一上"
    elif termnum==2:
        return "大一下"
    elif termnum==3:
        return "大二上"
    elif termnum==4:
        return "大二下"
    elif termnum==5:
        return "大三上"
    elif termnum==6:
        return "大三下"
    elif termnum==7:
        return "大四上"
    elif termnum==8:
        return "大四下"



#登录
def login(userid,passwd,realname):
    
    cookie = cookielib.CookieJar()
    opener = urllib2.build_opener(urllib2.HTTPCookieProcessor(cookie))
    opener.addheaders = [('User-agent','Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1)')]
    urllib2.install_opener(opener)
    req = urllib2.Request("http://jwxt.jiangnan.edu.cn/jndx/default_ysdx.aspx")
    req.add_header("Referer","http://jwxt.jiangnan.edu.cn/jndx/default_ysdx.aspx")
    resp = urllib2.urlopen(req)
    #page = unicode(resp.read(), 'gb2312').encode("utf-8")
    vs=getVIEW(resp.read())
    
    req = urllib2.Request("http://jwxt.jiangnan.edu.cn/jndx/default_ysdx.aspx",urllib.urlencode({"__VIEWSTATE":vs,
                                                                                                 "TextBox1":userid,
                                                                                                 "TextBox2":passwd,
                                                                                                 "RadioButtonList1":"学生",
                                                                                                 "Button1":"登录"}))
    req.add_header("Referer","http://jwxt.jiangnan.edu.cn/jndx/default_ysdx.aspx")
    resp = urllib2.urlopen(req)
    # print cookie
    Cookie=""
    for i in cookie:
        Cookie = i.name+"="+i.value
    #print Cookie
	
    head = {
    'Accept':'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
    'Accept-Encoding':'gzip, deflate',
    'Accept-Language':'zh-CN,zh;q=0.8',
    'Cache-Control':'no-cache',
    'Connection':'keep-alive',
    'Content-Type':'application/x-www-form-urlencoded',
    'Host':'jwxt.jiangnan.edu.cn',
    'Cookie':Cookie,
    'Origin':'http://202.195.144.163',
    'Pragma':'no-cache',
    'Referer':'http://jwxt.jiangnan.edu.cn/jndx/default6.aspx',
    'User-Agent':'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2272.76 Safari/537.36'
    }
    getdata = urllib.urlencode({'xh':userid,'xm':realname,'gnmkdm': 'N121605'})
    req = urllib2.Request("http://jwxt.jiangnan.edu.cn/jndx/xscjcx.aspx?xh="+userid+"&xm="+realname+"&gnmkdm=N121605",getdata,head)
    req.add_header("Referer","http://jwxt.jiangnan.edu.cn/jndx/default_ysdx.aspx")
    resp = urllib2.urlopen(req)
    
    head = {
    'Accept':'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
    'Accept-Encoding':'gzip, deflate',
    'Accept-Language':'zh-cn,zh;q=0.8,en-us;q=0.5,en;q=0.3',
    'Cache-Control':'no-cache',
    'Connection':'keep-alive',
    'Content-Type':'application/x-www-form-urlencoded',
    'Host':'jwxt.jiangnan.edu.cn',
    'Cookie':Cookie,
    'Origin':'http://jwxt.jiangnan.edu.cn',
    'Pragma':'no-cache',
    'Referer':'http://jwxt.jiangnan.edu.cn/jndx/xscjcx.aspx?xh='+userid+'&xm='+realname+'&gnmkdm=N121605',
    'User-Agent':'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2272.76 Safari/537.36'
    }
    
   # page =  unicode(resp.read(), 'gb2312').encode("utf-8")
    page=resp.read()
    vs=getVIEW(page)
    #print vs
    req = urllib2.Request("http://jwxt.jiangnan.edu.cn/jndx/xscjcx.aspx?xh="+userid+"&xm="+realname+"&gnmkdm=N121605",urllib.urlencode({"__VIEWSTATE":vs,'btn_zcj':'历年成绩',"__EVENTTARGET":"","__EVENTARGUMENT":"","hidLanguage":"","ddlXN":"","ddlXQ":"","ddl_kcxz":""}),head) 
    resp = urllib2.urlopen(req)
    soup = BeautifulSoup(resp.read(),"html.parser")
    table = soup.find("table",{"id":"Datagrid1"})
    table = str(table)
    fw=open('out','w') #打开一个空白文本文件，准备写入
    fw.write(table)
    fw.flush()
    fw.close



@route('/scorequery')
def scorequery():
    return template("scorequery")

@route("/scorejson", method="POST")
def scorejson():

    userid = request.forms.get("userid")
    passwd = request.forms.get("password")
    realname = request.forms.get("realname")
    return gen(userid,passwd,realname)

if __name__ == '__main__':
    run(host='0.0.0.0', port=80)
    '''userid="xxx"
    passwd="xxx"
    realname="xxx"
    gen(userid,passwd,realname)'''


