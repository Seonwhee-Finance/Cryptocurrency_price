library(mongolite)
library(plyr)
library(ggplot2)
library(zoo)
library(tis)
MongoConnect <- function(DB_name) {
  conn <- mongolite::mongo(collection = "BTC/USD_30MIN", db = DB_name, url = "mongodb://52.79.239.183:27017", verbose = TRUE, options = ssl_options())
  Raw_data <- conn$find()
  index <- with(Raw_data, order(time_period_end))
  rm(conn)
  return(Raw_data[index,])
}

Slicing_DF <- function(DF) {
  NewDF <- DF[c('time_period_end', 'price_close')]
  return(NewDF)
}

Binance_data <- MongoConnect('BINANCE')
Binance_data <- Slicing_DF(Binance_data)
Huobi_data <- MongoConnect("HUOBI")
Huobi_data <- Slicing_DF(Huobi_data)
Okex_data <- MongoConnect("OKEX")
Okex_data <- Slicing_DF(Okex_data)
Hitbtc_data <- MongoConnect("HITBTC")
Hitbtc_data <- Slicing_DF(Hitbtc_data)
Bitfinex_data <- MongoConnect("BITFINEX")
Bitfinex_data <- Slicing_DF(Bitfinex_data)

Join_data <- join_all(list(Binance_data, Huobi_data, Okex_data, Hitbtc_data, Bitfinex_data), by = "time_period_end", type = "inner")
head(Join_data)
markets <- c('Binance', 'Huobi', 'Okex', 'Hitbtc', 'Bitfinex')
Join_data['time_period_end'] <- as.POSIXct(Join_data$time_period_end, format = "%Y-%m-%d %H:%M:%S")
colnames(Join_data) <- c('Time', 'Binance', 'Huobi', 'Okex', 'Hitbtc', 'Bitfinex')

boxplot(Join_data$Binance+Join_data$Huobi+Join_data$Okex+Join_data$Bitfinex+Join_data$Hitbtc ~ Join_data$Time)

p <- ggplot(Join_data)
plot <- p + geom_point(aes(x = Time, y = Binance, group = Time), alpha = 0.1, color = "green", size = 1)
plot <- plot + geom_point(aes(x = Time, y = Huobi, group = Time), alpha = 0.1, color = "blue", size = 1)
plot <- plot + geom_point(aes(x = Time, y = Okex, group = Time), alpha = 0.1, color = "red", size = 1)
plot <- plot + geom_point(aes(x = Time, y = Hitbtc, group = Time), alpha = 0.1, color = "purple", size = 1)
plot <- plot + geom_point(aes(x = Time, y = Bitfinex, group = Time), alpha = 0.1, color = "grey", size = 1)
plot <- plot + geom_point(aes(x = Time, y = Binance, group = Time), alpha = 0.1, color = "orange", size = 1)
plot
dev.off()
