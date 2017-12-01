#coding=utf-8
import sqlite3


conn = sqlite3.connect('test.db')
c = conn.cursor()

try:
    c.execute('create table books (name,isbn)')
    c.execute('insert into books values (?,?)',('《论语》移译','9787551713641'))
    conn.commit()
except sqlite3.OperationalError as err:
    print(err)
    
c.execute('select * from books ')
resultTuple=c.fetchone()
print(resultTuple)
print(type(resultTuple))

conn.close()
