-- Insertions pour les groupes parents
INSERT INTO Groupes (id, nom, description) VALUES (Groupe_SEQPK.NEXTVAL, 'HE-Arc', 'Groupe parent de l''école HE-Arc');
INSERT INTO Groupes (id, nom, description) VALUES (Groupe_SEQPK.NEXTVAL, 'Gestion', 'Sous-groupe Gestion de HE-Arc');
INSERT INTO Groupes (id, nom, description) VALUES (Groupe_SEQPK.NEXTVAL, 'Ingénierie', 'Sous-groupe Ingénierie de HE-Arc');

-- Insertions pour les groupes personnels
INSERT INTO Groupes (id, nom, description) VALUES (Groupe_SEQPK.NEXTVAL, 'Durand', 'Groupe personnel de Sophie Durand');
INSERT INTO Groupes (id, nom, description) VALUES (Groupe_SEQPK.NEXTVAL, 'Petit', 'Groupe personnel de Jean Petit');

-- Insertions pour la table Personnes
INSERT INTO Personnes (id, Groupe_membre_de_id, nom, prenom, email) VALUES (Personne_SEQPK.NEXTVAL, (SELECT id FROM Groupes WHERE nom = 'Durand'), 'Durand', 'Sophie', 'sophie.durand@he-arc.ch');
INSERT INTO Personnes (id, Groupe_membre_de_id, nom, prenom, email) VALUES (Personne_SEQPK.NEXTVAL, (SELECT id FROM Groupes WHERE nom = 'Petit'), 'Petit', 'Jean', 'jean.petit@he-arc.ch');

-- Insertions pour la table Lieux
INSERT INTO Lieux (id, nom, Lieu_contient_id) VALUES (Lieu_SEQPK.NEXTVAL, 'Campus Arc 1', NULL);
INSERT INTO Lieux (id, nom, Lieu_contient_id) VALUES (Lieu_SEQPK.NEXTVAL, '1er Étage', (SELECT id FROM Lieux WHERE nom = 'Campus Arc 1'));
INSERT INTO Lieux (id, nom, Lieu_contient_id) VALUES (Lieu_SEQPK.NEXTVAL, 'Classe A101', (SELECT id FROM Lieux WHERE nom = '1er Étage'));
INSERT INTO Lieux (id, nom, Lieu_contient_id) VALUES (Lieu_SEQPK.NEXTVAL, 'Classe A102', (SELECT id FROM Lieux WHERE nom = '1er Étage'));
INSERT INTO Lieux (id, nom, Lieu_contient_id) VALUES (Lieu_SEQPK.NEXTVAL, 'Campus Arc 2', NULL);
INSERT INTO Lieux (id, nom, Lieu_contient_id) VALUES (Lieu_SEQPK.NEXTVAL, 'Rez-de-chaussée', (SELECT id FROM Lieux WHERE nom = 'Campus Arc 2'));
INSERT INTO Lieux (id, nom, Lieu_contient_id) VALUES (Lieu_SEQPK.NEXTVAL, 'Classe B001', (SELECT id FROM Lieux WHERE nom = 'Rez-de-chaussée'));
INSERT INTO Lieux (id, nom, Lieu_contient_id) VALUES (Lieu_SEQPK.NEXTVAL, 'Classe B002', (SELECT id FROM Lieux WHERE nom = 'Rez-de-chaussée'));

-- Insertions pour la table Serrures
INSERT INTO Serrures (id, cardinalite, Lieu_verouille_id) VALUES (Serrure_SEQPK.NEXTVAL, 'NORD', (SELECT id FROM Lieux WHERE nom = 'Campus Arc 1'));
INSERT INTO Serrures (id, cardinalite, Lieu_verouille_id) VALUES (Serrure_SEQPK.NEXTVAL, 'EST', (SELECT id FROM Lieux WHERE nom = 'Campus Arc 2'));

-- Insertions pour la table Clefs
INSERT INTO Clefs (id, numero_de_serie, status) VALUES (Clef_SEQPK.NEXTVAL, 'ABC123456', 'ACTIVE');
INSERT INTO Clefs (id, numero_de_serie, status) VALUES (Clef_SEQPK.NEXTVAL, 'XYZ654321', 'INACTIVE');

-- Insertions pour la table Acces
INSERT INTO Acces (iddep, Groupe_id, Lieu_id, date_debut, date_fin) VALUES (Acces_SEQPK.NEXTVAL, (SELECT id FROM Groupes WHERE nom = 'Gestion'), (SELECT id FROM Lieux WHERE nom = 'Campus Arc 1'), TO_TIMESTAMP('2024-03-01 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-03-01 18:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO Acces (iddep, Groupe_id, Lieu_id, date_debut, date_fin) VALUES (Acces_SEQPK.NEXTVAL, (SELECT id FROM Groupes WHERE nom = 'Ingénierie'), (SELECT id FROM Lieux WHERE nom = 'Campus Arc 2'), TO_TIMESTAMP('2024-03-02 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-03-02 18:00:00', 'YYYY-MM-DD HH24:MI:SS'));

-- Insertions pour la table Historiques
INSERT INTO Historiques (iddep, Serrure_id, Clef_id, date_utilisation) VALUES (Histo_SEQPK.NEXTVAL, (SELECT id FROM Serrures WHERE cardinalite = 'NORD'), (SELECT id FROM Clefs WHERE numero_de_serie = 'ABC123456'), TO_TIMESTAMP('2024-03-26 15:30:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO Historiques (iddep, Serrure_id, Clef_id, date_utilisation) VALUES (Histo_SEQPK.NEXTVAL, (SELECT id FROM Serrures WHERE cardinalite = 'EST'), (SELECT id FROM Clefs WHERE numero_de_serie = 'XYZ654321'), TO_TIMESTAMP('2024-03-27 10:15:00', 'YYYY-MM-DD HH24:MI:SS'));

-- Insertions pour la table Registre
INSERT INTO Registre (iddep, Clef_id, Personne_id, date_debut, date_fin) VALUES (Registre_SEQPK.NEXTVAL, (SELECT id FROM Clefs WHERE numero_de_serie = 'ABC123456'), (SELECT id FROM Personnes WHERE nom = 'Durand' AND prenom = 'Sophie'), TO_DATE('2024-03-01', 'YYYY-MM-DD'), TO_DATE('2024-03-31', 'YYYY-MM-DD'));
INSERT INTO Registre (iddep, Clef_id, Personne_id, date_debut, date_fin) VALUES (Registre_SEQPK.NEXTVAL, (SELECT id FROM Clefs WHERE numero_de_serie = 'XYZ654321'), (SELECT id FROM Personnes WHERE nom = 'Petit' AND prenom = 'Jean'), TO_DATE('2024-04-01', 'YYYY-MM-DD'), TO_DATE('2024-04-30', 'YYYY-MM-DD'));

-- Insertions pour la table FAIS_PARTIE_DE
INSERT INTO fais_partie_de (Groupe_parent_id, Groupe_enfant_id) VALUES ((SELECT id FROM Groupes WHERE nom = 'HE-Arc'), (SELECT id FROM Groupes WHERE nom = 'Gestion'));
INSERT INTO fais_partie_de (Groupe_parent_id, Groupe_enfant_id) VALUES ((SELECT id FROM Groupes WHERE nom = 'HE-Arc'), (SELECT id FROM Groupes WHERE nom = 'Ingénierie'));
INSERT INTO fais_partie_de (Groupe_parent_id, Groupe_enfant_id) VALUES ((SELECT id FROM Groupes WHERE nom = 'Gestion'), (SELECT id FROM Groupes WHERE nom = 'Petit'));
INSERT INTO fais_partie_de (Groupe_parent_id, Groupe_enfant_id) VALUES ((SELECT id FROM Groupes WHERE nom = 'Ingénierie'), (SELECT id FROM Groupes WHERE nom = 'Durand'));


-- Génération xml de la liste des personnes par groupes
INSERT INTO journal_xml (numero, xml_data, description)
SELECT seq_journal_xml.NEXTVAL, xml_data, 'Liste des personnes par groupes'
FROM vue_personnes_groupes_xml;

-- Génération xml de l'historique d'utilisation des clefs
INSERT INTO journal_xml (numero, xml_data, description)
SELECT seq_journal_xml.NEXTVAL, xml_data, 'Historique d''utilisation des clefs'
FROM vue_historique_utilisations_xml;
