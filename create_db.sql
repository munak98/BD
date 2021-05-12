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
	funcionario CHAR(11), 
    PRIMARY KEY (funcionario, nome),
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
    data_aplicacao DATE NOT NULL,
    data_vencimento DATE,
    conta VARCHAR(15) NOT NULL,
    produto VARCHAR(20) NOT NULL,
    horario CHAR(5) NOT NULL,
    PRIMARY KEY (horario, data_aplicacao, conta, produto),
    FOREIGN KEY (conta) REFERENCES CONTA_CORRENTE(numero),
    FOREIGN KEY (produto) REFERENCES PRODUTO (produto_id)
);


insert into CARGO (cargo_id, nome, carga_horaria, salario) VALUES (0, "Gerente", 45, 12000.88);
insert into CARGO (cargo_id, nome, carga_horaria, salario) VALUES (1, "Analista", 40, 7987.83);
insert into CARGO (cargo_id, nome, carga_horaria, salario) VALUES (2, "Atendente", 40, 3889.73);
insert into CARGO (cargo_id, nome, carga_horaria, salario) VALUES (3, "Diretor", 45, 16000.88);
insert into CARGO (cargo_id, nome, carga_horaria, salario) VALUES (4, "Supervisor", 40, 8300.44);

insert into AGENCIA (numero, cidade, endereco, capacidade)
VALUES ("201", "Brasília", "Setor bancário", 40);
insert into AGENCIA (numero, cidade, endereco, capacidade)
VALUES ("301", "Brasília", "W3 Sul", 40);
insert into AGENCIA (numero, cidade, endereco, capacidade)
VALUES ("401", "Brasília", "W3 Norte", 40);
insert into AGENCIA (numero, cidade, endereco, capacidade)
VALUES ("501", "Brasília", "Taguatinga", 40);
insert into AGENCIA (numero, cidade, endereco, capacidade)
VALUES ("601", "Brasília", "Sudoeste", 40);

insert into FUNCIONARIO (funcionario_cpf, nome, data_nascimento, data_contratacao, matricula, sexo, id_cargo, agencia)
VALUES ('90000000000', 'Elizabeth', '1986-08-29', '2008-03-19', '147', 'feminino', 4, 201);
insert into FUNCIONARIO (funcionario_cpf, nome, data_nascimento, data_contratacao, matricula, sexo, id_cargo, agencia)
VALUES ('90000000001', 'Eugênia', '1991-07-29', '2010-10-23', '148', 'outro', 1, 301);
insert into FUNCIONARIO (funcionario_cpf, nome, data_nascimento, data_contratacao, matricula, sexo, id_cargo, agencia)
VALUES ('90000000002', 'Pedro', '1988-11-29', '2012-12-21', '149', 'masculino', 3, 401);
insert into FUNCIONARIO (funcionario_cpf, nome, data_nascimento, data_contratacao, matricula, sexo, id_cargo, agencia)
VALUES ('90000000003', 'Mauro', '1994-02-12', '2017-09-23', '146', 'masculino', 2, 501);
insert into FUNCIONARIO (funcionario_cpf, nome, data_nascimento, data_contratacao, matricula, sexo, id_cargo, agencia)
VALUES ('90000000004', 'Dalila', '1979-06-26', '2016-04-13', '145', 'feminino', 0, 601);

insert into DEPENDENTE (dependente_cpf, nome, data_nascimento, parentesco, sexo, funcionario)
VALUES ('20000000000','Alberto', '2009-04-30', 'filho(a)', 'masculino', '90000000004');
insert into DEPENDENTE (dependente_cpf, nome, data_nascimento, parentesco, sexo, funcionario)
VALUES ('20000000001', 'Bianca', '2006-04-18', 'filho(a)', 'feminino', '90000000004');
insert into DEPENDENTE (dependente_cpf, nome, data_nascimento, parentesco, sexo, funcionario)
VALUES ('20000000002','Carlos', '1950-04-20', 'pai', 'masculino', '90000000001');
insert into DEPENDENTE (dependente_cpf, nome, data_nascimento, parentesco, sexo, funcionario)
VALUES ('20000000003','Daniela', '1949-07-30', 'mãe', 'feminino', '90000000000');
insert into DEPENDENTE (dependente_cpf, nome, data_nascimento, parentesco, sexo, funcionario)
VALUES ('20000000004','Eric', '2020-05-03', 'filho', 'masculino', '90000000002');

insert into CLIENTE (cliente_cpf, nome, data_nascimento, email, RG, endereco, sexo)
VALUES ("88888888888", "Ana", "2000-05-02", "ana@email.com", "8888888", "Setor residencial", "feminino");
insert into CLIENTE (cliente_cpf, nome, data_nascimento, email, RG, endereco, sexo)
VALUES ("77777777777", "Roberto", "1988-09-12", "beto@email.com", "7777777", "Setor residencial", "masculino");
insert into CLIENTE (cliente_cpf, nome, data_nascimento, email, RG, endereco, sexo)
VALUES ("66666666666", "Dario", "1978-05-06", "dario@email.com", "6666666", "Setor residencial", "masculino");
insert into CLIENTE (cliente_cpf, nome, data_nascimento, email, RG, endereco, sexo)
VALUES ("55555555555", "Emília", "1990-01-27", "amy@email.com", "5555555", "Setor residencial", "masculino");
insert into CLIENTE (cliente_cpf, nome, data_nascimento, email, RG, endereco, sexo)
VALUES ("44444444444", "Maximilliam", "1966-02-18", "max@email.com", "4444444", "Setor residencial", "masculino");

insert into CONTA_CORRENTE (numero, saldo, senha, cpf_cliente, agencia)
VALUES ("0000", 36483.88, "000000", "77777777777", "201");
insert into CONTA_CORRENTE (numero, saldo, senha, cpf_cliente, agencia)
VALUES ("1111", 96483.88, "111111", "88888888888", "301");
insert into CONTA_CORRENTE (numero, saldo, senha, cpf_cliente, agencia)
VALUES ("2222", 37483.88, "222222", "66666666666", "401");
insert into CONTA_CORRENTE (numero, saldo, senha, cpf_cliente, agencia)
VALUES ("3333", 78483.88, "333333", "55555555555", "501");
insert into CONTA_CORRENTE (numero, saldo, senha, cpf_cliente, agencia)
VALUES ("4444", 108483.88, "444444", "44444444444", "601");

insert into FINANCIAMENTO (valor, juros, dia_pagamento, data_vencimento, valor_quitado, cpf_cliente)
VALUES(5000.00, 0.045, 20, '2021-12-20', 1000.0, '88888888888');
insert into FINANCIAMENTO (valor, juros, dia_pagamento, data_vencimento, valor_quitado, cpf_cliente)
VALUES(20000.00, 0.03, 20, '2022-12-20', 7000.0, '77777777777');
insert into FINANCIAMENTO (valor, juros, dia_pagamento, data_vencimento, valor_quitado, cpf_cliente)
VALUES(15000.00, 0.035, 20, '2021-12-20', 3000.0, '66666666666');
insert into FINANCIAMENTO (valor, juros, dia_pagamento, data_vencimento, valor_quitado, cpf_cliente)
VALUES(6000.00, 0.03, 20, '2021-12-20', 1000.0, '55555555555');
insert into FINANCIAMENTO (valor, juros, dia_pagamento, data_vencimento, valor_quitado, cpf_cliente)
VALUES(8000.00, 0.03, 20, '2021-12-20', 2600.0, '44444444444');

insert into INSTITUICAO (cnpj, nome, endereco, classe, patrimonio) 
VALUES ("00000000001", "Banco Uno", "Setor Bancário", "banco", 998761462.77);
insert into INSTITUICAO (cnpj, nome, endereco, classe, patrimonio) 
VALUES ("00000000000", "Investimentor", "Setor Comercial", "corretora", 68975432165.86);
insert into INSTITUICAO (cnpj, nome, endereco, classe, patrimonio) 
VALUES ("00000000002", "Associação Imobiliária", "Setor Comercial", "outro", 9665432165.86);
insert into INSTITUICAO (cnpj, nome, endereco, classe, patrimonio) 
VALUES ("00000000003", "Dinheiroso", "Setor de Autarquias", "banco", 77575432165.86);
insert into INSTITUICAO (cnpj, nome, endereco, classe, patrimonio) 
VALUES ("00000000004", "Beb", "Setor de Diversões", "outro", 75432165.86);

insert into PRODUTO (produto_id, nome, classe, taxa_adm, taxa_rendimento, taxa_IR, valor_minimo, emissor)
VALUES ("00000", "BBU1", "renda variavel", 7.0, 0.4, 0.23, 3.40, "00000000001");
insert into PRODUTO (produto_id, nome, classe, taxa_adm, taxa_rendimento, taxa_IR, valor_minimo, emissor)
VALUES ("00001", "IVR0", "renda variavel", 8.0, 0.64, 0.33, 5.48, "00000000002");
insert into PRODUTO (produto_id, nome, classe, taxa_adm, taxa_rendimento, taxa_IR, valor_minimo, emissor)
VALUES ("00002", "Letra de crédito imobiliário", "renda fixa", 6.4, 0.64, 0.31, 7.23, "00000000003");
insert into PRODUTO (produto_id, nome, classe, taxa_adm, taxa_rendimento, taxa_IR, valor_minimo, emissor)
VALUES ("00003", "Letra de crédito financeiro", "renda fixa", 8.0, 0.64, 0.33, 5.48, "00000000000");
insert into PRODUTO (produto_id, nome, classe, taxa_adm, taxa_rendimento, taxa_IR, valor_minimo, emissor)
VALUES ("00004", "BEB4", "renda variavel", 8.0, 0.64, 0.33, 5.48, "00000000000");

insert into APLICACAO (valor, data_aplicacao, data_vencimento, conta, produto, horario)
VALUES (230.36, "2019-12-17", "2020-12-21", "0000", "00000", "16:22");
insert into APLICACAO (valor, data_aplicacao, data_vencimento, conta, produto, horario)
VALUES (637.82, "2019-12-21", "2020-06-21", "1111", "00001", "17:37");
insert into APLICACAO (valor, data_aplicacao, data_vencimento, conta, produto, horario)
VALUES (888.82, "2018-10-21", "2020-03-13", "2222", "00002", "11:22");
insert into APLICACAO (valor, data_aplicacao, data_vencimento, conta, produto, horario)
VALUES (1024.87, "2019-04-16", "2020-06-21", "3333", "00003", "17:15");
insert into APLICACAO (valor, data_aplicacao, data_vencimento, conta, produto, horario)
VALUES (3824.57, "2017-11-14", "2020-01-28", "4444", "00004", "09:01");




CREATE VIEW CLIENTE_APLICACAO AS
SELECT CLIENTE.nome, CLIENTE.cliente_cpf, APLICACAO.data_aplicacao, APLICACAO.valor, PRODUTO.nome as prodname
FROM CLIENTE
INNER JOIN CONTA_CORRENTE
ON CLIENTE.cliente_cpf = CONTA_CORRENTE.cpf_cliente
INNER JOIN APLICACAO
ON CONTA_CORRENTE.numero = APLICACAO.conta
INNER JOIN PRODUTO
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






