CREATE DATABASE plataforma_projetos
GO
USE plataforma_projetos
GO
---Criação das tabelas
--Projetos
CREATE TABLE projects(
id						INT			     NOT NULL IDENTITY(10001,1),
name_project			VARCHAR(45)      NOT NULL,
description_project		VARCHAR(45)      NULL,
date_project			DATE			 NOT NULL CHECK(date_project > '01/09/2014')
PRIMARY KEY(id)
)
GO
---Usuários
CREATE TABLE users(
id				INT					NOT NULL IDENTITY(1,1),
name_user		VARCHAR(45)			NOT NULL,
username		VARCHAR(45)			NOT NULL,
password_user	VARCHAR(45)			NOT NULL DEFAULT '123mudar',
email			VARCHAR(45)			NOT NULL
--- Unique precisa estar como constraint de nome especificado para usar o alter table
CONSTRAINT username_unique UNIQUE(username), 
PRIMARY KEY (id)
)
GO
---Para realizar as alterações necessárias é preciso retirar o Unique
ALTER TABLE users
DROP CONSTRAINT username_unique;
GO
----- Altera o tamanho do username
ALTER TABLE users
ALTER COLUMN username VARCHAR(10) NOT NULL;
GO
---- Coloca de volta o Unique em username
ALTER TABLE users
ADD CONSTRAINT username_unique UNIQUE(username);
GO
---- Altera o tamanho do password_user
ALTER TABLE users 
ALTER COLUMN password_user VARCHAR(8) NOT NULL;
GO
---- Cria tabela associativa
CREATE TABLE users_has_projects(
users_id		INT			NOT NULL,
projects_id		INT			NOT NULL
PRIMARY KEY(users_id, projects_id)
FOREIGN KEY(users_id) REFERENCES users(id),
FOREIGN KEY(projects_id) REFERENCES projects(id)
)
GO
---INSERÇÃO DE DADOS
---Usuarios
INSERT INTO users VALUES
('Maria',	'Rh_maria',	'123mudar','maria@empresa.com'),
('Paulo','Ti_paulo','123@456','paulo@empresa.com'),
('Ana','Rh_ana', '123mudar','ana@empresa.com'),
('Clara','Ti_clara','123mudar','clara@empresa.com'),
('Aparecido','Rh_apareci','55@!cido','aparecido@empresa.com')
GO
----PROJETOS
INSERT INTO projects VALUES
('Re-folha',		'Refatoração das Folhas', '05/09/2014'),
('Manutenção PCs',	'Manutenção PCs',	'06/09/2014'),
('Auditoria',NULL,'07/09/2014')
GO
----- Tabela associativa de Usuarios e Projetos
INSERT INTO users_has_projects VALUES
(1,10001),
(5,10001),
(3,10003),
(4,10002),
(2,10002)

-----Muda a data do projeto Manutenção de PCs
GO
UPDATE projects SET
date_project = '12/09/2014'
WHERE name_project LIKE '%Manutenção PCs%'
------
---Mudar o username de aparecido, usando o nome como condição para mudança
GO
UPDATE users SET
username = 'Rh_cido'
WHERE name_user = 'Aparecido'
--------------------

---Mudar o password do username Rh_maria(usar o username como condição)
--- e verificar se o password atual ainda é 123mudar
GO
UPDATE users SET
password_user = '888@*'
WHERE username = 'Rh_maria' AND password_user = '123mudar'
-------------

----Remover, da tabela associativa, o user de id 2 pois o mesmo não participa mais do projeto 10002
GO
DELETE FROM users_has_projects
WHERE users_id = 2 AND projects_id = 10002
GO
------------------------------------------
----Tarefa 05
--- Consultar:
-- Fazer uma consulta que retorne id, nome, email, username e caso a senha seja diferente de
---123mudar, mostrar ******** (8 asteriscos), caso contrário, mostrar a própria senha.
SELECT id, 
name_user,
email,
username,
			passwd = CASE( SUBSTRING(password_user,1,8))
			WHEN '123mudar' THEN
						  password_user
			ELSE
				          '********'
			END
from users
GO
/*- Considerando que o projeto 10001 durou 15 dias, fazer uma consulta que mostre o nome do
projeto, descrição, data, data_final do projeto realizado por usuário de e-mail
aparecido@empresa.com*/
SELECT name_project,
description_project,
date_project,
CONVERT(CHAR(10), DATEADD(DAY, 15, date_project), 103) AS data_final -- Soma +15 dias na data de inicio do projeto e converte em formato de data
FROM projects
WHERE id in
(
		SELECT projects_id
		FROM users_has_projects
		WHERE users_id IN
			(
					SELECT id
					from users
					WHERE email='aparecido@empresa.com'
			)
)
GO
--- Fazer uma consulta que retorne o nome e o email dos usuários que estão envolvidos no
-- projeto de nome Auditoria
SELECT name_user,
email
from users
WHERE id IN
				(	
					SELECT users_id FROM
					users_has_projects			
					WHERE projects_id IN
				(
					SELECT id from projects
					WHERE name_project = 'Auditoria'
				)
			
			)
GO
/*
- Considerando que o custo diário do projeto, cujo nome tem o termo Manutenção, é de 79.85
e ele deve finalizar 16/09/2014, consultar, nome, descrição, data, data_final e custo_total do
projeto
*/
SELECT name_project, 
description_project,
date_project, 
CONVERT(DATE,'2014-09-16') AS data_final,
DATEDIFF(DAY,date_project,'2014-09-16') * 79.85 AS custo_total
FROM projects
WHERE name_project LIKE '%Manutenção%'