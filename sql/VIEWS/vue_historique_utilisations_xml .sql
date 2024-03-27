CREATE OR REPLACE VIEW vue_historique_utilisations_xml AS
SELECT XMLElement("HistoriquesUtilisations",
         XMLAgg(
           XMLElement("HistoriqueUtilisation",
             XMLAttributes(hu.uuid AS "ID"),
             XMLElement("Clef",
               XMLForest(c.numero_de_serie AS "NumeroDeSerie", c.status AS "Status")
             ),
             XMLElement("Serrure",
               XMLForest(s.cardinalite AS "Cardinalite")
             ),
             XMLElement("Utilisateur",
               (SELECT XMLElement("NomComplet", p.nom || ' ' || p.prenom)
                FROM Personnes p
                WHERE p.uuid = hu.PersonneRef)
             ),
             XMLElement("DateUtilisation", hu.dateUtilisation)
           )
         )
       ).getClobVal() AS xml_data
FROM HistoriqueUtilisations hu
JOIN Clefs c ON hu.ClefRef = c.uuid
JOIN Serrures s ON hu.SerrureRef = s.uuid;
