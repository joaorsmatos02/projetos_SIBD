-- SIBD     2021/22     4ª etapa
-- grupo 28
-- João Ricardo Silva Matos       nº 56292 Turma 02
-- João Pedro Ramos Vedor         nº 56311 Turma 02
-- João Gonçalo Jorge dos Santos  nº 57103 Turma 01
-- Daniel Caetano Luís            nº 56362 Turma 01


DROP TABLE participa;
DROP TABLE jogos;
DROP TABLE atleta;

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

-- ----------------------------------------------------------------------------
DROP SEQUENCE seq;

CREATE SEQUENCE seq
  MINVALUE 1
  START WITH 1
  INCREMENT BY 1
  NOCACHE;
-- ----------------------------------------------------------------------------
VARIABLE atleta1 NUMBER;
VARIABLE atleta2 NUMBER;
VARIABLE atleta3 NUMBER;

-- registo correto
BEGIN :atleta1 := pkg_jogos.regista_atleta('Joao', 2010, 'M', 70, 'Portugal'); END; 
/
--verificar numero
PRINT atleta1;

-- erro: peso invalido
BEGIN :atleta3 := pkg_jogos.regista_atleta('Daniel', 2009, 'M', -70, 'Portugal'); END;
/
-- ----------------------------------------------------------------------------
INSERT INTO jogos (edicao, ano, pais, cidade)
  VALUES (1, 2000, 'Portugal', 'Lisboa');

-- registo correto
BEGIN pkg_jogos.regista_participacao(1, 1, 'ModalidadeA', 1); END;
/

-- BEGIN pkg_jogos.regista_participacao(2, 2, 'ModalidadeD', 1); END;
-- /

-- ----------------------------------------------------------------------------
BEGIN pkg_jogos.regista_edicao(2, 2004, 'Espanha', 'Madrid'); END; -- registo correto
/
BEGIN pkg_jogos.regista_edicao(2, 2004, 'Italia', 'Roma'); END; -- erro: numero de edicao repetido
/
BEGIN pkg_jogos.regista_edicao(3, 2008, 'Franca', 'Paris'); END; -- registo correto
/
BEGIN pkg_jogos.regista_edicao(4, 2010, 'Franca', 'Paris'); END; -- erro: <> 4 anos comparativamente com anterior
/
-- ----------------------------------------------------------------------------
-- erro: ja existe esta participacao
BEGIN pkg_jogos.regista_participacao(1, 1, 'ModalidadeA', 1); END;
/

-- registo correto
INSERT INTO participa (atleta, jogos, modalidade, posicao)
  VALUES (1, 2, 'ModalidadeB', 3); 

-- registo correto
INSERT INTO participa (atleta, jogos, modalidade, posicao)
  VALUES (1, 3, 'ModalidadeB', 4); 

--verificar cursor
VARIABLE cursor_medalhas REFCURSOR;
BEGIN :cursor_medalhas := pkg_jogos.lista_medalhas(1); END;
/
PRINT cursor_medalhas;

-- ----------------------------------------------------------------------------
-- verificar antes
SELECT * FROM jogos; 

-- verificar antes
SELECT * FROM participa; 

-- registo correto
BEGIN pkg_jogos.regista_participacao(1, 3, 'ModalidadeC', 1); END; 
/

-- verificar apos
SELECT * FROM participa; 

-- remove corretamente
BEGIN pkg_jogos.remove_edicao(3); END; 
/

-- verificar apos
SELECT * FROM jogos; 

-- verificar apos
SELECT * FROM participa;

-- ----------------------------------------------------------------------------
-- verificar antes
SELECT *FROM atleta; 

-- registo correto
VARIABLE atleta4 NUMBER;
BEGIN :atleta4 := pkg_jogos.regista_atleta('Antonio', 2009, 'M', 70, 'Portugal'); END; 
/

SELECT * FROM atleta; 
-- registo correto
BEGIN pkg_jogos.regista_participacao(3, 2, 'ModalidadeD', 1); END;
/

-- verificar antes
SELECT * FROM participa; 

--remove corretamente
BEGIN pkg_jogos.remove_atleta(3); END;
/

-- verificar apos
SELECT * FROM participa; 

-- verificar apos
SELECT *FROM atleta; 
