# -*- coding: utf-8 -*-
import os

for folder in os.listdir("./"):
	if folder!="rename.py":
	    fh = open(folder+"/Property.plist")
	    content=fh.read()
	    upbound=content.find("<date>")
	    lowbound=content.find("</date>")
	    content=content[upbound+6:lowbound-1].replace(":","-")
	    print content
	    os.rename(folder+"/Record.mp3",folder+"/"+content+".mp3")
