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
