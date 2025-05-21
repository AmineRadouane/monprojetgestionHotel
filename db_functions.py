import sqlite3

DB_PATH = "hotel.db"

def get_connection():
    return sqlite3.connect(DB_PATH)

def get_reservations():
    conn = get_connection()
    cursor = conn.cursor()
    query = """
    SELECT R.id_Reservation, R.Date_arrivee, R.Date_depart, C.Nom_complet
    FROM Reservation R
    JOIN Client C ON R.id_Client = C.id_Client
    """
    cursor.execute(query)
    rows = cursor.fetchall()
    conn.close()
    return rows

def get_clients():
    conn = get_connection()
    cursor = conn.cursor()
    query = "SELECT * FROM Client"
    cursor.execute(query)
    rows = cursor.fetchall()
    conn.close()
    return rows

def get_available_rooms(date_start, date_end):
    conn = get_connection()
    cursor = conn.cursor()
    query = """
    SELECT id_Chambre, Numero, Etage, Fumeurs, id_Type, id_Hotel
    FROM Chambre
    WHERE id_Chambre NOT IN (
        SELECT Ch.id_Chambre
        FROM Chambre Ch
        JOIN Concerner Co ON Ch.id_Type = Co.id_Type
        JOIN Reservation R ON Co.id_Reservation = R.id_Reservation
        WHERE NOT (R.Date_depart <= ? OR R.Date_arrivee >= ?)
    )
    """
    cursor.execute(query, (date_start, date_end))
    rows = cursor.fetchall()
    conn.close()
    return rows

def add_client(adresse, ville, code_postal, email, telephone, nom_complet):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute(
        "INSERT INTO Client (Adresse, Ville, Code_postal, E_mail, Numero_de_telephone, Nom_complet) VALUES (?, ?, ?, ?, ?, ?)",
        (adresse, ville, code_postal, email, telephone, nom_complet)
    )
    conn.commit()
    conn.close()

def add_reservation(date_arrivee, date_depart, id_client, id_type):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute(
        "INSERT INTO Reservation (Date_arrivee, Date_depart, id_Client) VALUES (?, ?, ?)",
        (date_arrivee, date_depart, id_client)
    )
    id_reservation = cursor.lastrowid
    cursor.execute(
        "INSERT INTO Concerner (id_Type, id_Reservation) VALUES (?, ?)",
        (id_type, id_reservation)
    )
    conn.commit()
    conn.close()
