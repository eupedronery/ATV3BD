CREATE DATABASE Loucadoura2
GO
USE Locadoura2

GO
CREATE TABLE Filme (
ID					INTEGER				NOT NULL,
Titulo				VARCHAR				NOT NULL,
Ano					INTEGER				NULL
PRIMARY KEY (ID)
)

GO
CREATE TABLE Estrela (
ID					INTEGER				NOT NULL,
Nome				VARCHAR(50)			NOT NULL

PRIMARY KEY (ID)
)

GO
CREATE TABLE Cliente (
Num_Cadastro		INTEGER				NOT NULL,
Nome				VARCHAR(70)			NOT NULL,
Logradouro			VARCHAR(150)		NOT NULL,
Num					INTEGER				NOT NULL,
CEP					CHAR(8)				NULL
PRIMARY KEY (Num_Cadastro)
)

GO
CREATE TABLE Filme_Estrela (
Filme_ID			INTEGER				NOT NULL,
Estrela_ID			INTEGER				NOT NULL

FOREIGN KEY (Filme_ID) REFERENCES Filme (ID),
FOREIGN KEY (Estrela_ID) REFERENCES Estrela (ID)
)

GO
CREATE TABLE DVD (
Num					INTEGER				NOT NULL,
Data_Fabricacao		DATE				NOT NULL,
Filme_ID			INTEGER				NOT NULL
PRIMARY KEY (Num),
FOREIGN KEY (Filme_ID) REFERENCES Filme (ID)

)

GO
CREATE TABLE Locacao (
DVD_Num					INTEGER				NOT NULL,
Cliente_Num_Cadastro	INTEGER				NOT NULL,
Data_Locacao			DATE				NOT NULL	DEFAULT (GETDATE()),
Data_Devolucao			DATE				NOT NULL,
Valor					DECIMAL (7, 2)		NOT NULL

PRIMARY KEY (Data_Locacao, DVD_Num, Cliente_Num_Cadastro)
FOREIGN KEY (DVD_Num) REFERENCES DVD (Num),
FOREIGN KEY (Cliente_Num_Cadastro) REFERENCES Cliente (Num_Cadastro)
)




GO
ALTER TABLE Filme
ADD CHECK (Ano <= 2021)


GO
ALTER TABLE DVD
ADD CHECK (Data_Fabricacao < GETDATE())


GO
ALTER TABLE Cliente
ADD CHECK (Num > 0)


GO
ALTER TABLE Cliente
ADD CHECK (LEN(CEP) = 8)

GO
ALTER TABLE Locacao
ADD CONSTRAINT Verifica_Data CHECK (Data_Devolucao > Data_Locacao)

GO
ALTER TABLE Locacao
ADD CHECK (Valor > 0)

GO
ALTER TABLE Estrela
ADD Nome_Real		VARCHAR(50)			NULL

GO
ALTER TABLE Filme
ALTER COLUMN Titulo			VARCHAR(80)	NOT NULL

GO
INSERT INTO Filme (ID, Titulo, Ano)
VALUES
(1001, 'Whiplash', 2015),
(1002, 'Birdman', 2015),
(1003, 'Interestelar', 2014),
(1004, 'A Culpa é das estrelas', 2014),
(1005, 'Alexandre e o Dia Terrível, Horrível, Espantoso e Horroroso', 2014),
(1006, 'Sing', 2016)

GO
INSERT INTO Estrela (ID, Nome, Nome_Real)
VALUES
(9901, 'Michael Keaton', 'Michael John Douglas'),
(9902, 'Emma Stone', 'Emily Jean Stone'),
(9903, 'Miles Teller', NULL),
(9904, 'Steve Carell', 'Steven John Carell'),
(9905, 'Jennifer Garner', 'Jennifer Anne Garner')

GO
INSERT INTO Filme_Estrela (Filme_ID, Estrela_ID)
VALUES
(1002, 9901),
(1002, 9902),
(1001, 9903),
(1005, 9904),
(1005, 9905)

GO
INSERT INTO DVD (Num, Data_Fabricacao, Filme_ID)
VALUES
(10001, '2020-12-02', 1001),
(10002,	'2019-10-18', 1002),
(10003,	'2020-04-03', 1003),
(10004,	'2020-12-02', 1001),
(10005, '2019-10-18', 1004),
(10006, '2020-04-03', 1002),
(10007,	'2020-12-02', 1005),
(10008, '2019-10-18', 1002),
(10009, '2020-04-03', 1003)

GO
INSERT INTO Cliente (Num_Cadastro, Nome, Logradouro, Num, cep)
VALUES
(5501, 'Matilde Luz', 'Rua Síria', 150,'03086050'),
(5502, 'Carlos Carreiro', 'Rua Bartolomeu Aires', 1250,'04419110'),
(5503, 'Daniel Ramalho', 'Rua Itajutiba', 169,NULL),
(5504, 'Roberta Bento',	'Rua Jayme Von Rosenburg', 36,NULL),
(5505, 'Rosa Cerqueira', 'Rua Arnaldo Simões Pinto', 235,'02917110')

GO
INSERT INTO Locacao (DVD_Num, Cliente_Num_Cadastro, Data_Locacao, Data_Devolucao, Valor)
VALUES
(10001, 5502, '2021-02-18',	'2021-02-21', 3.50),
(10009, 5502, '2021-02-18', '2021-02-21', 3.50),
(10002, 5503, '2021-02-18', '2021-02-19', 3.50),
(10002, 5505, '2021-02-20', '2021-02-23', 3.00),
(10004, 5505, '2021-02-20',	'2021-02-23', 3.00),
(10005, 5505, '2021-02-20', '2021-02-23', 3.00),
(10001, 5501, '2021-02-24', '2021-02-26', 3.50),
(10008, 5501, '2021-02-24', '2021-02-26', 3.50)


GO
UPDATE Cliente
SET CEP = '08411150'
WHERE Num_Cadastro = 5503

UPDATE Cliente
SET CEP = '02918190'
WHERE Num_Cadastro = 5504
SELECT * FROM Cliente

GO
UPDATE Locacao
SET Valor = 3.25
WHERE Cliente_Num_Cadastro = 5502

GO
UPDATE Locacao
SET Valor = 3.25
WHERE Cliente_Num_Cadastro = 5502

GO
UPDATE DVD
SET Data_Fabricacao = '2019-07-14'
WHERE Num = 10005

GO
UPDATE Estrela
SET Nome_Real = 'Miles Alexander Teller'
WHERE ID = 9903

GO
DELETE Filme
WHERE ID = 1006

SELECT ID, Ano, CASE WHEN LEN (Titulo) > 10
THEN RTRIM (SUBSTRING(Titulo, 1, 10)) + '...'
ELSE
   Titulo
END AS Titulo
FROM Filme
WHERE ID IN
(SELECT Filme_ID FROM DVD WHERE Data_Fabricacao > '2020-01-01')


SELECT DISTINCT Num, Data_Fabricacao,
DATEDIFF(MONTH, Data_Fabricacao, GETDATE()) AS Qtd_Meses_Desde_Fabricacao
FROM DVD

WHERE Filme_ID IN
(SELECT ID FROM Filme WHERE Titulo = 'Interestelar')

SELECT DISTINCT DVD_Num,
CONVERT(CHAR(10),Data_Locacao, 103),
CONVERT(CHAR(10),Data_Devolucao,103), Valor,
DATEDIFF (DAY, Data_Locacao, Data_Devolucao) AS Total_Dias_Alugado
FROM Locacao

WHERE Cliente_Num_Cadastro IN
(SELECT Num_Cadastro FROM Cliente WHERE Nome LIKE 'Rosa%')

SELECT * FROM Cliente

SELECT Nome, Logradouro + ', N°'+ CAST(Num AS VARCHAR(5)), + 'CEP: ' + 
SUBSTRING (CEP, 1, 5) + ' - ' + SUBSTRING(CEP,6, 3) AS CEP
FROM Cliente

WHERE Num_Cadastro IN
(SELECT Cliente_Num_Cadastro FROM Locacao WHERE DVD_Num IN
(SELECT Num FROM DVD WHERE Num = '10002'))