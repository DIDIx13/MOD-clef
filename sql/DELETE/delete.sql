-- Supprime toutes les données dans un ordre qui respecte les contraintes d'intégrité référentielle

-- Commencer par les tables avec des dépendances
DELETE FROM Historiques;
DELETE FROM Registre;
DELETE FROM Acces;
DELETE FROM FAIS_PARTIE_DE;

-- Ensuite, supprimer les données des tables référencées
DELETE FROM Personnes;
DELETE FROM Clefs;
DELETE FROM Serrures;

-- Tables qui peuvent avoir des dépendances hiérarchiques ou aucune
DELETE FROM Lieux;
DELETE FROM Groupes;

COMMIT;
