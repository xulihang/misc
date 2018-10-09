# -*- coding:utf-8 -*-  
#句法分析

import os  
from nltk.parse.stanford import StanfordParser

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
    en=line.split("\t")[0]
    cn=line.split("\t")[1]
    en_parsed=str(en_parse(en)).replace("\n","").strip()
    cn_parsed=str(cn_parse(cn)).replace("\n","").strip()
    fw.write(en_parsed+"\t"+cn_parsed+"\n")
    fw.flush()
fw.close()
f.close()





