CREATE OR REPLACE VIEW vue_personnes_groupes_xml AS
SELECT XMLElement("Personnes",
         XMLAgg(
           XMLElement("Personne",
             XMLAttributes(p.uuid AS "ID"),
             XMLElement("Nom", p.nom),
             XMLElement("Prenom", p.prenom),
             XMLElement("Email", p.email),
             XMLElement("Groupe",
               (SELECT XMLElement("Nom", g.nom)
                FROM Groupes g
                WHERE g.uuid = p.GroupeRef)
             )
           )
         )
       ).getClobVal() AS xml_data
FROM Personnes p;
