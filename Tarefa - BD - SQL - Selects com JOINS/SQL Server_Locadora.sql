CREATE DATABASE locadora;
GO
USE locadora;
GO
CREATE TABLE filme(
id		INT			NOT NULL,
titulo  VARCHAR(40)	NOT NULL,
ano		INT			NULL CHECK(ano <= 2021) -- Verifica se o ano do filme é menor igual a 2021
PRIMARY KEY(id)
)
GO
CREATE TABLE estrela(
id		INT				NOT NULL,
nome	VARCHAR(50)		NOT NULL
PRIMARY KEY(id)
)
GO
CREATE TABLE filme_estrela(
filme_id		INT		NOT NULL,
estrela_id		INT		NOT NULL
PRIMARY KEY(filme_id, estrela_id)
FOREIGN KEY(filme_id) REFERENCES filme(id),
FOREIGN KEY(estrela_id) REFERENCES estrela(id)
)
GO
CREATE TABLE dvd(
num					INT     NOT NULL,
data_fabricacao		DATE	NOT NULL CHECK(data_fabricacao < GETDATE()),
filme_id			INT		NOT NULL
PRIMARY KEY(num)
FOREIGN KEY(filme_id) REFERENCES filme(id)
)
GO
CREATE TABLE cliente(
num_cadastro		INT				NOT NULL,
nome				VARCHAR(70)		NOT NULL,
logradouro			VARCHAR(150)	NOT NULL,
num					INT				NOT NULL CHECK(NUM > 0),
cep					CHAR(8)			NULL CHECK(LEN(cep) = 8)
PRIMARY KEY(num_cadastro)
)
GO
CREATE TABLE locacao(
dvd_num			INT				NOT NULL,
cliente_num		INT				NOT NULL,
data_locacao	DATE			NOT NULL DEFAULT(CONVERT(DATE, GETDATE(), 103)),
data_devolucao	DATE			NOT NULL,
valor			DECIMAL(7,2)	NOT NULL CHECK(valor > 0)
PRIMARY KEY(dvd_num, cliente_num,data_locacao),
FOREIGN KEY(dvd_num) REFERENCES dvd(num),
FOREIGN KEY(cliente_num) REFERENCES cliente(num_cadastro),
CONSTRAINT dt_dev_maior_dt_locacao
								CHECK(data_devolucao > data_locacao)
)
---------------------
GO
---Estrela precisa de um atributo nome_real de 50 caracteries
ALTER TABLE estrela
ADD nome_real VARCHAR(80) NULL;
---Percebeu-se que o nome do filme deveria ser um atributo com 80 caracteres
GO
ALTER TABLE filme
ALTER COLUMN titulo VARCHAR(80) NOT NULL;
-----------------------------------------
--Inserir em filmes
INSERT INTO filme VALUES
(1001, 'Whiplash', 2015),
(1002, 'Birdman', 2015),
(1003, 'Interestelar',2014),
(1004, 'A Culpa é das estrelas',2014),
(1005, 'Alexandre e o Dia Terrível, Horrível, Espantoso e Horrosso',2014),
(1006, 'Sing', 2016)
GO
--Inserir em Estrela
INSERT INTO estrela VALUES
(9901, 'Michael Keaton', 'Michael John Douglas'),
(9902, 'Emma Stone', 'Emily Jean Stone'),
(9903, 'Miles Teller', NULL),
(9904, 'Steve Carell', 'Steven John Carell'),
(9905, 'Jennifer Garner', 'Jennifer Anne Garner')

GO
--Inserir em Filme_estrela
INSERT INTO filme_estrela VALUES
(1002, 9901),
(1002, 9902),
(1001, 9903),
(1005, 9904),
(1005, 9905)
GO
---Inserir em DVD, caso o sistema esteja em portugues colocar o padrão brasileiro de data (dd/mm/aaaa)
INSERT INTO dvd VALUES
(10001, '2020-12-02', 1001), 
(10002, '2019-10-18', 1002),
(10003, '2020-04-03', 1003),
(10004, '2020-12-02', 1001),
(10005, '2019-10-18', 1004),
(10006, '2020-04-03', 1002),
(10007, '2020-12-02', 1005),
(10008, '2019-10-18', 1002),
(10009, '2020-04-03', 1003)
---------------------------
GO
----Inserir em Cliente
INSERT INTO cliente VALUES
(5501, 'Matilde Luz', 'Rua Síria', 150, '03086040'),
(5502, 'Carlos Carreiro', 'Rua Bartolomeu Aires',1250, '04419110'),
(5503, 'Daniel Ramalho', 'Rua Itajutiba', 169, NULL),
(5504, 'Roberta Bento', 'Rua Jayme Von Rosenburg', 36, NULL),
(5505, 'Rosa Cerqueira', 'Rua Arnaldo Simões Pinto', 235, '02917110')
---
GO
-----Inserir em Locacao
INSERT INTO locacao VALUES
(10001, 5502, '2021-02-18', '2021-02-21', 3.50),
(10009, 5502, '2021-02-18', '2021-02-21', 3.50),
(10002, 5503, '2021-02-18', '2021-02-19', 3.50),
(10002, 5505, '2021-02-20', '2021-02-23', 3.00),
(10004, 5505, '2021-02-20', '2021-02-23', 3.00),
(10005, 5505, '2021-02-20', '2021-02-23', 3.00),
(10001, 5501, '2021-02-24', '2021-02-26', 3.50),
(10008, 5501, '2021-02-24', '2021-02-26', 3.50)
----------------
----Operações com dados
--Os CEP dos clientes 5503 e 5504 são 08411150 e 02918190 respectivamente
GO
UPDATE cliente SET
cep = '08411150'
WHERE num_cadastro = 5503
GO
UPDATE cliente SET
cep = '02918190'
WHERE num_cadastro = 5504
---A locação de 2021-02-18 do cliente 5502 teve o valor de 3.25 para cada DVD alugado
GO
UPDATE locacao SET
valor = 3.25
WHERE cliente_num = 5502 AND data_locacao = '2021-02-18'
--A locação de 2021-02-24 do cliente 5501 teve o valor de 3.10 para cada DVD alugado
GO
UPDATE locacao SET
valor = 3.10
WHERE cliente_num = 5501 AND data_locacao = '2021-02-24'
--O DVD 10005 foi fabricado em 2019-07-14
GO
UPDATE dvd SET
data_fabricacao = '2019-07-14'
WHERE num = 10005
--O nome real de Miles Teller é Miles Alexander Teller
GO
UPDATE estrela SET
nome_real = 'Miles Alexander Teller'
WHERE nome = 'Miles Teller'
---O filme Sing não tem DVD cadastrado e deve ser excluíd
GO
DELETE from filme
WHERE titulo = 'Sing'
-----------------------
---- Tarefa 7 SQL

-- • Não esquecer de rever as restrições de datas
/*1) Consultar num_cadastro do cliente, nome do cliente, data_locacao (Formato
dd/mm/aaaa), Qtd_dias_alugado (total de dias que o filme ficou alugado), titulo do
filme, ano do filme da locação do cliente cujo nome inicia com Matilde*/
SELECT c.num_cadastro, c.nome,
CONVERT(CHAR(10),lo.data_locacao,103) AS dt_locacao,
DATEDIFF(DAY,lo.data_locacao, lo.data_devolucao) AS qtd_dias_alugado,
f.titulo, f.ano
FROM locacao lo
INNER JOIN cliente c
ON c.num_cadastro = lo.cliente_num
INNER JOIN dvd
ON dvd.num = lo.dvd_num
INNER JOIN filme f
ON f.id = dvd.filme_id
WHERE c.nome LIKE 'Matilde%'
------------------------------
--2) Consultar nome da estrela, nome_real da estrela, título do filme dos filmes
--cadastrados do ano de 2015
SELECT e.nome, e.nome_real,
f.titulo
FROM filme_estrela f_e
INNER JOIN estrela e
ON e.id = f_e.estrela_id
INNER JOIN filme f
ON f.id = f_e.filme_id
WHERE f.ano = 2015
ORDER BY e.nome
-----------------
/*
3) Consultar título do filme, data_fabricação do dvd (formato dd/mm/aaaa), caso a
diferença do ano do filme com o ano atual seja maior que 6, deve aparecer a diferença
do ano com o ano atual concatenado com a palavra anos (Exemplo: 7 anos), caso
contrário só a diferença (Exemplo: 4).*/
SELECT f.titulo, CONVERT(CHAR(10),d.data_fabricacao,103) AS dt_fabricacao,
CASE WHEN(CONVERT(INT, YEAR(GETDATE()), 103) - f.ano  > 6)
		THEN
			
			CAST(CONVERT(INT, YEAR(GETDATE()), 103) - f.ano AS varchar(7)) + ' anos'
		ELSE
			CAST(CONVERT(INT, YEAR(GETDATE()), 103) - f.ano AS varchar(2))
		END AS dif_anos_lancamento_atual
FROM dvd d
INNER JOIN filme f
ON f.id = d.filme_id
			
