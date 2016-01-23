# -*- coding: utf-8 -*-

result=''
f=open('data.csv')
for i in f.readlines():
    a=i.split(',')
    
    name=''
    #name=name.decode("utf8").encode("utf8")
    #name2=''
    number=a[1]
    for j in a[0]:
        j.replace(" ","")
        name=name+"="+"%02x"%ord(j)
        #name2=name2+"="+"%02x"%ord(j)+";"
        name=name.upper()
        #name2=name2.upper()
    result=result+"BEGIN:VCARD\n"+"VERSION:2.1\n"+"N;CHARSET=UTF-8;ENCODING=QUOTED-PRINTABLE:"+str(name)+";;;\n"+"FN;CHARSET=UTF-8;ENCODING=QUOTED-PRINTABLE:"+str(name)+"\n"+"TEL;CELL:"+str(number)+"\nEND:VCARD\n"
fw=open('00001.vcf','w')
fw.write(result)
fw.flush()
fw.close()