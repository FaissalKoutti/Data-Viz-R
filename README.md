# Projet Python et R, étude du bonheur et sa répartition mondiale de 2015 à 2019

Lien du dataset : *[https://www.kaggle.com/unsdsn/world-happiness](url)*



## Description du contexte:

La question du bonheur et de son acquisition diffère selon les pays. En effet, certains pays sont plus disposés à avoir
leurs populations plus heureuses que d'autres. Mais pourquoi ? Comment ? Quels sont les facteurs de la perception
du bonheur ? De nombreux philosphes se sont posés la question durant l'Histoire, et je vais vous prouver pourquoi
les conditions ainsi que les zones du monde dans lesquelles vous vivez ont un rôle majeur sur votre bonheur ...


## User Guide:

Les bases de données 2015.csv et 2016.csv contiennent : 

*  Country : Pays
*  Region : Région du monde du pays
*  Happiness Rank : Classement au test du bonheur
*  Happiness Score : core au test du bonheur
*  Economy(GDP per Capita) : valeur du PIB par habitant
*  Family : Valeur des aides sociales
*  Health (Life Expectancy) : valeur de l'estimation de durée de viee représentative de la santé
*  Freedom : valeur de la liberté
*  Trust(Government Corruption) : Valeur de la confiance envers les Gouvernements
*  Generosity : Valeur de la générosité
*  Dystopia Residual = Rassemble les pires scores de toutes les caractéristiques énoncées précedemment. Il s'agit du contraire de "Utopia"


**Attention: Les données ne sont pas les chiffres d'une science excacte mais des données qui proviennent du Gallup World Poll.
Les classements sont basés sur les réponses à la principale question d'évaluation de la vie posée dans les sondage de chacune des caractéristiques
pour ensuite calculer le score du test du bonheur.**

*Pour en savoir plus, visitez [https://worldhappiness.report/faq/]()*

Les bases de données 2017.csv, 2018.csv et 2018.csv auront les mêmes colonnes sauf la colonne Région
que nous devrons soigneuseument créer.

Enfin, la base de données country-capitals.csv nous est utile pour ses données géographiques des pays.



 **Installation des packages R**

*  install.packages('shiny')
*  install.packages("shinydashboard")
*  install.packages("tidyverse")
*  install.packages("plotly")
*  install.packages("rworldmap")
*  install.packages("gapminder")


 **Le script**

**Pour R**
Fichiers concernés :

*  2015.csv
*  2016.csv
*  2017.csv
*  2018.csv
*  2019.csv
*  Happiness.Rproj
*  Happiness.R

Ouvrir le projet Happiness.Rproj
Ouvrir le fichier Happiness.R
Pour executer le fichier:

Dans la fenêtre du fichier jeux_video.R appuyez sur la commande "Run App"
La commande executera ui, server et enfin shinyApp(ui = ui, server = server).
Patienter un petit instant
Le dashboard va s'ouvrir automatiquement sur une page web
Bonne lecture


**Pour Python**
Fichiers concernés :


*  2015.csv
*  2016.csv
*  2017.csv
*  2018.csv
*  2019.csv
*  country-capitals.csv
*  Happi.py

Sur Visual Studio Code, ouvrez le fichier happi.py, naviguez jusqu'au dossier contenant le fichier grâce à la commande "cd",
puis exécutez la commande "python Happy.py" sur Windows et python3 happy.py sur Mac et Linux
Sur Pycharm, ouvrir le fichier Happi.py, puis executer ("Run")
Le fichier s'exécute et le terminal nous donne l'adresse **http://127.0.0.1:8050/** sur laquelle il faut se rendre pour parcourir le Dashboard.


## Developper Guide:

Les bases de données 2017.csv, 2018.csv et 2018.csv auront les mêmes colonnes sauf la colonne Région
que nous devrons soigneuseument créer, avec l'utilisation du dictionnaire sur python et du mapping sur R.
Le nettoyage et le tri des données étant effectué au début des fichier Happi.py pour python et Happiness.R pour R,
nous créerons par la suite des dataframes globales rassemblant toutes les données qui nous intéressent, pour des 
meilleures visualisations et interprétations dans les dashboard.

## Analyse globale:

Les conclusions à tirer de notre étude sont nombreuses:


     
*  les pays du Tiers Monde, notamment les pays d'Afrique subsaharienne et les pays d'Asie du Sud sont les pays les moins heureux, du fait de leurs mauvais résultats pour quasiment tous les critères
     
*  les critères qui composent le score du test du bonheur sont liés. Une augmentation du PIB par habitant entaine d'autres améliorations de scores, et vice versa, de même pour les autres citères
     
*  les pays d'Europe de l'Ouest, d'Océanie et d'Amérique du Nord dominent les classements, avec à leur tête la Finlande et le Danemark
     
*  le score n'est pas influencé de la même manière par tous les critères, comme par exemple, la première position de la Birmanie sur la générosité mais donc cet incroyable statistique n'est pas visible
   sur les scores globaux mondiaux. A l'inverse, certains dominent comme les aides sociales ou le PIB par habitant, dont les leaders possèdent les meilleurs scores totaux.
  
     
D'un point de vue personnel, la réalisation de cette étude captivante, m'a fait progressé d'une telle manière: la réalisation de celle-ci, sur deux laguages mères du domaine de la Data Science, m'a permis de
de prendre conscience de ce que nous pourrons réaliser dans les métiers de la Data, et des différentes étapes à suivre sur la gestion d'un projet, afin d'être réalisée de la manière la plus complète.