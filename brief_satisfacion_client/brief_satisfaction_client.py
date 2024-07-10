from pathlib import Path
import csv
import sqlite3


def create_tables(schema: sqlite3, conn: sqlite3.Connection) -> None:
    try:
        cursor = conn.cursor()
        cursor.executescript(schema)
    except Exception as e:
        print(e)


def populate_produit(conn: sqlite3.Connection, rows: list, table_name: str = 'Produit') -> None:
    try:
        cursor = conn.cursor()
        cursor.executemany(f"INSERT or IGNORE INTO {table_name} VALUES (?,?,?)", rows)
        print(f"Rows inserted successfully in {table_name} table.")
    except sqlite3.Error as e:
        print(f"Error inserting rows: {e}")


def populate_magazin(conn: sqlite3.Connection, rows: list, table_name: str = 'Magasin') -> None:
    try:
        cursor = conn.cursor()
        cursor.executemany(f"INSERT or IGNORE INTO {table_name} VALUES (?,?,?,?,?,?,?)", rows)
        print(f"Rows inserted successfully in {table_name} table.")
    except sqlite3.Error as e:
        print(f"Error inserting rows: {e}")


def populate_retour(conn: sqlite3.Connection, rows: list, table_name: str = 'Retour_client') -> None:
    try:
        cursor = conn.cursor()
        cursor.executemany(f"INSERT or IGNORE INTO {table_name} VALUES (?,?,?,?,?,?,?,?)", rows)
        print(f"Rows inserted successfully in {table_name} table.")
    except sqlite3.Error as e:
        print(f"Error inserting rows: {e}")


if __name__ == "__main__":
    connector = sqlite3.connect('./data/bsc.sqlite')
    schema_path = Path('./brief_satisfaction_client.sql')
    product_path = Path('../../data/data_sem2/produit.csv')
    magazin_path = Path('../../data/data_sem2/magasin.csv')
    retour_client = Path('../../data/data_sem2/retour_clients.csv')

    with open(schema_path, "r") as file:
        schema_sql = file.read()
    with open(product_path, "r") as file:
        reader = csv.reader(file, delimiter=';')
        list_products = [tuple(elem) for elem in list(reader)]
    with open(magazin_path, "r") as file:
        reader = csv.reader(file, delimiter=';')
        list_magazins = [tuple(elem) for elem in list(reader)]
    with open(retour_client, "r") as file:
        reader = csv.reader(file, delimiter=';')
        list_retours = [tuple(elem) for elem in list(reader)]
    with connector:
        create_tables(schema_sql, connector)
        populate_produit(connector, table_name="Produit", rows=list_products[1:])
        populate_magazin(connector, table_name="Magasin", rows=list_magazins[1:])
        populate_retour(connector, table_name="Retour_client", rows=list_retours[1:])

