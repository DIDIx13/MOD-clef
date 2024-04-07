-- Le reste du ddl est trouvable dans MOD-clef/MPD/MODclef.ddl

-- Table de journalisation xml
CREATE TABLE journal_xml (
    numero NUMBER(9) NOT NULL,
    xml_data CLOB,
    generation_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    description VARCHAR2(255),
    CONSTRAINT PK_journal_xml PRIMARY KEY (numero)
);

CREATE SEQUENCE seq_journal_xml START WITH 1 INCREMENT BY 1;
