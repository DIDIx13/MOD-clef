SELECT l.nom AS nom_lieu, s.cardinalite
FROM Serrures s
JOIN Lieux l ON s.LieuRef = l.uuid;
