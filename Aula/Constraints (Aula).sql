CREATE DATABASE ConstraintsAula
GO
USE ConstraintsAula
GO
CREATE TABLE livro (
cod				INT				NOT NULL	IDENTITY(100001,100),
nome			VARCHAR(200)	NOT NULL,
lingua			VARCHAR(10)		NOT NULL	DEFAULT('PT-BR'),
ano				DATE			NOT NULL	CHECK(ano >= '31/12/1990')
PRIMARY KEY(cod)
)
GO
CREATE TABLE autor (
id				INT				NOT NULL	IDENTITY(2351,1),
nome			VARCHAR(200)	NOT NULL	UNIQUE,
dt_nasc			DATE			NOT NULL,
pais_nasc		VARCHAR(50)		NOT NULL,
bio				VARCHAR(255)	NOT NULL
PRIMARY KEY(id),
CONSTRAINT pais_disp 
	CHECK((UPPER(pais_nasc) = 'Brasil' OR (UPPER(pais_nasc) = 'Estados Unidos'
	OR (UPPER(pais_nasc) = 'Inglaterra' OR (UPPER(pais_nasc) = 'Alemanha')))))
)
GO
CREATE TABLE livro_autor (
cod				INT				NOT NULL,
id				INT				NOT NULL
PRIMARY KEY(cod, id)
FOREIGN KEY(cod) REFERENCES livro(cod),
FOREIGN KEY(id) REFERENCES autor(id)
)
GO
CREATE TABLE editora (
id_edit			INT				NOT NULL	IDENTITY(491,16),
nome			VARCHAR(200)	NOT NULL	UNIQUE,
tel				VARCHAR(11)		NOT NULL	CHECK(LEN(tel) = 10),
log_end			VARCHAR(200)	NOT NULL,
n_end			INT				NOT NULL	CHECK(n_end > 0),
cep				CHAR(8)			NOT NULL	CHECK(LEN(cep) = 8),
compl_end		VARCHAR(255)	NOT NULL
PRIMARY KEY(id_edit)
)
GO
CREATE TABLE edicao (
isbn			CHAR(13)		NOT NULL	CHECK(LEN(isbn) = 13),
preco			DECIMAL(4,2)	NOT NULL	CHECK(preco >= 0),
ano				DATE			NOT NULL	CHECK(ano >= '31/12/1993'),
n_pag			INT				NOT NULL	CHECK(n_pag >= 15),
qtd_estoque		INT				NOT NULL
PRIMARY KEY(isbn)
)
GO
CREATE TABLE editora_edicao_livro (
cod				INT				NOT NULL,
id_edit			INT				NOT NULL,
isbn			CHAR(13)		NOT NULL
PRIMARY KEY(cod, id_edit, isbn)
FOREIGN KEY(cod) REFERENCES livro(cod),
FOREIGN KEY(id_edit) REFERENCES editora(id_edit),
FOREIGN KEY(isbn) REFERENCES edicao(isbn)
)

EXEC sp_help livro
EXEC sp_help autor
EXEC sp_help livro_autor
EXEC sp_help editora
EXEC sp_help edicao
EXEC sp_help editora_edicao_livro

SELECT * FROM livro
SELECT * FROM autor
SELECT * FROM livro_autor
SELECT * FROM editora
SELECT * FROM edicao
SELECT * FROM editora_edicao_livro

DROP TABLE livro
DROP TABLE autor
DROP TABLE livro_autor
DROP TABLE editora_edicao_livro
DROP TABLE edicao
DROP TABLE editora