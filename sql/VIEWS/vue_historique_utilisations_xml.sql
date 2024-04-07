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