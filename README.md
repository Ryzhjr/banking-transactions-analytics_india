# Analyse des transactions bancaires clients

## Présentation du projet

Ce projet analyse des transactions bancaires clients à l’aide de **SQL** et **Power BI**.

L’objectif est de transformer des données transactionnelles brutes en un tableau de bord décisionnel permettant de mieux comprendre le comportement des clients, d’identifier les segments à forte valeur et de surveiller les transactions inhabituelles.

Le projet repose sur un dataset public contenant plus de **1 million de transactions bancaires**.

---

## Problématique métier

Les banques génèrent chaque jour un volume important de données transactionnelles. Cependant, ces données brutes sont difficiles à exploiter sans nettoyage, transformation et visualisation.

Ce projet cherche à répondre à la question suivante :

> Comment une banque peut-elle utiliser les données de transactions clients pour mieux comprendre les comportements, identifier les profils à forte valeur et détecter les opérations inhabituelles ?

---

## Données utilisées

Le dataset contient des transactions bancaires avec les informations suivantes :

* Identifiant de transaction
* Identifiant client
* Date de naissance du client
* Genre du client
* Localisation du client
* Solde du compte client
* Date de transaction
* Heure de transaction
* Montant de la transaction en INR

La période observée va de **août 2016 à octobre 2016**.

> Remarque : les montants financiers sont exprimés en **INR**, c’est-à-dire en roupies indiennes.

---

## Outils utilisés

* **MySQL** : import, nettoyage, transformation et analyse des données
* **SQL** : jointures, agrégations, segmentation client et détection des transactions inhabituelles
* **Power BI** : création du tableau de bord et visualisation des indicateurs
* **DAX** : création des mesures utilisées dans Power BI
* **GitHub** : documentation et partage du projet

---

## Objectifs du projet

Les principaux objectifs de ce projet sont :

1. Nettoyer et transformer les données transactionnelles brutes avec SQL.
2. Créer des agrégations au niveau client.
3. Segmenter les clients selon leur niveau d’activité et leur valeur transactionnelle.
4. Détecter les transactions inhabituelles à l’aide d’une règle métier.
5. Construire un tableau de bord interactif sur Power BI.
6. Produire des analyses et recommandations exploitables.

---

## Nettoyage des données

Le fichier CSV brut a été importé dans MySQL sous le nom de table :

```sql
bank_transactions
```

Une table nettoyée a ensuite été créée :

```sql
bank_transactions_clean
```

Les principales étapes de nettoyage sont :

* Renommage des colonnes pour faciliter l’analyse.
* Conversion des dates de transaction au format date SQL.
* Conversion des dates de naissance client au format date SQL.
* Remplacement des dates invalides comme `1/1/1800` par `NULL`.
* Gestion des valeurs manquantes comme `nan`.
* Création de colonnes temporelles supplémentaires :

  * `transaction_year`
  * `transaction_month`
  * `transaction_month_name`
* Création d’index pour améliorer les performances des requêtes.

---

## Modèle de données

Le modèle utilisé dans Power BI repose principalement sur deux tables.

### 1. `bank_transactions_powerbi`

Cette table contient les données de transaction enrichies avec des statistiques clients et des indicateurs d’anomalie.

Colonnes importantes :

* `transaction_id`
* `customer_id`
* `customer_location`
* `transaction_date`
* `transaction_amount_inr`
* `avg_transaction_amount_client`
* `is_unusual_transaction`
* `is_high_value_transaction`

### 2. `customer_segments`

Cette table contient une ligne par client avec des indicateurs agrégés.

Colonnes importantes :

* `customer_id`
* `customer_location`
* `nb_transactions`
* `total_amount_inr`
* `avg_amount_inr`
* `avg_account_balance`
* `customer_segment`

---

## Segmentation client

Les clients ont été segmentés selon deux critères principaux :

* le nombre de transactions ;
* le montant total des transactions.

Les segments créés sont :

| Segment                | Définition                                                       |
| ---------------------- | ---------------------------------------------------------------- |
| Low Activity           | Client avec une faible activité transactionnelle                 |
| Active                 | Client avec une activité modérée                                 |
| Very Active            | Client avec une forte fréquence de transactions                  |
| High Value             | Client avec un montant total de transactions élevé               |
| Very Active High Value | Client combinant forte activité et forte valeur transactionnelle |

Cette segmentation permet d’identifier les profils clients les plus intéressants pour la banque.

---

## Détection des transactions inhabituelles

Une transaction est considérée comme inhabituelle lorsque :

> Le montant de la transaction est supérieur à 3 fois la moyenne habituelle des transactions du client.

Cette règle permet d’identifier les opérations qui s’éloignent fortement du comportement habituel d’un client.

Ces transactions ne sont pas forcément frauduleuses, mais elles représentent des **signaux de risque** pouvant nécessiter une vérification.

---

## Tableau de bord Power BI

Le tableau de bord Power BI est composé de 3 pages.

---

### Page 1 — Vue globale bancaire

Cette page donne une vision générale de l’activité transactionnelle.

Indicateurs principaux :

* Nombre total de transactions
* Nombre de clients uniques
* Montant total des transactions
* Montant moyen par transaction
* Solde moyen client
* Nombre de transactions inhabituelles

Visualisations principales :

* Volume transactionnel par mois
* Top villes par volume transactionnel

![Vue globale bancaire](screenshots/page_1_overview.png)

---

### Page 2 — Segmentation clients

Cette page analyse les profils clients et permet d’identifier les segments à forte valeur.

Indicateurs principaux :

* Nombre de clients segmentés
* Volume transactionnel total
* Solde moyen par segment
* Nombre moyen de transactions par client

Visualisations principales :

* Répartition des clients par segment
* Volume transactionnel par segment
* Top clients à forte valeur

![Segmentation clients](screenshots/page_2_segmentation.png)

---

### Page 3 — Surveillance des transactions inhabituelles

Cette page se concentre sur les transactions inhabituelles.

Indicateurs principaux :

* Nombre de transactions inhabituelles
* Montant total des transactions inhabituelles
* Montant moyen des transactions inhabituelles

Visualisations principales :

* Top villes par transactions inhabituelles
* Montant inhabituel par mois
* Tableau détaillé des transactions inhabituelles

![Surveillance des transactions inhabituelles](screenshots/page_3_risk_monitoring.png)

---

## Principaux enseignements

* Le dataset contient plus de **1 million de transactions bancaires** et plus de **880 000 clients uniques**.
* L’analyse couvre une période courte de trois mois, ce qui permet une analyse transactionnelle à court terme, mais pas une analyse de saisonnalité annuelle.
* La majorité des clients appartient au segment **Low Activity**.
* Certains segments génèrent un volume transactionnel important malgré un nombre plus faible de clients.
* Des villes comme **Mumbai**, **New Delhi** et **Gurgaon** apparaissent parmi les zones les plus actives.
* Les transactions inhabituelles sont rares, avec **488 transactions détectées** selon la règle des 3 fois la moyenne client.
* Ces transactions doivent être considérées comme des signaux de surveillance, et non comme des fraudes confirmées.

---

## Recommandations métier

### 1. Prioriser les clients à forte valeur

Les clients générant un fort volume transactionnel doivent être ciblés avec des services premium :

* cartes haut de gamme ;
* conseiller dédié ;
* produits d’épargne ;
* solutions d’investissement.

---

### 2. Adapter les offres selon les segments clients

Les offres commerciales doivent être adaptées au comportement des clients :

* Les clients très actifs peuvent être ciblés avec des services liés aux moyens de paiement.
* Les clients à forte valeur peuvent être orientés vers des produits patrimoniaux ou d’investissement.
* Les clients peu actifs peuvent recevoir des campagnes de réactivation.

---

### 3. Renforcer la surveillance des transactions inhabituelles

Les transactions supérieures à 3 fois la moyenne habituelle du client devraient déclencher une alerte interne.

Cela peut permettre d’améliorer :

* la prévention de la fraude ;
* le contrôle opérationnel ;
* la sécurité client.

---

### 4. Concentrer les actions commerciales sur les villes stratégiques

Les villes avec les plus forts volumes transactionnels peuvent être priorisées pour des campagnes locales ou digitales.

Cela permettrait d’améliorer l’acquisition client et l’adoption de nouveaux produits bancaires dans les zones à fort potentiel.

---

## Structure du projet

```text
banking-transactions-analytics/
│
├── README.md
│
├── sql/
│   ├── 01_create_database_and_raw_table.sql
│   ├── 02_cleaning.sql
│   ├── 03_powerbi_table.sql
│   ├── 04_customer_segmentation.sql
│   └── 05_analysis_queries.sql
│
├── powerbi/
│   └── banking_dashboard.pbix
│
├── screenshots/
│   ├── page_1_overview.png
│   ├── page_2_segmentation.png
│   └── page_3_risk_monitoring.png
│
└── data/
    └── sample_data.csv
```

---

## Principales étapes SQL

### 1. Import des données brutes

Le fichier CSV a été importé dans MySQL Workbench sous le nom :

```sql
bank_transactions
```

### 2. Création de la table nettoyée

Les données brutes ont été nettoyées et transformées dans la table :

```sql
bank_transactions_clean
```

### 3. Création des statistiques clients

Les statistiques au niveau client ont été créées dans :

```sql
customer_transaction_stats
```

### 4. Création de la table finale pour Power BI

La table transactionnelle finale utilisée dans Power BI est :

```sql
bank_transactions_powerbi
```

### 5. Création de la table de segmentation client

Les segments clients ont été stockés dans :

```sql
customer_segments
```

---

## Mesures DAX utilisées

Voici quelques mesures DAX créées dans Power BI :

```DAX
Nb Transactions = COUNTROWS('banking_analytics bank_transactions_powerbi')
```

```DAX
Nb Clients = DISTINCTCOUNT('banking_analytics bank_transactions_powerbi'[customer_id])
```

```DAX
Montant Total INR = SUM('banking_analytics bank_transactions_powerbi'[transaction_amount_inr])
```

```DAX
Montant Moyen Transaction = AVERAGE('banking_analytics bank_transactions_powerbi'[transaction_amount_inr])
```

```DAX
Solde Moyen Client = AVERAGE('banking_analytics bank_transactions_powerbi'[customer_account_balance])
```

```DAX
Nb Transactions Inhabituelles =
CALCULATE(
    COUNTROWS('banking_analytics bank_transactions_powerbi'),
    'banking_analytics bank_transactions_powerbi'[is_unusual_transaction] = 1
)
```

```DAX
Montant Inhabituel INR =
CALCULATE(
    SUM('banking_analytics bank_transactions_powerbi'[transaction_amount_inr]),
    'banking_analytics bank_transactions_powerbi'[is_unusual_transaction] = 1
)
```

---

## Compétences démontrées

Ce projet met en avant les compétences suivantes :

* Nettoyage de données avec SQL
* Agrégations SQL
* Jointures SQL
* Création d’indicateurs métier
* Segmentation client
* Détection de transactions inhabituelles
* Création de dashboard Power BI
* Mesures DAX
* Analyse métier
* Data storytelling
* Formulation de recommandations business

---

## Conclusion

Ce projet montre comment SQL et Power BI peuvent être utilisés pour transformer des données transactionnelles bancaires brutes en un tableau de bord décisionnel.

Le dashboard final permet de :

* suivre l’activité transactionnelle ;
* comprendre le comportement des clients ;
* identifier les clients à forte valeur ;
* détecter des transactions inhabituelles ;
* soutenir la prise de décision commerciale et le contrôle du risque.
