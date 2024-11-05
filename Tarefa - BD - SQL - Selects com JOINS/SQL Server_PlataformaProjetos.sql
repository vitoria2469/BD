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
GO
-----Muda a data do projeto Manutenção de PCs
UPDATE projects SET
date_project = '12/09/2014'
WHERE name_project LIKE '%Manutenção PCs%'
------
GO
---Mudar o username de aparecido, usando o nome como condição para mudança
UPDATE users SET
username = 'Rh_cido'
WHERE name_user = 'Aparecido'
--------------------
GO
---Mudar o password do username Rh_maria(usar o username como condição)
--- e verificar se o password atual ainda é 123mudar
UPDATE users SET
password_user = '888@*'
WHERE username = 'Rh_maria' AND password_user = '123mudar'
-------------
GO
----Remover, da tabela associativa, o user de id 2 pois o mesmo não participa mais do projeto 10002
DELETE FROM users_has_projects
WHERE users_id = 2 AND projects_id = 10002
GO
---------------------
---Tarefa 06
--Fazer:
--a) Adicionar User
--(6; Joao; Ti_joao; 123mudar; joao@empresa.com)
INSERT INTO users VALUES
('Joao','Ti_joao', '123mudar', 'joao@empresa.com')
-- b) Adicionar Project
--(10004; Atualização de Sistemas; Modificação de Sistemas Operacionais nos PC's; 12/09/2014)
GO
INSERT INTO projects VALUES
('Atualização de Sistemas', 'Modificação de Sistemas Operacionais nos PCs', '12/09/2014')
-----------------------
--c) Consultar:
--1) Id, Name e Email de Users, Id, Name, Description e Data de Projects, dos usuários que
--participaram do projeto Name Re-folha
SELECT us.id, us.name_user, us.email,
p.id, p.name_project, p.description_project, p.date_project
FROM users_has_projects as usp
INNER JOIN users us 
ON us.id = usp.users_id
INNER JOIN projects p
ON p.id = usp.projects_id
WHERE p.name_project = 'Re-folha'
ORDER BY us.name_user

--2) Name dos Projects que não tem Users
SELECT p.name_project
FROM projects p LEFT OUTER JOIN users_has_projects usp --- Olhando o conteudo de projects para users_has_projects
ON usp.projects_id = p.id
WHERE usp.projects_id IS NULL

---3) Name dos Users que não tem Projects
SELECT us.name_user
FROM users us LEFT OUTER JOIN users_has_projects usp
ON usp.users_id = us.id
WHERE usp.users_id IS NULL