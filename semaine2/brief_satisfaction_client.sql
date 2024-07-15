
CREATE TABLE IF NOT EXISTS Magasin
(
ref_magasin INT PRIMARY KEY,
departement INT,
departement_commune INT,
libelle_de_commune TEXT,
population FLOAT,
longitude FLOAT,
latitude FLOAT
);

CREATE TABLE IF NOT EXISTS Produit
(
cle_produit	INT PRIMARY KEY,
typologie_produit TEXT,
titre_produit TEXT
);

CREATE table if not exists Retour_client
(
    cle_retour_client INT PRIMARY KEY,
    note INT,
    cle_produit INT,
    ref_magasin INT,
    date_achat DATE,
    libelle_source TEXT,
    libelle_categorie TEXT,
    recommandation BOOLEAN,
    FOREIGN KEY ("ref_magasin") REFERENCES Magasin("ref_magasin"),
    FOREIGN KEY ("cle_produit") REFERENCES Produit("cle_produit")
)