-- SIBD     2021/22     4ª etapa
-- grupo 28
-- João Ricardo Silva Matos       nº 56292 Turma 02
-- João Pedro Ramos Vedor         nº 56311 Turma 02
-- João Gonçalo Jorge dos Santos  nº 57103 Turma 01
-- Daniel Caetano Luís            nº 56362 Turma 01

CREATE OR REPLACE PACKAGE pkg_jogos IS

-- Todas as operações lançam exceções para sinalizar casos de erro.
  --
  -- Exceção Mensagem
  --  -20000 Ano de nascimento tem de ser superior a 0.
  --  -20001 Peso tem de ser superior a 0.
  --  -20002 Genero tem de ser M ou F.
  --  -20003 Ja existe um atleta com esse numero.
  --  -20005 Numero de edicao tem de ser igual ou superior a 1.
  --  -20006 Ano tem de ser igual ou superior a 1896.
  --  -20007 Ano nao pode ser NULL e tem de ser unico.
  --  -20008 Ano de edicao tem de ser pelo menos 4 anos depois da anterior.
  --  -20009 Ja existe uma edicao com esse numero.
  --  -20010 Numero de edicao nao pode ser NULL.
  --  -20011 Modalidade nao pode ser NULL.
  --  -20012 Posicao nao pode ser NULL.
  --  -20013 Anos de nascimento ou de edicao invalidos.
  --  -20014 Edicao a remover nao existe.  
  --  -20999 Restricao violada.



FUNCTION regista_atleta (
 nome_in IN atleta.nome%TYPE,
 nascimento_in IN atleta.nascimento%TYPE,
 genero_in IN atleta.genero%TYPE,
 peso_in IN atleta.peso%TYPE,
 pais_in IN atleta.pais%TYPE
) RETURN NUMBER;

-- -------------------------------------------------------------------

PROCEDURE regista_edicao (
 numero_in IN jogos.edicao%TYPE,
 ano_in IN jogos.ano%TYPE,
 pais_in IN jogos.pais%TYPE,
 cidade_in IN jogos.cidade%TYPE
);

-- -------------------------------------------------------------------

PROCEDURE regista_participacao (
  atleta_in IN atleta.numero%TYPE,
  jogos_in IN jogos.edicao%TYPE,
  modalidade_in IN participa.modalidade%TYPE,
  posicao_in IN participa.posicao%TYPE
);

-- -------------------------------------------------------------------

PROCEDURE remove_participacao (
  atleta_in IN atleta.numero%TYPE,
  jogos_in IN jogos.edicao%TYPE,
  modalidade_in IN participa.modalidade%TYPE
);

-- -------------------------------------------------------------------

PROCEDURE remove_edicao (
  jogos_in IN participa.jogos%TYPE
);

-- -------------------------------------------------------------------

PROCEDURE  remove_atleta (
  atleta_in IN participa.atleta%TYPE
);

-- -------------------------------------------------------------------

FUNCTION lista_medalhas (
  atleta_in IN atleta.numero%TYPE
)
 RETURN SYS_REFCURSOR;

END pkg_jogos;
/