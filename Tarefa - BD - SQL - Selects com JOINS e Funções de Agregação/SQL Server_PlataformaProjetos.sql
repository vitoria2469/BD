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
UPDATE projects SET
date_project = '12/09/2014'
WHERE name_project LIKE '%Manutenção PCs%'
------
---Mudar o username de aparecido, usando o nome como condição para mudança
UPDATE users SET
username = 'Rh_cido'
WHERE name_user = 'Aparecido'
--------------------

---Mudar o password do username Rh_maria(usar o username como condição)
--- e verificar se o password atual ainda é 123mudar
UPDATE users SET
password_user = '888@*'
WHERE username = 'Rh_maria' AND password_user = '123mudar'
-------------

----Remover, da tabela associativa, o user de id 2 pois o mesmo não participa mais do projeto 10002
DELETE FROM users_has_projects
WHERE users_id = 2 AND projects_id = 10002

---------------------
GO
---Tarefa 08
USE plataforma_projetos
/* Fazer:
Considerando já inseridas as linhas:
a) User (6; Joao; Ti_joao; 123mudar; joao@empresa.com)
b) Project (10004; Atualização de Sistemas; Modificação de Sistemas Operacionais nos PC's; 
12/09/2014)
c) Consultar:
• Quantos projetos não tem usuários associados a ele. A coluna deve chamar 
qty_projects_no_users
• Id do projeto, nome do projeto, qty_users_project (quantidade de usuários por 
projeto) em ordem alfabética crescente pelo nome do projeto 
*/
--- a) E b)
--- Verifica se ja foi inserido o user e o projeto
GO
SELECT * FROM users WHERE id = 6 AND name_user = 'Joao'
SELECT * FROM projects WHERE id = 10004 AND name_project = 'Atualização de Sistemas'
---- Caso não tenha sido inserido, descomentar as linhas abaixo e executar a inserção
/*INSERT INTO users VALUES
(6, 'Joao', 'Ti_joao', '123mudar', 'joao@empresa.com')

INSERT INTO projects VALUES
(10004, 'Atualização de Sistemas', 'Modificação de Sistemas Operacionais nos PCs'
,'12/09/2014')*/

---- c) 
-- • Quantos projetos não tem usuários associados a ele. A coluna deve chamar qty_projects_no_users

SELECT COUNT(proj.id) AS qty_projects_no_users
FROM projects proj LEFT OUTER JOIN users_has_projects usp
ON proj.id = usp.projects_id
WHERE usp.projects_id IS NULL

---- • Id do projeto, nome do projeto, qty_users_project (quantidade de usuários por projeto) em ordem alfabética crescente pelo nome do projeto
SELECT proj.id, proj.name_project,
COUNT(proj.id) AS qty_projects_users
FROM projects proj
INNER JOIN users_has_projects usp
ON proj.id = usp.projects_id
INNER JOIN users us
ON us.id = usp.users_id
GROUP BY proj.id, proj.name_project
ORDER BY proj.name_project ASC
--- Project de id 10004 não é exibido já que não se encontra na tabela users_has_projects

