-- Vue pour l'Historique d'Utilisation des Clefs (Ne fonctionne pas encore)
CREATE OR REPLACE VIEW vue_historique_clefs_xml AS
SELECT XMLAgg(
        XMLElement("Historique",
            XMLAttributes(h.id AS "ID"),
            XMLForest(
                s.id AS "SerrureID",
                s.cardinalite AS "Cardinalite",
                c.id AS "ClefID",
                c.numero_de_serie AS "NumeroSerie",
                TO_CHAR(h.date_utilisation, 'YYYY-MM-DD HH24:MI:SS') AS "DateUtilisation"
            )
        )
    ).getClobVal() AS xml_data
FROM Historiques h
JOIN Serrures s ON h.serrure_id = s.id
JOIN Clefs c ON h.clef_id = c.id;
