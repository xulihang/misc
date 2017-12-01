name=input("Please input your name:")
age=input("Age:")


while True:
    mood=input("Mood(Good or Bad):")
    if mood.lower()=="good" or mood.lower()=="bad":
        break
    else:
        print("Please choose between Good and Bad.")

print(name,age,mood.lower())
