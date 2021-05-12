USE financeiro;

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
DROP VIEW IF EXISTS CLIENTE_APLICACAO;
DROP PROCEDURE IF EXISTS INVESTIMENTOS;

CREATE TABLE CARGO(
	cargo_id INT PRIMARY KEY NOT NULL,
	nome VARCHAR(45),
	carga_horaria INT,
	salario FLOAT
);

CREATE TABLE AGENCIA(
	numero VARCHAR(5) PRIMARY KEY NOT NULL,
	cidade VARCHAR(45),
	endereco VARCHAR(45),
	capacidade INT
);

CREATE TABLE FUNCIONARIO(
	funcionario_cpf CHAR(11) PRIMARY KEY NOT NULL,
	nome VARCHAR(45),
	data_nascimento DATE,
	data_contratacao DATE,
	matricula VARCHAR(45),
    foto BINARY,
	sexo ENUM('masculino', 'feminino', 'outro'),
    id_cargo INT NOT NULL, 
    agencia VARCHAR(5) NOT NULL, 
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
	numero VARCHAR(15) PRIMARY KEY NOT NULL,
	saldo FLOAT,
	senha CHAR(6),
	cpf_cliente CHAR(11) NOT NULL,
	agencia VARCHAR(5) NOT NULL,
    FOREIGN KEY (cpf_cliente) REFERENCES CLIENTE (cliente_cpf),
	FOREIGN KEY (agencia) REFERENCES AGENCIA (numero)
);

CREATE TABLE FINANCIAMENTO(
	valor DECIMAL NOT NULL,
	juros DECIMAL NOT NULL,
	dia_pagamento INT,
	data_vencimento DATE NOT NULL,
    valor_quitado FLOAT,
	cpf_cliente CHAR(11) PRIMARY KEY NOT NULL,
    FOREIGN KEY (cpf_cliente) REFERENCES CLIENTE (cliente_cpf)
);

CREATE TABLE INSTITUICAO(
	cnpj CHAR(11) PRIMARY KEY NOT NULL,
	nome VARCHAR(45) NOT NULL,
	endereco VARCHAR(45),
    classe ENUM('banco','corretora','outro'),
    patrimonio Float
);

CREATE TABLE PRODUTO(
	produto_id VARCHAR(20) PRIMARY KEY NOT NULL,
	nome VARCHAR(45) NOT NULL,
    classe ENUM('renda fixa','renda variavel','misto'),
    taxa_adm FLOAT,
    taxa_rendimento FLOAT,
    taxa_IR FLOAT,
    valor_minimo FLOAT,
    emissor CHAR(11) NOT NULL,
    FOREIGN KEY (emissor) REFERENCES INSTITUICAO (cnpj)
);

CREATE TABLE APLICACAO(
	valor FLOAT,
    data_aplicacao DATE,
    data_vencimento DATE,
    conta CHAR(10) NOT NULL,
    produto VARCHAR(20) NOT NULL,
    FOREIGN KEY (conta) REFERENCES CONTA_CORRENTE(numero),
    FOREIGN KEY (produto) REFERENCES PRODUTO (produto_id)
);


insert into INSTITUICAO (cnpj, nome, endereco, classe, patrimonio) VALUES ("00000000001", "Banco Uno", "Setor bancário", "banco", 998761462.77);
insert into INSTITUICAO (cnpj, nome, endereco, classe, patrimonio) VALUES ("00000000000", "Investimentor", "Setor Comercial", "corretora", 68975432165.86);

insert into PRODUTO (produto_id, nome, classe, taxa_adm, taxa_rendimento, taxa_IR, valor_minimo, emissor)
VALUES ("00000", "ABC3", "renda variavel", 7.0, 0.4, 0.23, 3.40, "00000000001");

insert into PRODUTO (produto_id, nome, classe, taxa_adm, taxa_rendimento, taxa_IR, valor_minimo, emissor)
VALUES ("00001", "XPH8", "renda variavel", 8.0, 0.64, 0.33, 5.48, "00000000000");

insert into CLIENTE (cliente_cpf, nome, data_nascimento, email, RG, endereco, sexo)
VALUES ("88888888888", "Ana", "2000-05-02", "ana@email.com", "8888888", "Setor residencial", "feminino");

insert into CLIENTE (cliente_cpf, nome, data_nascimento, email, RG, endereco, sexo)
VALUES ("77777777777", "Beto", "1988-09-12", "beto@email.com", "7777777", "Setor residencial", "masculino");

insert into AGENCIA (numero, cidade, endereco, capacidade)
VALUES ("201", "Brasília", "Setor bancário", 40);

insert into CONTA_CORRENTE (numero, saldo, senha, cpf_cliente, agencia)
VALUES ("78ABF1", 36483.88, "123456", "77777777777", "201");

insert into CONTA_CORRENTE (numero, saldo, senha, cpf_cliente, agencia)
VALUES ("78910", 96483.88, "123456", "88888888888", "201");

insert into APLICACAO (valor, data_aplicacao, data_vencimento, conta, produto)
VALUES (230.36, "2019-12-21", "2020-12-21", "78ABF1", "00001");

insert into APLICACAO (valor, data_aplicacao, data_vencimento, conta, produto)
VALUES (637.82, "2019-12-21", "2020-06-21", "78ABF1", "00000");

insert into APLICACAO (valor, data_aplicacao, data_vencimento, conta, produto)
VALUES (888.82, "2019-12-21", "2020-06-21", "78910", "00000");


CREATE VIEW CLIENTE_APLICACAO AS
SELECT CLIENTE.nome, CLIENTE.cliente_cpf, APLICACAO.data_aplicacao, APLICACAO.valor, PRODUTO.nome as prodname
FROM CLIENTE
LEFT JOIN CONTA_CORRENTE
ON CLIENTE.cliente_cpf = CONTA_CORRENTE.cpf_cliente
LEFT JOIN APLICACAO
ON CONTA_CORRENTE.numero = APLICACAO.conta
LEFT JOIN PRODUTO
ON PRODUTO.produto_id = APLICACAO.produto;


DELIMITER $$
CREATE PROCEDURE INVESTIMENTOS(IN current_cpf CHAR(11))
BEGIN
SELECT CLIENTE.nome, CLIENTE.cliente_cpf, APLICACAO.data_aplicacao, APLICACAO.valor, PRODUTO.classe, PRODUTO.nome as Produto, INSTITUICAO.nome as Emissor
FROM CLIENTE
LEFT JOIN CONTA_CORRENTE
ON CLIENTE.cliente_cpf = CONTA_CORRENTE.cpf_cliente
LEFT JOIN APLICACAO
ON CONTA_CORRENTE.numero = APLICACAO.conta
LEFT JOIN PRODUTO
ON PRODUTO.produto_id = APLICACAO.produto
LEFT JOIN INSTITUICAO
ON INSTITUICAO.cnpj = PRODUTO.emissor GROUP BY CLIENTE.cliente_cpf, APLICACAO.data_aplicacao, APLICACAO.valor, PRODUTO.classe, PRODUTO.nome, INSTITUICAO.nome HAVING
CLIENTE.cliente_cpf = current_cpf;
END $$
DELIMITER ;






