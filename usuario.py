from persistencia import *
tables = ["CLIENTE", "INSTITUICAO", "PRODUTO"]

def printCRUDMenu():
    print("\nQue operação deseja realizar? Digite -1 para sair.")
    print("1 - Criar \n2 - Ler \n3 - Atualizar \n4 - Deletar ")
    op = int(input("-> "))
    return op

def printTablesMenu():
    print("\nEm que tabela deseja realizar a operação? Digite -1 para voltar.")
    print("1 - Cliente \n2 - Instituição \n3 - Produto de investimento")
    table = int(input("-> "))
    return table

def IUcreate(cursor, table):
    print("\nPor favor, preencha as informações para o cadastro.")
    if (table == 1):
        cpf = str(input("CPF: "))
        nome = str(input("Nome: "))
        data_nascimento = str(input("Data de nascimento (YYYY-MM-DD): "))
        email = str(input("Email: "))
        rg = str(input("RG: "))
        endereco = str(input("Endereço: "))
        sexo = str(input("Sexo: "))
        data = (cpf, nome, data_nascimento, email, rg, endereco, sexo)

    if (table == 2):
        cnpj = str(input("CNPJ: "))
        nome = str(input("Nome: "))
        endereco = str(input("Endereço: "))
        classe = str(input("Classe da instituição: "))
        patrimonio = input("Patrimônio: ")
        data = (cnpj, nome, endereco, classe, patrimonio)

    if (table == 3):
        id = input("Identificador: ")
        nome = str(input("Nome do produto: "))
        classe = str(input("Classe: "))
        taxa_adm = input("Taxa de administração: ")
        taxa_rendimento = input("Taxa de rendimento: ")
        taxa_IR = input("Taxa de imposto de renda: ")
        valor_minimo = input("Valor mínimo: ")
        emissor = str(input("CNPJ da instituição emissora: "))
        data = (id, nome, classe, taxa_adm, taxa_rendimento, taxa_IR, valor_minimo, emissor)

    status = IPcreate(cursor, table, data)
    if status == 0:
        print("\nInstância criada com sucesso!")

    return

def IUread(cursor, table):
    status, data = IPread(cursor, tables[table-1])
    if status == 0:
        showData(data, table)

def showData(data, table):
    for i in data:
        print(i)

def IUupdate(cursor, table):
    if table == 1:
        columns = ["cpf", "nome", "data_nascimento", "email", "rg", "endereco", "sexo"]
        key = "cliente_cpf"
        key_value = input("\nInsira o CPF da instância: ")
        print("\nSelecione o dado a ser atualizado.")
        print("1 - Nome")
        print("2 - Data de nascimento (YYYY-MM-DD)")
        print("3 - Email")
        print("4 - RG")
        print("5 - Endereço")
        print("6 - Sexo")
        col = int(input("-> "))
        col_value = input("\nInsira o novo valor: ")
        col_value = "\"{}\"".format(col_value)
    if table == 2:
        columns = ["cnpj", "nome", "endereco", "classe", "patrimonio"]
        key = "cnpj"
        key_value = input("\nInsira o CNPJ da instância: ")
        print("\nSelecione o dado a ser atualizado.")
        print("1 - Nome")
        print("2 - Endereço")
        print("3 - Classe")
        print("4 - Patrimônio")
        col = int(input("-> "))
        col_value = input("\nInsira o novo valor: ")
        if (col == 4):
            col_value = float(col_value)
        else:
            col_value = "\"{}\"".format(col_value)

    if table == 3:
        columns = ["produto_id", "nome", "classe", "taxa_adm", "taxa_rendimento", "taxa_IR", "valor_minimo", "emissor"]
        key = "produto_id"
        key_value = input("\nInsira o identificador da instância: ")
        print("\nSelecione o dado a ser atualizado.")
        print("1 - Nome")
        print("2 - Classe")
        print("3 - Taxa de administração")
        print("4 - Taxa de rendimento")
        print("5 - Taxa de imposto de renda")
        print("6 - Valor mínimo para aplicação")
        print("7 - CNPJ da instituição emissora")
        col = int(input("-> "))
        col_value = input("\nInsira o novo valor: ")
        if (col in [3,4,5,6]):
            col_value = float(col_value)
        else:
            col_value = "\"{}\"".format(col_value)

    status = IPupdate(cursor, tables[table-1], columns[col], col_value, key, key_value)
    if status == 0:
        print("\nInstância atualizada com sucesso.")

def IUdelete(cursor, table):
    if table == 1:
        key = "cpf"
        print("Insira o CPF da instância. Digite -1 para deletar todas as instâncias.")
        key_value = input("-> ")
    if table == 2:
        key = "cnpj"
        print("Insira o CNPJ da instância. Digite -1 para deletar todas as instâncias.")
        key_value = input("-> ")
    if table == 3:
        key = "produto_id"
        print("Insira o identificador da instância. Digite -1 para deletar todas as instâncias.")
        key_value = input("-> ")

    status = IPdelete(cursor, tables[table-1], key, key_value)
    if status == 0:
        print("\nInstância(s) deletada(s) com sucesso.")
    return
