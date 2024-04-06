CREATE SEQUENCE Groupe_SEQPK CACHE 20;
CREATE SEQUENCE Acces_SEQPK CACHE 20;
CREATE SEQUENCE Personne_SEQPK CACHE 20;
CREATE SEQUENCE Clef_SEQPK CACHE 20;
CREATE SEQUENCE Registre_SEQPK CACHE 20;
CREATE SEQUENCE Lieu_SEQPK CACHE 20;
CREATE SEQUENCE Serrure_SEQPK CACHE 20;
CREATE SEQUENCE Histo_SEQPK CACHE 20;
CREATE SEQUENCE fais_SEQPK CACHE 20;
CREATE TABLE Groupes (
  id                    number(9) NOT NULL, 
  Personne_membre_de_id number(9) NOT NULL, 
  nom                   varchar2(2000) NOT NULL, 
  description           varchar2(2000), 
  CONSTRAINT PK_Groupe 
    PRIMARY KEY (id), 
  CONSTRAINT FK1_Groupe_MaxOne 
    UNIQUE (Personne_membre_de_id), 
  CONSTRAINT Groupe_id_DATATYPE 
    CHECK ((id>0)));
CREATE TABLE Acces (
  Groupe_id  number(9) NOT NULL, 
  Lieu_id    number(9) NOT NULL, 
  iddep      number(9) NOT NULL, 
  date_debut timestamp(0) NOT NULL, 
  date_fin   timestamp(0) NOT NULL, 
  CONSTRAINT PK_Acces 
    PRIMARY KEY (Groupe_id, 
  Lieu_id, 
  iddep), 
  CONSTRAINT Acces_iddep_DATATYPE 
    CHECK ((iddep>0)));
CREATE TABLE Personnes (
  id     number(9) NOT NULL, 
  nom    varchar2(2000) NOT NULL, 
  prenom varchar2(2000) NOT NULL, 
  email  varchar2(2000) NOT NULL, 
  CONSTRAINT PK_Personne 
    PRIMARY KEY (id), 
  CONSTRAINT NID1_Personne_email_nom_prenom 
    UNIQUE (email, nom, prenom), 
  CONSTRAINT Personne_id_DATATYPE 
    CHECK ((id>0)));
CREATE TABLE Clefs (
  id              number(9) NOT NULL, 
  numero_de_serie varchar2(2000) NOT NULL, 
  status          varchar2(2000), 
  CONSTRAINT PK_Clef 
    PRIMARY KEY (id), 
  CONSTRAINT NID1_Clef_numero_de_serie 
    UNIQUE (numero_de_serie), 
  CONSTRAINT Clef_id_DATATYPE 
    CHECK ((id>0)));
CREATE TABLE Registre (
  Clef_id     number(9) NOT NULL, 
  Personne_id number(9) NOT NULL, 
  iddep       number(9) NOT NULL, 
  date_debut  timestamp(0) NOT NULL, 
  date_fin    timestamp(0) NOT NULL, 
  CONSTRAINT PK_Registre 
    PRIMARY KEY (Clef_id, 
  Personne_id, 
  iddep), 
  CONSTRAINT Registre_iddep_DATATYPE 
    CHECK ((iddep>0)));
CREATE TABLE Lieux (
  id               number(9) NOT NULL, 
  Lieu_contient_id number(9), 
  nom              varchar2(2000) NOT NULL, 
  CONSTRAINT PK_Lieu 
    PRIMARY KEY (id), 
  CONSTRAINT Lieu_id_DATATYPE 
    CHECK ((id>0)));
CREATE TABLE Serrures (
  id                number(9) NOT NULL, 
  Lieu_verouille_id number(9) NOT NULL, 
  cardinalite       varchar2(2000), 
  CONSTRAINT PK_Serrure 
    PRIMARY KEY (id), 
  CONSTRAINT Serrure_id_DATATYPE 
    CHECK ((id>0)));
CREATE TABLE Historiques (
  Serrure_id       number(9) NOT NULL, 
  Clef_id          number(9) NOT NULL, 
  iddep            number(9) NOT NULL, 
  date_utilisation timestamp(0) NOT NULL, 
  CONSTRAINT PK_Histo 
    PRIMARY KEY (Serrure_id, 
  Clef_id, 
  iddep), 
  CONSTRAINT Histo_iddep_DATATYPE 
    CHECK ((iddep>0)));
CREATE TABLE fais_partie_de (
  Groupe_parent_id number(9) NOT NULL, 
  Groupe_enfant_id number(9) NOT NULL, 
  CONSTRAINT PK_fais 
    PRIMARY KEY (Groupe_parent_id, 
  Groupe_enfant_id));
CREATE INDEX FK1_Acces_Groupe 
  ON Acces (Groupe_id);
CREATE INDEX FK2_Acces_Lieu 
  ON Acces (Lieu_id);
CREATE INDEX FK1_Registre_Clef 
  ON Registre (Clef_id);
CREATE INDEX FK2_Registre_Personne 
  ON Registre (Personne_id);
CREATE INDEX FK1_Lieu_Lieu_contient 
  ON Lieux (Lieu_contient_id);
CREATE INDEX FK1_Serrure_Lieu_verouille 
  ON Serrures (Lieu_verouille_id);
CREATE INDEX FK1_Histo_Serrure 
  ON Historiques (Serrure_id);
CREATE INDEX FK2_Histo_Clef 
  ON Historiques (Clef_id);
CREATE INDEX FK1_fais_Groupe_parent 
  ON fais_partie_de (Groupe_parent_id);
CREATE INDEX FK2_fais_Groupe_enfant 
  ON fais_partie_de (Groupe_enfant_id);
ALTER TABLE Serrures ADD CONSTRAINT FK1_Serrure_Lieu_verouille FOREIGN KEY (Lieu_verouille_id) REFERENCES Lieux (id);
ALTER TABLE Groupes ADD CONSTRAINT FK1_Groupe_Personne_membre_de FOREIGN KEY (Personne_membre_de_id) REFERENCES Personnes (id);
ALTER TABLE fais_partie_de ADD CONSTRAINT FK2_fais_Groupe_enfant FOREIGN KEY (Groupe_enfant_id) REFERENCES Groupes (id);
ALTER TABLE fais_partie_de ADD CONSTRAINT FK1_fais_Groupe_parent FOREIGN KEY (Groupe_parent_id) REFERENCES Groupes (id);
ALTER TABLE Historiques ADD CONSTRAINT FK2_Histo_Clef FOREIGN KEY (Clef_id) REFERENCES Clefs (id);
ALTER TABLE Historiques ADD CONSTRAINT FK1_Histo_Serrure FOREIGN KEY (Serrure_id) REFERENCES Serrures (id);
ALTER TABLE Lieux ADD CONSTRAINT FK1_Lieu_Lieu_contient FOREIGN KEY (Lieu_contient_id) REFERENCES Lieux (id);
ALTER TABLE Registre ADD CONSTRAINT FK2_Registre_Personne FOREIGN KEY (Personne_id) REFERENCES Personnes (id);
ALTER TABLE Registre ADD CONSTRAINT FK1_Registre_Clef FOREIGN KEY (Clef_id) REFERENCES Clefs (id);
ALTER TABLE Acces ADD CONSTRAINT FK2_Acces_Lieu FOREIGN KEY (Lieu_id) REFERENCES Lieux (id);
ALTER TABLE Acces ADD CONSTRAINT FK1_Acces_Groupe FOREIGN KEY (Groupe_id) REFERENCES Groupes (id);
create or replace PACKAGE UTIL IS
MYTRUE  CONSTANT CHAR := 'Y';
MYFALSE CONSTANT CHAR := 'N';
FUNCTION EQUALORNULL (arg1 IN NUMBER, arg2 IN NUMBER) RETURN VARCHAR2;
FUNCTION GETBOOLEAN(arg IN VARCHAR2) RETURN BOOLEAN;

END;
/
CREATE OR REPLACE PACKAGE BODY UTIL IS
FUNCTION EQUALORNULL (arg1 IN NUMBER, arg2 IN NUMBER) RETURN VARCHAR2 IS
BEGIN
  IF (arg1 = arg2) OR ( (arg1 IS NULL) AND (arg2 IS NULL)) THEN
    RETURN UTIL.MYTRUE;
  ELSE
    RETURN UTIL.MYFALSE;
  END IF;
END;


FUNCTION GETBOOLEAN(arg IN VARCHAR2) RETURN BOOLEAN IS
BEGIN
  IF arg IS NULL THEN 
    RETURN NULL;
  ELSE
    IF arg = 'Y' THEN
      RETURN true;
    ELSE 
      IF arg = 'N' THEN 
        RETURN false;
      ELSE
       raise_application_error(-20001, 'La valeur ' + arg + ' ne peut pas être convertie en un type boolean/logique');
      END IF;
    END IF;
  END IF; 
END;


BEGIN
	NULL;
END;
/
CREATE OR REPLACE PACKAGE Groupe_TAPIs IS
PROCEDURE autogen_column(pio_crtrec IN OUT Groupes%ROWTYPE);
PROCEDURE autogen_column_ins(pio_crtrec IN OUT Groupes%ROWTYPE);
PROCEDURE autogen_column_upd(pio_crtrec IN OUT Groupes%ROWTYPE);
PROCEDURE uppercase_column(pio_crtrec IN OUT Groupes%ROWTYPE);
PROCEDURE checktype_column(pio_crtrec IN OUT Groupes%ROWTYPE);
PROCEDURE column_PEA(pio_crtrec IN OUT Groupes%ROWTYPE);
PROCEDURE frozen_column(  pio_newrec IN OUT Groupes%ROWTYPE
						  , pio_oldrec IN OUT Groupes%ROWTYPE);
PROCEDURE tree_or_list_loop;
PROCEDURE tree_or_list_onlyone;


TYPE type_Groupes  IS TABLE OF Groupes%ROWTYPE
INDEX BY PLS_INTEGER;
vg_Groupes type_Groupes;

vg_insteadof_call BOOLEAN := FALSE;

END;
/
CREATE OR REPLACE PACKAGE BODY Groupe_TAPIs IS


PROCEDURE autogen_column(pio_crtrec IN OUT Groupes%ROWTYPE) IS
BEGIN
	NULL;
END;

PROCEDURE autogen_column_ins(pio_crtrec IN OUT Groupes%ROWTYPE) IS
BEGIN
	NULL;
	IF pio_crtrec.id IS NULL THEN
	SELECT Groupe_SEQPK.NEXTVAL
	INTO pio_crtrec.id
	FROM DUAL;
END IF;
	
	
	
	
	
END;

PROCEDURE autogen_column_upd(pio_crtrec IN OUT Groupes%ROWTYPE) IS
BEGIN
	NULL;
	
END;


PROCEDURE uppercase_column(pio_crtrec IN OUT Groupes%ROWTYPE) IS
BEGIN
	NULL;
	
END;

PROCEDURE checktype_column(pio_crtrec IN OUT Groupes%ROWTYPE) IS
BEGIN
	NULL;
	
END;

PROCEDURE column_PEA(pio_crtrec IN OUT Groupes%ROWTYPE) IS
BEGIN
	NULL;
	
END;

PROCEDURE frozen_column(	pio_newrec IN OUT Groupes%ROWTYPE,
							pio_oldrec IN OUT Groupes%ROWTYPE) IS
BEGIN
	NULL;
	
END;


PROCEDURE tree_or_list_loop IS
v_temp NUMBER;
BEGIN
	NULL;
	
END;

PROCEDURE tree_or_list_onlyone IS
v_temp NUMBER;
BEGIN
	NULL;
	
END;




BEGIN
	NULL;
END;
/
CREATE OR REPLACE PACKAGE Acces_TAPIs IS
PROCEDURE autogen_column(pio_crtrec IN OUT Acces%ROWTYPE);
PROCEDURE autogen_column_ins(pio_crtrec IN OUT Acces%ROWTYPE);
PROCEDURE autogen_column_upd(pio_crtrec IN OUT Acces%ROWTYPE);
PROCEDURE uppercase_column(pio_crtrec IN OUT Acces%ROWTYPE);
PROCEDURE checktype_column(pio_crtrec IN OUT Acces%ROWTYPE);
PROCEDURE column_PEA(pio_crtrec IN OUT Acces%ROWTYPE);
PROCEDURE frozen_column(  pio_newrec IN OUT Acces%ROWTYPE
						  , pio_oldrec IN OUT Acces%ROWTYPE);
PROCEDURE tree_or_list_loop;
PROCEDURE tree_or_list_onlyone;


TYPE type_Acces  IS TABLE OF Acces%ROWTYPE
INDEX BY PLS_INTEGER;
vg_Acces type_Acces;

vg_insteadof_call BOOLEAN := FALSE;

END;
/
CREATE OR REPLACE PACKAGE BODY Acces_TAPIs IS


PROCEDURE autogen_column(pio_crtrec IN OUT Acces%ROWTYPE) IS
BEGIN
	NULL;
END;

PROCEDURE autogen_column_ins(pio_crtrec IN OUT Acces%ROWTYPE) IS
BEGIN
	NULL;
	
	IF pio_crtrec.iddep IS NULL THEN
	SELECT NVL(MAX(iddep), 0) + 1
	INTO pio_crtrec.iddep
	FROM Acces
	WHERE (1=1)
	
 AND Acces.Groupe_id = pio_crtrec.Groupe_id
 AND Acces.Lieu_id = pio_crtrec.Lieu_id;
END IF;
	
	
	
	
END;

PROCEDURE autogen_column_upd(pio_crtrec IN OUT Acces%ROWTYPE) IS
BEGIN
	NULL;
	
END;


PROCEDURE uppercase_column(pio_crtrec IN OUT Acces%ROWTYPE) IS
BEGIN
	NULL;
	
END;

PROCEDURE checktype_column(pio_crtrec IN OUT Acces%ROWTYPE) IS
BEGIN
	NULL;
	
END;

PROCEDURE column_PEA(pio_crtrec IN OUT Acces%ROWTYPE) IS
BEGIN
	NULL;
	
END;

PROCEDURE frozen_column(	pio_newrec IN OUT Acces%ROWTYPE,
							pio_oldrec IN OUT Acces%ROWTYPE) IS
BEGIN
	NULL;
	
END;


PROCEDURE tree_or_list_loop IS
v_temp NUMBER;
BEGIN
	NULL;
	
END;

PROCEDURE tree_or_list_onlyone IS
v_temp NUMBER;
BEGIN
	NULL;
	
END;




BEGIN
	NULL;
END;
/
CREATE OR REPLACE PACKAGE Personne_TAPIs IS
PROCEDURE autogen_column(pio_crtrec IN OUT Personnes%ROWTYPE);
PROCEDURE autogen_column_ins(pio_crtrec IN OUT Personnes%ROWTYPE);
PROCEDURE autogen_column_upd(pio_crtrec IN OUT Personnes%ROWTYPE);
PROCEDURE uppercase_column(pio_crtrec IN OUT Personnes%ROWTYPE);
PROCEDURE checktype_column(pio_crtrec IN OUT Personnes%ROWTYPE);
PROCEDURE column_PEA(pio_crtrec IN OUT Personnes%ROWTYPE);
PROCEDURE frozen_column(  pio_newrec IN OUT Personnes%ROWTYPE
						  , pio_oldrec IN OUT Personnes%ROWTYPE);
PROCEDURE tree_or_list_loop;
PROCEDURE tree_or_list_onlyone;


TYPE type_Personnes  IS TABLE OF Personnes%ROWTYPE
INDEX BY PLS_INTEGER;
vg_Personnes type_Personnes;

vg_insteadof_call BOOLEAN := FALSE;

END;
/
CREATE OR REPLACE PACKAGE BODY Personne_TAPIs IS


PROCEDURE autogen_column(pio_crtrec IN OUT Personnes%ROWTYPE) IS
BEGIN
	NULL;
END;

PROCEDURE autogen_column_ins(pio_crtrec IN OUT Personnes%ROWTYPE) IS
BEGIN
	NULL;
	IF pio_crtrec.id IS NULL THEN
	SELECT Personne_SEQPK.NEXTVAL
	INTO pio_crtrec.id
	FROM DUAL;
END IF;
	
	
	
	
	
END;

PROCEDURE autogen_column_upd(pio_crtrec IN OUT Personnes%ROWTYPE) IS
BEGIN
	NULL;
	
END;


PROCEDURE uppercase_column(pio_crtrec IN OUT Personnes%ROWTYPE) IS
BEGIN
	NULL;
	
END;

PROCEDURE checktype_column(pio_crtrec IN OUT Personnes%ROWTYPE) IS
BEGIN
	NULL;
	
END;

PROCEDURE column_PEA(pio_crtrec IN OUT Personnes%ROWTYPE) IS
BEGIN
	NULL;
	
END;

PROCEDURE frozen_column(	pio_newrec IN OUT Personnes%ROWTYPE,
							pio_oldrec IN OUT Personnes%ROWTYPE) IS
BEGIN
	NULL;
	
END;


PROCEDURE tree_or_list_loop IS
v_temp NUMBER;
BEGIN
	NULL;
	
END;

PROCEDURE tree_or_list_onlyone IS
v_temp NUMBER;
BEGIN
	NULL;
	
END;




BEGIN
	NULL;
END;
/
CREATE OR REPLACE PACKAGE Clef_TAPIs IS
PROCEDURE autogen_column(pio_crtrec IN OUT Clefs%ROWTYPE);
PROCEDURE autogen_column_ins(pio_crtrec IN OUT Clefs%ROWTYPE);
PROCEDURE autogen_column_upd(pio_crtrec IN OUT Clefs%ROWTYPE);
PROCEDURE uppercase_column(pio_crtrec IN OUT Clefs%ROWTYPE);
PROCEDURE checktype_column(pio_crtrec IN OUT Clefs%ROWTYPE);
PROCEDURE column_PEA(pio_crtrec IN OUT Clefs%ROWTYPE);
PROCEDURE frozen_column(  pio_newrec IN OUT Clefs%ROWTYPE
						  , pio_oldrec IN OUT Clefs%ROWTYPE);
PROCEDURE tree_or_list_loop;
PROCEDURE tree_or_list_onlyone;


TYPE type_Clefs  IS TABLE OF Clefs%ROWTYPE
INDEX BY PLS_INTEGER;
vg_Clefs type_Clefs;

vg_insteadof_call BOOLEAN := FALSE;

END;
/
CREATE OR REPLACE PACKAGE BODY Clef_TAPIs IS


PROCEDURE autogen_column(pio_crtrec IN OUT Clefs%ROWTYPE) IS
BEGIN
	NULL;
END;

PROCEDURE autogen_column_ins(pio_crtrec IN OUT Clefs%ROWTYPE) IS
BEGIN
	NULL;
	IF pio_crtrec.id IS NULL THEN
	SELECT Clef_SEQPK.NEXTVAL
	INTO pio_crtrec.id
	FROM DUAL;
END IF;
	
	
	
	
	
END;

PROCEDURE autogen_column_upd(pio_crtrec IN OUT Clefs%ROWTYPE) IS
BEGIN
	NULL;
	
END;


PROCEDURE uppercase_column(pio_crtrec IN OUT Clefs%ROWTYPE) IS
BEGIN
	NULL;
	
END;

PROCEDURE checktype_column(pio_crtrec IN OUT Clefs%ROWTYPE) IS
BEGIN
	NULL;
	
END;

PROCEDURE column_PEA(pio_crtrec IN OUT Clefs%ROWTYPE) IS
BEGIN
	NULL;
	
END;

PROCEDURE frozen_column(	pio_newrec IN OUT Clefs%ROWTYPE,
							pio_oldrec IN OUT Clefs%ROWTYPE) IS
BEGIN
	NULL;
	
END;


PROCEDURE tree_or_list_loop IS
v_temp NUMBER;
BEGIN
	NULL;
	
END;

PROCEDURE tree_or_list_onlyone IS
v_temp NUMBER;
BEGIN
	NULL;
	
END;




BEGIN
	NULL;
END;
/
CREATE OR REPLACE PACKAGE Registre_TAPIs IS
PROCEDURE autogen_column(pio_crtrec IN OUT Registre%ROWTYPE);
PROCEDURE autogen_column_ins(pio_crtrec IN OUT Registre%ROWTYPE);
PROCEDURE autogen_column_upd(pio_crtrec IN OUT Registre%ROWTYPE);
PROCEDURE uppercase_column(pio_crtrec IN OUT Registre%ROWTYPE);
PROCEDURE checktype_column(pio_crtrec IN OUT Registre%ROWTYPE);
PROCEDURE column_PEA(pio_crtrec IN OUT Registre%ROWTYPE);
PROCEDURE frozen_column(  pio_newrec IN OUT Registre%ROWTYPE
						  , pio_oldrec IN OUT Registre%ROWTYPE);
PROCEDURE tree_or_list_loop;
PROCEDURE tree_or_list_onlyone;


TYPE type_Registre  IS TABLE OF Registre%ROWTYPE
INDEX BY PLS_INTEGER;
vg_Registre type_Registre;

vg_insteadof_call BOOLEAN := FALSE;

END;
/
CREATE OR REPLACE PACKAGE BODY Registre_TAPIs IS


PROCEDURE autogen_column(pio_crtrec IN OUT Registre%ROWTYPE) IS
BEGIN
	NULL;
END;

PROCEDURE autogen_column_ins(pio_crtrec IN OUT Registre%ROWTYPE) IS
BEGIN
	NULL;
	
	IF pio_crtrec.iddep IS NULL THEN
	SELECT NVL(MAX(iddep), 0) + 1
	INTO pio_crtrec.iddep
	FROM Registre
	WHERE (1=1)
	
 AND Registre.Clef_id = pio_crtrec.Clef_id
 AND Registre.Personne_id = pio_crtrec.Personne_id;
END IF;
	
	
	
	
END;

PROCEDURE autogen_column_upd(pio_crtrec IN OUT Registre%ROWTYPE) IS
BEGIN
	NULL;
	
END;


PROCEDURE uppercase_column(pio_crtrec IN OUT Registre%ROWTYPE) IS
BEGIN
	NULL;
	
END;

PROCEDURE checktype_column(pio_crtrec IN OUT Registre%ROWTYPE) IS
BEGIN
	NULL;
	
END;

PROCEDURE column_PEA(pio_crtrec IN OUT Registre%ROWTYPE) IS
BEGIN
	NULL;
	
END;

PROCEDURE frozen_column(	pio_newrec IN OUT Registre%ROWTYPE,
							pio_oldrec IN OUT Registre%ROWTYPE) IS
BEGIN
	NULL;
	
END;


PROCEDURE tree_or_list_loop IS
v_temp NUMBER;
BEGIN
	NULL;
	
END;

PROCEDURE tree_or_list_onlyone IS
v_temp NUMBER;
BEGIN
	NULL;
	
END;




BEGIN
	NULL;
END;
/
CREATE OR REPLACE PACKAGE Lieu_TAPIs IS
PROCEDURE autogen_column(pio_crtrec IN OUT Lieux%ROWTYPE);
PROCEDURE autogen_column_ins(pio_crtrec IN OUT Lieux%ROWTYPE);
PROCEDURE autogen_column_upd(pio_crtrec IN OUT Lieux%ROWTYPE);
PROCEDURE uppercase_column(pio_crtrec IN OUT Lieux%ROWTYPE);
PROCEDURE checktype_column(pio_crtrec IN OUT Lieux%ROWTYPE);
PROCEDURE column_PEA(pio_crtrec IN OUT Lieux%ROWTYPE);
PROCEDURE frozen_column(  pio_newrec IN OUT Lieux%ROWTYPE
						  , pio_oldrec IN OUT Lieux%ROWTYPE);
PROCEDURE tree_or_list_loop;
PROCEDURE tree_or_list_onlyone;


TYPE type_Lieux  IS TABLE OF Lieux%ROWTYPE
INDEX BY PLS_INTEGER;
vg_Lieux type_Lieux;

vg_insteadof_call BOOLEAN := FALSE;

END;
/
CREATE OR REPLACE PACKAGE BODY Lieu_TAPIs IS


PROCEDURE autogen_column(pio_crtrec IN OUT Lieux%ROWTYPE) IS
BEGIN
	NULL;
END;

PROCEDURE autogen_column_ins(pio_crtrec IN OUT Lieux%ROWTYPE) IS
BEGIN
	NULL;
	IF pio_crtrec.id IS NULL THEN
	SELECT Lieu_SEQPK.NEXTVAL
	INTO pio_crtrec.id
	FROM DUAL;
END IF;
	
	
	
	
	
END;

PROCEDURE autogen_column_upd(pio_crtrec IN OUT Lieux%ROWTYPE) IS
BEGIN
	NULL;
	
END;


PROCEDURE uppercase_column(pio_crtrec IN OUT Lieux%ROWTYPE) IS
BEGIN
	NULL;
	
END;

PROCEDURE checktype_column(pio_crtrec IN OUT Lieux%ROWTYPE) IS
BEGIN
	NULL;
	
END;

PROCEDURE column_PEA(pio_crtrec IN OUT Lieux%ROWTYPE) IS
BEGIN
	NULL;
	
END;

PROCEDURE frozen_column(	pio_newrec IN OUT Lieux%ROWTYPE,
							pio_oldrec IN OUT Lieux%ROWTYPE) IS
BEGIN
	NULL;
	
END;


PROCEDURE tree_or_list_loop IS
v_temp NUMBER;
BEGIN
	NULL;
	
END;

PROCEDURE tree_or_list_onlyone IS
v_temp NUMBER;
BEGIN
	NULL;
	
END;




BEGIN
	NULL;
END;
/
CREATE OR REPLACE PACKAGE Serrure_TAPIs IS
PROCEDURE autogen_column(pio_crtrec IN OUT Serrures%ROWTYPE);
PROCEDURE autogen_column_ins(pio_crtrec IN OUT Serrures%ROWTYPE);
PROCEDURE autogen_column_upd(pio_crtrec IN OUT Serrures%ROWTYPE);
PROCEDURE uppercase_column(pio_crtrec IN OUT Serrures%ROWTYPE);
PROCEDURE checktype_column(pio_crtrec IN OUT Serrures%ROWTYPE);
PROCEDURE column_PEA(pio_crtrec IN OUT Serrures%ROWTYPE);
PROCEDURE frozen_column(  pio_newrec IN OUT Serrures%ROWTYPE
						  , pio_oldrec IN OUT Serrures%ROWTYPE);
PROCEDURE tree_or_list_loop;
PROCEDURE tree_or_list_onlyone;


TYPE type_Serrures  IS TABLE OF Serrures%ROWTYPE
INDEX BY PLS_INTEGER;
vg_Serrures type_Serrures;

vg_insteadof_call BOOLEAN := FALSE;

END;
/
CREATE OR REPLACE PACKAGE BODY Serrure_TAPIs IS


PROCEDURE autogen_column(pio_crtrec IN OUT Serrures%ROWTYPE) IS
BEGIN
	NULL;
END;

PROCEDURE autogen_column_ins(pio_crtrec IN OUT Serrures%ROWTYPE) IS
BEGIN
	NULL;
	IF pio_crtrec.id IS NULL THEN
	SELECT Serrure_SEQPK.NEXTVAL
	INTO pio_crtrec.id
	FROM DUAL;
END IF;
	
	
	
	
	
END;

PROCEDURE autogen_column_upd(pio_crtrec IN OUT Serrures%ROWTYPE) IS
BEGIN
	NULL;
	
END;


PROCEDURE uppercase_column(pio_crtrec IN OUT Serrures%ROWTYPE) IS
BEGIN
	NULL;
	
END;

PROCEDURE checktype_column(pio_crtrec IN OUT Serrures%ROWTYPE) IS
BEGIN
	NULL;
	
END;

PROCEDURE column_PEA(pio_crtrec IN OUT Serrures%ROWTYPE) IS
BEGIN
	NULL;
	
END;

PROCEDURE frozen_column(	pio_newrec IN OUT Serrures%ROWTYPE,
							pio_oldrec IN OUT Serrures%ROWTYPE) IS
BEGIN
	NULL;
	
END;


PROCEDURE tree_or_list_loop IS
v_temp NUMBER;
BEGIN
	NULL;
	
END;

PROCEDURE tree_or_list_onlyone IS
v_temp NUMBER;
BEGIN
	NULL;
	
END;




BEGIN
	NULL;
END;
/
CREATE OR REPLACE PACKAGE Histo_TAPIs IS
PROCEDURE autogen_column(pio_crtrec IN OUT Historiques%ROWTYPE);
PROCEDURE autogen_column_ins(pio_crtrec IN OUT Historiques%ROWTYPE);
PROCEDURE autogen_column_upd(pio_crtrec IN OUT Historiques%ROWTYPE);
PROCEDURE uppercase_column(pio_crtrec IN OUT Historiques%ROWTYPE);
PROCEDURE checktype_column(pio_crtrec IN OUT Historiques%ROWTYPE);
PROCEDURE column_PEA(pio_crtrec IN OUT Historiques%ROWTYPE);
PROCEDURE frozen_column(  pio_newrec IN OUT Historiques%ROWTYPE
						  , pio_oldrec IN OUT Historiques%ROWTYPE);
PROCEDURE tree_or_list_loop;
PROCEDURE tree_or_list_onlyone;


TYPE type_Historiques  IS TABLE OF Historiques%ROWTYPE
INDEX BY PLS_INTEGER;
vg_Historiques type_Historiques;

vg_insteadof_call BOOLEAN := FALSE;

END;
/
CREATE OR REPLACE PACKAGE BODY Histo_TAPIs IS


PROCEDURE autogen_column(pio_crtrec IN OUT Historiques%ROWTYPE) IS
BEGIN
	NULL;
END;

PROCEDURE autogen_column_ins(pio_crtrec IN OUT Historiques%ROWTYPE) IS
BEGIN
	NULL;
	
	IF pio_crtrec.iddep IS NULL THEN
	SELECT NVL(MAX(iddep), 0) + 1
	INTO pio_crtrec.iddep
	FROM Historiques
	WHERE (1=1)
	
 AND Historiques.Serrure_id = pio_crtrec.Serrure_id
 AND Historiques.Clef_id = pio_crtrec.Clef_id;
END IF;
	
	
	
	
END;

PROCEDURE autogen_column_upd(pio_crtrec IN OUT Historiques%ROWTYPE) IS
BEGIN
	NULL;
	
END;


PROCEDURE uppercase_column(pio_crtrec IN OUT Historiques%ROWTYPE) IS
BEGIN
	NULL;
	
END;

PROCEDURE checktype_column(pio_crtrec IN OUT Historiques%ROWTYPE) IS
BEGIN
	NULL;
	
END;

PROCEDURE column_PEA(pio_crtrec IN OUT Historiques%ROWTYPE) IS
BEGIN
	NULL;
	
END;

PROCEDURE frozen_column(	pio_newrec IN OUT Historiques%ROWTYPE,
							pio_oldrec IN OUT Historiques%ROWTYPE) IS
BEGIN
	NULL;
	
END;


PROCEDURE tree_or_list_loop IS
v_temp NUMBER;
BEGIN
	NULL;
	
END;

PROCEDURE tree_or_list_onlyone IS
v_temp NUMBER;
BEGIN
	NULL;
	
END;




BEGIN
	NULL;
END;
/
CREATE OR REPLACE PACKAGE fais_TAPIs IS
PROCEDURE autogen_column(pio_crtrec IN OUT fais_partie_de%ROWTYPE);
PROCEDURE autogen_column_ins(pio_crtrec IN OUT fais_partie_de%ROWTYPE);
PROCEDURE autogen_column_upd(pio_crtrec IN OUT fais_partie_de%ROWTYPE);
PROCEDURE uppercase_column(pio_crtrec IN OUT fais_partie_de%ROWTYPE);
PROCEDURE checktype_column(pio_crtrec IN OUT fais_partie_de%ROWTYPE);
PROCEDURE column_PEA(pio_crtrec IN OUT fais_partie_de%ROWTYPE);
PROCEDURE frozen_column(  pio_newrec IN OUT fais_partie_de%ROWTYPE
						  , pio_oldrec IN OUT fais_partie_de%ROWTYPE);
PROCEDURE tree_or_list_loop;
PROCEDURE tree_or_list_onlyone;


TYPE type_fais_partie_de  IS TABLE OF fais_partie_de%ROWTYPE
INDEX BY PLS_INTEGER;
vg_fais_partie_de type_fais_partie_de;

vg_insteadof_call BOOLEAN := FALSE;

END;
/
CREATE OR REPLACE PACKAGE BODY fais_TAPIs IS


PROCEDURE autogen_column(pio_crtrec IN OUT fais_partie_de%ROWTYPE) IS
BEGIN
	NULL;
END;

PROCEDURE autogen_column_ins(pio_crtrec IN OUT fais_partie_de%ROWTYPE) IS
BEGIN
	NULL;
	
	
	
	
	
	
END;

PROCEDURE autogen_column_upd(pio_crtrec IN OUT fais_partie_de%ROWTYPE) IS
BEGIN
	NULL;
	
END;


PROCEDURE uppercase_column(pio_crtrec IN OUT fais_partie_de%ROWTYPE) IS
BEGIN
	NULL;
	
END;

PROCEDURE checktype_column(pio_crtrec IN OUT fais_partie_de%ROWTYPE) IS
BEGIN
	NULL;
	
END;

PROCEDURE column_PEA(pio_crtrec IN OUT fais_partie_de%ROWTYPE) IS
BEGIN
	NULL;
	
END;

PROCEDURE frozen_column(	pio_newrec IN OUT fais_partie_de%ROWTYPE,
							pio_oldrec IN OUT fais_partie_de%ROWTYPE) IS
BEGIN
	NULL;
	
END;


PROCEDURE tree_or_list_loop IS
v_temp NUMBER;
BEGIN
	NULL;
	
END;

PROCEDURE tree_or_list_onlyone IS
v_temp NUMBER;
BEGIN
	NULL;
	
END;




BEGIN
	NULL;
END;
/
CREATE OR REPLACE TRIGGER Groupe_BIR
	BEFORE INSERT ON Groupes FOR EACH ROW
	DECLARE
	vl_newrec Groupes%ROWTYPE;

	BEGIN

vl_newrec.id := :NEW.id;
vl_newrec.Personne_membre_de_id := :NEW.Personne_membre_de_id;
vl_newrec.nom := :NEW.nom;
vl_newrec.description := :NEW.description;
		Groupe_TAPIs.autogen_column_ins(vl_newrec);
		Groupe_TAPIs.autogen_column(vl_newrec);
		Groupe_TAPIs.checktype_column(vl_newrec);
		Groupe_TAPIs.uppercase_column(vl_newrec);
		Groupe_TAPIs.column_PEA(vl_newrec);

:NEW.id := vl_newrec.id;
:NEW.Personne_membre_de_id := vl_newrec.Personne_membre_de_id;
:NEW.nom := vl_newrec.nom;
:NEW.description := vl_newrec.description;
	END;
;
/
CREATE OR REPLACE TRIGGER Groupe_BUR
	BEFORE UPDATE ON Groupes FOR EACH ROW
	DECLARE
	vl_newrec Groupes%ROWTYPE;
	vl_oldrec Groupes%ROWTYPE;

	BEGIN

vl_newrec.id := :NEW.id;
vl_newrec.Personne_membre_de_id := :NEW.Personne_membre_de_id;
vl_newrec.nom := :NEW.nom;
vl_newrec.description := :NEW.description;

vl_oldrec.id := :OLD.id;
vl_oldrec.Personne_membre_de_id := :OLD.Personne_membre_de_id;
vl_oldrec.nom := :OLD.nom;
vl_oldrec.description := :OLD.description;
		Groupe_TAPIs.autogen_column_upd(vl_newrec);
		Groupe_TAPIs.autogen_column(vl_newrec);
		Groupe_TAPIs.checktype_column(vl_newrec);
		Groupe_TAPIs.uppercase_column(vl_newrec);
		Groupe_TAPIs.column_PEA(vl_newrec);
		Groupe_TAPIs.frozen_column(vl_newrec, vl_oldrec);

:NEW.id := vl_newrec.id;
:NEW.Personne_membre_de_id := vl_newrec.Personne_membre_de_id;
:NEW.nom := vl_newrec.nom;
:NEW.description := vl_newrec.description;
	END;
;
/
CREATE OR REPLACE TRIGGER Groupe_BIU
BEFORE INSERT OR UPDATE ON Groupes

BEGIN

	NULL;
	-- Seulement si nécessaire!
 	-- select * bulk collect into Groupe_TAPIs.vg_Groupes
 	-- from Groupes ;
END;
;
/
CREATE OR REPLACE TRIGGER Groupe_BDR
	BEFORE DELETE ON Groupes FOR EACH ROW
	DECLARE
	 	vl_oldrec Groupes%ROWTYPE;

	BEGIN

vl_oldrec.id := :OLD.id;
vl_oldrec.Personne_membre_de_id := :OLD.Personne_membre_de_id;
vl_oldrec.nom := :OLD.nom;
vl_oldrec.description := :OLD.description;

	END;
;
/
CREATE OR REPLACE TRIGGER Groupe_AIUD
	AFTER INSERT OR UPDATE OR DELETE ON Groupes
	DECLARE
	BEGIN
		Groupe_TAPIs.tree_or_list_loop();
		Groupe_TAPIs.tree_or_list_onlyone();
	END;
;
/
CREATE OR REPLACE TRIGGER Acces_BIR
	BEFORE INSERT ON Acces FOR EACH ROW
	DECLARE
	vl_newrec Acces%ROWTYPE;

	BEGIN

vl_newrec.Groupe_id := :NEW.Groupe_id;
vl_newrec.Lieu_id := :NEW.Lieu_id;
vl_newrec.iddep := :NEW.iddep;
vl_newrec.date_debut := :NEW.date_debut;
vl_newrec.date_fin := :NEW.date_fin;
		Acces_TAPIs.autogen_column_ins(vl_newrec);
		Acces_TAPIs.autogen_column(vl_newrec);
		Acces_TAPIs.checktype_column(vl_newrec);
		Acces_TAPIs.uppercase_column(vl_newrec);
		Acces_TAPIs.column_PEA(vl_newrec);

:NEW.Groupe_id := vl_newrec.Groupe_id;
:NEW.Lieu_id := vl_newrec.Lieu_id;
:NEW.iddep := vl_newrec.iddep;
:NEW.date_debut := vl_newrec.date_debut;
:NEW.date_fin := vl_newrec.date_fin;
	END;
;
/
CREATE OR REPLACE TRIGGER Acces_BUR
	BEFORE UPDATE ON Acces FOR EACH ROW
	DECLARE
	vl_newrec Acces%ROWTYPE;
	vl_oldrec Acces%ROWTYPE;

	BEGIN

vl_newrec.Groupe_id := :NEW.Groupe_id;
vl_newrec.Lieu_id := :NEW.Lieu_id;
vl_newrec.iddep := :NEW.iddep;
vl_newrec.date_debut := :NEW.date_debut;
vl_newrec.date_fin := :NEW.date_fin;

vl_oldrec.Groupe_id := :OLD.Groupe_id;
vl_oldrec.Lieu_id := :OLD.Lieu_id;
vl_oldrec.iddep := :OLD.iddep;
vl_oldrec.date_debut := :OLD.date_debut;
vl_oldrec.date_fin := :OLD.date_fin;
		Acces_TAPIs.autogen_column_upd(vl_newrec);
		Acces_TAPIs.autogen_column(vl_newrec);
		Acces_TAPIs.checktype_column(vl_newrec);
		Acces_TAPIs.uppercase_column(vl_newrec);
		Acces_TAPIs.column_PEA(vl_newrec);
		Acces_TAPIs.frozen_column(vl_newrec, vl_oldrec);

:NEW.Groupe_id := vl_newrec.Groupe_id;
:NEW.Lieu_id := vl_newrec.Lieu_id;
:NEW.iddep := vl_newrec.iddep;
:NEW.date_debut := vl_newrec.date_debut;
:NEW.date_fin := vl_newrec.date_fin;
	END;
;
/
CREATE OR REPLACE TRIGGER Acces_BIU
BEFORE INSERT OR UPDATE ON Acces

BEGIN

	NULL;
	-- Seulement si nécessaire!
 	-- select * bulk collect into Acces_TAPIs.vg_Acces
 	-- from Acces ;
END;
;
/
CREATE OR REPLACE TRIGGER Acces_BDR
	BEFORE DELETE ON Acces FOR EACH ROW
	DECLARE
	 	vl_oldrec Acces%ROWTYPE;

	BEGIN

vl_oldrec.Groupe_id := :OLD.Groupe_id;
vl_oldrec.Lieu_id := :OLD.Lieu_id;
vl_oldrec.iddep := :OLD.iddep;
vl_oldrec.date_debut := :OLD.date_debut;
vl_oldrec.date_fin := :OLD.date_fin;

	END;
;
/
CREATE OR REPLACE TRIGGER Acces_AIUD
	AFTER INSERT OR UPDATE OR DELETE ON Acces
	DECLARE
	BEGIN
		Acces_TAPIs.tree_or_list_loop();
		Acces_TAPIs.tree_or_list_onlyone();
	END;
;
/
CREATE OR REPLACE TRIGGER Personne_BIR
	BEFORE INSERT ON Personnes FOR EACH ROW
	DECLARE
	vl_newrec Personnes%ROWTYPE;

	BEGIN

vl_newrec.id := :NEW.id;
vl_newrec.nom := :NEW.nom;
vl_newrec.prenom := :NEW.prenom;
vl_newrec.email := :NEW.email;
		Personne_TAPIs.autogen_column_ins(vl_newrec);
		Personne_TAPIs.autogen_column(vl_newrec);
		Personne_TAPIs.checktype_column(vl_newrec);
		Personne_TAPIs.uppercase_column(vl_newrec);
		Personne_TAPIs.column_PEA(vl_newrec);

:NEW.id := vl_newrec.id;
:NEW.nom := vl_newrec.nom;
:NEW.prenom := vl_newrec.prenom;
:NEW.email := vl_newrec.email;
	END;
;
/
CREATE OR REPLACE TRIGGER Personne_BUR
	BEFORE UPDATE ON Personnes FOR EACH ROW
	DECLARE
	vl_newrec Personnes%ROWTYPE;
	vl_oldrec Personnes%ROWTYPE;

	BEGIN

vl_newrec.id := :NEW.id;
vl_newrec.nom := :NEW.nom;
vl_newrec.prenom := :NEW.prenom;
vl_newrec.email := :NEW.email;

vl_oldrec.id := :OLD.id;
vl_oldrec.nom := :OLD.nom;
vl_oldrec.prenom := :OLD.prenom;
vl_oldrec.email := :OLD.email;
		Personne_TAPIs.autogen_column_upd(vl_newrec);
		Personne_TAPIs.autogen_column(vl_newrec);
		Personne_TAPIs.checktype_column(vl_newrec);
		Personne_TAPIs.uppercase_column(vl_newrec);
		Personne_TAPIs.column_PEA(vl_newrec);
		Personne_TAPIs.frozen_column(vl_newrec, vl_oldrec);

:NEW.id := vl_newrec.id;
:NEW.nom := vl_newrec.nom;
:NEW.prenom := vl_newrec.prenom;
:NEW.email := vl_newrec.email;
	END;
;
/
CREATE OR REPLACE TRIGGER Personne_BIU
BEFORE INSERT OR UPDATE ON Personnes

BEGIN

	NULL;
	-- Seulement si nécessaire!
 	-- select * bulk collect into Personne_TAPIs.vg_Personnes
 	-- from Personnes ;
END;
;
/
CREATE OR REPLACE TRIGGER Personne_BDR
	BEFORE DELETE ON Personnes FOR EACH ROW
	DECLARE
	 	vl_oldrec Personnes%ROWTYPE;

	BEGIN

vl_oldrec.id := :OLD.id;
vl_oldrec.nom := :OLD.nom;
vl_oldrec.prenom := :OLD.prenom;
vl_oldrec.email := :OLD.email;

	END;
;
/
CREATE OR REPLACE TRIGGER Personne_AIUD
	AFTER INSERT OR UPDATE OR DELETE ON Personnes
	DECLARE
	BEGIN
		Personne_TAPIs.tree_or_list_loop();
		Personne_TAPIs.tree_or_list_onlyone();
	END;
;
/
CREATE OR REPLACE TRIGGER Clef_BIR
	BEFORE INSERT ON Clefs FOR EACH ROW
	DECLARE
	vl_newrec Clefs%ROWTYPE;

	BEGIN

vl_newrec.id := :NEW.id;
vl_newrec.numero_de_serie := :NEW.numero_de_serie;
vl_newrec.status := :NEW.status;
		Clef_TAPIs.autogen_column_ins(vl_newrec);
		Clef_TAPIs.autogen_column(vl_newrec);
		Clef_TAPIs.checktype_column(vl_newrec);
		Clef_TAPIs.uppercase_column(vl_newrec);
		Clef_TAPIs.column_PEA(vl_newrec);

:NEW.id := vl_newrec.id;
:NEW.numero_de_serie := vl_newrec.numero_de_serie;
:NEW.status := vl_newrec.status;
	END;
;
/
CREATE OR REPLACE TRIGGER Clef_BUR
	BEFORE UPDATE ON Clefs FOR EACH ROW
	DECLARE
	vl_newrec Clefs%ROWTYPE;
	vl_oldrec Clefs%ROWTYPE;

	BEGIN

vl_newrec.id := :NEW.id;
vl_newrec.numero_de_serie := :NEW.numero_de_serie;
vl_newrec.status := :NEW.status;

vl_oldrec.id := :OLD.id;
vl_oldrec.numero_de_serie := :OLD.numero_de_serie;
vl_oldrec.status := :OLD.status;
		Clef_TAPIs.autogen_column_upd(vl_newrec);
		Clef_TAPIs.autogen_column(vl_newrec);
		Clef_TAPIs.checktype_column(vl_newrec);
		Clef_TAPIs.uppercase_column(vl_newrec);
		Clef_TAPIs.column_PEA(vl_newrec);
		Clef_TAPIs.frozen_column(vl_newrec, vl_oldrec);

:NEW.id := vl_newrec.id;
:NEW.numero_de_serie := vl_newrec.numero_de_serie;
:NEW.status := vl_newrec.status;
	END;
;
/
CREATE OR REPLACE TRIGGER Clef_BIU
BEFORE INSERT OR UPDATE ON Clefs

BEGIN

	NULL;
	-- Seulement si nécessaire!
 	-- select * bulk collect into Clef_TAPIs.vg_Clefs
 	-- from Clefs ;
END;
;
/
CREATE OR REPLACE TRIGGER Clef_BDR
	BEFORE DELETE ON Clefs FOR EACH ROW
	DECLARE
	 	vl_oldrec Clefs%ROWTYPE;

	BEGIN

vl_oldrec.id := :OLD.id;
vl_oldrec.numero_de_serie := :OLD.numero_de_serie;
vl_oldrec.status := :OLD.status;

	END;
;
/
CREATE OR REPLACE TRIGGER Clef_AIUD
	AFTER INSERT OR UPDATE OR DELETE ON Clefs
	DECLARE
	BEGIN
		Clef_TAPIs.tree_or_list_loop();
		Clef_TAPIs.tree_or_list_onlyone();
	END;
;
/
CREATE OR REPLACE TRIGGER Registre_BIR
	BEFORE INSERT ON Registre FOR EACH ROW
	DECLARE
	vl_newrec Registre%ROWTYPE;

	BEGIN

vl_newrec.Clef_id := :NEW.Clef_id;
vl_newrec.Personne_id := :NEW.Personne_id;
vl_newrec.iddep := :NEW.iddep;
vl_newrec.date_debut := :NEW.date_debut;
vl_newrec.date_fin := :NEW.date_fin;
		Registre_TAPIs.autogen_column_ins(vl_newrec);
		Registre_TAPIs.autogen_column(vl_newrec);
		Registre_TAPIs.checktype_column(vl_newrec);
		Registre_TAPIs.uppercase_column(vl_newrec);
		Registre_TAPIs.column_PEA(vl_newrec);

:NEW.Clef_id := vl_newrec.Clef_id;
:NEW.Personne_id := vl_newrec.Personne_id;
:NEW.iddep := vl_newrec.iddep;
:NEW.date_debut := vl_newrec.date_debut;
:NEW.date_fin := vl_newrec.date_fin;
	END;
;
/
CREATE OR REPLACE TRIGGER Registre_BUR
	BEFORE UPDATE ON Registre FOR EACH ROW
	DECLARE
	vl_newrec Registre%ROWTYPE;
	vl_oldrec Registre%ROWTYPE;

	BEGIN

vl_newrec.Clef_id := :NEW.Clef_id;
vl_newrec.Personne_id := :NEW.Personne_id;
vl_newrec.iddep := :NEW.iddep;
vl_newrec.date_debut := :NEW.date_debut;
vl_newrec.date_fin := :NEW.date_fin;

vl_oldrec.Clef_id := :OLD.Clef_id;
vl_oldrec.Personne_id := :OLD.Personne_id;
vl_oldrec.iddep := :OLD.iddep;
vl_oldrec.date_debut := :OLD.date_debut;
vl_oldrec.date_fin := :OLD.date_fin;
		Registre_TAPIs.autogen_column_upd(vl_newrec);
		Registre_TAPIs.autogen_column(vl_newrec);
		Registre_TAPIs.checktype_column(vl_newrec);
		Registre_TAPIs.uppercase_column(vl_newrec);
		Registre_TAPIs.column_PEA(vl_newrec);
		Registre_TAPIs.frozen_column(vl_newrec, vl_oldrec);

:NEW.Clef_id := vl_newrec.Clef_id;
:NEW.Personne_id := vl_newrec.Personne_id;
:NEW.iddep := vl_newrec.iddep;
:NEW.date_debut := vl_newrec.date_debut;
:NEW.date_fin := vl_newrec.date_fin;
	END;
;
/
CREATE OR REPLACE TRIGGER Registre_BIU
BEFORE INSERT OR UPDATE ON Registre

BEGIN

	NULL;
	-- Seulement si nécessaire!
 	-- select * bulk collect into Registre_TAPIs.vg_Registre
 	-- from Registre ;
END;
;
/
CREATE OR REPLACE TRIGGER Registre_BDR
	BEFORE DELETE ON Registre FOR EACH ROW
	DECLARE
	 	vl_oldrec Registre%ROWTYPE;

	BEGIN

vl_oldrec.Clef_id := :OLD.Clef_id;
vl_oldrec.Personne_id := :OLD.Personne_id;
vl_oldrec.iddep := :OLD.iddep;
vl_oldrec.date_debut := :OLD.date_debut;
vl_oldrec.date_fin := :OLD.date_fin;

	END;
;
/
CREATE OR REPLACE TRIGGER Registre_AIUD
	AFTER INSERT OR UPDATE OR DELETE ON Registre
	DECLARE
	BEGIN
		Registre_TAPIs.tree_or_list_loop();
		Registre_TAPIs.tree_or_list_onlyone();
	END;
;
/
CREATE OR REPLACE TRIGGER Lieu_BIR
	BEFORE INSERT ON Lieux FOR EACH ROW
	DECLARE
	vl_newrec Lieux%ROWTYPE;

	BEGIN

vl_newrec.id := :NEW.id;
vl_newrec.Lieu_contient_id := :NEW.Lieu_contient_id;
vl_newrec.nom := :NEW.nom;
		Lieu_TAPIs.autogen_column_ins(vl_newrec);
		Lieu_TAPIs.autogen_column(vl_newrec);
		Lieu_TAPIs.checktype_column(vl_newrec);
		Lieu_TAPIs.uppercase_column(vl_newrec);
		Lieu_TAPIs.column_PEA(vl_newrec);

:NEW.id := vl_newrec.id;
:NEW.Lieu_contient_id := vl_newrec.Lieu_contient_id;
:NEW.nom := vl_newrec.nom;
	END;
;
/
CREATE OR REPLACE TRIGGER Lieu_BUR
	BEFORE UPDATE ON Lieux FOR EACH ROW
	DECLARE
	vl_newrec Lieux%ROWTYPE;
	vl_oldrec Lieux%ROWTYPE;

	BEGIN

vl_newrec.id := :NEW.id;
vl_newrec.Lieu_contient_id := :NEW.Lieu_contient_id;
vl_newrec.nom := :NEW.nom;

vl_oldrec.id := :OLD.id;
vl_oldrec.Lieu_contient_id := :OLD.Lieu_contient_id;
vl_oldrec.nom := :OLD.nom;
		Lieu_TAPIs.autogen_column_upd(vl_newrec);
		Lieu_TAPIs.autogen_column(vl_newrec);
		Lieu_TAPIs.checktype_column(vl_newrec);
		Lieu_TAPIs.uppercase_column(vl_newrec);
		Lieu_TAPIs.column_PEA(vl_newrec);
		Lieu_TAPIs.frozen_column(vl_newrec, vl_oldrec);

:NEW.id := vl_newrec.id;
:NEW.Lieu_contient_id := vl_newrec.Lieu_contient_id;
:NEW.nom := vl_newrec.nom;
	END;
;
/
CREATE OR REPLACE TRIGGER Lieu_BIU
BEFORE INSERT OR UPDATE ON Lieux

BEGIN

	NULL;
	-- Seulement si nécessaire!
 	-- select * bulk collect into Lieu_TAPIs.vg_Lieux
 	-- from Lieux ;
END;
;
/
CREATE OR REPLACE TRIGGER Lieu_BDR
	BEFORE DELETE ON Lieux FOR EACH ROW
	DECLARE
	 	vl_oldrec Lieux%ROWTYPE;

	BEGIN

vl_oldrec.id := :OLD.id;
vl_oldrec.Lieu_contient_id := :OLD.Lieu_contient_id;
vl_oldrec.nom := :OLD.nom;

	END;
;
/
CREATE OR REPLACE TRIGGER Lieu_AIUD
	AFTER INSERT OR UPDATE OR DELETE ON Lieux
	DECLARE
	BEGIN
		Lieu_TAPIs.tree_or_list_loop();
		Lieu_TAPIs.tree_or_list_onlyone();
	END;
;
/
CREATE OR REPLACE TRIGGER Serrure_BIR
	BEFORE INSERT ON Serrures FOR EACH ROW
	DECLARE
	vl_newrec Serrures%ROWTYPE;

	BEGIN

vl_newrec.id := :NEW.id;
vl_newrec.Lieu_verouille_id := :NEW.Lieu_verouille_id;
vl_newrec.cardinalite := :NEW.cardinalite;
		Serrure_TAPIs.autogen_column_ins(vl_newrec);
		Serrure_TAPIs.autogen_column(vl_newrec);
		Serrure_TAPIs.checktype_column(vl_newrec);
		Serrure_TAPIs.uppercase_column(vl_newrec);
		Serrure_TAPIs.column_PEA(vl_newrec);

:NEW.id := vl_newrec.id;
:NEW.Lieu_verouille_id := vl_newrec.Lieu_verouille_id;
:NEW.cardinalite := vl_newrec.cardinalite;
	END;
;
/
CREATE OR REPLACE TRIGGER Serrure_BUR
	BEFORE UPDATE ON Serrures FOR EACH ROW
	DECLARE
	vl_newrec Serrures%ROWTYPE;
	vl_oldrec Serrures%ROWTYPE;

	BEGIN

vl_newrec.id := :NEW.id;
vl_newrec.Lieu_verouille_id := :NEW.Lieu_verouille_id;
vl_newrec.cardinalite := :NEW.cardinalite;

vl_oldrec.id := :OLD.id;
vl_oldrec.Lieu_verouille_id := :OLD.Lieu_verouille_id;
vl_oldrec.cardinalite := :OLD.cardinalite;
		Serrure_TAPIs.autogen_column_upd(vl_newrec);
		Serrure_TAPIs.autogen_column(vl_newrec);
		Serrure_TAPIs.checktype_column(vl_newrec);
		Serrure_TAPIs.uppercase_column(vl_newrec);
		Serrure_TAPIs.column_PEA(vl_newrec);
		Serrure_TAPIs.frozen_column(vl_newrec, vl_oldrec);

:NEW.id := vl_newrec.id;
:NEW.Lieu_verouille_id := vl_newrec.Lieu_verouille_id;
:NEW.cardinalite := vl_newrec.cardinalite;
	END;
;
/
CREATE OR REPLACE TRIGGER Serrure_BIU
BEFORE INSERT OR UPDATE ON Serrures

BEGIN

	NULL;
	-- Seulement si nécessaire!
 	-- select * bulk collect into Serrure_TAPIs.vg_Serrures
 	-- from Serrures ;
END;
;
/
CREATE OR REPLACE TRIGGER Serrure_BDR
	BEFORE DELETE ON Serrures FOR EACH ROW
	DECLARE
	 	vl_oldrec Serrures%ROWTYPE;

	BEGIN

vl_oldrec.id := :OLD.id;
vl_oldrec.Lieu_verouille_id := :OLD.Lieu_verouille_id;
vl_oldrec.cardinalite := :OLD.cardinalite;

	END;
;
/
CREATE OR REPLACE TRIGGER Serrure_AIUD
	AFTER INSERT OR UPDATE OR DELETE ON Serrures
	DECLARE
	BEGIN
		Serrure_TAPIs.tree_or_list_loop();
		Serrure_TAPIs.tree_or_list_onlyone();
	END;
;
/
CREATE OR REPLACE TRIGGER Histo_BIR
	BEFORE INSERT ON Historiques FOR EACH ROW
	DECLARE
	vl_newrec Historiques%ROWTYPE;

	BEGIN

vl_newrec.Serrure_id := :NEW.Serrure_id;
vl_newrec.Clef_id := :NEW.Clef_id;
vl_newrec.iddep := :NEW.iddep;
vl_newrec.date_utilisation := :NEW.date_utilisation;
		Histo_TAPIs.autogen_column_ins(vl_newrec);
		Histo_TAPIs.autogen_column(vl_newrec);
		Histo_TAPIs.checktype_column(vl_newrec);
		Histo_TAPIs.uppercase_column(vl_newrec);
		Histo_TAPIs.column_PEA(vl_newrec);

:NEW.Serrure_id := vl_newrec.Serrure_id;
:NEW.Clef_id := vl_newrec.Clef_id;
:NEW.iddep := vl_newrec.iddep;
:NEW.date_utilisation := vl_newrec.date_utilisation;
	END;
;
/
CREATE OR REPLACE TRIGGER Histo_BUR
	BEFORE UPDATE ON Historiques FOR EACH ROW
	DECLARE
	vl_newrec Historiques%ROWTYPE;
	vl_oldrec Historiques%ROWTYPE;

	BEGIN

vl_newrec.Serrure_id := :NEW.Serrure_id;
vl_newrec.Clef_id := :NEW.Clef_id;
vl_newrec.iddep := :NEW.iddep;
vl_newrec.date_utilisation := :NEW.date_utilisation;

vl_oldrec.Serrure_id := :OLD.Serrure_id;
vl_oldrec.Clef_id := :OLD.Clef_id;
vl_oldrec.iddep := :OLD.iddep;
vl_oldrec.date_utilisation := :OLD.date_utilisation;
		Histo_TAPIs.autogen_column_upd(vl_newrec);
		Histo_TAPIs.autogen_column(vl_newrec);
		Histo_TAPIs.checktype_column(vl_newrec);
		Histo_TAPIs.uppercase_column(vl_newrec);
		Histo_TAPIs.column_PEA(vl_newrec);
		Histo_TAPIs.frozen_column(vl_newrec, vl_oldrec);

:NEW.Serrure_id := vl_newrec.Serrure_id;
:NEW.Clef_id := vl_newrec.Clef_id;
:NEW.iddep := vl_newrec.iddep;
:NEW.date_utilisation := vl_newrec.date_utilisation;
	END;
;
/
CREATE OR REPLACE TRIGGER Histo_BIU
BEFORE INSERT OR UPDATE ON Historiques

BEGIN

	NULL;
	-- Seulement si nécessaire!
 	-- select * bulk collect into Histo_TAPIs.vg_Historiques
 	-- from Historiques ;
END;
;
/
CREATE OR REPLACE TRIGGER Histo_BDR
	BEFORE DELETE ON Historiques FOR EACH ROW
	DECLARE
	 	vl_oldrec Historiques%ROWTYPE;

	BEGIN

vl_oldrec.Serrure_id := :OLD.Serrure_id;
vl_oldrec.Clef_id := :OLD.Clef_id;
vl_oldrec.iddep := :OLD.iddep;
vl_oldrec.date_utilisation := :OLD.date_utilisation;

	END;
;
/
CREATE OR REPLACE TRIGGER Histo_AIUD
	AFTER INSERT OR UPDATE OR DELETE ON Historiques
	DECLARE
	BEGIN
		Histo_TAPIs.tree_or_list_loop();
		Histo_TAPIs.tree_or_list_onlyone();
	END;
;
/
CREATE OR REPLACE TRIGGER fais_BIR
	BEFORE INSERT ON fais_partie_de FOR EACH ROW
	DECLARE
	vl_newrec fais_partie_de%ROWTYPE;

	BEGIN

vl_newrec.Groupe_parent_id := :NEW.Groupe_parent_id;
vl_newrec.Groupe_enfant_id := :NEW.Groupe_enfant_id;
		fais_TAPIs.autogen_column_ins(vl_newrec);
		fais_TAPIs.autogen_column(vl_newrec);
		fais_TAPIs.checktype_column(vl_newrec);
		fais_TAPIs.uppercase_column(vl_newrec);
		fais_TAPIs.column_PEA(vl_newrec);

:NEW.Groupe_parent_id := vl_newrec.Groupe_parent_id;
:NEW.Groupe_enfant_id := vl_newrec.Groupe_enfant_id;
	END;
;
/
CREATE OR REPLACE TRIGGER fais_BUR
	BEFORE UPDATE ON fais_partie_de FOR EACH ROW
	DECLARE
	vl_newrec fais_partie_de%ROWTYPE;
	vl_oldrec fais_partie_de%ROWTYPE;

	BEGIN

vl_newrec.Groupe_parent_id := :NEW.Groupe_parent_id;
vl_newrec.Groupe_enfant_id := :NEW.Groupe_enfant_id;

vl_oldrec.Groupe_parent_id := :OLD.Groupe_parent_id;
vl_oldrec.Groupe_enfant_id := :OLD.Groupe_enfant_id;
		fais_TAPIs.autogen_column_upd(vl_newrec);
		fais_TAPIs.autogen_column(vl_newrec);
		fais_TAPIs.checktype_column(vl_newrec);
		fais_TAPIs.uppercase_column(vl_newrec);
		fais_TAPIs.column_PEA(vl_newrec);
		fais_TAPIs.frozen_column(vl_newrec, vl_oldrec);

:NEW.Groupe_parent_id := vl_newrec.Groupe_parent_id;
:NEW.Groupe_enfant_id := vl_newrec.Groupe_enfant_id;
	END;
;
/
CREATE OR REPLACE TRIGGER fais_BIU
BEFORE INSERT OR UPDATE ON fais_partie_de

BEGIN

	NULL;
	-- Seulement si nécessaire!
 	-- select * bulk collect into fais_TAPIs.vg_fais_partie_de
 	-- from fais_partie_de ;
END;
;
/
CREATE OR REPLACE TRIGGER fais_BDR
	BEFORE DELETE ON fais_partie_de FOR EACH ROW
	DECLARE
	 	vl_oldrec fais_partie_de%ROWTYPE;

	BEGIN

vl_oldrec.Groupe_parent_id := :OLD.Groupe_parent_id;
vl_oldrec.Groupe_enfant_id := :OLD.Groupe_enfant_id;

	END;
;
/
CREATE OR REPLACE TRIGGER fais_AIUD
	AFTER INSERT OR UPDATE OR DELETE ON fais_partie_de
	DECLARE
	BEGIN
		fais_TAPIs.tree_or_list_loop();
		fais_TAPIs.tree_or_list_onlyone();
	END;
;
/
