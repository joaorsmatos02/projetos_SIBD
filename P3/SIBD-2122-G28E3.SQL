-- SIBD     2021/22     3ª etapa
-- grupo 28
-- João Ricardo Silva Matos       nº 56292 Turma 02
-- João Pedro Ramos Vedor         nº 56311 Turma 02
-- João Gonçalo Jorge dos Santos  nº 57103 Turma 01
-- Daniel Caetano Luís            nº 56362 Turma 01
-- ----------------------------------------------------------------------------
DROP TABLE participa;
DROP TABLE jogos;
DROP TABLE atleta;
-- ----------------------------------------------------------------------------
CREATE TABLE atleta (
 numero NUMBER (8),
 nome VARCHAR (80) CONSTRAINT nn_atleta_nome NOT NULL,
 nascimento NUMBER (4) CONSTRAINT nn_atleta_nascimento NOT NULL, -- Ano.
 genero CHAR (1) CONSTRAINT nn_atleta_genero NOT NULL,
 peso NUMBER (3) CONSTRAINT nn_atleta_peso NOT NULL, -- kg.
 pais VARCHAR (80) CONSTRAINT nn_atleta_pais NOT NULL,
--
 CONSTRAINT pk_atleta
 PRIMARY KEY (numero),
--
 CONSTRAINT ck_atleta_numero
 CHECK (numero > 0),
 CONSTRAINT ck_atleta_nascimento
 CHECK (nascimento > 0),
 CONSTRAINT ck_atleta_genero
 CHECK (UPPER(genero) IN ('F', 'M')),
 CONSTRAINT ck_atleta_peso
 CHECK (peso > 0)
);
-- ----------------------------------------------------------------------------
CREATE TABLE jogos (
 edicao NUMBER (2),
 ano NUMBER (4) CONSTRAINT nn_jogos_ano NOT NULL,
 pais VARCHAR (80) CONSTRAINT nn_jogos_pais NOT NULL,
 cidade VARCHAR (80) CONSTRAINT nn_jogos_cidade NOT NULL,
--
 CONSTRAINT pk_jogos
 PRIMARY KEY (edicao),
--
 CONSTRAINT un_jogos_ano -- Chave candidata.
 UNIQUE (ano),
--
 CONSTRAINT ck_jogos_edicao
 CHECK (edicao >= 1),
 CONSTRAINT ck_jogos_ano
 CHECK (ano >= 1896)
);
-- ----------------------------------------------------------------------------
CREATE TABLE participa (
 atleta,
 jogos,
 modalidade VARCHAR (80),
 posicao NUMBER (1), -- Pode ser NULL.
--
 CONSTRAINT pk_participa
 PRIMARY KEY (atleta, jogos, modalidade),
--
 CONSTRAINT fk_participa_atleta
 FOREIGN KEY (atleta)
 REFERENCES atleta (numero),
 CONSTRAINT fk_participa_jogos
 FOREIGN KEY (jogos)
 REFERENCES jogos (edicao),
--
 CONSTRAINT ck_participa_posicao
 CHECK (posicao >= 1)
);
-- --------------------------------------------------------------------------
-- INSERTS
-- --------------------------------------------------------------------------
-- 1
INSERT INTO atleta(numero,nome,nascimento,genero,peso,pais)
VALUES (1, 'Marisa Lopes', 1980, 'F', 60, 'Portugal');

INSERT INTO atleta(numero,nome,nascimento,genero,peso,pais)
VALUES (2, 'Luisa Lopes', 1987, 'F', 62, 'Portugal');

INSERT INTO atleta(numero,nome,nascimento,genero,peso,pais)
VALUES (3, 'Miguel Silva', 1999, 'M', 77, 'Portugal');

INSERT INTO atleta(numero,nome,nascimento,genero,peso,pais)
VALUES (4, 'Laura Lopes', 1995, 'F', 68, 'Portugal');

INSERT INTO atleta(numero,nome,nascimento,genero,peso,pais)
VALUES (5, 'Joao Lopes', 2000, 'M', 52, 'Portugal');

INSERT INTO atleta(numero,nome,nascimento,genero,peso,pais)
VALUES (5000, 'Manelina Lopes', 1979, 'F', 60, 'Portugal');
-- --------------------------------------------------------------------------
INSERT INTO jogos(edicao,ano,pais,cidade)
VALUES (32, 2020, 'Japao', 'Toquio');

INSERT INTO jogos(edicao,ano,pais,cidade)
VALUES (31, 2016, 'Brasil', 'Rio de Janeiro');
-- --------------------------------------------------------------------------
INSERT INTO participa(atleta,jogos,modalidade,posicao)
VALUES (1, 32, 'Atletismo', 2);

INSERT INTO participa(atleta,jogos,modalidade,posicao)
VALUES (2, 31, 'Tenis de mesa', 2);

INSERT INTO participa(atleta,jogos,modalidade,posicao)
VALUES (3, 31, 'Nataçao', 2);

INSERT INTO participa(atleta,jogos,modalidade,posicao)
VALUES (4, 32, 'Canoagem', 4);

INSERT INTO participa(atleta,jogos,modalidade,posicao)
VALUES (5, 32, 'Esgrima', 1);

INSERT INTO participa(atleta,jogos,modalidade,posicao)
VALUES (5000, 32, 'Atletismo', 1);
-- --------------------------------------------------------------------------
-- 2
INSERT INTO jogos(edicao,ano,pais,cidade)
VALUES (29, 2008, 'China', 'Pequim');

INSERT INTO jogos(edicao,ano,pais,cidade)
VALUES (30, 2012, 'Reino Unido', 'Londres');
-- --------------------------------------------------------------------------
INSERT INTO atleta(numero,nome,nascimento,genero,peso,pais)
VALUES (6, 'Manuel Alves', 1980, 'M', 60, 'Brasil');

INSERT INTO atleta(numero,nome,nascimento,genero,peso,pais)
VALUES (7, 'Luisa Almeida', 1987, 'F', 62, 'Portugal');

INSERT INTO atleta(numero,nome,nascimento,genero,peso,pais)
VALUES (8, 'Miguel Silva', 1999, 'M', 77, 'Portugal');

INSERT INTO atleta(numero,nome,nascimento,genero,peso,pais)
VALUES (9, 'Joana Silva', 1995, 'F', 68, 'Brasil');

INSERT INTO atleta(numero,nome,nascimento,genero,peso,pais)
VALUES (10, 'Joao Lopes', 2000, 'M', 52, 'Portugal');
-- --------------------------------------------------------------------------

INSERT INTO participa(atleta,jogos,modalidade,posicao)
VALUES (6, 31, 'Nataçao', 2);

INSERT INTO participa(atleta,jogos,modalidade,posicao)
VALUES (6, 30, 'Nataçao', 2);

INSERT INTO participa(atleta,jogos,modalidade,posicao)
VALUES (6, 32, 'Nataçao', 1);

INSERT INTO participa(atleta,jogos,modalidade,posicao)
VALUES (7, 31, 'Nataçao', 2);

INSERT INTO participa(atleta,jogos,modalidade,posicao)
VALUES (7, 30, 'Nataçao', 1);

INSERT INTO participa(atleta,jogos,modalidade,posicao)
VALUES (7, 29, 'Nataçao', 2);

INSERT INTO participa(atleta,jogos,modalidade,posicao)
VALUES (8, 32, 'Nataçao', 1);

INSERT INTO participa(atleta,jogos,modalidade,posicao)
VALUES (8, 31, 'Nataçao', 4);

INSERT INTO participa(atleta,jogos,modalidade,posicao)
VALUES (8, 30, 'Atletismo', 1);
-- --------------------------------------------------------------------------
-- 3
INSERT INTO atleta(numero,nome,nascimento,genero,peso,pais)
VALUES (11, 'Manuel Alves', 1980, 'M', 40, 'Brasil');

INSERT INTO atleta(numero,nome,nascimento,genero,peso,pais)
VALUES (12, 'Luisa Guerra', 1987, 'F', 80, 'Portugal');

INSERT INTO atleta(numero,nome,nascimento,genero,peso,pais)
VALUES (13, 'Miguel Silva', 1999, 'M', 37, 'Portugal');
-- --------------------------------------------------------------------------
INSERT INTO participa(atleta,jogos,modalidade,posicao)
VALUES (11, 32, 'Atletismo', 1);

INSERT INTO participa(atleta,jogos,modalidade,posicao)
VALUES (11, 31, 'Atletismo', 2);

INSERT INTO participa(atleta,jogos,modalidade,posicao)
VALUES (12, 32, 'Atletismo', 2);

INSERT INTO participa(atleta,jogos,modalidade,posicao)
VALUES (12, 31, 'Atletismo', 2);

INSERT INTO participa(atleta,jogos,modalidade,posicao)
VALUES (13, 31, 'Nataçao', 1);

INSERT INTO participa(atleta,jogos,modalidade,posicao)
VALUES (13, 32, 'Atletismo', 2);
-- --------------------------------------------------------------------------
-- Exercicio 1
--
-- Número, nome, e idade das atletas femininas com apelido Lopes, que ficaram pelo menos
-- uma vez nos três primeiros lugares em alguma participação em jogos olímpicos no Japão.
-- A edição e cidade dos jogos também devem ser mostradas. O resultado deve vir ordenado
-- pela edição dos jogos e pela idade da atleta de forma descendente, e pelo nome e número
-- da atleta de forma ascendente.
-- --------------------------------------------------------------------------
SELECT A.numero, A.nome, (EXTRACT(YEAR FROM CURRENT_DATE) - A.nascimento) AS idade, J.edicao, J.cidade
FROM atleta A, participa P, jogos J
WHERE P.atleta = A.numero
AND P.jogos = J.edicao
AND P.posicao <= 3 
AND P.jogos = J.edicao
AND UPPER(J.pais) = 'JAPAO'
AND A.genero = 'F'
AND UPPER(A.nome) LIKE '% LOPES'
ORDER BY J.edicao DESC, idade DESC, A.nome ASC, A.numero ASC;
-- --------------------------------------------------------------------------
-- Exercicio 2
--
-- Número e nome dos atletas masculinos que nunca participaram em jogos olímpicos realizados
-- no seu país (independentemente da modalidade), e que participaram fora do seu país
-- menos de três jogos na modalidade de natação. Inclua no resultado os atletas que ainda
-- não participaram em quaisquer jogos. O resultado deve vir ordenado pelo nome do atleta
-- de forma ascendente e pelo número do atleta de forma descendente.
-- --------------------------------------------------------------------------
SELECT numero, nome
FROM (
    SELECT A.numero, A.nome
    FROM atleta A
    WHERE A.genero = 'M'
    AND NOT EXISTS (
                    SELECT A1.numero
                    FROM atleta A1, participa P1, jogos J1
                    WHERE P1.atleta = A1.numero
                    AND P1.jogos = J1.edicao
                    AND A1.numero = A.numero
                    AND A1.pais = J1.pais
                   )
    INTERSECT
    SELECT A2.numero, A2.nome
    FROM atleta A2
    WHERE A2.genero = 'M'
    AND 3 > (
                SELECT COUNT (P3.modalidade)
                FROM atleta A3, participa P3
                WHERE P3.atleta = A3.numero
                AND A3.numero = A2.numero
                AND UPPER(P3.modalidade) = 'NATACAO'
            )
)
ORDER BY nome ASC, numero DESC;
-- --------------------------------------------------------------------------
-- Exercicio 3
--
-- Atletas com um peso inferior à média de pesos dos atletas, e que participaram na modalidade
-- de atletismo em todas as edições dos jogos olímpicos realizadas a partir de 2016, inclusivamente.
-- O resultado deve vir ordenado pelo peso do atleta de forma ascendente e
-- pelo número do atleta de forma descendente.
-- --------------------------------------------------------------------------
SELECT A.numero, A.peso
FROM atleta A
WHERE A.peso < (
                SELECT AVG(A1.peso)
                FROM atleta A1
             )
AND (
        SELECT COUNT (P1.modalidade)
        FROM atleta A1, participa P1, jogos J1
        WHERE P1.atleta = A1.numero
        AND P1.jogos = J1.edicao
        AND A1.numero = A.numero
        AND UPPER(P1.modalidade) = 'ATLETISMO'
        AND J1.ano >= 2016
    ) = (
            SELECT COUNT (J2.edicao)
            FROM jogos J2
            WHERE J2.ano >= 2016
        )
ORDER BY A.peso ASC, A.numero DESC;
-- --------------------------------------------------------------------------
-- Exercicio 4
--
-- Nome do(s) país(es) com mais medalhas de ouro em cada edição dos jogos olímpicos, separadamente
-- para atletas femininos e masculinos. O número de medalhas também deve vir
-- no resultado, assim como o país de cada edição dos jogos, e a ordenação deve ser por edição
-- dos jogos de forma descendente, e pelo género e país dos atletas de forma ascendente.
-- --------------------------------------------------------------------------
SELECT genero, pais, medalhas, edicao
FROM (
    SELECT A1.genero AS genero, A1.pais, COUNT(A1.pais) AS medalhas, J1.edicao
    FROM atleta A1, participa P1, jogos J1
    WHERE (A1.numero = P1.atleta)
    AND (J1.edicao = P1.jogos) 
    AND (P1.posicao = 1)
    AND A1.genero = 'F'
    GROUP BY A1.genero, A1.pais, J1.edicao
    HAVING (COUNT(A1.pais) = (SELECT MAX(COUNT(A2.pais))
                              FROM atleta A2, participa P2, jogos J2 
                              WHERE (A2.numero = P2.atleta)
                              AND (J2.edicao = P2.jogos) 
                              AND (A2.genero = 'F')
                              AND (P2.posicao = 1)
                              and (J1.edicao = J2.edicao)
                              GROUP BY A2.pais, J2.edicao))
    UNION
    SELECT A3.genero AS genero, A3.pais, COUNT(A3.pais) AS medalhas, J3.edicao
    FROM atleta A3, participa P3, jogos J3
    WHERE (A3.numero = P3.atleta)
    AND (J3.edicao = P3.jogos) 
    AND (P3.posicao = 1)
    AND A3.genero = 'M'
    GROUP BY A3.genero, A3.pais, J3.edicao
    HAVING (COUNT(A3.pais) = (SELECT MAX(COUNT(A4.pais))
                              FROM atleta A4, participa P4, jogos J4
                              WHERE (A4.numero = P4.atleta)
                              AND (J4.edicao = P4.jogos) 
                              AND (A4.genero = 'M')
                              AND (P4.posicao = 1)
                              and (J3.edicao = J4.edicao)
                              GROUP BY A4.pais, J4.edicao))
)
ORDER BY edicao DESC, genero ASC, pais ASC;