DROP TABLE IF EXISTS DEPENDENTE;
DROP TABLE IF EXISTS FUNCIONARIO;
DROP TABLE IF EXISTS CARGO;
DROP TABLE IF EXISTS APLICACAO;
DROP TABLE IF EXISTS CONTA_CORRENTE;
DROP TABLE IF EXISTS AGENCIA;
DROP TABLE IF EXISTS FINANCIAMENTO;
DROP TABLE IF EXISTS PRODUTO;
DROP TABLE IF EXISTS INSTITUICAO;
DROP TABLE IF EXISTS CLIENTE;


CREATE TABLE CARGO(
	cargo_id INT PRIMARY KEY NOT NULL,
	nome VARCHAR(45),
	carga_horaria INT,
	salario DECIMAL
);

CREATE TABLE AGENCIA(
	numero INT PRIMARY KEY NOT NULL,
	municipio VARCHAR(45),
	endereco VARCHAR(45),
	capacidade INT,
    cpf_funcionario CHAR(11) NOT NULL
);

CREATE TABLE FUNCIONARIO(
	funcionario_cpf CHAR(11) PRIMARY KEY NOT NULL,
	nome VARCHAR(45),
	data_nascimento DATE,
	data_contratacao DATE,
	matricula VARCHAR(45),
	sexo ENUM('masculino', 'feminino', 'outro'),
    id_cargo INT NOT NULL, 
    agencia INT NOT NULL, 
	FOREIGN KEY (id_cargo) REFERENCES CARGO (cargo_id),
    FOREIGN KEY (agencia) REFERENCES AGENCIA (numero)
);

CREATE TABLE DEPENDENTE(
	dependente_cpf CHAR(11) NOT NULL,
	nome VARCHAR(45),
	data_nascimento DATE,
	parentesco VARCHAR(45),
	sexo ENUM('masculino', 'feminino', 'outro'),
	funcionario CHAR(11) PRIMARY KEY NOT NULL,
    FOREIGN KEY (funcionario) REFERENCES FUNCIONARIO (funcionario_cpf)
);

CREATE TABLE CLIENTE(
	cliente_cpf CHAR(11) PRIMARY KEY NOT NULL,
	nome VARCHAR(45),
	data_nascimento DATE,
	email VARCHAR(45),
	RG CHAR(7),
    endereco VARCHAR(45),
	sexo ENUM('masculino', 'feminino', 'outro')
);

CREATE TABLE CONTA_CORRENTE(
	numero CHAR(10) NOT NULL,
	saldo DECIMAL,
	senha CHAR(6),
	cpf_cliente CHAR(11) PRIMARY KEY NOT NULL,
	agencia INT NOT NULL,
    FOREIGN KEY (cpf_cliente) REFERENCES CLIENTE (cliente_cpf),
	FOREIGN KEY (agencia) REFERENCES AGENCIA (numero)
);

CREATE TABLE FINANCIAMENTO(
	valor DECIMAL NOT NULL,
	juros DECIMAL NOT NULL,
	dia_pagamento INT,
	data_vencimento DATE NOT NULL,
    valor_quitado DECIMAL,
	cpf_cliente CHAR(11) PRIMARY KEY NOT NULL,
    FOREIGN KEY (cpf_cliente) REFERENCES CLIENTE (cliente_cpf)
);

CREATE TABLE INSTITUICAO(
	cnpj CHAR(11) PRIMARY KEY NOT NULL,
	nome VARCHAR(45) NOT NULL,
	endereco VARCHAR(45),
    classe ENUM('banco','corretora','outro'),
    patrimonio DECIMAL
);

CREATE TABLE PRODUTO(
	produto_id INT PRIMARY KEY NOT NULL,
	nome VARCHAR(45) NOT NULL,
    classe ENUM('renda fixa','renda variavel','misto'),
    taxa_adm DECIMAL,
    taxa_rendimento DECIMAL,
    taxa_IR DECIMAL,
    valor_minimo DECIMAL,
    emissor CHAR(11) NOT NULL,
    FOREIGN KEY (emissor) REFERENCES INSTITUICAO (cnpj)
);

CREATE TABLE APLICACAO(
	valor DECIMAL,
    data_aplicacao DATE,
    data_vencimento DATE,
    conta CHAR(10) NOT NULL,
    produto INT NOT NULL,
    FOREIGN KEY (conta) REFERENCES CONTA_CORRENTE(cpf_cliente),
    FOREIGN KEY (produto) REFERENCES PRODUTO (produto_id)
);