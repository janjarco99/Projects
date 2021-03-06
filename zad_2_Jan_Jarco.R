#Zadanie 2 z strony wyk�adowcy - Jan Jarco
rm(list=ls())
library(AER)
data("CPSSWEducation")
help("CPSSWEducation")
head(CPSSWEducation)
model1<- lm(log(earnings)~education, data = CPSSWEducation)
summary(model1)
summary(model1)$coefficients[,1]
nrow(CPSSWEducation)
#1) Wzrost liczby lat edukacji o 1 rok powoduje wzrost dochodu w $/h o ok. 8,88%
#2) Tak, oszacowanie Beta1 jest statystycznie istotne warto�� p <0.05
#3) Hipoteza jest nast�puj�ca: Wzrost liczby lat edukacji o 1 rok powoduje wzrost dochodu w $/h o 10%
#   H0: Beta1 = .1
#   H1: Beta1 != .1
df	=model1$df
df
alpha = .05
2*pt(abs((summary(model1)$coefficients[2,1]-.1)/summary(model1)$coefficients[2,2]),df,lower.tail=FALSE)
coef<- summary(model1)$coefficients
coef

if (2*pt(q = abs((coef[2,1]-.1)/coef[2,2]),df,lower.tail=FALSE) > alpha) {
  print(sprintf("Przy alfaa %f brak podstaw do odrzucenia hipotezy H0 m�wi�cej, �e Beta1 r�wna si� 0.1 ", alpha))
} else {
  print(sprintf("Przy alfa %f istniej� podstawy do odrzucenia hipotezy H0, m�wi�cej, �e Beta1 r�wna si� 0.1 ", alpha))
}



#4) H0: Beta1 = .08
#   H1: Beta1 > .08
pt((coef[2,1]-.08)/coef[2,2], df , lower.tail = FALSE)# w tym przypadku false bo statystyka testu jest >0

if (pt((coef[2,1]-.08)/coef[2,2], df , lower.tail = FALSE)>(2*alpha)) {
print(sprintf("Przy poziomie istotno�ci %f brak podstaw do odrzucenia hipotezy H0, m�wi�cej, �e Beta1 r�wna si� 0.08 ", alpha))
} else {
  print(sprintf("Przy poziomie istotno�ci %f istniej� podstawy do odrzucenia hipotezy H0, m�wi�cej, �e Beta1 r�wna si� 0.08 na racze H1 m�Wi�cej, �e Beta1 jest wi�ksza od 0.08", alpha))
}


#5) 


probka<- c(sample(1:2950, 2950, replace=TRUE))
probka

betas<- c()

for (i in (1:1000)) {
  probka= c(sample(1:2950, 2950, replace=TRUE))
  model2 = lm(log(earnings) ~ education, data = CPSSWEducation[probka,])
  betas <- rbind(betas,summary(model2)$coefficients[,1])
}
betas
b1 <- c(betas[,2])
hist(b1) #wykres - rozk��d cz�sto�ci
mean(b1)  # �rednia oszacowa�
sd(b1)  #odchylenie standardowe
length(b1)
sum(c(b1>0.0))
#6)a)
sum(c(b1>0.0))/length(b1) *100 # % wynik�w wi�kszych od 0
  #b)
sum(c(b1>0.08))/length(b1) *100   # % wynik�w wi�kszych od 0.08
# Nie mo�na, poniewa� dokonujemy estymacji na r�ni�cych si� od siebie pr�bach
# Podczas naszego eskperymentu parametry modelu mog� by� estymowane wielokrotnie 
# na jednej obserwacji, co nie mo�e si� zdarzy� podczas standardowej metdody z punkt�w i - iii.
