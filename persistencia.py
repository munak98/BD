import mysql.connector
from mysql.connector import Error

def IPcreate(cursor, table, data):
    tablename = ''
    if table == 1:
        columns = "(cliente_cpf, nome, data_nascimento, email, rg, endereco, sexo)"
        tablename = 'CLIENTE'
    elif table == 2:
        columns = "(cnpj, nome, endereco, classe, patrimonio)"
        tablename = 'INSTITUICAO'
    elif table == 3:
        columns = "(produto_id, nome, classe, taxa_adm, taxa_rendimento, taxa_IR, valor_minimo, emissor)"
        tablename = 'PRODUTO'
    elif table == 4:
        columns = "(numero, saldo, senha, cpf_cliente, agencia)"
        tablename = 'CONTA_CORRENTE'
    elif table == 5:
        columns = "(valor, data_aplicacao, data_vencimento, conta, produto, horario)"
        tablename = 'APLICACAO'

    try:
        cursor.execute(f"INSERT INTO {tablename} {columns} VALUES {data}")
    except Error as e:
        print (e)
        return 1
    return 0

def IPread(cursor, table):
    if table == "CLIENTE":
        cursor.execute(f"SELECT cliente_cpf, nome, data_nascimento, email, RG, endereco, sexo FROM {table}")
    else:
        cursor.execute(f"SELECT * FROM {table};")
    return 0, cursor.fetchall();


def IPupdate(cursor, table, column, value, key, key_value):
    try:
        query = f"UPDATE {table} SET {column} = %s WHERE {key} = %s;"
        tuple = (value, key_value)
        cursor.execute(query, tuple)
    except Error as e:
        print(e)
        return 1
    return 0

def IUupdateApplication(cursor, table, column, value, time, date, account, product):
    try:
        cursor.execute(f"UPDATE {table} SET {column} = {value} WHERE horario = \"{time}\" AND data_aplicacao = \"{date}\" AND conta = \"{account}\" AND produto = \"{product}\";")
    except Error as e:
        print(e)
        return 1
    return 0




def IPdelete(cursor, table, key, key_value):
    if key_value == '-1':
        cursor.execute("DELETE FROM {};".format(table))
    else:
        try:
            cursor.execute("DELETE FROM {} WHERE {} = \"{}\";".format(table, key, key_value))
        except Error as e:
            print(e)
            return 1
    return 0

def IPdeleteApplication(cursor, table, time, date, account, product):
    if time == '-1':
        cursor.execute("DELETE FROM {};".format(table))

    else:
        try:
            cursor.execute(f"DELETE FROM APLICACAO WHERE horario = \"{time}\" AND data_aplicacao = \"{date}\" AND conta = \"{account}\" AND produto = \"{product}\";")
        except Error as e:
            print(e)
            return 1
    return 0

def view(cursor):
    cursor.execute("SELECT * FROM CLIENTE_APLICACAO;")
    data = cursor.fetchall();
    for i in data:
        print(i)
