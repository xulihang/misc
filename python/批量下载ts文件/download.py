import wget
count=0
while count<5:
    try:
        result=wget.download("https://stream.scic.ec.europa.eu/vod/_definst_/smil:11066_12470_5a01687c2dbff.smil/media_w442363958_b466000_"+str(count)+".ts?tracks=or&clientip=218.247.220.230&smvplayersession=80c4681f-acac-4906-5611-52d0af6818f0")
        if result.find("ts")!=-1:
            count=count+1
    except:
        continue
        
    
