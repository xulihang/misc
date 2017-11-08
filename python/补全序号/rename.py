#change 0.ts or 00.ts or 000,ts to 0000.ts
import os
filelist=os.listdir("./")
for file in filelist:
    orgName=file
    file=file.split("_")
    if len(file[3])<7:
        for i in range(7-len(file[3])):
            file[3]="0"+file[3]
        print(file)
        filename="_".join(file)
        print(filename)
        os.rename(orgName,filename)
    else:
        pass
