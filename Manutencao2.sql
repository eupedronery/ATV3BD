CREATE DATABASE Manutencao2
GO
USE Manutencao2

GO
CREATE TABLE Users (
ID					INT				IDENTITY (1, 1)			NOT NULL,
Name				VARCHAR(45)								NOT NULL,
Username			VARCHAR(45)								NOT NULL,
Password			VARCHAR(45)		DEFAULT ('123mudar')	NOT NULL,
Email				VARCHAR(45)								NOT NULL

PRIMARY KEY (ID)
)

GO
CREATE TABLE Projects (
ID					INT				IDENTITY (10001, 1)		NOT NULL,
Name				VARCHAR(45)								NOT NULL,
Description			VARCHAR(45)								NOT NULL,
Data				DATE									NOT NULL

PRIMARY KEY (ID)

)

GO
CREATE TABLE Users_Has_Projects (
Users_ID			INT				NOT NULL,
Projects_ID			INT				NOT NULL

PRIMARY KEY (Users_ID, Projects_ID)
FOREIGN KEY (Users_ID) REFERENCES Users (ID),
FOREIGN KEY (Projects_ID) REFERENCES Projects (ID)
)

--A COLUNA DATE DA TABELA PROJECTS DEVE VERIFICAR SE A DATA É POSTERIOR QUE 01/09/2014.
--CASO CONTRÁRIO, O REGISTRO NÃO DEVE SER INSERIDO

GO
ALTER TABLE Projects
ADD		CHECK(Data > '01/09/2014')

GO
ALTER TABLE Users
ALTER COLUMN Username			VARCHAR(10)		NOT NULL

GO
ALTER TABLE Users
ADD CONSTRAINT  AK_Username		UNIQUE(Username)


ALTER TABLE Users
ALTER COLUMN Password			VARCHAR(8)		NOT NULL

GO
DBCC CHECKIDENT('Users', RESEED, 1)

GO
INSERT INTO Users (Name, Username, Email)
VALUES
('Maria','Rh_Maria', 'maria@empresa.com'),
('Paulo', 'Ti_paulo', 'paulo@empresa.com'),
('Ana', 'Rh_Ana', 'ana@empresa.com'),
('Clara', 'Ti_clara', 'clara@empresa.com'),
('Aparecido', 'Rh_apareci', 'aparecido@empresa.com')

GO
UPDATE Users
SET Password = '123@456'
WHERE ID = 2

GO
UPDATE Users
SET Password = '55@!cido'
WHERE ID = 5

ALTER TABLE Projects
ALTER COLUMN Description		VARCHAR(45)			NULL

GO
INSERT INTO Projects (Name, Description, Data)
VALUES
('Re-folha', 'Refatoração das Folhas', '05/09/2014'),
('Manutenção PC´s', 'Manutenção PC´s', '06/09/2014'),
('Auditoria', NULL, '07/09/2014')


insert into projects (name, description, data) values
('Re-folha', 'Refatoração das Folhas', '05/09/2014'),
('Manutenção PC´s', 'Manutenção PC´s', '06/09/2014'),
('Auditoria', NULL, '07/09/2014')

GO
INSERT INTO Users_Has_Projects(Users_ID, Projects_ID)
VALUES 
(1, 10001),
(5, 10001),
(3, 10003),
(4, 10002),
(2, 10002)

GO
UPDATE Projects
SET Data = '12/09/2014'
WHERE Name LIKE 'Manutenção%'

GO
UPDATE Users
SET Username = 'Rh_cido'
WHERE Name = 'aparecido'

UPDATE Users
SET Password = '888@*'
WHERE Username = 'Rh_maria' AND Password = '123mudar'

DELETE Users_Has_Projects
WHERE Users_ID = 2
SELECT * FROM Users_Has_Projects

SELECT ID, Name, Email, Username,
	CASE WHEN Password = '123mudar'
		THEN Password
	ELSE
		'********'
END AS Password
FROM Users

SELECT Name,Description,
CONVERT(CHAR(10),Data, 103) AS Data,
CONVERT(CHAR(10), DATEADD(DAY, 15, Data), 103) AS Data_Final
FROM Projects

WHERE ID IN
(SELECT Projects_ID FROM Users_Has_Projects
WHERE Users_ID IN

(SELECT ID
FROM Users
WHERE Email = 'aparecido@empresa.com')
)

FROM Users

WHERE ID IN
(SELECT Users_ID FROM Users_Has_Projects
WHERE Projects_ID IN

(SELECT ID FROM Projects
WHERE Name = 'Auditoria')
)

SELECT Name, Description, 
CONVERT(CHAR(10),Data, 103) AS Data_Inicial,
CONVERT(CHAR(10),'16/09/2014', 103) AS Data_Final, 79.85 AS Custo_Diario,
DATEDIFF(DAY, Data, '16/09/2014') AS Dias_Manutençâo,
DATEDIFF(DAY, Data, '2014-09-16') * 79.85 AS Custo_Total_Projeto
FROM Projects

WHERE Name LIKE 'Manutenção%'