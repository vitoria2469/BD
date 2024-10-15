CREATE DATABASE maternidade;
GO
USE maternidade;
GO
CREATE TABLE mae (
id_mae				INT				NOT NULL,
nome				VARCHAR(60)		NOT NULL,
logradouro_end		VARCHAR(100)	NOT NULL,
numero_end			INT				NOT NULL,
cep_end				CHAR(8)			NOT NULL,
complemento_end		VARCHAR(200)	NOT NULL,
telefone			CHAR(10)		NOT NULL,
data_nasc			DATE			NOT NULL
PRIMARY KEY(id_mae)
)
GO
CREATE TABLE bebe(
id_bebe			INT				NOT NULL,
nome			VARCHAR(60)		NOT NULL,
data_nasc		DATE			NOT NULL,
altura			DECIMAL(7,2)	NOT NULL,
peso			DECIMAL(4,3)	NOT NULL,
mae_id			INT				NOT NULL
PRIMARY KEY(id_bebe)
FOREIGN KEY(mae_id) REFERENCES mae(id_mae)
)
GO
CREATE TABLE medico(
numero_crm				INT				NOT NULL,
uf_crm					CHAR(2)			NOT NULL,
nome					VARCHAR(60)		NOT NULL,
telefone_celular		CHAR(2)			NOT NULL,
especialidade			VARCHAR(30)		NOT NULL
PRIMARY KEY(numero_crm, uf_crm)
)
GO
CREATE TABLE bebe_medico (
bebe_id					INT			NOT NULL,
medico_num_crm			INT			NOT NULL,
medico_uf_crm			CHAR(2)		NOT NULL
PRIMARY KEY(bebe_id,medico_num_crm,medico_uf_crm)
FOREIGN KEY(bebe_id) REFERENCES bebe(id_bebe),
FOREIGN KEY(medico_num_crm) REFERENCES medico(numero_crm),
FOREIGN KEY(medico_uf_crm) REFERENCES medico(uf_crm)
)