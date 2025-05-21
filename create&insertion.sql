
CREATE TABLE IF NOT EXISTS Hotel (
    id_Hotel INTEGER PRIMARY KEY,
    Ville TEXT,
    Pays TEXT,
    Code_postal INTEGER
);

CREATE TABLE IF NOT EXISTS Presentation (
    id_Presentation INTEGER PRIMARY KEY,
    Prix REAL,
    Description TEXT
);

CREATE TABLE IF NOT EXISTS Client (
    id_Client INTEGER PRIMARY KEY,
    Adresse TEXT,
    Ville TEXT,
    Code_postal INTEGER,
    E_mail TEXT,
    Numero_de_telephone TEXT,
    Nom_complet TEXT
);

CREATE TABLE IF NOT EXISTS Type_Chambre (
    id_Type INTEGER PRIMARY KEY,
    Type TEXT,
    Tarif INTEGER
);

CREATE TABLE IF NOT EXISTS Reservation (
    id_Reservation INTEGER PRIMARY KEY,
    Date_arrivee TEXT,
    Date_depart TEXT,
    id_Client INTEGER,
    FOREIGN KEY (id_Client) REFERENCES Client(id_Client)
);

CREATE TABLE IF NOT EXISTS Chambre (
    id_Chambre INTEGER PRIMARY KEY,
    Numero INTEGER,
    Etage INTEGER,
    Fumeurs INTEGER,
    id_Type INTEGER,
    id_Hotel INTEGER,
    FOREIGN KEY (id_Type) REFERENCES Type_Chambre(id_Type),
    FOREIGN KEY (id_Hotel) REFERENCES Hotel(id_Hotel)
);

CREATE TABLE IF NOT EXISTS Evaluation (
    id_Evaluation INTEGER PRIMARY KEY,
    Date_arrivee TEXT,
    La_note INTEGER,
    Texte_descriptif TEXT,
    id_Hotel INTEGER,
    id_Client INTEGER,
    FOREIGN KEY (id_Hotel) REFERENCES Hotel(id_Hotel),
    FOREIGN KEY (id_Client) REFERENCES Client(id_Client)
);

CREATE TABLE IF NOT EXISTS Offre (
    id_Hotel INTEGER,
    id_Presentation INTEGER,
    PRIMARY KEY (id_Hotel, id_Presentation),
    FOREIGN KEY (id_Hotel) REFERENCES Hotel(id_Hotel),
    FOREIGN KEY (id_Presentation) REFERENCES Presentation(id_Presentation)
);

CREATE TABLE IF NOT EXISTS Concerner (
    id_Type INTEGER,
    id_Reservation INTEGER,
    PRIMARY KEY (id_Type, id_Reservation),
    FOREIGN KEY (id_Type) REFERENCES Type_Chambre(id_Type),
    FOREIGN KEY (id_Reservation) REFERENCES Reservation(id_Reservation)
);
--insertion
INSERT INTO Hotel (id_Hotel, Ville, Pays, Code_postal) VALUES
(1, 'Paris', 'France', 75001),
(2, 'Lyon', 'France', 69002);
INSERT INTO Client (id_Client, Adresse, Ville, Code_postal, E_mail, Numero_de_telephone, Nom_complet) VALUES
(1, '12 Rue de Paris', 'Paris', 75001, 'jean.dupont@email.fr','0612345678', 'Jean Dupont'),
(2, '5 Avenue Victor Hugo', 'Lyon', 69002, 'marie.leroy@email.fr','0623456789', 'Marie Leroy'),
(3, '8 Boulevard Saint-Michel', 'Marseille', 13005,'paul.moreau@email.fr', '0634567890', 'Paul Moreau'),
(4, '27 Rue Nationale', 'Lille', 59800, 'lucie.martin@email.fr','0645678901', 'Lucie Martin'),
(5, '3 Rue des Fleurs', 'Nice', 06000, 'emma.giraud@email.fr','0656789012', 'Emma Giraud');
INSERT INTO Presentation (id_Presentation, Prix, Description) VALUES
(1, 15, 'Petit-déjeuner'),
(2, 30, 'Navette aéroport'),
(3, 0, 'Wi-Fi gratuit'),
(4, 50, 'Spa et bien-être'),
(5, 20, 'Parking sécurisé');
INSERT INTO Type_Chambre (id_Type, Type, Tarif) VALUES
(1, 'Simple', 80),
(2, 'Double', 120);
INSERT INTO Chambre (id_Chambre, Numero, Etage, Fumeurs, id_Type, id_Hotel) VALUES
(1, 201, 2, 0, 1, 1),
(2, 502, 5, 1, 1, 2),
(3, 305, 3, 0, 2, 1),
(4, 410, 4, 0, 2, 2),
(5, 104, 1, 1, 2, 2),
(6, 202, 2, 0, 1, 1),
(7, 307, 3, 1, 1, 2),
(8, 101, 1, 0, 1, 1);
INSERT INTO Reservation (id_Reservation, Date_arrivee, Date_depart, id_Client) VALUES
# Client 1 (Jean Dupont)
(1, '2025-06-15', '2025-06-18', 1),
# Client 2 (Marie Leroy)
(2, '2025-07-01', '2025-07-05', 2),
(7, '2025-11-12', '2025-11-14', 2),
(10, '2026-02-01', '2026-02-05', 2),
# Client 3 (Paul Moreau)
(3, '2025-08-10', '2025-08-14', 3),
# Client 4 (Lucie Martin)
(4, '2025-09-05', '2025-09-07', 4),
(9, '2026-01-15', '2026-01-18', 4),
# Client 5 (Emma Giraud)
(5, '2025-09-20', '2025-09-25', 5);
INSERT INTO Evaluation (id_Evaluation, Date_arrivee, La_note, Texte_descriptif, id_Hotel, id_Client) VALUES
(1, '2025-06-15', 5, 'Excellent séjour, personnel très accueillant.', 1, 1),
(2, '2025-07-01', 4, 'Chambre propre, bon rapport qualité/prix.', 2, 2),
(3, '2025-08-10', 3, 'Séjour correct mais bruyant la nuit.', 1, 3),
(4, '2025-09-05', 5, 'Service impeccable, je recommande.', 2, 4),
(5, '2025-09-20', 4, 'Très bon petit-déjeuner, hôtel bien situé.', 1, 5);

--Ecrire les requêtes SQL ET en algèbre relationnelle qui permettent de:
--a. Afficher la liste des réservations avec le nom du client et la ville de l’hôtel réservé.
SELECT R.id_Reservation, R.Date_arrivee, R.Date_depart, C.Nom_complet, H.Ville
FROM Reservation R
JOIN Client C ON R.id_Client = C.id_Client
JOIN Concerner Co ON R.id_Reservation = Co.id_Reservation
JOIN Chambre Ch ON Co.id_Type = Ch.id_Type
JOIN Hotel H ON Ch.id_Hotel = H.id_Hotel;


--b. Afficher les clients qui habitent à Paris.
SELECT * 
FROM Client 
WHERE Ville = 'Paris';
--c. Calculer le nombre de réservations faites par chaque client.
SELECT C.id_Client, C.Nom_complet, COUNT(R.id_Reservation) AS Nb_Reservations
FROM Client C
LEFT JOIN Reservation R ON C.id_Client = R.id_Client
GROUP BY C.id_Client, C.Nom_complet;
--d. Donner le nombre de chambres pour chaque type de chambre.
SELECT TC.Type, COUNT(C.id_Chambre) AS Nb_Chambres
FROM Type_Chambre TC
LEFT JOIN Chambre C ON TC.id_Type = C.id_Type
GROUP BY TC.id_Type, TC.Type;
-- e. Afficher la liste des chambres qui ne sont pas réservées pour une période donnée (entre deux dates saisies par l’utilisateur)
SELECT * 
FROM Chambre 
WHERE id_Chambre NOT IN (
  SELECT Ch.id_Chambre
  FROM Chambre Ch
  JOIN Concerner Co ON Ch.id_Type = Co.id_Type
  JOIN Reservation R ON Co.id_Reservation = R.id_Reservation
  WHERE R.Date_arrivee <= @date_fin 
    AND R.Date_depart >= @date_debut
);



