# -*- coding:utf-8 -*-  
#句法分析

import os  
from nltk.parse.stanford import StanfordParser

def getPP(t):
    """
    递归tree，找到介词短语
    """
    try:
        t.label()
    except AttributeError:
        pass
    else:
        if t.label()=="PP":
            PPs.append(" ".join(t.leaves()))
        for child in t:
            getPP(child)

def en_parse(sent):
    """
    对英文句子做句法分析
    """
    parser=StanfordParser('E:\standford_nlp\stanford-parser-full-2018-02-27\stanford-parser.jar','E:\standford_nlp\stanford-parser-full-2018-02-27\stanford-parser-3.9.1-models.jar')
    return list(parser.raw_parse(sent))[0]

def cn_parse(sent):
    """
    对中文句子做句法分析，记得model_path要改变
    """
    parser = StanfordParser('E:\standford_nlp\stanford-parser-full-2018-02-27\stanford-parser.jar','E:\standford_nlp\stanford-parser-full-2018-02-27\stanford-parser-3.9.1-models.jar',model_path='edu/stanford/nlp/models/lexparser/chinesePCFG.ser.gz')            
    return list(parser.raw_parse(sent))[0]

f=open("句对齐的喜福会-中文分词版.txt","r",encoding="utf-8")
fw=open("out.txt","a",encoding="utf-8")
for line in f.readlines():
    line=line.replace("\n","")
    print(line)
    result=""
    en=line.split("\t")[0]
    cn=line.split("\t")[1]
    PPs=[]
    getPP(en_parse(en))
    en_PPs=PPs.copy()
    PPs.clear()
    if len(en_PPs)==0:
        continue
    else:
        getPP(cn_parse(cn))
        cn_PPs=PPs.copy()
        PPs.clear()
        if len(cn_PPs)>0:
            result=" ".join(en_PPs)
            result=result+"\t"+" ".join(cn_PPs)+"\n"
            print(result)
            fw.write(result)
            fw.flush()
fw.close()
f.close()





