CREATE DATABASE ex9
GO
USE ex9
GO
CREATE TABLE editora (
codigo			INT				NOT NULL,
nome			VARCHAR(30)		NOT NULL,
site			VARCHAR(40)		NULL
PRIMARY KEY (codigo)
)
GO
CREATE TABLE autor (
codigo			INT				NOT NULL,
nome			VARCHAR(30)		NOT NULL,
biografia		VARCHAR(100)	NOT NULL
PRIMARY KEY (codigo)
)
GO
CREATE TABLE estoque (
codigo			INT				NOT NULL,
nome			VARCHAR(100)	NOT NULL	UNIQUE,
quantidade		INT				NOT NULL,
valor			DECIMAL(7,2)	NOT NULL	CHECK(valor > 0.00),
codEditora		INT				NOT NULL,
codAutor		INT				NOT NULL
PRIMARY KEY (codigo)
FOREIGN KEY (codEditora) REFERENCES editora (codigo),
FOREIGN KEY (codAutor) REFERENCES autor (codigo)
)
GO
CREATE TABLE compra (
codigo			INT				NOT NULL,
codEstoque		INT				NOT NULL,
qtdComprada		INT				NOT NULL,
valor			DECIMAL(7,2)	NOT NULL,
dataCompra		DATE			NOT NULL
PRIMARY KEY (codigo, codEstoque, dataCompra)
FOREIGN KEY (codEstoque) REFERENCES estoque (codigo)
)
GO
INSERT INTO editora VALUES
(1,'Pearson','www.pearson.com.br'),
(2,'Civilização Brasileira',NULL),
(3,'Makron Books','www.mbooks.com.br'),
(4,'LTC','www.ltceditora.com.br'),
(5,'Atual','www.atualeditora.com.br'),
(6,'Moderna','www.moderna.com.br')
GO
INSERT INTO autor VALUES
(101,'Andrew Tannenbaun','Desenvolvedor do Minix'),
(102,'Fernando Henrique Cardoso','Ex-Presidente do Brasil'),
(103,'Diva Marilia Flemming','Professora adjunta da UFSC'),
(104,'David Halliday','Ph.D. da University of Pittsburgh'),
(105,'Alfredo Steinbruch','Professor de Matematica da UFRS e da PUCRS'),
(106,'Willian Roberto Cereja','Doutorado em Linguistica Aplicada e Estudos da Linguagem'),
(107,'William Stallings','Doutorado em Ciencias da Computacão pelo MIT'),
(108,'Carlos Morimoto','Criador do Kurumin Linux')
GO
INSERT INTO estoque VALUES
(10001,'Sistemas Operacionais Modernos ',4,108.00,1,101),
(10002,'A Arte da Política',2,55.00,2,102),
(10003,'Calculo A',12,79.00,3,103),
(10004,'Fundamentos de Fisica I',26,68.00,4,104),
(10005,'Geometria Analitica',1,95.00,3,105),
(10006,'Gramática Reflexiva',10,49.00,5,106),
(10007,'Fundamentos de Fisica III',1,78.00,4,104),
(10008,'Calculo B',3,95.00,3,103)
GO
INSERT INTO compra VALUES
(15051,10003,2,158.00,'04/07/2021'),
(15051,10008,1,95.00,'04/07/2021'),
(15051,10004,1,68.00,'04/07/2021'),
(15051,10007,1,78.00,'04/07/2021'),
(15052,10006,1,49.00,'05/07/2021'),
(15052,10002,3,165.00,'05/07/2021'),
(15053,10001,1,108.00,'05/07/2021'),
(15054,10003,1,79.00,'06/08/2021'),
(15054,10008,1,95.00,'06/08/2021')
---------------------------------
-- Exercícios
GO
-- 
/*1) Consultar nome, valor unitário, nome da editora e nome do autor dos livros do estoque que foram vendidos. 
Não podem haver repetições.*/
SELECT DISTINCT est.nome as nomeLivro, est.valor AS valorUnitario,
ed.nome as nomeEditora, aut.nome as nomeAutor
FROM compra c
INNER JOIN estoque est
ON est.codigo = c.codEstoque
INNER JOIN editora ed
ON ed.codigo = est.codEditora
INNER JOIN autor aut
ON aut.codigo = est.codAutor
ORDER BY est.nome
---------
-- 2) Consultar nome do livro, quantidade comprada e valor de compra da compra 15051
SELECT est.nome, c.qtdComprada, c.valor
FROM compra c
INNER JOIN estoque est
ON est.codigo = c.codEstoque
WHERE c.codigo = 15051

--- 3) Consultar Nome do livro e site da editora dos livros da Makron books
-- (Caso o site tenha mais de 10 dígitos, remover o www.).
SELECT est.nome, 
CASE WHEN(LEN(ed.site) > 10)
		THEN
			SUBSTRING( ed.site,5,LEN(ed.site) )
		ELSE
			ed.site
		END AS siteEditora
FROM editora ed
INNER JOIN estoque est
ON ed.codigo = est.codEditora
WHERE ed.nome LIKE '%Makron Books%'
-------------------------------

-- 4) Consultar nome do livro e Breve Biografia do David Halliday
SELECT est.nome, aut.biografia
FROM estoque est
INNER JOIN autor aut
ON aut.codigo = est.codAutor
WHERE aut.nome = 'David Halliday'

----------------
-- 5) Consultar código de compra e quantidade comprada do livro Sistemas Operacionais Modernos
SELECT c.codigo, c.qtdComprada
FROM compra c
INNER JOIN estoque est
ON est.codigo = c.codEstoque
WHERE est.nome = 'Sistemas Operacionais Modernos'
-------------------------------
--- 6) Consultar quais livros não foram vendidos
SELECT est.nome
FROM estoque est LEFT OUTER JOIN compra c
ON est.codigo = c.codEstoque
WHERE c.codigo IS NULL


----7) Consultar quais livros foram vendidos e não estão cadastrados.
--- Caso o nome dos livros terminem com espaço, fazer o trim apropriado.
SELECT est.nome
FROM estoque est RIGHT OUTER JOIN compra c
ON est.codigo = c.codEstoque
WHERE est.codigo is NULL
---------
--- 8) Consultar Nome e site da editora que não tem Livros no estoque
---(Caso o site tenha mais de 10 dígitos, remover o www.)
SELECT ed.nome,
CASE WHEN(LEN(ed.site) > 10)
		THEN
			SUBSTRING( ed.site,5,LEN(ed.site) )
		ELSE
			ed.site
		END AS siteEditora
FROM editora ed LEFT OUTER JOIN estoque est
ON ed.codigo = est.codEditora
WHERE est.codEditora IS NULL

---------------------------
--9) Consultar Nome e biografia do autor que não tem Livros no estoque
-- (Caso a biografia inicie com Doutorado, substituir por Ph.D.)
SELECT aut.nome,
CASE WHEN(SUBSTRING(aut.biografia, 1, 9) = 'Doutorado')
		THEN
			'Ph.D. '+ SUBSTRING(aut.biografia,10, LEN(aut.biografia))
		ELSE
			aut.biografia
		END AS biografia
FROM autor aut LEFT OUTER JOIN estoque est
ON aut.codigo = est.codAutor
WHERE est.codAutor IS NULL
--------------------------
--- 10) Consultar o nome do Autor, e o maior valor de Livro no estoque. Ordenar por valor descendente
SELECT aut.nome, MAX(est.valor) as maiorValorLivro
FROM autor aut
INNER JOIN estoque est
ON aut.codigo = est.codAutor
GROUP BY aut.nome
ORDER BY  MAX(est.valor) DESC
-----------------------------
--- 11) Consultar o código da compra, o total de livros comprados e a soma dos valores gastos.
---- Ordenar por Código da Compra ascendente.	
SELECT c.codigo, COUNT(c.codigo) AS totalLivrosComprados,
SUM(c.valor) AS SomaValoresGastos
FROM compra c
GROUP BY c.codigo
ORDER BY c.codigo ASC
--------------------
-- 12) Consultar o nome da editora e a média de preços dos livros em estoque.
--- Ordenar pela Média de Valores ascendente.	
SELECT ed.nome, AVG(est.valor) as mediaPrecoLivros
FROM editora ed
INNER JOIN estoque est
ON ed.codigo = est.codEditora
GROUP BY ed.nome
ORDER BY AVG(est.valor) ASC
-----------------------
/* 13) 
	Consultar o nome do Livro, a quantidade em estoque o nome da editora, o site da editora 
	(Caso o site tenha mais de 10 dígitos, remover o www.), criar uma coluna status onde:	
	Caso tenha menos de 5 livros em estoque, escrever Produto em Ponto de Pedido
	Caso tenha entre 5 e 10 livros em estoque, escrever Produto Acabando
	Caso tenha mais de 10 livros em estoque, escrever Estoque Suficiente
	A Ordenação deve ser por Quantidade ascendente
*/
SELECT est.nome, est.quantidade,
CASE WHEN(LEN(ed.site) > 10)
		THEN
			SUBSTRING( ed.site,5,LEN(ed.site) )
		ELSE
			ed.site
		END AS siteEditora,
CASE WHEN(COUNT(est.codigo) < 5)
	  THEN
		  'Produto em Ponto Pedido'
	  WHEN(COUNT(est.codigo) > 5 AND COUNT(est.codigo) <= 10)
			'