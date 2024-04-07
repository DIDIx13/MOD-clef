-- Vue pour la Liste des Personnes par Groupe
CREATE OR REPLACE VIEW vue_personnes_groupes_xml AS
WITH hierarchy AS (
  SELECT  CONNECT_BY_ROOT f.Groupe_parent_id AS root_id,
          f.Groupe_enfant_id AS current_id,
          g.nom AS nom_groupe,
          LEVEL AS lvl
  FROM    fais_partie_de f
  JOIN    Groupes g ON f.Groupe_enfant_id = g.id
  CONNECT BY PRIOR f.Groupe_enfant_id = f.Groupe_parent_id
)
SELECT XMLElement("Groupes",
  XMLAgg(
    XMLElement("Groupe",
      XMLAttributes(h.root_id AS "ID", h.nom_groupe AS "NomGroupe"),
      XMLForest(
        (SELECT XMLAgg(
            XMLElement("Personne",
              XMLForest(p.id AS "ID",
                        p.nom AS "Nom",
                        p.prenom AS "Prenom",
                        p.email AS "Email")
            )
          )
          FROM Personnes p
          WHERE p.Groupe_membre_de_id = h.current_id
        ) AS "Personnes"
      )
    )
  )
).getClobVal() AS xml_data
FROM hierarchy h
WHERE h.lvl = 1;
