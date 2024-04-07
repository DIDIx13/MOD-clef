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

-- Vue pour l'Historique d'Utilisation des Clefs
CREATE OR REPLACE VIEW Vue_HistoriqueUtilisations AS
SELECT 
    XMLAGG(
        XMLELEMENT(
            "Utilisation",
            XMLFOREST(
                p.nom AS "NomPersonne",
                p.prenom AS "PrenomPersonne",
                c.numero_de_serie AS "NumeroSerieClef",
                s.cardinalite AS "Serrure",
                hu.dateUtilisation AS "DateUtilisation"
            )
        )
    ) AS Historique
FROM 
    HistoriqueUtilisations hu
JOIN 
    Personnes p ON hu.personne_ref_uuid = p.uuid
JOIN 
    Clefs c ON hu.clef_ref_uuid = c.uuid
JOIN 
    Serrures s ON hu.serrure_ref_uuid = s.uuid;