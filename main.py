from usuario import *
import mysql.connector
from mysql.connector import Error

try:
    connection = mysql.connector.connect(host='localhost', database='financeiro', user='root', password='975856')
    if connection.is_connected():
        print("Connected to MySQL Server")
        cursor = connection.cursor()

        while(True):
            operation = printCRUDMenu()
            if operation == -1:
                break
            while(True):
                if operation == 5:
                    view(cursor)
                    break
                table = printTablesMenu()
                if table == -1:
                    break
                if (operation == 1):
                    IUcreate(cursor, table)
                elif (operation == 2):
                    IUread(cursor, table)
                elif (operation == 3):
                    IUupdate(cursor, table)
                elif (operation == 4):
                    IUdelete(cursor, table)
                
                connection.commit()

except Error as e:
    print("Error while connecting to MySQL", e)

finally:
    if connection.is_connected():
        cursor.close()
        connection.close()
        print("MySQL connection is closed")
