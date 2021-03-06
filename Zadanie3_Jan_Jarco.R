#Zadanie 3 Jan Jarco nr albumu 82762
#Zadanie 1
rm(list=ls())
getwd()
setwd("C:/Users/User/Documents/R/ME")
library(car)
library(lmtest)
library(AER)
library(tseries)
install.packages('stargazer')
library(stargazer)
df <- read.csv('Export.csv')
head(df)
summary((df))
#usuwam wiersze z brakuj�cymi danymi
df <- na.omit(df)
summary((df))
nrow(df)
hist(df$Export)
lexp <- log(df$Export)
hist(lexp)
length(lexp)
#Zdecydowanie bardziej mo�emy si� spodziewa� po logarytmie tej zmiennej zachowania tej w�asno�ci
#Zadanie 2
colnames(df)
lgdprep <- log(df$GDP_Reporter)
lgdppar <- log(df$GDP_Partner)
ldist <- log(df$dist)
help(lm)
model1 <- lm(lexp ~ lgdprep +lgdppar + ldist )
summary(model1)

scatterplot(lgdprep, lgdppar)
#Model jest statystycznie istotny
#beta1 -Wzrost PKB kraju eksportuj�cego o 1% powoduje wzrost eksportu brutto towar�w w tys. o 1.32%, ceteris paribus 
#beta2 - Wzrost PKB partnera handlowego o 1% powoduje wzrost eksportu brutto towar�w w tys. o 0.91%, ceteris paribus 
#beta3 - Wzrost dystansu pomi�dzy krajami o 1% powoduje spadek eksportu brutto [...] o 1.56%, ceteris paribus 
#Wszystkie oszacowania modelu s� statystycznie istotne
#Zadanie 3
#Podany model objasnia 61% zmienno�ci eksportu brutto wzgl�dem danych empirycznych
#Zadanie 4
# TEST RESET
#Wyrzucam wiersze z niepe�nymi danymi 

nrow(df)
model1
yhat=model1$fitted.values
yhat
length(yhat)
yhat2=yhat^2
yhat3=yhat^3


model_reset=lm(lexp~lgdppar+lgdprep+ldist + yhat2+ yhat3, data = df)
linearHypothesis(model_reset,c(
  "yhat2=0",
  "yhat3=0"
))

# w pakiecie lmtest
reset(model1)
#Brak poprawnej postaci funkcyjnej modelu

#Zadanie 5
# H0 : Beta2 = -Beta3
# H0 : Beta2 != -Beta3
linearHypothesis(model1,  "lgdppar= -ldist")
#H0 :PKB partnera handlowego wzrasta procentowo wraz z spadkiem procentowym dystansu pomi�dzy krajami
#Przy danym poziomie pvalue odrzucam hipotez� zerow� wspomniane� linijk� wy�ej na rzecz hipotezy alternatywnej,
#nie ma ona sensu ekonomicznego. S� to zmienne niezale�ne.
#Zadanie 6
# H0 : Beta1 = Beta2 = -Beta3
# H1: Beta1 = Beta2 = -Beta3 (co najmniej jedno nie jest prawdziwe)
#H0 PKB kraju eksportuj�cego i partnera handlowego wzrasta procentowo wraz z spadkiem procentowym dystansu 
#pomi�dzy krajami

linearHypothesis(model1, c( "lgdppar= -ldist","lgdppar= lgdprep" ))
#Przy danym poziomie pvalue odrzucam hipotez� zerow� ,co najmniej jedna r�wno�� nie jest spe�niona 
#Tak samo, nie ma ona sensu ekonomicznego. Wynika to r�wnie� z wcze�niejszej hipotezy z zadania 5

#Zadanie 7
eu_countries = factor(c( 'AUT', 'BEL', 'BGR','HRV', 'CZE', 'DNK', 'EST', 'FIN', 'FRA',
                'DEU', 'GRC', 'HUN', 'IRL', 'ITA', 'LVA', 'LTU', 'LUX', 'MLT',
                'NLD', 'POL', 'PRT', 'ROU', 'SVK', 'SVN', 'ESP', 'SWE', 'GBR'))

df$EU_rep <- ifelse(df$Reporter %in%eu_countries,1,0)
df$EU_par <- ifelse(df$Partner %in% eu_countries,1,0)

model2 <-lm(lexp ~ lgdprep +lgdppar + ldist + df$EU_rep + df$EU_par, data = df )
summary(model2)
#beta1 -Wzrost PKB kraju eksportuj�cego o 1% powoduje wzrost eksportu brutto towar�w w tys. przeci�tnie o 1.29%, ceteris paribus
#beta2 - Wzrost PKB partnera handlowego o 1% powoduje wzrost eksportu brutto towar�w w tys. przeci�tnie o 0.91%, ceteris paribus 
#beta3 - Wzrost dystansu pomi�dzy krajami o 1% powoduje spadek eksportu brutto [...] przeci�tnie o 1.56%, ceteris paribus 
#beta4 - je�li kraj eksportuj�cy jest z UE to powoduje wzrost eksportu kraju eksportuj�cego �rednio o 0,59%, ceteris paribus
#beta5 - je�li kraj partnerski jest z UE to powoduje wzrost eksportu w kraju gospodarki eksportuj�cej �rednio o 0,05%, ceteris paribus
# Pierwsze 3 r�ni� si� one, ale nieznacznie. Zmienna  
#H0: df$EU_par=df$EU_rep
linearHypothesis(model2,'df$EU_par=df$EU_rep')
#Odrzucam hipotez� H0 przy tym pvalue . Te oszacowania paramter�W s� od siebie statystycznie r�ne
#Zatem wy��cznie to,�e kraj eksportuj�cy jest z UE istotnie wp�ywa na warto�� eksportu. Cz�onkowstwo w UE partnera handlowego nie jest statystycznie istotne.






