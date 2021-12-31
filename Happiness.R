library(tidyverse)
library(shiny)
#install.packages("plotly")
#install.packages("gapminder")
library(plotly)
library(gapminder)
library(shinydashboard)

#Ouverture des fichiers .csv
#J'ai choisi une étude trés interesante mais dont les .csv
#read_csv et non read.csv pour avoir une tibble
df2015 <- read_csv("2015.csv")
df2016 <- read_csv("2016.csv")
df2017 <- read_csv("2017.csv")
df2018 <- read_csv("2018.csv")
df2019 <- read_csv("2019.csv")

#On renomme les colonnes des différentes dataframes dans l'optique de tout fusionner dans la dataframe globale
#C'est aussi une question de clarté

df2019 <- rename(df2019,'Country'='Country or region', 
                 'Freedom' = 'Freedom to make life choices',
                 'Trust (Government Corruption)' = 'Perceptions of corruption'
)



df2018 <- rename(df2018,'Country'='Country or region', 
                 'Freedom' = 'Freedom to make life choices',
                 'Trust (Government Corruption)' = 'Perceptions of corruption')

# Colomne "Trust" de df2018 n'est pas un double mais un character. Il faut donc convertir : 
df2018$`Trust (Government Corruption)` <- as.double(df2018$`Trust (Government Corruption)`)

df2017 <- rename(df2017,'Overall rank'= 'Happiness.Rank',
                 'Score' = 'Happiness.Score',
                 'GDP per capita' = 'Economy..GDP.per.Capita.',
                 'Social support'= 'Family',
                 'Healthy life expectancy' = 'Health..Life.Expectancy.',
                 'Trust (Government Corruption)' = 'Trust..Government.Corruption.',
                 'DystopiaResidual' = 'Dystopia.Residual')
#On choisit également de supprimer des colonnes inutiles et qui vont nous encombrer par la suite

df2017 <- subset(df2017, select = -c(Whisker.high, Whisker.low,
                                     DystopiaResidual))

df2016 <- rename(df2016,'Overall rank'= 'Happiness Rank',
                 'Score' = 'Happiness Score',
                 'GDP per capita' = 'Economy (GDP per Capita)',
                 'Social support'= 'Family',
                 'Healthy life expectancy' =   'Health (Life Expectancy)',
                 'LowerConfidenceInterval' = 'Lower Confidence Interval',
                 'UpperConfidenceInterval' = 'Upper Confidence Interval',
                 'DystopiaResidual' = 'Dystopia Residual')





df2016 <- subset(df2016, select = -c(LowerConfidenceInterval,
                                     UpperConfidenceInterval))

df2015 <- rename(df2015,'Overall rank'= 'Happiness Rank',
                 'Score' = 'Happiness Score',
                 'GDP per capita' = 'Economy (GDP per Capita)',
                 'Social support'= 'Family',
                 'Healthy life expectancy' = 'Health (Life Expectancy)',
                 'StandardError' = 'Standard Error',
                 'DystopiaResidual' = 'Dystopia Residual')

df2015 <- subset(df2015, select = -c(StandardError))

#Nous ajouterons la colonne Year pour chaque dataframe
df2015["Year"] <-2015
df2016["Year"] <-2016
df2017["Year"] <-2017
df2018["Year"] <-2018
df2019["Year"] <-2019


#Nous avons les régions seulement pour les dataframes df2015 et df2016. Afin de résoudre cela et de manière pratique,
#nous utiliserons le mapping sur la dataframes de 2015 (qui possède le plus de régions) afin d'obtenir les régions 
#sur les dataframes df2017, df2018, df2019, similaire au dictionnaire sur python.
df_789 <- bind_rows(df2017, df2018, df2019)
cty_reg <- select(df2015, c("Country", "Region"))
df_789 <- inner_join(df_789, cty_reg)


df_globale <- bind_rows(df2015, df2016, df_789)

#Nous utiliserons d'autres nom de pays, afin qu'ils correspondent aux pays de map_world pour effectuer des représentations géographiques.
df_globale$Country <- recode(df_globale$Country,
                             "Congo (Brazzaville)"="Republic of Congo",
                             "Congo (Kinshasa)"="Democratic Republic of the Congo",
                             "Hong Kong"="China",
                             "Hong Kong S.A.R., China"="China",
                             "North Cyprus"="Cyprus",
                             "Palestinian Territories"="Palestine",
                             "Somaliland region"="Somalia",
                             "Trinidad and Tobago"="Trinidad",
                             "United Kingdom"="UK",
                             "United States"="USA",
                             "Somaliland Region"="Somalia",
                             "Taiwan Province of China"="Taiwan")
df2019$Country <- recode(df2019$Country,
                         "Congo (Brazzaville)"="Republic of Congo",
                         "Congo (Kinshasa)"="Democratic Republic of the Congo",
                         "Hong Kong"="China",
                         "Hong Kong S.A.R., China"="China",
                         "North Cyprus"="Cyprus",
                         "Palestinian Territories"="Palestine",
                         "Somaliland region"="Somalia",
                         "Trinidad and Tobago"="Trinidad",
                         "United Kingdom"="UK",
                         "United States"="USA",
                         "Somaliland Region"="Somalia",
                         "Taiwan Province of China"="Taiwan")
df_globale <- arrange(df_globale, Country)
df2019 <- arrange(df2019, Country)

df_globale <- rename(df_globale, 'OverallRank' = 'Overall rank',
                     'GDPPerCapita' = 'GDP per capita',
                     'SocialSupport' = 'Social support',
                     'HealthyLifeExpectancy' = 'Healthy life expectancy',
                     'Trust_GovernmentCorruption' = 'Trust (Government Corruption)')


an2019<-c(filter(df_globale, Year == 2019))
an2015<-c(filter(df_globale, Year == 2015))
df_an2019 <- data.frame(an2019)
df_an2015 <- data.frame(an2015)
#Evolution des scores des tests du bonheur selon l'esperance de vie (santé)
fig1 <-ggplot(df_an2019, aes(x = `HealthyLifeExpectancy`, y = `GDPPerCapita`)) + 
   geom_point(aes(color = `Region`)) + 
   labs(title = "Evolution des scores des tests du bonheur selon la santé en 2019")+
   xlab("Esperance de vie") + ylab('PIB par habitant')
fig100 <- ggplotly(fig1)
fig100 <- plotly_build(fig1) 


fig2 <-ggplot(df_an2015, aes(x = `HealthyLifeExpectancy`, y = `GDPPerCapita`)) + 
   geom_point(aes(color = `Region`)) + 
   labs(title = "Evolution des scores des tests du bonheur selon la santé en 2015")+
   xlab("Esperance de vie") + ylab('PIB par habitant')
fig200 <- ggplotly(fig2)
fig200 <- plotly_build(fig2) 

#grid.arrange(fig1, fig2)#Permet de rassembler les 2 plot afin d'observer les disparités et similitudes


#Carte du monde représentant les scores du test du bonheur en fonction des pays
#install.packages("rworldmap")
library(rworldmap)
map_world <- map_data(map="world")#Nous permettra d'obtenir les positions geographiques des pays grâce aux colonnes 'Country' de nos dataframes
map_world2019 <- left_join(map_world, df2019, by = c('region' = 'Country'))
map.world.change <- left_join(map_world, df_globale, by = c('region' = 'Country'))#left_join permet de positionner les colonnes de map_world en première position dans la nouvelle dataframe

map_world2019 <- rename(map_world2019,'GDPPerCapita' = 'GDP per capita',
                        'SocialSupport' = 'Social support',
                        'HealthyLifeExpectancy' = 'Healthy life expectancy',
                        'Trust_GovernmentCorruption' = 'Trust (Government Corruption)')

map1 <- ggplot(data = map_world2019, aes(x = long, y = lat, group = group, fill = Score, text =  paste("Pays:", region, "<br>", "Score du test du bonheur:", Score))) + #Avec le curseur pointé sur un pays, nous pourrons voir ces deux informations
   geom_polygon() +
   scale_fill_gradient(low = "ivory", high = "darkgreen") +
   theme(panel.background =  element_rect(fill = "white", colour = "grey50"),
         panel.grid = element_blank(),
         axis.text = element_blank(),
         axis.title = element_blank(),
         axis.ticks = element_blank(),
         legend.title = element_blank(),
         plot.title = element_text(hjust = 0.5)) +
   labs(title = "Carte du monde représentant les scores de Happiness en fonction des pays") +
   guides(fill = guide_legend(title=NULL))
fig3 = ggplotly(map1, tooltip = c("text"))
fig300 <- ggplotly(fig3)
fig300 <- plotly_build(fig3) 



#Carte du monde représentant le PIB par habitant en fonction des pays
map2 <- ggplot(data = map_world2019, aes(x = long, y = lat, group = group, fill = GDPPerCapita, text =  paste("Pays::", region, "<br>", "PIB par habitant", GDPPerCapita))) + 
   geom_polygon() +
   scale_fill_gradient(low = "ivory", high = "lightblue") +
   theme(panel.background =  element_rect(fill = "white", colour = "grey50"),
         panel.grid = element_blank(),
         axis.text = element_blank(),
         axis.title = element_blank(),
         axis.ticks = element_blank(),
         legend.title = element_blank(),
         plot.title = element_text(hjust = 0.5)) +
   labs(title = "Carte du monde représentant les scores de GDP per capita en fonction des pays") +
   guides(fill = guide_legend(title=NULL))
fig4 = ggplotly(map2, tooltip = c("text"))
fig400 <- ggplotly(fig4)
fig400 <- plotly_build(fig4) 

#Carte du monde représentant les aides sociales en fonction des pays
map3 <- ggplot(data = map_world2019, aes(x = long, y = lat, group = group, fill = SocialSupport, text =  paste("Pays:", region, "<br>", "Aides sociales", SocialSupport))) +
   geom_polygon() +
   scale_fill_gradient(low = "red", high = "yellow") +
   theme(panel.background =  element_rect(fill = "white", colour = "grey50"),
         panel.grid = element_blank(),
         axis.text = element_blank(),
         axis.title = element_blank(),
         axis.ticks = element_blank(),
         legend.title = element_blank(),
         plot.title = element_text(hjust = 0.5)) +
   labs(title = "Carte du monde représentant les aides sociales en fonction des pays") +
   guides(fill = guide_legend(title=NULL))
fig5 = ggplotly(map3, tooltip = c("text"))
fig500 <- ggplotly(fig5)
fig500 <- plotly_build(fig5) 

#Carte du monde représentant la confiance en son Gouvernement (Corruption) en fonction des pays
map4 <- ggplot(data = map_world2019, aes(x = long, y = lat, group = group, fill = Trust_GovernmentCorruption, text =  paste("Pays:", region, "<br>", "Confiance:", Trust_GovernmentCorruption))) +
   geom_polygon() +
   scale_fill_gradient(low = "ivory", high = "black") +
   theme(panel.background =  element_rect(fill = "white", colour = "grey50"),
         panel.grid = element_blank(),
         axis.text = element_blank(),
         axis.title = element_blank(),
         axis.ticks = element_blank(),
         legend.title = element_blank(),
         plot.title = element_text(hjust = 0.5)) +
   labs(title = "Carte du monde représentant la confiance en son Gouvernement (Corruption) en fonction des pays") +
   guides(fill = guide_legend(title=NULL))
fig6 = ggplotly(map4, tooltip = c("text"))
fig600 <- ggplotly(fig6)
fig600 <- plotly_build(fig6) 

#Carte du monde représentant la générosité selon les pays
map5 <- ggplot(data = map_world2019, aes(x = long, y = lat, group = group, fill = Generosity, text =  paste("Pays:", region, "<br>", "Generosité:", Generosity))) +
   geom_polygon() +
   scale_fill_gradient(low = "ivory", high = "palevioletred") +
   theme(panel.background =  element_rect(fill = "white", colour = "grey50"),
         panel.grid = element_blank(),
         axis.text = element_blank(),
         axis.title = element_blank(),
         axis.ticks = element_blank(),
         legend.title = element_blank(),
         plot.title = element_text(hjust = 0.5)) +
   labs(title = "Carte du monde représentant la générosité selon les pays") +
   guides(fill = guide_legend(title=NULL))
fig7 = ggplotly(map5, tooltip = c("text"))
fig700 <- ggplotly(fig7)
fig700 <- plotly_build(fig7) 

#Carte du monde représentant la liberté en fonction des pays
map6 <- ggplot(data = map_world2019, aes(x = long, y = lat, group = group, fill = Freedom, text =  paste("Pays:", region, "<br>", "Liberté:", Freedom))) +
   geom_polygon() +
   scale_fill_gradient(low = "black", high = "lightgreen") +
   theme(panel.background =  element_rect(fill = "white", colour = "grey50"),
         panel.grid = element_blank(),
         axis.text = element_blank(),
         axis.title = element_blank(),
         axis.ticks = element_blank(),
         legend.title = element_blank(),
         plot.title = element_text(hjust = 0.5)) +
   labs(title = "Carte du monde représentant la liberté en fonction des pays") +
   guides(fill = guide_legend(title=NULL))
fig8 = ggplotly(map6, tooltip = c("text"))
fig800 <- ggplotly(fig8)
fig800 <- plotly_build(fig8) 


#ScoreGlobal <-aggregate(df_globale[, 4], list(df_globale$Year), mean)
ScoreGlobal2 <- group_by(df_globale, Year) %>% summarise(Score = mean(Score))#ScoreGlobal2 correspond à  la moyenne scores du test du bonheur en fonction des années

#Graphique montrant l'évolution des scores mondiaux du test du bonheur en fonction du temps
fig9 <-ggplot(ScoreGlobal2, aes(x = `Year`, y = `Score`)) + 
   geom_point(aes(size = Score))+ 
   labs(title = "Graphique montrant l'évolution des scores mondiaux du test du bonheur en fonction du temps")
fig9
fig900 <- ggplotly(fig9)
fig900 <- plotly_build(fig9) 



ResultatsGlobaux <- group_by(df_globale, Year) %>% summarise(Generosity = mean(Generosity),
                                                             Score = mean(Score),
                                                             GDPPerCapita = mean(GDPPerCapita),
                                                             Freedom = mean(Freedom),
                                                             Trust_GovernmentCorruption = mean(Trust_GovernmentCorruption),
                                                             HealthyLifeExpectancy = mean(HealthyLifeExpectancy),
                                                             SocialSupport = mean(SocialSupport))
ResultatsGlobaux[is.na(x = ResultatsGlobaux)] <- 0.1151 #Valeur manquante pour les Emirats Arabes Unis

#Evolution des critères du test du bonheur en fonction du temps
fig10 <- ggplot(ResultatsGlobaux,aes(x = Year, y = value)) + 
   geom_line(aes(y = Freedom, color = "Freedom")) +
   geom_line(aes(y = GDPPerCapita, color = 'GDPPerCapita')) + 
   geom_line(aes(y = Generosity, color = 'Generosity')) +
   geom_line(aes(y = Trust_GovernmentCorruption, color = 'Trust(GovernmentCorruption)')) +
   geom_line(aes(y = HealthyLifeExpectancy, color = 'HealthyLifeExpectancy')) +
   geom_line(aes(y = SocialSupport, color = 'SocialSupport')) + 
   xlab("Année") + ylab('Valeur')+
   ggtitle("Evolution des critères du test du bonheur en fonction du temps")

fig1000 <- ggplotly(fig10)
fig1000 <- plotly_build(fig10) 

#Autre manière d'avoir des années visées sur notre dataframe
year2019 <- df_globale %>% filter(Year ==2019)
year2015 <- df_globale %>% filter(Year ==2015)

#Graphique montrant l'évolution du score du test selon l'ésperance de vie(Santé)
fig11 <-ggplot(year2019, aes(x = `HealthyLifeExpectancy`, y = `Score`)) + 
   geom_point(aes(color = `Region`)) + 
   xlab("Esperance de vie") + ylab('Score du test')+
   labs(title = "Graphique montrant l'évolution du score du test selon l'ésperance de vie(Santé) en 2019")
fig1100 <- ggplotly(fig11)
fig1100 <- plotly_build(fig11)

fig12 <-ggplot(year2015, aes(x = `HealthyLifeExpectancy`, y = `Score`)) + 
   geom_point(aes(color = `Region`)) + 
   xlab("Esperance de vie") + ylab('Score du test')+
   labs(title = "Graphique montrant l'évolution du score du test selon l'ésperance de vie(Santé) en 2015")
fig1200 <- ggplotly(fig12)
fig1200 <- plotly_build(fig12)
#grid.arrange(fig11, fig12)

#Graphique montrant l'évolution du score du test selon le PIB par habitant
fig13 <-ggplot(year2019, aes(x = `GDPPerCapita`, y = `Score`)) + 
   geom_point(aes(color = `Region`)) + 
   xlab("PIB par habitant") + ylab('Score du test')+
   labs(title = "Graphique montrant l'évolution du score du test selon le PIB par habitant en 2019")
fig1300 <- ggplotly(fig13)
fig1300 <- plotly_build(fig13)
fig14 <-ggplot(year2015, aes(x = `GDPPerCapita`, y = `Score`)) + 
   geom_point(aes(color = `Region`)) + 
   xlab("PIB par habitant") + ylab('Score du test')+
   labs(title = "Graphique montrant l'évolution du score du test selon le PIB par habitant en 2015")
fig1400 <- ggplotly(fig14)
fig1400 <- plotly_build(fig14)

#grid.arrange(fig13, fig14)

#Graphique montrant l'évolution du score du test selon la liberté
fig15 <-ggplot(year2019, aes(x = `Freedom`, y = `Score`)) + 
   geom_point(aes(color = `Region`)) + 
   xlab("Liberté") + ylab('Score du test')+
   labs(title = "#Graphique montrant l'évolution du score du test selon la liberté en 2019")
fig1500 <- ggplotly(fig15)
fig1500 <- plotly_build(fig15)
fig16 <-ggplot(year2015, aes(x = `Freedom`, y = `Score`)) + 
   geom_point(aes(color = `Region`)) + 
   xlab("Liberté") + ylab('Score du test')+
   labs(title = "#Graphique montrant l'évolution du score du test selon la liberté en 2015")
fig1600 <- ggplotly(fig16)
fig1600 <- plotly_build(fig16)
#grid.arrange(fig15, fig16)

#Graphique représentant les évolutions de confiance en son gouvernement des pays européens
continenEur<- df_globale %>% filter(Region == 'Western Europe')
fig17 <- ggplot(continenEur,aes(x = Year, y = Trust_GovernmentCorruption)) + 
   geom_line(aes(y = Trust_GovernmentCorruption, color = Country)) + 
   xlab("Année") + ylab('Confiance')+
   ggtitle('Graphique représentant les évolutions de confiance en son gouvernement des pays européens')
fig1700 <- ggplotly(fig17)
fig1700 <- plotly_build(fig17)

#Graphique représentant les évolutions de confiance en son gouvernement des pays africains'
continenAfr<- df_globale %>% filter(Region == 'Sub-Saharan Africa')                                      
fig18 <- ggplot(continenAfr,aes(x = Year, y = Trust_GovernmentCorruption)) + 
   geom_line(aes(y = Trust_GovernmentCorruption, color = Country)) + 
   xlab("Année") + ylab('Confiance')+
   ggtitle('Graphique représentant les évolutions de confiance en son gouvernement des pays dAfrique Subsaharienne')
fig1800 <- ggplotly(fig18)
fig1800 <- plotly_build(fig18)

#Graphique représentant les évolutions de confiance en son gouvernement des pays MO et Maghreb'
MoyOrientMagh<- df_globale %>% filter(Region == 'Middle East and Northern Africa')                                      
fig19 <- ggplot(MoyOrientMagh,aes(x = Year, y = Trust_GovernmentCorruption)) + 
   geom_line(aes(y = Trust_GovernmentCorruption, color = Country)) + 
   xlab("Année") + ylab('Confiance')+
   ggtitle('Graphe représentant les évolutions de confiance en son gouvernement des pays du Moyen Orient et de lAfrique du Nord')

fig1900 <- ggplotly(fig19)
fig1900 <- plotly_build(fig19)
#Graphique représentant les évolutions de confiance en son gouvernement des pays d'Amerique du Sud et Caraibes
AmsudCari<- df_globale %>% filter(Region == 'Latin America and Caribbean')                                      
fig20<- ggplot(AmsudCari,aes(x = Year, y = Trust_GovernmentCorruption)) + 
   geom_line(aes(y = Trust_GovernmentCorruption, color = Country)) + 
   xlab("Année") + ylab('Confiance')+
   ggtitle('Graphe représentant les évolutions de confiance en son gouvernement des pays dAmerique du Sud et des Caraibes')
fig2000 <- ggplotly(fig20)
fig2000 <- plotly_build(fig20)


MoyennesRegions<- group_by(df_globale, Region) %>% summarise(Generosity = mean(Generosity),
                                                             Score = mean(Score),
                                                             GDPPerCapita = mean(GDPPerCapita),
                                                             Freedom = mean(Freedom),
                                                             Trust_GovernmentCorruption = mean(Trust_GovernmentCorruption),
                                                             HealthyLifeExpectancy = mean(HealthyLifeExpectancy),
                                                             SocialSupport = mean(SocialSupport))
#'Camemberts des différents critères du test du bonheur par répartition dans le monde'
cam1 <- plot_ly(MoyennesRegions, labels = ~Region, values = ~HealthyLifeExpectancy, type = 'pie')
fig21<- cam1 %>% layout(title = "'Camembert des estimations de vie des différentes régions'",
                        xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                        yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
fig21
fig2100 <- ggplotly(fig21)
fig2100 <- plotly_build(fig21)
cam2 <- plot_ly(MoyennesRegions, labels = ~Region, values = ~GDPPerCapita, type = 'pie')
fig22<- cam2 %>% layout(title = "'Camembert du PIB par habitant des différentes régions'",
                        xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                        yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
fig2200 <- ggplotly(fig22)
fig2200 <- plotly_build(fig22)

cam3 <- plot_ly(MoyennesRegions, labels = ~Region, values = ~Freedom, type = 'pie')
fig23<- cam3 %>% layout(title = "'Camembert des libertés des différentes régions'",
                        xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                        yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
fig2300 <- ggplotly(fig23)
fig2300 <- plotly_build(fig23)

cam4 <- plot_ly(MoyennesRegions, labels = ~Region, values = ~SocialSupport, type = 'pie')
fig24<- cam4 %>% layout(title = "'Camembert des aides sociales des différentes régions'",
                        xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                        yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
fig2400 <- ggplotly(fig24)
fig2400 <- plotly_build(fig24)



#Boxplot des différents critères par régions
fig25 <-plot_ly(year2019,x=~Region,
                y=~Score,
                type="box",
                boxpoints="all",
                pointpos = -1.8,
                color=~Region)%>%
   layout(xaxis=list(showticklabels = FALSE),
          margin=list(b = 100))
fig25 %>% layout(title = 'Boxplot des différents critères par régions en 2019')
fig2500 <- ggplotly(fig25)
fig2500 <- plotly_build(fig25)

fig26 <-plot_ly(year2015,x=~Region,
                y=~Score,
                type="box",
                boxpoints="all",
                pointpos = -1.8,
                color=~Region)%>%
   layout(xaxis=list(showticklabels = FALSE),
          margin=list(b = 100))
fig26 %>% layout(title = 'Boxplot des différents critères par régions en 2015')
fig2600 <- ggplotly(fig26)
fig2600 <- plotly_build(fig26)

#Moyenne du score d Happiness en fonction des régions
ResultatsRegion <- group_by(df_globale, Region) %>% summarise(Generosity = mean(Generosity),
                                                              Score = mean(Score),
                                                              GDPPerCapita = mean(GDPPerCapita),
                                                              Freedom = mean(Freedom),
                                                              Trust_GovernmentCorruption = mean(Trust_GovernmentCorruption),
                                                              HealthyLifeExpectancy = mean(HealthyLifeExpectancy),
                                                              SocialSupport = mean(SocialSupport))
#Bar Chart des moyennes du score du test du bonheur par régions
fig27<- ggplot(ResultatsRegion,aes(x = Region,y = Score))+
   geom_bar(stat='identity', aes(fill=Score)) + 
   ggtitle("Moyenne du score d Happiness en fonction des régions")+
   xlab("Régions") + ylab("Score") + theme(axis.text.x = element_text(angle = 60, hjust = 1))
fig27 <-style(fig27,hoverinfo = "x")
fig2700 <- ggplotly(fig27)
fig2700 <- plotly_build(fig27)


ui <- dashboardPage( #Création de la dashboard.
   dashboardHeader( #Création de l'en tête.
      title = "An equal world ?",
      titleWidth = 500
   ),
   dashboardSidebar( #Création d'une Sidebar dans laquelle on rajoute 5 rubriques.
      sidebarMenu(
         menuItem("Introduction", tabName = "intro"),
         menuItem("Géographie du bonheur", tabName = "geo"),
         menuItem("Les evolutions du score", tabName = "evol"),
         menuItem("Les confiances en les Gouvernements", tabName = "confiance"),
         menuItem("Répartition mondiale", tabName = "repart"),
         menuItem("Vision globale", tabName = "vision"),
         menuItem("Conclusion", tabName = "conclusion")
         
      )
   ),
   dashboardBody( 
      tabItems( 
         tabItem( 
            "intro",
            tabBox( 
               width = 15,
               tabPanel(title = "Introduction", "Introduction", "Dans ce Dashboard, vous trouverez une étude globale de la perçeption du bonheur dans le monde. 
                     Différents critères mènent au bonheur, et on s'occupera ici de l'ésperance de vie témoignant de la santé, des aides sociales, du PIB par habitant du pays, la liberté, la confiance
                     en son Gouvernement et enfin de la générosité.
                     La quête du bonheur est une question qui a été traitée par un bon nombre de philosophe...
                     Quant à moi, je vous montrerai quels sont les attributs qui influent le plus sur ton bonheur au quotidien !
                     Nous étudierons alors les évolutions des caractéristiques fondant le score en fonction des années, les répartitions autour du globe
                     et une trentaine de graphiques trés intéressants. Bonne lecture !")
               
            )),
         tabItem(
            "geo",
            box( 
               title = "Evolution des scores des tests du bonheur selon la santé, en 2019",
               status = "info",
               solidHeader = TRUE,
               width = 8,
               plotlyOutput("fig100")
            ),
            tabBox(
               width = 4,
               tabPanel(title = "Interprétation", "Ce graphique de l'année 2019 nous montre qu'il y a bien une corélation entre le PIB par habitant et l'ésperance de vie.
          L'esperance de vie, témoignant de la santé des habitants du pays, est la plus faible en Afrique Subsaharienne tout comme le GDP. Elle est en revanche
          bien plus élevée dans les régions européennes, nord américaines et d'Asie de l'Est. Ainsi, ce premier graphique nous montre déjà que pour les caractéristiques
          qui forment le score total du test, la plupart son liées.")
               
            ),
            box(
               title = "Evolution des scores des tests du bonheur selon la santé en 2015",
               status = "info",
               solidHeader = TRUE,
               width = 8,
               plotlyOutput("fig200")
            ),
            tabBox(
               width = 4,
               tabPanel(title = "Interprétation", "Ce graphique, dont les données correspondent cette fois à l'année 2015 sont trés similaires.
          Il nous prouve ainsi, que selon les années, les valeurs changent peu, et l'on retrouve toujours les mêmes régions élitistes
          et les régions les plus en difficulté. Ainsi, ces 2 graphiques nous ont permis de prouver que les 2 critères sont liés, et sont la cause
          des ralentissement de développement des pays d'Afrique et d'Asie du Sud")
               
            ),
            box( #Box contenant le graphique
               title = "Carte du monde représentant les scores de GDP per capita en fonction des pays",
               status = "info",
               solidHeader = TRUE,
               width = 8, #Paramètre permettant de choisir la taille de la Box.
               plotlyOutput("fig400")
            ),
            tabBox(
               width = 4,
               tabPanel(title = "Interprétation", "Comme stipulé précedemment, nous pouvons clairement distinguées les régions dont le PIB par habitant 
                   est le plus élevé. En pointant le curseur sur le pays qui correspond, nous obtenons le nom de celui ci ainsi que sa valeur
                   correspondante en fonction du graphique.")
               
            ),
            box(
               title = "Carte du monde représentant les aides sociales en fonction des pays",
               status = "info",
               solidHeader = TRUE,
               width = 8,
               plotlyOutput("fig500")
            ), tabBox(
               width = 4,
               tabPanel(title = "Interprétation", "Nous remarquons ici que ce sont les pays étant le plus en difficulté
                   sur le plan économique et de la santé qui bénéficient le plus d'aides sociales. Les aides sociales
                   comprennent les aides locales mais notamment les aides internationales. L'Afrique et l'Asie du Sud 
                   sont les régions les plus bénéficiaires de ces aides.")
               
            ), 
            box(
               title = "Carte du monde représentant la confiance en son Gouvernement (Corruption) en fonction des pays",
               status = "info",
               solidHeader = TRUE,
               width = 8,
               plotlyOutput("fig600")
            ), tabBox(
               width = 4,
               tabPanel(title = "Interprétation", "D'aprés le graphique obtenu, nous pouvons en déduire que les Sud Américains ainsi que les
                        habitants de l'Europe de l'Ouest sont ceux qui s'affirme être les plus douteux sur les Gouvernements qui les dirigent.
                        Cependant, les valeurs associés montrent qu'il n'influencent pas beaucoup le score total du test du bonheur.")
               
            ),
            box(
               title = "Carte du monde représentant la générosité selon les pays",
               status = "info",
               solidHeader = TRUE,
               width = 8,
               plotlyOutput("fig700")
            ),tabBox(
               width = 4,
               tabPanel(title = "Interprétation", "Cette carte nous indique quant à elle les pays et leur générosité. On peut remarquer que c'est l'Asie 
                        du Sud qui mène la danse. Seulement, encore une fois, la générosité bien qu'étant importante, influe beaucoup moins que le PIB 
                        par habitant par exemple.")
               
            ),
            box(
               title = "Carte du monde représentant la liberté en fonction des pays",
               status = "info",
               solidHeader = TRUE,
               width = 8,
               plotlyOutput("fig800")
            ),
            tabBox(
               width = 4,
               tabPanel(title = "Interprétation", "D'aprés la carte obtenue, les pays orientaux ainsi que les pays d'Europe de l'Ouest sont les pays les
                        moins libre selon leur population. Attention, ces données comme toutes les autres restent basées sur des sondages et non d'une étude
                        internationale basée sur des critères globaux.")
               
            )
         ),
         tabItem(
            "evol",
            box(
               title = "Graphique montrant l évolution des scores mondiaux du test du bonheur en fonction du temps",
               status = "info",
               solidHeader = TRUE,
               width = 8,
               plotlyOutput("fig900")
            ),
            tabBox(
               width = 4,
               tabPanel(title = "Interprétation", "Le graphique obtennu emet des retours positifs. En effet, la moyenne des scores mondiaux a augmenté. C'est un bon signe pour les prédictions du futur.
                        Nous pourrions croirer qu'un écart de seulement 0.06 serait négligeable, mais cette valeur correspond à une moyenne mondiale. ")
               ),
            box(
               title = "Evolution des critères du test du bonheur en fonction du temps",
               status = "info",
               solidHeader = TRUE,
               width = 8,
               plotlyOutput("fig1000")
            ),
            tabBox(
               width = 4,
               tabPanel(title = "Interprétation", "D'aprés ce graphique, nous remarquons que hormis les aides sociales qui ont considérablement baissé en 2016,
                        les données des différents critères qui composent le score sont constantes. Tout les critères montrent de bons signes pour le futur, sauf la liberté,
                        qui elle, est un pilier fondamental de notre monde. Les habitants du monde se sentent plus opressés et cette donnée est vraiment trés représentative de ce qu'il 
                        ce passe dans le monde actuellement.")
            ),
            box(
               title = "Graphique montrant l'évolution du score du test selon l'ésperance de vie(Santé) en 2019",
               status = "info",
               solidHeader = TRUE,
               width = 12,
               plotlyOutput("fig1100")
            ),
            box(
               title = "Graphique montrant l'évolution du score du test selon l'ésperance de vie(Santé) en 2015",
               status = "info",
               solidHeader = TRUE,
               width = 8,
               plotlyOutput("fig1200")
            ),
            tabBox(
               width = 4,
               tabPanel(title = "Interprétation", "Ces 2 graphiques des années 2015 et 2019 nous montree 2 choses notables. Premièrement, 
                        l'allure globale du score du test selon l'esperance de vie de 2015 est trés rapprochée de celle de 2019. Les pays influencent leur
                        score du manière très semblable. De plus, malgré que l'Afrique Subsaharienne reste en position de difficulté, les régions d'Amérique latine et Caraibes,
                        ainsi que l'Europe de l'Ouest ont vu leurs données se densifier, et ce, de manière nettement positive pour l'Europe de l'Ouest.")
            ),
            
            
            box(
               title = "Graphique montrant l'évolution du score du test selon le PIB par habitant en 2019",
               status = "info",
               solidHeader = TRUE,
               width = 8,
               plotlyOutput("fig1300")
            ),
         
            box(
               title = "Graphique montrant l'évolution du score du test selon le PIB par habitant en 2015",
               status = "info",
               solidHeader = TRUE,
               width = 8,
               plotlyOutput("fig1400")
            ),
            tabBox(
               width = 4,
               tabPanel(title = "Interprétation", "L'étude des deux graphiques de l'évolution du Score selon le PIB par habitant nous montre que les
                        données renseignées par les sondages sont très constantes entre les 4 années. Ainsi, ces valeurs de PIB par habitant ont influencé le
                        score du bonheur de la même manière au fil du temps.")
            ),
            
            box(
               title = "Graphique montrant l'évolution du score du test selon la liberté en 2019",
               status = "info",
               solidHeader = TRUE,
               width = 8,
               plotlyOutput("fig1500")
            ),
            
            box(
               title = "Graphique montrant l'évolution du score du test selon la liberté en 2019",
               status = "info",
               solidHeader = TRUE,
               width = 8,
               plotlyOutput("fig1600")
            ),
            tabBox(
               width = 4,
               tabPanel(title = "Interprétation", "D'après les données du graphique, il y a eu une augmentation des notes attribués au sondage
                        selon la liberté des individus. Ils vont donc jouer un rôle lourd dans l'élaboration du Score du test et son augmentation logique.
                        Comme vu lors du graphique de la moyenne des Scores mondiaux, il est tout à fait normal qu'il ait augmenté. En effet, la plupart des éléments qui
                        composent ce fameux score ont augmenté légèrement mais assez suffisamment pour observer un changement notoire.
                        Les Hommes vont mieux !")
            )
            
            
            
            
            
            
            
         ),
         tabItem(
            "confiance",
            
            
            box(
               title = 'Graphique représentant les évolutions de confiance en son gouvernement des pays européens',
               status = "info",
               solidHeader = TRUE,
               width = 8,
               plotlyOutput("fig1700")
            ),
      
            
            
            box(
               title = "Graphique représentant les évolutions de confiance en son gouvernement des pays d'Afrique Subsaharienne",
               status = "info",
               solidHeader = TRUE,
               width = 8,
               plotlyOutput("fig1800")
            ),
   
            
            
            
            box(
               title = "Graphe représentant les évolutions de confiance en son gouvernement des pays du Moyen Orient et de l'Afrique du Nord",
               status = "info",
               solidHeader = TRUE,
               width = 8,
               plotlyOutput("fig1900")
            ),
            
            
            box(
               title = "Graphe représentant les évolutions de confiance en son gouvernement des pays d'Amerique du Sud et des Caraibes",
               status = "info",
               solidHeader = TRUE,
               width = 8,
               plotlyOutput("fig2000")
            ),
            tabBox(
               width = 4,
               tabPanel(title = "Interprétation", "Les graphiques obtenus nous permettent de dresser plusieurs faits. Premièrement,
                        l'Afrique est le continent qui a le plus de mal à faire confiance en son Gouvernement et la corruption qui peut y régner.
                        Hortmis le Rwanda qui sort du los, ils ont tous des résultats trés faibles, et c'est sans doute un élément important dans
                        les résultats des sondages pour la santé et le PIB par habitant. Le Gouvernement conditionne tout, et la mauvaise image de celui-ci
                        en Afrique se montre chez les habitants, et se montre sur les résultats critiques économiques et sanitaires.
                        Au Moyen-Orient et en Afrique du Nord, c'est mieux, ou du moins, c'était ! Tous les pays sans exceptions ont vus leur confiance en leur 
                        Gouvernement chuter : cela témoigne surement des troubles qui ont lieu dans ces régions depuis quelques temps. Pour l'Europe, les résultats
                        sont plutôt constants, mais en Amérique du Sud, il y a une certaine baisse qui s'intensifie depuis les dernières années.")
            )
            
         ),
         
        
         tabItem(
            "vision",
            box( #Box contenant le graphique
               title = "Carte du monde représentant les scores de Happiness en fonction des pays",
               status = "info",
               solidHeader = TRUE,
               width = 8, #Paramètre permettant de choisir la taille de la Box.
               plotlyOutput("fig300")
            ),
            tabBox(
               width = 4,
               tabPanel(title = "Interprétation", "Cette carte nous montre les résultats globaux du monde entier.
                        Sans surprises et en toutes logiques, on retrouve les pays et les régions ayant été le plus en difficultés dans les analyses des différents critères,
                        en mauvaise posture. L'Europe de l'Ouest, l'Océanie ainsi que l'Amérique du Nord dominent les débats. Ces pays 
                        possèdent les meilleurs données dans la quasi totalité des critères composants le Score. De plus, aucun pays dominant un classement ne possède pas
                        un bon score au test du bonheur. Nous pouvons donc en conclure que les valeur des différents critères sont logiquement liés.
                        ")
               
            )
         ),
         
   
         
         
         
         
         tabItem(
            "repart",
            box( #Box contenant le graphique
               title = "Camembert des estimations de vie des différentes régions",
               status = "info",
               solidHeader = TRUE,
               width = 8, #Paramètre permettant de choisir la taille de la Box.
               plotlyOutput("fig2100")
            ),
            tabBox(
               width = 4,
               tabPanel(title = "Interprétation", "Cette étude nous permet de visualiser les proportions
                        des différents critères selon les régions du monde, et ce, d'une manière immédiate grâce au camembert.
                        L'Australie domine par rapport aux autres pays avec l'Europe mais il faut rappeler que l'Océanie est composée
                        de peu de pays.")
               
            ),
            box( #Box contenant le graphique
               title = "Camembert du PIB par habitant des différentes régions",
               status = "info",
               solidHeader = TRUE,
               width = 8, #Paramètre permettant de choisir la taille de la Box.
               plotlyOutput("fig2200")
            ),
           
            box( #Box contenant le graphique
               title = "Camembert des libertés des différentes régions",
               status = "info",
               solidHeader = TRUE,
               width = 8, #Paramètre permettant de choisir la taille de la Box.
               plotlyOutput("fig2300")
            ),
            box( #Box contenant le graphique
               title = "Camembert des aides sociales des différentes régions",
               status = "info",
               solidHeader = TRUE,
               width = 8, #Paramètre permettant de choisir la taille de la Box.
               plotlyOutput("fig2400")
            ),
            tabBox(
               width = 4,
               tabPanel(title = "Interprétation", "Comme nous avons pu le voir sur quasiment tout les graphiques,
                        les continents qui dominent en proportions le PIB par habitant, les aides sociales..., sont
                        les mêmes à retomber. ")
               
            ), box( #Box contenant le graphique
               title = "Boxplot des différents critères par régions en 2019",
               status = "info",
               solidHeader = TRUE,
               width = 8, #Paramètre permettant de choisir la taille de la Box.
               plotlyOutput("fig2500")
            ),
            
            box( #Box contenant le graphique
               title = "Boxplot des différents critères par régions en 2015",
               status = "info",
               solidHeader = TRUE,
               width = 8, #Paramètre permettant de choisir la taille de la Box.
               plotlyOutput("fig2600")
            ),
            tabBox(
               width = 4,
               tabPanel(title = "Interprétation", "Ces deux boxplots des critères des différentes années nous montrent des faits intéressants.
                        Premièrement, il saute aux yeux que malgré les 4 années d'écart, les valeurs restent les mêmes avec approximativement les mêmes plages de résultats
                        pour les régions du monde. Cependant, nous pouvons voir grâce à ce boxplot qu'il y a beaucoup de continents comprenant des inégalités
                        au sein de ses pays, comme le Moyen-Orient et l'Afrique du Nord. Cela s'explique à grande partie du fait qu'ils composent deux continents différents, et que le PIB par
                        habitant des pays du Golfe est nettement supérieur aux pays nords africains. L'Europe de l'Ouest et l'Asie du Sud aussi montrent ces disparités par une zone d'occupation
                        plus large. Le trait du milieu correspondant à la moyenne, on retouve encore une fois les pays d'Océanie, d'Europe de l'Ouest et d'Amérique du Nord qui se situent dans des positions confortables.")
               
            ),
            box( #Box contenant le graphique
               title = "Moyenne du score d'Happiness en fonction des régions",
               status = "info",
               solidHeader = TRUE,
               width = 8, #Paramètre permettant de choisir la taille de la Box.
               plotlyOutput("fig2700")
            ),
            tabBox(
               width = 4,
               tabPanel(title = "Interprétation", "Nous avons ici grâce à cet histogramme une étude plus concise des moyennes des différentes régions du monde, comme vus lors des
                        boxplots précédents")
               
            )
         ),
     
         tabItem(
            "conclusion",
            tabBox(
               width = 15,
               tabPanel(title = "Conclusion", "Les conclusions à tirer de notre étude sont nombreuses:
                        - les pays du Tiers Monde, notamment les pays d'Afrique subsaharienne et les pays d'Asie du Sud sont les pays les moins heureux, du fait de leurs mauvais résultats pour quasiment tous les critères.
                        - les critères qui composent le score du test du bonheur sont liés. Une augmentation du PIB par habitant entaine d'autres améliorations de scores, et vice versa, de même pour les autres citères
                        - les pays d'Europe de l'Ouest, d'Océanie et d'Amérique du Nord dominent les classements, avec à leur tête la Finlande et le Danemark.
                        - le score n'est pas influencé de la même manière par tous les critères, comme par exemple, la première position de la Birmanie sur la générosité mais donc cet incroyable statistique n'est pas visible sur les scores globaux mondiaux. A l'inverse, certains dominent comme les aides sociales ou le PIB par habitant, dont les leaders possèdent les meilleurs scores totaux")
               
            )
         )
      )
   ),
   title = "Score du test du bonheur",
   skin = "red" #Couleur de l'en tête.
)


server <- function(input, output) {
   
   output$fig100 <- renderPlotly({ #On associe a hist1 le graphique que l'on souhaite afficher.
      
      fig100 
      
   })
   
   output$test <- renderUI({ #On associe a test la fonction qui va permettre d'afficher plusieurs graphiques en meme temps avec le dropdown.
      
      l[[input$Continent]][2]
      
   })
   
   output$fig200 <- renderPlotly({
      
      fig200
      
   })
   
   output$fig700 <- renderPlotly({
      
      fig700
      
   })
   
   output$fig400 <- renderPlotly({
      
      fig400
      
   })
   
   output$fig500 <- renderPlotly({
      
      fig500
      
   })
   
   output$fig600 <- renderPlotly({
      
      fig600
      
   })
   
   output$fig800 <- renderPlotly({
      
      fig800
      
   })
   
   output$test2 <- renderUI({
      l2[[input$Continent2]][2]
      
   })
   
   output$fig900 <- renderPlotly({
      
      fig900
      
   })
   output$fig1000 <- renderPlotly({
      
      fig1000
      
   })
   output$fig1100 <- renderPlotly({
      
      fig1100
      
   })
   
   output$fig1200 <- renderPlotly({
      
      fig1200
      
   })
   output$fig1300 <- renderPlotly({
      
      fig1300
      
   })
   output$fig1400 <- renderPlotly({
      
      fig1400
      
   })
   output$fig1500 <- renderPlotly({
      
      fig1500
      
   })
   output$fig1600 <- renderPlotly({
      
      fig1600
      
   })
   output$fig1700 <- renderPlotly({
      
      fig1700
      
   })
   output$fig1800 <- renderPlotly({
      
      fig1800
      
   })
   output$fig1900 <- renderPlotly({
      
      fig1900
      
   })
   output$fig2000 <- renderPlotly({
      
      fig2000
      
   })
   output$fig2100 <- renderPlotly({
      
      fig2100
      
   })
   output$fig2200 <- renderPlotly({
      
      fig2200
      
   })
   output$fig2300 <- renderPlotly({
      
      fig2300
      
   })
   output$fig2400 <- renderPlotly({
      
      fig2400
      
   })
   output$fig2500 <- renderPlotly({
      
      fig2500
      
   })
   output$fig2600 <- renderPlotly({
      
      fig2600
      
   })
   output$fig2700 <- renderPlotly({
      
      fig2700
      
   })
   output$fig300 <- renderPlotly({
      
      fig300
      
   })
}

shinyApp(ui = ui, server = server) #Création de la page internet.