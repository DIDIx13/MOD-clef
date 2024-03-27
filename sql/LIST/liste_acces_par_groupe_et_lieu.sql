SELECT g.nom AS nom_groupe, l.nom AS nom_lieu, a.dateDebut, a.dateFin
FROM Acces a
JOIN Groupes g ON a.GroupeRef = g.uuid
JOIN Lieux l ON a.LieuRef = l.uuid
WHERE a.dateFin >= CURRENT_DATE;
