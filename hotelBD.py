import streamlit as st
from datetime import date
import pandas as pd
from db_functions import get_reservations, get_clients, get_available_rooms, add_client, add_reservation

st.title("Gestion Hôtel - Interface")

menu = ["Liste Réservations", "Liste Clients", "Chambres Disponibles", "Ajouter Client", "Ajouter Réservation"]
choice = st.sidebar.selectbox("Menu", menu)

if choice == "Liste Réservations":
    st.header("Liste des réservations")
    reservations = get_reservations()
    df = pd.DataFrame(reservations, columns=["ID Réservation", "Date arrivée", "Date départ", "Client"])
    st.dataframe(df)

elif choice == "Liste Clients":
    st.header("Liste des clients")
    clients = get_clients()
    cols = ["ID Client", "Adresse", "Ville", "Code postal", "Email", "Téléphone", "Nom complet"]
    df = pd.DataFrame(clients, columns=cols)
    st.dataframe(df)

elif choice == "Chambres Disponibles":
    st.header("Chambres disponibles")
    date_start = st.date_input("Date d'arrivée", date.today())
    date_end = st.date_input("Date de départ", date.today())
    if date_end < date_start:
        st.error("La date de départ doit être après la date d'arrivée.")
    else:
        if st.button("Chercher"):
            rooms = get_available_rooms(date_start.isoformat(), date_end.isoformat())
            if rooms:
                cols = ["ID Chambre", "Numéro", "Étage", "Fumeurs (0=non,1=oui)", "ID Type", "ID Hôtel"]
                df = pd.DataFrame(rooms, columns=cols)
                st.dataframe(df)
            else:
                st.write("Aucune chambre disponible pour ces dates.")

elif choice == "Ajouter Client":
    st.header("Ajouter un nouveau client")
    adresse = st.text_input("Adresse")
    ville = st.text_input("Ville")
    code_postal = st.text_input("Code postal")
    email = st.text_input("E-mail")
    telephone = st.text_input("Numéro de téléphone")
    nom_complet = st.text_input("Nom complet")
    if st.button("Ajouter Client"):
        if adresse and ville and code_postal and email and telephone and nom_complet:
            add_client(adresse, ville, code_postal, email, telephone, nom_complet)
            st.success("Client ajouté avec succès !")
        else:
            st.error("Veuillez remplir tous les champs.")

elif choice == "Ajouter Réservation":
    st.header("Ajouter une réservation")
    id_client = st.number_input("ID Client", min_value=1, step=1)
    id_type = st.number_input("ID Type de chambre", min_value=1, step=1)
    date_arrivee = st.date_input("Date d'arrivée", date.today())
    date_depart = st.date_input("Date de départ", date.today())
    if st.button("Ajouter Réservation"):
        if date_depart < date_arrivee:
            st.error("La date de départ doit être après la date d'arrivée.")
        else:
            add_reservation(date_arrivee.isoformat(), date_depart.isoformat(), id_client, id_type)
            st.success("Réservation ajoutée avec succès !")
