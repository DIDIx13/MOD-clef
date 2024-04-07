-- Vue pour la Liste des Personnes par Groupe
CREATE OR REPLACE VIEW Vue_PersonnesParGroupe AS
SELECT 
    g.nom AS NomGroupe,
    XMLAGG(
        XMLELEMENT(
            "Personne",
            XMLFOREST(
                p.nom AS "Nom",
                p.prenom AS "Prenom",
                p.email AS "Email"
            )
        )
    ) AS Membres
FROM 
    Personnes p
JOIN 
    FAIS_PARTIE_DE fpd ON p.uuid = fpd.personne_uuid
JOIN 
    Groupes g ON fpd.groupe_uuid = g.uuid
GROUP BY 
    g.nom;
