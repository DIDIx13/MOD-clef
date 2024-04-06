SELECT p.nom, p.prenom, c.numero_de_serie, s.cardinalite, hu.dateUtilisation
FROM HistoriqueUtilisations hu
JOIN Personnes p ON hu.PersonneRef = p.uuid
JOIN Clefs c ON hu.ClefRef = c.uuid
JOIN Serrures s ON hu.SerrureRef = s.uuid;
