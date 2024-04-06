SELECT p.nom, p.prenom, p.email, g.nom AS nom_groupe
FROM Personnes p
JOIN Groupes g ON p.GroupeRef = g.uuid;
