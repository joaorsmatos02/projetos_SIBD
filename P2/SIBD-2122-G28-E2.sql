-- SIBD     2021/22     2ª etapa
-- grupo 28
-- João Ricardo Silva Matos       nº 56292 Turma 02
-- João Pedro Ramos Vedor         nº 56311 Turma 02
-- João Gonçalo Jorge dos Santos  nº 57103 Turma 01
-- Daniel Caetano Luís            nº 56362 Turma 01

-- -------------------------------------------------------------------
-- DROP TABLES
-- -------------------------------------------------------------------

DROP TABLE disputada;
DROP TABLE tem_comitiva;
DROP TABLE compete;
DROP TABLE jogos_olimpicos;
DROP TABLE categoria;
DROP TABLE modalidade;
DROP TABLE pais;
DROP TABLE atleta;

-- -------------------------------------------------------------------
ALTER SESSION SET NLS_DATE_FORMAT = 'DD.MM.YYYY';
-- -------------------------------------------------------------------

-- -------------------------------------------------------------------
-- CREATE TABLES
-- -------------------------------------------------------------------
CREATE TABLE atleta (
    ni             NUMBER(10),
    nome           VARCHAR(40) CONSTRAINT nn_atleta_nome   NOT NULL,
    ano_nascimento NUMBER(4)   CONSTRAINT nn_atleta_ano    NOT NULL,
    genero         VARCHAR(10) CONSTRAINT nn_atleta_genero NOT NULL,
    altura         NUMBER(3,2) CONSTRAINT nn_atleta_altura NOT NULL,
    peso           NUMBER(4,1) CONSTRAINT nn_atleta_peso   NOT NULL,
    --
    CONSTRAINT pk_atleta
        PRIMARY KEY (ni),
    -- 
    CONSTRAINT ck_atleta_ano
        CHECK (ano_nascimento > 1800),
    --
    CONSTRAINT ck_atleta_altura
        CHECK (altura > 0),
    --
    CONSTRAINT ck_atleta_peso
        CHECK (peso > 0),
    --
    CONSTRAINT ck_atleta_genero
        CHECK (genero = 'Masculino' OR genero = 'Feminino')
);

-- -------------------------------------------------------------------

CREATE TABLE pais (
    id                NUMBER(3),
    codigo            VARCHAR(3)  CONSTRAINT nn_pais_codigo     NOT NULL,
    nome              VARCHAR(20) CONSTRAINT nn_pais_nome       NOT NULL,
    numero_habitantes NUMBER(15)  CONSTRAINT nn_pais_habitantes NOT NULL,
    pib               NUMBER(20)  CONSTRAINT nn_pais_PIB        NOT NULL,
    --
    CONSTRAINT pk_pais
        PRIMARY KEY (id),
    --
    CONSTRAINT un_pais_codigo
        UNIQUE (codigo),
    --
    CONSTRAINT ck_pais_habitantes
        CHECK (numero_habitantes > 0),
        --
    CONSTRAINT ck_pais_pib
        CHECK (pib > 0)
);

-- -------------------------------------------------------------------

CREATE TABLE modalidade (
    nome VARCHAR(20),
    --
    CONSTRAINT pk_modalidade
        PRIMARY KEY (nome)
);

-- -------------------------------------------------------------------

CREATE TABLE categoria (
    nome           VARCHAR(20),
    nome_categoria VARCHAR(40),
    genero         VARCHAR(10) CONSTRAINT nn_categoria_nome NOT NULL,
    --
    CONSTRAINT pk_categoria
        PRIMARY KEY (nome, nome_categoria),
    --
    FOREIGN KEY (nome) 
        REFERENCES modalidade(nome) ON DELETE CASCADE
);

-- -------------------------------------------------------------------

CREATE TABLE jogos_olimpicos (
    numero_edicao NUMBER(3),
    ano           NUMBER(4) CONSTRAINT nn_jogos_olimpicos_ano     NOT NULL,
    data_ab       DATE      CONSTRAINT nn_jogos_olimpicos_data_ab NOT NULL,
    data_en       DATE      CONSTRAINT nn_jogos_olimpicos_data_en NOT NULL,
    --
    CONSTRAINT pk_jogos_olimpicos
        PRIMARY KEY (numero_edicao),
    --
    CONSTRAINT ck_jogos_olimpicos_data_ab
        CHECK (data_ab < data_en) 
);

-- -------------------------------------------------------------------

CREATE TABLE compete (
    ni      NUMBER(10),
    posicao NUMBER(3) CONSTRAINT nn_compete_posicao NOT NULL,
    --
    CONSTRAINT pk_compete
        PRIMARY KEY (ni),
    --
    FOREIGN KEY (ni) 
        REFERENCES atleta(ni) ON DELETE CASCADE
);

-- -------------------------------------------------------------------

CREATE TABLE tem_comitiva (
    ni             NUMBER(10),
    id             NUMBER(3),
    numero_edicao  NUMBER(3),
    data_inscricao DATE CONSTRAINT nn_tem_comitiva_data NOT NULL,
    --
    CONSTRAINT pk_tem_comitiva
        PRIMARY KEY (ni,id,numero_edicao),
    --
    FOREIGN KEY (ni)
        REFERENCES compete(ni),
    --
    FOREIGN KEY (id) 
        REFERENCES pais(id),
    --
    FOREIGN KEY (numero_edicao) 
        REFERENCES jogos_olimpicos(numero_edicao)
);

-- -------------------------------------------------------------------

CREATE TABLE disputada (
    ni              NUMBER(10),
    numero_edicao   NUMBER(3),
    nome_categoria  VARCHAR(40),
    nome_modalidade VARCHAR(40),
    --
    CONSTRAINT pk_disputada
        PRIMARY KEY (ni, nome_categoria, nome_modalidade, numero_edicao),
    --
    FOREIGN KEY (ni) 
        REFERENCES compete(ni),
    --
    FOREIGN KEY (nome_categoria, nome_modalidade) 
        REFERENCES categoria(nome_categoria, nome),
    --
    FOREIGN KEY (numero_edicao) 
        REFERENCES jogos_olimpicos(numero_edicao)
);

-- -------------------------------------------------------------------
-- INSERTS
-- -------------------------------------------------------------------

INSERT INTO atleta(ni, nome, ano_nascimento, genero, altura, peso) 
    VALUES (1, 'Gong Lijiao', 2000, 'Masculino', 1.70, 67);

INSERT INTO atleta(ni, nome, ano_nascimento, genero, altura, peso) 
    VALUES (5675, 'Daniel', 1987, 'Masculino', 1.82, 74);

INSERT INTO atleta(ni, nome, ano_nascimento, genero, altura, peso) 
    VALUES (72910, 'Kassa', 1994, 'Feminino', 1.61, 56);

-- -------------------------------------------------------------------

INSERT INTO pais(id, codigo, nome, numero_habitantes, pib)
    VALUES (54, 'CHN', 'China', 1409389043, 120940007600);

INSERT INTO pais(id, codigo, nome, numero_habitantes, pib)
    VALUES (1, 'POR', 'Portugal', 10583082, 2310484032);

INSERT INTO pais(id, codigo, nome, numero_habitantes, pib)
    VALUES (64, 'ETH', 'Ethiopia', 648204802, 759205820);

-- -------------------------------------------------------------------

INSERT INTO modalidade(nome)
    VALUES ('Skateboarding');

INSERT INTO modalidade(nome)
    VALUES ('Esgrima');

INSERT INTO modalidade(nome)
    VALUES ('Halterofilismo');

-- -------------------------------------------------------------------

INSERT INTO categoria(nome, nome_categoria, genero)
    VALUES ('Skateboarding', 'Street', 'Masculino');

INSERT INTO categoria(nome, nome_categoria, genero)
    VALUES ('Esgrima', 'Florete', 'Feminino');

INSERT INTO categoria(nome, nome_categoria, genero)
    VALUES ('Halterofilismo', 'Peso leve', 'Masculino');

-- -------------------------------------------------------------------

INSERT INTO jogos_olimpicos(numero_edicao, ano, data_ab, data_en)
    VALUES (32, 2020, '23.07.2021', '08.08.2021');

INSERT INTO jogos_olimpicos(numero_edicao, ano, data_ab, data_en)
    VALUES (31, 2016, '05.08.2016', '21.08.2016');

INSERT INTO jogos_olimpicos(numero_edicao, ano, data_ab, data_en)
    VALUES (1, 1896, '06.04.1896', '15.04.1896');

-- -------------------------------------------------------------------

INSERT INTO compete(ni, posicao)
    VALUES (5675, 2);

INSERT INTO compete(ni, posicao)
    VALUES (1, 1);

INSERT INTO compete(ni, posicao)
    VALUES (72910, 5);

-- -------------------------------------------------------------------

INSERT INTO tem_comitiva (ni, id, numero_edicao, data_inscricao)
    VALUES (5675, 1, 32, '21.02.2020');

INSERT INTO tem_comitiva (ni, id, numero_edicao, data_inscricao)
    VALUES (1, 54, 31, '14.07.2013');

INSERT INTO tem_comitiva (ni, id, numero_edicao, data_inscricao)
    VALUES (72910, 64, 1, '02.11.1895');

-- -------------------------------------------------------------------

INSERT INTO disputada (ni, numero_edicao, nome_categoria, nome_modalidade)
    VALUES (72910, 1, 'Florete', 'Esgrima');

INSERT INTO disputada (ni, numero_edicao, nome_categoria, nome_modalidade)
    VALUES (1, 31, 'Peso leve', 'Halterofilismo');

INSERT INTO disputada (ni, numero_edicao, nome_categoria, nome_modalidade)
    VALUES (5675, 32, 'Street', 'Skateboarding');

-- -------------------------------------------------------------------
-- RESTRIÇÕES DE INTEGRIDADE NÃO SUPORTADAS
-- -------------------------------------------------------------------

-- A data de inscrição de uma comitiva numa edição dos jogos tem de ser anterior à data de
-- abertura desses jogos.

-- A categoria na qual um atleta compete tem de ter o mesmo género do atleta

-- A posição de um atleta que compete numa categoria de uma edição dos jogos não pode ser
-- superior ao número de atletas que compete nessa categoria desses jogos.

-- A categoria na qual compete um atleta integrado na comitiva de uma edição dos jogos tem
-- de ser uma das categorias disputadas nesses jogos.

-- Continente AND País AND Cidade COVER Região Geográfica

-- O ano de nascimento de um atleta que compete numa edição dos jogos tem de ser anterior
-- ao ano desses jogos

-- Numa edição dos jogos, um atleta só pode competir integrado na comitiva de um país