install.packages("dplyr")
library(ggplot2)
library(dplyr)
library(corrplot)

###############
# Upload data #
btc_price <- read.csv("BTC_price_Bitcoin.csv", sep=",", header = TRUE) # daily
dollar_circulation <- read.csv("CURRCIR.csv", sep=",", header = TRUE) # monthly
btc_addr_total <- read.csv("BTC_Total Addresses_Bitcoin.csv", sep=",", header = TRUE) # daily
btc_hashrate_difficulty <- read.csv("BTC_Hash Rate_Difficulty.csv", sep=",", header = TRUE) # daily
btc_transaction <- read.csv("BTC_Number of Transactions_Bitcoin.csv", sep=",", header = TRUE) # daily
btc_miner_rewards <- read.csv("BTC_Miner Rewards_undefined.csv", sep=",", header = TRUE) # daily

btc_avg_fees <- read.csv("BTC_Average Transaction Fees_Bitcoin.csv", sep=",", header = TRUE) # daily not null from 29/11/09
btc_days_halving <- read.csv("days_to_halving.csv", sep=",", header = TRUE) # daily

# Normalize data
norm <- function(lista_numeri) {
  # Calcola il minimo e il massimo della lista
  minimo <- min(lista_numeri)
  massimo <- max(lista_numeri)
  
  # Normalizza la lista tra 0 e 1
  lista_normalizzata <- (lista_numeri - minimo) / (massimo - minimo)
  
  # Restituisci la lista normalizzata
  return(lista_normalizzata)
}
# From daily to monthly
monthly <- function(data, col_date) {
  # Assicurati che la colonna 'DateTime' sia di tipo Date
  data[[col_date]] <- as.Date(data[[col_date]], format = "%Y-%m-%dT%H:%M:%S.000Z")
  
  # Estrai il mese dalla colonna 'DateTime'
  data <- data %>%
    mutate(Month = format(get(col_date), "%Y-%m"))
  
  # Seleziona solo colonne numeriche per calcolare la media
  cols_num <- names(data)[sapply(data, is.numeric)]
  
  # Calcola la media delle colonne numeriche per ogni mese
  new_dataset <- data %>%
    group_by(Month) %>%
    summarise(across(all_of(cols_num), mean))
  
  new_dataset$Month <- as.Date(paste(new_dataset$Month, "01", sep = "-"))
  
  # Restituisci il nuovo dataset
  return(new_dataset)
}

#####################
# FROM DAY TO MONTH #
btc_price <- monthly(btc_price, "DateTime")
btc_addr_total <- monthly(btc_addr_total, "DateTime")
btc_hashrate_difficulty <- monthly(btc_hashrate_difficulty, "DateTime")
btc_transaction <- monthly(btc_transaction, "DateTime")
btc_miner_rewards <- monthly(btc_miner_rewards, "DateTime")
btc_avg_fees <- monthly(btc_avg_fees, "DateTime")
#btc_days_halving <- monthly(btc_days_halving, "date")

###############
# GLOBAL DATE #
###############
start_date <- as.Date("2011-09-01") # 2011-09-01
end_date <- as.Date("2023-10-01") # 2023-10-01

########
# DATE #
btc_price <- btc_price[btc_price$Month >= start_date & btc_price$Month <= end_date, ] # price
dollar_circulation <- dollar_circulation[dollar_circulation$DATE >= start_date & dollar_circulation$DATE <= end_date, ] # price
btc_addr_total <- btc_addr_total[btc_addr_total$Month >= start_date & btc_addr_total$Month <= end_date, ] # price
btc_hashrate_difficulty <- btc_hashrate_difficulty[btc_hashrate_difficulty$Month >= start_date & btc_hashrate_difficulty$Month <= end_date, ] # price
btc_transaction <- btc_transaction[btc_transaction$Month >= start_date & btc_transaction$Month <= end_date, ] # price

btc_miner_rewards <- btc_miner_rewards[btc_miner_rewards$Month >= start_date & btc_miner_rewards$Month <= end_date, ] # price

# Error in btc_miner_rewards
nrows <- nrow(btc_miner_rewards)
row_pre <- btc_miner_rewards[(nrows - 29):(nrows - 15), -1]
btc_miner_rewards[(nrows - 14):nrows, -1] <- row_pre

#######
# LOG #
btc_price$log_Price <- log(btc_price$Price)
dollar_circulation$log_CURRCIR <- log(dollar_circulation$CURRCIR)
btc_addr_total$log_total <- log(btc_addr_total$Total.With.Balance)
btc_hashrate_difficulty$log_HashRate <- log(btc_hashrate_difficulty$Hash.Rate)
btc_transaction$log_transaction <- log(btc_transaction$Number.Of.Transactions)
btc_miner_rewards$log_Rewards <- log(btc_miner_rewards$Rewards)

########
# Plot #
ggplot(btc_price, aes(x = Month, y = log_Price)) +
  geom_line(color = "orange", size = 1) +
  labs(x = "Date", y = "Price Bitcoin", title = "Bitcoin price over time")

########
# PLOT #
ggplot() +
  geom_line(data = btc_price, aes(x = Month, y = norm(log_Price)), color = "orange", size = 1, linetype = "solid") +
  geom_line(data = dollar_circulation, aes(x = as.Date(DATE), y = norm(log_CURRCIR)), color = "red", size = 0.2, linetype = "solid") +
  geom_line(data = btc_addr_total, aes(x = Month, y = norm(log_total)), color = "green", size = 0.2, linetype = "solid") +
  geom_line(data = btc_transaction, aes(x = Month, y = norm(log_transaction)), color = "black", size = 0.2, linetype = "solid") +
  geom_line(data = btc_hashrate_difficulty, aes(x = Month, y = norm(log_HashRate)), color = "blue", size = 0.2, linetype = "solid") +
  geom_line(data = btc_miner_rewards, aes(x = Month, y = norm(log_Rewards)), color = "blue", size = 0.2, linetype = "solid") +

  labs(x = "Date", y = "Log(Price)", title = "Bitcoin Price and other Time Series") +
  scale_linetype_manual(name = "Legend", values = c("solid", "dashed"), labels = c("Bitcoin Price", "Another Time Series"))

##########
# DATASET#
dataset_log <- data.frame(price = btc_price$log_Price, 
                      dollar_circulation = dollar_circulation$log_CURRCIR,
                      total_addr = btc_addr_total$log_total,
                      transaction = btc_transaction$log_transaction,
                      hashrate = btc_hashrate_difficulty$log_HashRate,
                      rewards = btc_miner_rewards$log_Rewards)

dataset <- data.frame(price = btc_price$Price, 
                      dollar_circulation = dollar_circulation$CURRCIR,
                      total_addr = btc_addr_total$Total.With.Balance,
                      transaction = btc_transaction$Number.Of.Transactions,
                      hashrate = btc_hashrate_difficulty$Hash.Rate,
                      rewards = btc_miner_rewards$Rewards)

acf(dataset$price)
mat <- cor(dataset)

corrplot(mat, method = "color", addCoef.col = "black")

###DIFFERENTIATION##

# Calcola le differenze
dataset$price_diff <- c(NA, diff(dataset$price))
dataset$dollar_circulation_diff <- c(NA, diff(dataset$dollar_circulation))
dataset$total_addr_diff <- c(NA, diff(dataset$total_addr))
dataset$transaction_diff <- c(NA, diff(dataset$transaction))
dataset$hashrate_diff <- c(NA, diff(dataset$hashrate))
dataset$rewards_diff <- c(NA, diff(dataset$rewards))

# Rimuovi le variabili temporali originali
dataset_senza_tempo <- subset(dataset, select = -c(price, dollar_circulation, total_addr, transaction, hashrate, rewards))

# Calcola la matrice di correlazione
matrix_correlazione <- cor(dataset_senza_tempo, use = "complete.obs")

# Visualizza la matrice di correlazione
print(matrix_correlazione)


corrplot(matrix_correlazione, method = "color", addCoef.col = "black")


###LINEAR REGRESSION###
# Eseguire la regressione lineare
modello_reg_lineare <- lm(price ~ dollar_circulation + total_addr + transaction + hashrate + rewards , data = dataset[1:(nrow(dataset) - 50),])
nuovi_dati <- dataset[(nrow(dataset) - 49):nrow(dataset), c("dollar_circulation", "total_addr", "transaction", "hashrate", "rewards")]
predizioni <- predict(modello_reg_lineare, newdata = nuovi_dati)
print(predizioni)
plot(predizioni)
n_totale <- nrow(dataset)

plot(dataset[(n_totale - 49):n_totale, "price"], type = "l", col = "blue", ylim = range(c(ultime_50_price, predizioni)), ylab = "Price")

# Aggiungi le predizioni al grafico
lines(predizioni, col = "red")
summary(modello_reg_lineare)
