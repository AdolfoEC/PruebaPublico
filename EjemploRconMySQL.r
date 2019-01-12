
options(scipen=99)

setwd("C:/Users/AdolfoEC/Desktop")

read.csv("TopSongs.csv")->TopSongs

colnames(TopSongs)<-c("position","ArtistName","SongName","Year","RawPop","UsPop","UKPop","EuropePop","RestWorldPop")


install.packages("RMySQL")
library(RMySQL)


mydb = dbConnect(MySQL(), user='root', password='AdolfoSQL_2019', dbname='top_songsDB', host='localhost') ## Crear la conexión local

dbListTables(mydb) ## Enlistas las tablas y 

dbListFields(mydb, 'top5000')


PruebaR<-data.frame(ID=1:7000,Categoria=LETTERS[1:10],Valor=rnorm(7000))


dbWriteTable(mydb, name='tablaR7000_2', value=PruebaR,overwrite = TRUE)

dbDisconnect(mydb)
dbGetInfo(mydb)
summary(mydb)


dbWriteTable(mydb, "mtcars", mtcars[1:5, ], overwrite = TRUE)


tail(dbReadTable(mydb,"top5000"))


### Leer de la base de datos por partes y hacer merge entre bases de datos y subir la base de datos nueva en el servidor nuevamente

install.packages("RMySQL")
library(RMySQL)

mydb = dbConnect(MySQL(), user="root", password="AdolfoSQL_2019", dbname="top_songsDB", host="localhost") ## Crear la conexión local

dbListTables(mydb) ## Enlistas las tablas y 

dbListFields(mydb, "top5000")

## Crear un query para reducir la dimensión de la base de datos 

sql_query_R<-"SELECT * FROM top5000 LIMIT 3"
sql_query_R2<-"SELECT position,ArtistName,SongName FROM top5000 LIMIT 25"
res <- dbSendQuery(mydb,sql_query_R2)
dbFetch(res)


top7000_R<-dbReadTable(mydb,"tablar7000_2")


dbDisconnect(mydb)





library(DBI)
library(RMySQL) 
drv <- dbDriver("MySQL") 
con <- dbConnect (drv, dbname="mydb", user="username") 
dbWriteTable(con, "mtcars", mtcars)
dbReadTable(con, "mtcars") # full table

tablaSQL<-"tablar7000_2"

sql <- paste0("SELECT ", paste(dbListFields(mydb,tablaSQL)[-(1:1)], collapse=","), " FROM ",tablaSQL," LIMIT 5")
res <- dbSendQuery(mydb, sql)
dbFetch(res)

dbClearResult(res)

res <- dbSendQuery(con, 'DROP TABLE mtcars')
dbDisconnect(con)
