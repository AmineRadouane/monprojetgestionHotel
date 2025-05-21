import sqlite3
import os
import re

db_path = "hotel.db"

if os.path.exists(db_path):
    os.remove(db_path)

conn = sqlite3.connect(db_path)
cursor = conn.cursor()

with open("create_and_insert.sql", "r", encoding="utf-8") as f:
    sql_script = f.read()

cleaned_script = re.sub(r'--.*\n|#.*\n', '\n', sql_script)

cursor.executescript(cleaned_script)

conn.commit()
conn.close()

print("✅ Base de données créée et remplie avec succès !")
