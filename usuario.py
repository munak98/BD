from persistencia import *
import base64
tables = ["CLIENTE", "INSTITUICAO", "PRODUTO", "CONTA_CORRENTE", "APLICACAO"]


def printCRUDMenu():
    print("\nQue operação deseja realizar? Digite -1 para sair.")
    print("1 - Criar \n2 - Ler \n3 - Atualizar \n4 - Deletar \n5 - Ver todos os clientes e suas aplicações")
    op = int(input("-> "))
    return op

def printTablesMenu():
    print("\nEm que tabela deseja realizar a operação? Digite -1 para voltar.")
    print("1 - Cliente \n2 - Instituição \n3 - Produto de investimento \n4 - Conta Corrente \n5 - Aplicação")
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
        sexo = str(input("Sexo ('masculino', 'feminino', 'outro'):"))
        data = (cpf, nome, data_nascimento, email, rg, endereco, binaryFoto, sexo)

    if (table == 2):
        cnpj = str(input("CNPJ: "))
        nome = str(input("Nome: "))
        endereco = str(input("Endereço: "))
        classe = str(input("Classe da instituição ('banco','corretora','outro'):"))
        patrimonio = input("Patrimônio: ")
        data = (cnpj, nome, endereco, classe, patrimonio)

    if (table == 3):
        id = input("Identificador: ")
        nome = str(input("Nome do produto: "))
        classe = str(input("Classe ('renda fixa','renda variavel','misto'):"))
        taxa_adm = input("Taxa de administração: ")
        taxa_rendimento = input("Taxa de rendimento: ")
        taxa_IR = input("Taxa de imposto de renda: ")
        valor_minimo = input("Valor mínimo: ")
        emissor = str(input("CNPJ da instituição emissora: "))
        data = (id, nome, classe, taxa_adm, taxa_rendimento, taxa_IR, valor_minimo, emissor)

    if table == 4:
        numero = input("Número da conta (Até 15 dígitos): ")
        saldo = input("Saldo: ")
        senha = input("Senha (Até 6 dígitos): ")
        cpf_titular = input("CPF do titular: ")
        agencia = input("Agência (Até 5 dígitos): ")
        data = (numero, saldo, senha, cpf_titular, agencia)

    if table == 5:
        valor = float(input("Digite o valor da aplicação: "))
        data_aplic = input("Digite a data da aplicação (YYYY-MM-DD): ")
        data_venc = input("Digite a data de vencimento da aplicação (YYYY-MM-DD): ")
        conta = input("Digite o número da conta: ")
        produto = input("Digite o código do produto: ")
        horario = input("Digite o horário de realização da aplicação (hh:mm): ")
        data = (valor, data_aplic, data_venc, conta, produto, horario)


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
        columns = ["cpf", "nome", "data_nascimento", "email", "rg", "endereco", "foto", "sexo"]
        key = "cliente_cpf"
        key_value = input("\nInsira o CPF da instância: ")
        print("\nSelecione o dado a ser atualizado.")
        print("1 - Nome")
        print("2 - Data de nascimento (YYYY-MM-DD)")
        print("3 - Email")
        print("4 - RG")
        print("5 - Endereço")
        print("6 - Foto")
        print("7 - Sexo ('masculino', 'feminino', 'outro')")
        col = int(input("-> "))
        if (col == 6):
            col_value = input("\nInsira o caminho para a foto: ")
            with open(col_value, 'rb') as file:
                col_value = file.read()
        else:
            col_value = input("\nInsira o novo valor: ")
            col_value = "\"{}\"".format(col_value)
    if table == 2:
        columns = ["cnpj", "nome", "endereco", "classe", "patrimonio"]
        key = "cnpj"
        key_value = input("\nInsira o CNPJ da instância: ")
        print("\nSelecione o dado a ser atualizado.")
        print("1 - Nome")
        print("2 - Endereço")
        print("3 - Classe ('banco','corretora','outro')")
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
        print("2 - Classe ('renda fixa','renda variavel','misto')")
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

    if table == 4:
        columns = ["numero", "saldo", "senha", "cpf_cliente", "agencia"]
        key = "numero"
        key_value = input("insira o número da conta que deseja alterar: ")
        print("\nSelecione o dado a ser atualizado.")
        print("1 - Saldo")
        print("2 - Senha")
        print("3 - CPF do titular")
        print("4 - Agencia")
        col = int(input("->"))
        col_value = input("\nIsira o novo valor: ")
        if col == 1:
            col_value = float(col_value)
        else:
            col_value = f"\"{col_value}\""

    if table == 5:
        columns = ["data_aplicacao", "valor", "data_vencimento", "conta", "produto", "horario"]
        print("Digite o horario da aplicação que deseja alterar.")
        time = input("-> ")
        print("Digite a data da aplicação que deseja alterar.")
        date = input("-> ")
        print("Digite a conta da aplicação que deseja alterar.")
        account = input("-> ")
        print("Digite o produto da aplicação que deseja alterar.")
        product = input("-> ")
        print("\nSelecione o dado a ser atualizado.")
        print("1 - Valor")
        print("2 - Data de vencimento")
        col = int(input("->" ))
        col_value = input("\nInsira o novo valor: ")
        if col == 1:
            col_value = float(col_value)
        else:
            col_value = f"\"{col_value}\""
        status = IUupdateApplication(cursor, tables[table-1], columns[col], col_value, time, date, account, product)
        if status == 0:
            print("\nInstância atualizada com sucesso.")
            return


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
    if table == 4:
        key = "numero"
        print("Insira o numero da instância. Digite -1 para deletar todas as instâncias.")
        key_value = input("->")
    if table == 5:
        print("Digite o horário da instância. Digite -1 para deletar todas as instâncias.")
        time = input("-> ")
        print("Digite a data da instância.")
        date = input("-> ")
        print("Digite a conta responsável pela instância.")
        account = input("-> ")
        print("Digite o produto da instância.")
        product = input("-> ")
        status = IPdeleteApplication(cursor, table, time, date, account, product)
        if status == 0:
            print("\nInstância(s) deletada(s) com sucesso.")
        return


    status = IPdelete(cursor, tables[table-1], key, key_value)
    if status == 0:
        print("\nInstância(s) deletada(s) com sucesso.")
    return
