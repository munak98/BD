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

    #cursor.execute("INSERT INTO {} {} VALUES {}; ".format(table, columns, data))
    try:
        cursor.execute(f"INSERT INTO {tablename} {columns} VALUES {data}")
    except Error as e:
        print (e)
        return 1
    return 0

def IPread(cursor, table):
    cursor.execute("SELECT * FROM {};".format(table))
    return 0, cursor.fetchall();


def IPupdate(cursor, table, column, value, key, key_value):
    try:
        cursor.execute("UPDATE {} SET {} = {} WHERE {} = \"{}\";".format(table, column, value, key, key_value))
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

def view(cursor):
    cursor.execute("SELECT * FROM CLIENTE_APLICACAO;")
    data = cursor.fetchall();
    for i in data:
        print(i)

