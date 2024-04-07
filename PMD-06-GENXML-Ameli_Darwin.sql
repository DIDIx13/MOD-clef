-- Vue pour la Liste des Personnes par Groupe
CREATE OR REPLACE VIEW vue_personnes_groupes_xml AS
SELECT XMLAgg(
        XMLElement("Groupe",
            XMLAttributes(g.uuid AS "ID", g.nom AS "NomGroupe"),
            (SELECT XMLAgg(
                XMLElement("Personne",
                    XMLAttributes(p.uuid AS "ID"),
                    XMLElement("Nom", p.nom),
                    XMLElement("Prenom", p.prenom),
                    XMLElement("Email", p.email)
                )
             )
             FROM Personnes p
             JOIN FAIS_PARTIE_DE fpd ON p.uuid = fpd.personne_uuid
             WHERE fpd.groupe_uuid = g.uuid)
        )
    ).getClobVal() AS xml_data
FROM Groupes g;

-- Vue pour l'Historique d'Utilisation des Clefs (Ne fonctionne pas encore)
/*CREATE OR REPLACE VIEW vue_historique_clefs_xml AS
SELECT XMLAgg(
        XMLElement("Historique",
            XMLAttributes(Historiques.id AS "ID"),
            XMLForest(
                Serrures.id AS "SerrureID",
                Serrures.cardinalite AS "Cardinalite",
                Clefs.id AS "ClefID",
                Clefs.numero_de_serie AS "NumeroSerie",
                TO_CHAR(Historiques.date_utilisation, 'YYYY-MM-DD HH24:MI:SS') AS "DateUtilisation"
            )
        )
    ).getClobVal() AS xml_data
FROM Historiques
JOIN Serrures ON Historiques.Serrure_id = Serrures.id
JOIN Clefs ON Historiques.Clef_id = Clefs.id;
*/

-- Génération xml de la liste des personnes par groupes
INSERT INTO journal_xml (numero, xml_data, description)
SELECT seq_journal_xml.NEXTVAL, xml_data, 'Liste des personnes par groupes'
FROM vue_personnes_groupes_xml;

-- Génération xml de l'historique d'utilisation des clefs (Ne fonctionne pas encore)
-- INSERT INTO journal_xml (numero, xml_data, description)
-- SELECT seq_journal_xml.NEXTVAL, xml_data, 'Historique d''utilisation des clefs'
-- FROM vue_historique_utilisations_xml;
