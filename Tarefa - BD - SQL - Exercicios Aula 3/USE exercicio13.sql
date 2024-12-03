USE exercicio13

select * from carro
select * from empresa
select * from viagem

--Exerc�cios
--1)Apresentar marca e modelo de carro e a soma total da dist�ncia percorrida pelos carros,
--em viagens, de uma dada empresa, ordenado pela dist�ncia percorrida
SELECT c.marca, c.modelo, SUM(v.distanciaPercorrida) AS  DistanciaTotal
FROM carro c
INNER JOIN viagem v
ON c.id = v.idCarro
--INNER JOIN empresa e
--ON c.id = e.id
GROUP BY c.marca, c.modelo
ORDER BY DistanciaTotal DESC



--2)Apresentar nome das empresas cuja soma total da dist�ncia percorrida pelos carros,
--em viagens, � superior a 50000 km
SELECT e.nome, SUM(v.distanciaPercorrida) AS DistanciaTotal
FROM empresa e
INNER JOIN carro c
ON e.id = c.idEmpresa
INNER JOIN viagem v
ON c.id = v.idCarro
GROUP BY e.nome
HAVING SUM(v.distanciaPercorrida) > 50000;



--3)Apresentar nome das empresas cuja soma total da dist�ncia percorrida pelos carros
--e a media das dist�ncias percorridas por seus carros em viagens.
--A m�dia deve ser exibida em uma coluna chamada mediaDist e com 2 casas decimais apenas.
--Deve-se ordenar a sa�da pela m�dia descrescente
SELECT e.nome, SUM(v.distanciaPercorrida) AS  DistanciaTotal,
		CAST(AVG(v.distanciaPercorrida) AS DECIMAL(10, 2)) AS MediaDist
FROM empresa e
INNER JOIN carro c
ON e.id = c.idEmpresa
INNER JOIN viagem v
ON c.id = v.idCarro
GROUP BY e.nome
ORDER BY MediaDist DESC



--4)Apresentar nome das empresas cujos carro percorreram a maior dist�ncia dentre as cadastradas

/*
SELECT e.nome, v.distanciaPercorrida
FROM empresa e
INNER JOIN carro c
ON e.id = c.idEmpresa
INNER JOIN viagem v
ON c.id = v.idCarro
WHERE v.distanciaPercorrida IN (
				SELECT MAX(V.distanciaPercorrida)
				FROM viagem)
GROUP BY e.nome
*/


SELECT
	empresa.nome, viagem.distanciaPercorrida
FROM empresa
INNER JOIN carro ON carro.idEmpresa = empresa.id
INNER JOIN viagem ON viagem.idCarro = carro.id
WHERE viagem.distanciaPercorrida IN (
	SELECT MAX(distanciaPercorrida)
	FROM viagem
)



--5)Apresentar nome das empresas e a quantidade de carros cadastrados para cada empresa
--Desde que a empresa tenha 3 ou mais carros
--A sa�da deve ser ordenada pela quantidade de carros, descrescente
SELECT e.nome, COUNT(c.id) AS QuantCarros
FROM empresa e
INNER JOIN carro c
ON e.id = c.idEmpresa
GROUP BY e.nome
HAVING COUNT(c.id) >= 3
ORDER BY QuantCarros DESC


SELECT e.nome, COUNT(c.id) AS QuantCarros
FROM empresa e LEFT OUTER JOIN carro c
ON e.id = c.idEmpresa
GROUP BY e.nome
HAVING COUNT(c.id) >= 3
ORDER BY QuantCarros DESC



--6)Consultar Nomes das empresas que n�o tem carros cadastrados
SELECT e.nome
FROM empresa e LEFT OUTER JOIN carro c
ON e.id = c.idEmpresa
WHERE c.id IS NULL



--7)Consultar Marca e modelos dos carros que n�o fizeram viagens

--8)Consultar quantas viagens foram feitas por cada carro (marca e modelo) de cada empresa
--em ordem ascendente de nome de empresa e descendente de quantidade

--9) Consultar o nome da empresa, a marca e o modelo do carro, a dist�ncia percorrida
--e o valor total ganho por viagem, sabendo que para dist�ncias inferiores a 1000 km, o valor � R$10,00
--por km e para viagens superiores a 1000 km, o valor � R$15,00 por km.

--10) Apresentar o nome da empresa e a m�dia de dist�ncia percorrida por seus carros. A sa�da da m�dia deve ter at� 2 casas decimais e deve ser ordenada pela m�dia da dist�ncia percorrida 

--11) Apresentar marca e modelo do carro, al�m do nome da empresa e a data no formato (DD/MM/AAAA) do carro que fez a �ltima viagem dentre os cadastrados

--12) Considerando que hoje � 01/01/2023, apresentar a marca e o modelo do carro, al�m do nome da empresa e a quantidade de dias da viagem, dos carros que tiveram viagens nos �ltimos 3 meses. Ordenar (todos ascendentes) por quantidade de dias, marca, modelo e nome da empresa.