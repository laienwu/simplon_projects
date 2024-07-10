-- 1--Quel est le nombre de retour clients sur la livraison?
SELECT count(*)
from Retour_client
where libelle_categorie = 'livraison';

-- 2-- Quelle est la liste des notes des clients sur les réseaux sociaux sur les TV ?
select note
from Retour_client
         join main.Produit P on P.cle_produit = Retour_client.cle_produit
where libelle_source = 'réseaux sociaux'
  and P.titre_produit = 'TV';

-- 3--Quelle est la note moyenne pour chaque typologie de produit (Classé de la
-- meilleure à la moins bonne) ?
select avg(note) as note_moyenne
from Retour_client
         join main.Produit P on P.cle_produit = Retour_client.cle_produit
group by P.typologie_produit
order by note_moyenne desc;

-- 4-- Quels sont les 5 magasins avec les meilleures notes moyennes ?
select avg(note) as note_moyenne
from Retour_client
         join main.Magasin M on M.ref_magasin = Retour_client.ref_magasin
group by M.ref_magasin
order by note_moyenne desc
limit 5;


-- 5-- Quels sont les magasins qui ont plus de 12 feedbacks sur le drive ?
select count(cle_retour_client) most_fb, ref_magasin
from Retour_client
-- join main.Magasin M on Retour_client.ref_magasin = M.ref_magasin
where libelle_categorie = 'drive'
group by ref_magasin
order by most_fb desc
limit 12;

-- 6-- Quel est le classement des départements par note ?
select avg(note) as note_avg
from Retour_client
         join main.Magasin M on M.ref_magasin = Retour_client.ref_magasin
group by M.departement
order by note_avg desc;

-- 7-- Quelle est la typologie de produit qui apporte le meilleur service après-vente ?
select avg(note) as note_avg
from Retour_client
         join main.Produit P on P.cle_produit = Retour_client.cle_produit
where libelle_categorie = 'service après-vente'
group by P.typologie_produit
order by note_avg desc;

-- 8-- Quelle est la note moyenne sur l’ensemble des boissons ?
select avg(note) note_avg
from Retour_client
         join main.Produit P on P.cle_produit = Retour_client.cle_produit
where P.titre_produit like 'Boisson%';

-- 9-- Quel est le classement des les jours de la semaine selon la meilleure expérience
-- en magasin ?
SELECT avg(note) note_avg, strftime('%w', date_achat) AS weekday
FROM Retour_client
group by weekday
order by weekday desc;

-- 10-- Sur quel mois a-t-on le plus de retour sur le service après-vente ?
SELECT count("cle_retour_client") as nb_retour, strftime('%m', date_achat) AS month
from Retour_client
group by month
order by nb_retour desc;


-- 11-- Quel est le pourcentage de recommandation client ?
select sum("recommandation") / count("cle_retour_client") * 100 as taux_recommandation
from Retour_client;

-- 12-- Quels sont les magasins qui ont une note inférieure à la moyenne ?
select avg(note) note_moyenne
from Retour_client
group by ref_magasin
having note_moyenne < (select avg(note) from retour_client);


-- 13-- Quelles sont les typologies produits qui ont amélioré leur moyenne entre le 1er
-- et le 2eme trimestre 2021 ?
WITH T1 AS (SELECT P.typologie_produit, AVG(note) AS moyenne_T1
            FROM Retour_client
                     join main.Produit P on P.cle_produit = Retour_client.cle_produit
            WHERE date_achat BETWEEN '2021-01-01' AND '2021-03-31'
            GROUP BY P.typologie_produit),
     T2 AS (SELECT P.typologie_produit, AVG(note) AS moyenne_T2
            FROM Retour_client
                     join main.Produit P on P.cle_produit = Retour_client.cle_produit
            WHERE date_achat BETWEEN '2021-04-01' AND '2021-06-30'
            GROUP BY P.typologie_produit)
SELECT T1.typologie_produit, T1.moyenne_T1, T2.moyenne_T2
FROM T1
         JOIN T2 ON T1.typologie_produit = T2.typologie_produit
WHERE T2.moyenne_T2 > T1.moyenne_T1;

-- 14-- Calculer le NPS

WITH Scores AS (SELECT CASE
                           WHEN note >= 9 THEN 'Promoteur'
                           WHEN note >= 7 THEN 'Passif'
                           WHEN note >= 0 THEN 'Détracteur'
                           END  AS categorie,
                       COUNT(*) AS total
                FROM Retour_client
                GROUP BY CASE
                             WHEN note >= 9 THEN 'Promoteur'
                             WHEN note >= 7 THEN 'Passif'
                             WHEN note >= 0 THEN 'Détracteur'
                             END),
     Totals AS (SELECT SUM(total)                                                    AS total_responses,
                       SUM(CASE WHEN categorie = 'Promoteur' THEN total ELSE 0 END)  AS promoteurs,
                       SUM(CASE WHEN categorie = 'Détracteur' THEN total ELSE 0 END) AS detracteurs
                FROM Scores)
SELECT *, (promoteurs * 100.0 / total_responses) - (detracteurs * 100.0 / total_responses) AS NPS
FROM Totals;


-- 15-- le NPS par source
WITH Scores AS (SELECT libelle_source,
                       CASE
                           WHEN note >= 9 THEN 'Promoteur'
                           WHEN note >= 7 THEN 'Passif'
                           WHEN note >= 0 THEN 'Détracteur'
                           END  AS categorie,
                       COUNT(*) AS total
                FROM Retour_client
                GROUP BY libelle_source,
                         CASE
                             WHEN note >= 9 THEN 'Promoteur'
                             WHEN note >= 7 THEN 'Passif'
                             WHEN note >= 0 THEN 'Détracteur'
                             END),
     Totals AS (SELECT libelle_source,
                       SUM(total)                                                    AS total_responses,
                       SUM(CASE WHEN categorie = 'Promoteur' THEN total ELSE 0 END)  AS promoteurs,
                       SUM(CASE WHEN categorie = 'Détracteur' THEN total ELSE 0 END) AS detracteurs
                FROM Scores
                GROUP BY libelle_source)
SELECT libelle_source,
       (promoteurs * 100.0 / total_responses) - (detracteurs * 100.0 / total_responses) AS NPS
FROM Totals;


-- 16-- Quel est le nombre de retour clients par source ?
select count(*)
from Retour_client
group by libelle_source;

-- 17-- Quels sont les 5 magasins avec le plus de feedbacks ?
select count(libelle_source) nb_retour
from Retour_client
group by ref_magasin
order by nb_retour desc
limit 5;

-- 18-- Proposer 3 autres axes d’analyse de votre choix. Bon Travail!
--axe1, axe2, axe3