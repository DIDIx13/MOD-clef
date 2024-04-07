-- Insertions pour la table Personnes
INSERT INTO Personnes (uuid, nom, prenom, email) VALUES ('1a2b3c4d-5e6f-7a8b-9c0d-1e2f3a4b5c6d', 'Durand', 'Sophie', 'sophie.durand@he-arc.ch');
INSERT INTO Personnes (uuid, nom, prenom, email) VALUES ('6f8b7c9d-0e1f-2a3b-4c5d-6e7f8g9h0i1j', 'Petit', 'Jean', 'jean.petit@he-arc.ch');

-- Insertions pour la table Groupes
INSERT INTO Groupes (uuid, nom, description) VALUES ('12345678-1234-1234-1234-1234567890ab', 'HE-Arc Informatique', 'Département Informatique de la HE-Arc');
INSERT INTO Groupes (uuid, nom, description) VALUES ('abcdefab-abcd-abcd-abcd-abcdefabcdef', 'HE-Arc Ingénierie', 'Département Ingénierie de la HE-Arc');

-- Insertions pour la table Lieux
INSERT INTO Lieux (uuid, nom, parent_uuid) VALUES ('456e1234-e89b-12d3-a456-426614174000', 'Campus Arc 1', NULL);
INSERT INTO Lieux (uuid, nom, parent_uuid) VALUES ('789e1234-e89b-12d3-a456-426614174001', '1er Étage', '456e1234-e89b-12d3-a456-426614174000');
INSERT INTO Lieux (uuid, nom, parent_uuid) VALUES ('123f4567-e89b-12d3-a456-426614174001', 'Classe A101', '789e1234-e89b-12d3-a456-426614174001');
INSERT INTO Lieux (uuid, nom, parent_uuid) VALUES ('234g5678-e89b-12d3-a456-426614174002', 'Classe A102', '789e1234-e89b-12d3-a456-426614174001');
INSERT INTO Lieux (uuid, nom, parent_uuid) VALUES ('321e6789-e89b-12d3-a456-426614174000', 'Campus Arc 2', NULL);
INSERT INTO Lieux (uuid, nom, parent_uuid) VALUES ('890f1234-e89b-12d3-a456-426614174003', 'Rez-de-chaussée', '321e6789-e89b-12d3-a456-426614174000');
INSERT INTO Lieux (uuid, nom, parent_uuid) VALUES ('345h6789-e89b-12d3-a456-426614174004', 'Classe B001', '890f1234-e89b-12d3-a456-426614174003');
INSERT INTO Lieux (uuid, nom, parent_uuid) VALUES ('456i7890-e89b-12d3-a456-426614174005', 'Classe B002', '890f1234-e89b-12d3-a456-426614174003');

-- Insertions pour la table Serrures
INSERT INTO Serrures (uuid, cardinalite, lieu_ref_uuid) VALUES ('111a222b-333c-444d-555e-666f777g888h', 'NORD', '456e1234-e89b-12d3-a456-426614174000');
INSERT INTO Serrures (uuid, cardinalite, lieu_ref_uuid) VALUES ('999a888b-777c-666d-555e-444f333g222h', 'EST', '321e6789-e89b-12d3-a456-426614174000');

-- Insertions pour la table Clefs
INSERT INTO Clefs (uuid, numero_de_serie, status) VALUES ('aaaabbbb-cccc-dddd-eeee-ffff00001111', 'ABC123456', 'ACTIVE');
INSERT INTO Clefs (uuid, numero_de_serie, status) VALUES ('22223333-4444-5555-6666-777788889999', 'XYZ654321', 'INACTIVE');

-- Insertions pour la table Acces
INSERT INTO Acces (uuid, groupe_ref_uuid, lieu_ref_uuid, dateDebut, dateFin) VALUES ('acces1-uuid-0000-0000-000000000000', '12345678-1234-1234-1234-1234567890ab', '456e1234-e89b-12d3-a456-426614174000', TO_TIMESTAMP('2024-03-01 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-03-01 18:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO Acces (uuid, groupe_ref_uuid, lieu_ref_uuid, dateDebut, dateFin) VALUES ('acces2-uuid-1111-1111-111111111111', 'abcdefab-abcd-abcd-abcd-abcdefabcdef', '321e6789-e89b-12d3-a456-426614174000', TO_TIMESTAMP('2024-03-02 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-03-02 18:00:00', 'YYYY-MM-DD HH24:MI:SS'));

-- Insertions pour la table HistoriqueUtilisations
INSERT INTO HistoriqueUtilisations (uuid, clef_ref_uuid, serrure_ref_uuid, personne_ref_uuid, dateUtilisation) VALUES ('a1b2c3d4-e5f6-g7h8-i9j0-k1l2m3n4o5p6', 'aaaabbbb-cccc-dddd-eeee-ffff00001111', '111a222b-333c-444d-555e-666f777g888h', '1a2b3c4d-5e6f-7a8b-9c0d-1e2f3a4b5c6d', TO_TIMESTAMP('2024-03-26 15:30:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO HistoriqueUtilisations (uuid, clef_ref_uuid, serrure_ref_uuid, personne_ref_uuid, dateUtilisation) VALUES ('p6o5n4m3-l2k1-j0i9-h8g7-f6e5d4c3b2a1', '22223333-4444-5555-6666-777788889999', '999a888b-777c-666d-555e-444f333g222h', '6f8b7c9d-0e1f-2a3b-4c5d-6e7f8g9h0i1j', TO_TIMESTAMP('2024-03-27 10:15:00', 'YYYY-MM-DD HH24:MI:SS'));

-- Insertions pour la table Registres
INSERT INTO Registres (uuid, personne_ref_uuid, clef_ref_uuid, dateDebut, dateFin) VALUES ('reg-001-uuid-0000-0000-000000000001', '1a2b3c4d-5e6f-7a8b-9c0d-1e2f3a4b5c6d', 'aaaabbbb-cccc-dddd-eeee-ffff00001111', TO_DATE('2024-03-01', 'YYYY-MM-DD'), TO_DATE('2024-03-31', 'YYYY-MM-DD'));
INSERT INTO Registres (uuid, personne_ref_uuid, clef_ref_uuid, acces_ref_uuid, dateDebut, dateFin) VALUES ('reg-002-uuid-1111-1111-111111111112', '6f8b7c9d-0e1f-2a3b-4c5d-6e7f8g9h0i1j', '22223333-4444-5555-6666-777788889999', 'acces1-uuid-0000-0000-000000000000', TO_DATE('2024-04-01', 'YYYY-MM-DD'), TO_DATE('2024-04-30', 'YYYY-MM-DD'));

-- Insertions pour la table FAIS_PARTIE_DE
INSERT INTO FAIS_PARTIE_DE (personne_uuid, groupe_uuid) VALUES ('1a2b3c4d-5e6f-7a8b-9c0d-1e2f3a4b5c6d', '12345678-1234-1234-1234-1234567890ab');
INSERT INTO FAIS_PARTIE_DE (personne_uuid, groupe_uuid) VALUES ('1a2b3c4d-5e6f-7a8b-9c0d-1e2f3a4b5c6d', 'abcdefab-abcd-abcd-abcd-abcdefabcdef');
INSERT INTO FAIS_PARTIE_DE (personne_uuid, groupe_uuid) VALUES ('6f8b7c9d-0e1f-2a3b-4c5d-6e7f8g9h0i1j', '12345678-1234-1234-1234-1234567890ab');
INSERT INTO FAIS_PARTIE_DE (personne_uuid, groupe_uuid) VALUES ('6f8b7c9d-0e1f-2a3b-4c5d-6e7f8g9h0i1j', 'abcdefab-abcd-abcd-abcd-abcdefabcdef');

-- # TODO utiliser les seq