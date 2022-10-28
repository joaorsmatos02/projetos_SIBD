-- SIBD     2021/22     4ª etapa
-- grupo 28
-- João Ricardo Silva Matos       nº 56292 Turma 02
-- João Pedro Ramos Vedor         nº 56311 Turma 02
-- João Gonçalo Jorge dos Santos  nº 57103 Turma 01
-- Daniel Caetano Luís            nº 56362 Turma 01

CREATE OR REPLACE PACKAGE BODY pkg_jogos IS

FUNCTION regista_atleta (
  nome_in IN atleta.nome%TYPE,
  nascimento_in IN atleta.nascimento%TYPE,
  genero_in IN atleta.genero%TYPE,
  peso_in IN atleta.peso%TYPE,
  pais_in IN atleta.pais%TYPE)
  RETURN NUMBER

IS
  seq_num NUMBER := seq.NEXTVAL;
BEGIN
  IF (nascimento_in <= 0) THEN RAISE_APPLICATION_ERROR(-20000, 'Ano de nascimento tem de ser superior a 0.');
  ELSIF (peso_in <= 0) THEN RAISE_APPLICATION_ERROR(-20001, 'Peso tem de ser superior a 0.');
  ELSIF (genero_in <> 'M' AND genero_in <> 'F') THEN RAISE_APPLICATION_ERROR(-20002, 'Genero tem de ser M ou F.');
  END IF;

  INSERT INTO atleta (numero, nome, nascimento, genero, peso, pais)
    VALUES (seq_num, nome_in, nascimento_in, genero_in, peso_in, pais_in); 
  RETURN seq_num;

EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN
     RAISE_APPLICATION_ERROR(-20003, 'Ja existe um atleta ' ||
                                      'com esse numero.');                                   

  WHEN OTHERS THEN
    BEGIN
      IF (SQLCODE = -2290) THEN
        RAISE_APPLICATION_ERROR(-20999, 'Restricao violada');
      END IF;
      RAISE;
    END;
END regista_atleta;

-- -------------------------------------------------------------------


PROCEDURE regista_edicao (
  numero_in IN jogos.edicao%TYPE,
  ano_in IN jogos.ano%TYPE,
  pais_in IN jogos.pais%TYPE,
  cidade_in IN jogos.cidade%TYPE)
IS
  var_ano_edicao_anterior  jogos.ano%TYPE;    
BEGIN  
  IF (numero_in < 1 ) THEN RAISE_APPLICATION_ERROR(-20005, 'Numero de edicao tem de ser igual ou superior a 1.');
  ELSIF (ano_in < 1896) THEN RAISE_APPLICATION_ERROR(-20006, 'Ano tem de ser igual ou superior a 1896.');
  ELSIF (ano_in IS NULL) THEN RAISE_APPLICATION_ERROR(-20007, 'Ano nao pode ser NULL e tem de ser unico.'); ---------------------
  END IF;

  SELECT ano into var_ano_edicao_anterior FROM jogos J WHERE (J.edicao = numero_in - 1);
    IF ((numero_in > 1 AND (ano_in - var_ano_edicao_anterior) = 4) OR numero_in = 1) THEN
      INSERT INTO jogos (edicao, ano, pais, cidade)
        VALUES (numero_in, ano_in, pais_in, cidade_in);
    ELSE
      RAISE_APPLICATION_ERROR(-20008, 'Ano de edicao tem de ser pelo menos 4 anos depois da anterior.');
    END IF;

EXCEPTION 
  WHEN DUP_VAL_ON_INDEX THEN
     RAISE_APPLICATION_ERROR(-20009, 'Ja existe uma edicao ' ||
                                      'com esse numero.');

  WHEN OTHERS THEN
    BEGIN
      IF (SQLCODE = -2290) THEN
        RAISE_APPLICATION_ERROR(-20999, 'Restricao violada');
      END IF;
      RAISE;
    END;
END regista_edicao;

-- -------------------------------------------------------------------

PROCEDURE regista_participacao (
    atleta_in IN atleta.numero%TYPE,
    jogos_in IN jogos.edicao%TYPE,
    modalidade_in IN participa.modalidade%TYPE,
    posicao_in IN participa.posicao%TYPE)

IS
  var_ano_edicao  jogos.ano%TYPE;
  var_ano_atleta  atleta.nascimento%TYPE;
  
BEGIN
  IF (jogos_in IS NULL) THEN RAISE_APPLICATION_ERROR(-20010, 'Numero de edicao nao pode ser NULL.');
  ELSIF (modalidade_in IS NULL) THEN RAISE_APPLICATION_ERROR(-20011, 'Modalidade nao pode ser NULL.');
  ELSIF (posicao_in IS NULL) THEN RAISE_APPLICATION_ERROR(-20012, 'Posicao nao pode ser NULL.');
  END IF;

  SELECT ano into var_ano_edicao FROM jogos J WHERE (J.edicao = jogos_in);
  SELECT nascimento into var_ano_atleta FROM atleta A WHERE (A.numero = atleta_in);

    IF (var_ano_atleta > var_ano_edicao) THEN 
      INSERT INTO participa (atleta, jogos, modalidade, posicao)
      VALUES (atleta_in, jogos_in, modalidade_in, posicao_in);
    ELSE 
      RAISE_APPLICATION_ERROR(-20013, 'Anos de nascimento ou de edicao invalidos.');
    END IF;

EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
     RAISE_APPLICATION_ERROR(-20003, 'Ja existe um atleta ' ||
                                      'com esse numero.');                              

    WHEN OTHERS THEN
    BEGIN
      IF (SQLCODE = -2290) THEN
        RAISE_APPLICATION_ERROR(-20999, 'Restricao violada');
      END IF;
      RAISE;
    END;

END regista_participacao;

-- -------------------------------------------------------------------

PROCEDURE remove_participacao (
  atleta_in IN atleta.numero%TYPE,
  jogos_in IN jogos.edicao%TYPE,
  modalidade_in IN participa.modalidade%TYPE
)

IS
BEGIN
  IF (jogos_in IS NULL) THEN RAISE_APPLICATION_ERROR(-20010, 'Numero de edicao nao pode ser NULL.');
  ELSIF (modalidade_in IS NULL) THEN RAISE_APPLICATION_ERROR(-20011, 'Modalidade nao pode ser NULL.');
  END IF;

  IF (SQL%ROWCOUNT = 0) THEN    
    RAISE_APPLICATION_ERROR(-20014, 'Edicao a remover nao existe.');
  END IF;

  DELETE FROM participa
    WHERE atleta = atleta_in
    AND jogos = jogos_in
    AND modalidade = modalidade_in;

EXCEPTION 

WHEN DUP_VAL_ON_INDEX THEN
     RAISE_APPLICATION_ERROR(-20003, 'Ja existe um atleta ' ||
                                      'com esse numero.');    

WHEN OTHERS THEN
    BEGIN
      IF (SQLCODE = -2290) THEN
        RAISE_APPLICATION_ERROR(-20999, 'Restricao violada');
      END IF;
      RAISE;
    END;

END remove_participacao;

-- -------------------------------------------------------------------
PROCEDURE remove_edicao (
  jogos_in IN participa.jogos%TYPE)
IS
 CURSOR c_participa IS
    SELECT P.atleta, P.jogos, P.modalidade FROM participa P WHERE (P.jogos = jogos_in);
  TYPE tabela_local_participa IS TABLE OF c_participa%ROWTYPE;
  participa tabela_local_participa; 

BEGIN
  IF (SQL%ROWCOUNT = 0) THEN    
    RAISE_APPLICATION_ERROR(-20014, 'Edicao a remover nao existe.');
  END IF;
  OPEN c_participa;
  FETCH c_participa BULK COLLECT INTO participa;
  CLOSE c_participa;
  IF (participa.COUNT > 0) THEN
    FOR posicao_atual IN participa.FIRST .. participa.LAST LOOP
      IF (participa(posicao_atual).jogos = jogos_in) THEN
        remove_participacao (participa(posicao_atual).atleta, participa(posicao_atual).jogos, participa(posicao_atual).modalidade);
      END IF;
    END LOOP;
  END IF;
  DELETE FROM jogos WHERE (edicao = jogos_in);

EXCEPTION 
  WHEN DUP_VAL_ON_INDEX THEN
     RAISE_APPLICATION_ERROR(-20009, 'Ja existe uma edicao ' ||
                                      'com esse numero.');    

WHEN OTHERS THEN
    BEGIN
      IF (SQLCODE = -2290) THEN
        RAISE_APPLICATION_ERROR(-20999, 'Restricao violada');
      END IF;
      RAISE;
    END;

END remove_edicao;

-- -------------------------------------------------------------------
PROCEDURE remove_atleta (
  atleta_in IN participa.atleta%TYPE)
IS
 CURSOR c_participa IS
    SELECT P.atleta, P.jogos, P.modalidade FROM participa P WHERE (P.atleta = atleta_in);
  TYPE tabela_local_participa IS TABLE OF c_participa%ROWTYPE;
  participa tabela_local_participa; 

BEGIN
  IF (SQL%ROWCOUNT = 0) THEN      
    RAISE_APPLICATION_ERROR(-20014, 'Edicao a remover nao existe.');
  END IF;
  OPEN c_participa;
  FETCH c_participa BULK COLLECT INTO participa;
  CLOSE c_participa;
  IF (participa.COUNT > 0) THEN
    FOR posicao_atual IN participa.FIRST .. participa.LAST LOOP
      IF (participa(posicao_atual).atleta = atleta_in) THEN
        remove_participacao (participa(posicao_atual).atleta, participa(posicao_atual).jogos, participa(posicao_atual).modalidade);
      END IF;
    END LOOP;
  END IF;
  DELETE FROM atleta WHERE (numero = atleta_in);

EXCEPTION 
  WHEN DUP_VAL_ON_INDEX THEN
     RAISE_APPLICATION_ERROR(-20003, 'Ja existe um atleta ' ||
                                      'com esse numero.'); 

WHEN OTHERS THEN
    BEGIN
      IF (SQLCODE = -2290) THEN
        RAISE_APPLICATION_ERROR(-20999, 'Restricao violada');
      END IF;
      RAISE;
    END;

END remove_atleta;

-- -------------------------------------------------------------------

FUNCTION lista_medalhas (
  atleta_in IN atleta.numero%TYPE)
  RETURN SYS_REFCURSOR 
IS
  var_medalhas SYS_REFCURSOR;
BEGIN
  OPEN  var_medalhas FOR
    SELECT A.numero, A.nome, J.ano, P.modalidade, P.posicao 
    FROM atleta A, participa P, jogos J
    WHERE P.atleta = atleta_in
    AND P.jogos = J.edicao
    AND P.posicao <= 3; 
  
  RETURN var_medalhas; 

EXCEPTION 
  WHEN DUP_VAL_ON_INDEX THEN
     RAISE_APPLICATION_ERROR(-20003, 'Ja existe um atleta ' ||
                                      'com esse numero.');

  WHEN OTHERS THEN
    BEGIN
      IF (SQLCODE = -2290) THEN
        RAISE_APPLICATION_ERROR(-20999, 'Restricao violada');
      END IF;
      RAISE;
    END;

END lista_medalhas;

END pkg_jogos;
/