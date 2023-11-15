
library(ggplot2)

###############
# Upload data #
btc_price <- read.csv("BTC_price_Bitcoin.csv", sep=",", header = TRUE) # daily
dollar_circulation <- read.csv("CURRCIR.csv", sep=",", header = TRUE) # monthly
btc_addr_total <- read.csv("BTC_Total Addresses_Bitcoin.csv", sep=",", header = TRUE) # daily

btc_transaction <- read.csv("BTC_Number of Transactions_Bitcoin.csv", sep=",", header = TRUE) # daily
btc_miner_rewards <- read.csv("BTC_Miner Rewards_undefined.csv", sep=",", header = TRUE) # daily
btc_hashrate_difficulty <- read.csv("BTC_Hash Rate_Difficulty.csv", sep=",", header = TRUE) # daily
btc_avg_fees <- read.csv("BTC_Average Transaction Fees_Bitcoin.csv", sep=",", header = TRUE) # daily not null from 29/11/09
btc_days_halving <- read.csv("days_to_halving.csv", sep=",", header = TRUE) # daily

###############
# GLOBAL DATE #
###############
start_date <- as.Date("2015-07-17") # 2010-07-17
end_date <- as.Date("2023-11-09") # 2023-11-09

############
# BTC DATE #
btc_price$DateTime <- as.Date(substr(btc_price$DateTime, 1, 10))
filtered_btc_price <- subset(btc_price, DateTime >= start_date & DateTime <= end_date) # price
filtered_btc_price$log_Price <- log(filtered_btc_price$Price) # log price

date_range_btc <- as.Date(substr(filtered_btc_price$DateTime, 1, 10))

# Plot
ggplot(filtered_btc_price, aes(x = date_range_btc, y = filtered_btc_price$log_Price)) +
  geom_line(color = "orange", size = 1) +
  labs(x = "Date", y = "Price Bitcoin", title = "Bitcoin price over time")

###############
# DOLLAR DATE #
dollar_circulation$DATE <- as.Date(substr(dollar_circulation$DATE, 1, 10))
filtered_dollar_circulation <- subset(dollar_circulation, DATE >= start_date & DATE <= end_date) # price
filtered_dollar_circulation$log_CURRCIR <- log(filtered_dollar_circulation$CURRCIR)

date_range_dollar <- as.Date(substr(filtered_dollar_circulation$DATE, 1, 10))

# Plot
ggplot(filtered_dollar_circulation, aes(x = date_range_dollar, y = filtered_dollar_circulation$CURRCIR)) +
  geom_line(color = "orange", size = 1) +
  labs(x = "Date", y = "Dollar Circulation", title = "Dollar Circulation over time")

################
# ADDRESS DATE #
btc_addr_total$DateTime <- as.Date(substr(btc_addr_total$DateTime, 1, 10))
filtered_btc_addr_total <- subset(btc_addr_total, DateTime >= start_date & DateTime <= end_date) # price
date_range_btc_addr_total <- as.Date(substr(filtered_btc_addr_total$DateTime, 1, 10))

# Plot
ggplot(filtered_btc_addr_total, aes(x = date_range_btc_addr_total, y = filtered_btc_addr_total$Total.With.Balance)) +
  geom_line(color = "orange", size = 1) +
  labs(x = "Date", y = "Total Address with Balance", title = "Bitcoin Address over time")

################
# HASHRATE DATE #
btc_hashrate_difficulty$DateTime <- as.Date(substr(btc_hashrate_difficulty$DateTime, 1, 10))
filtered_btc_hashrate_difficulty <- subset(btc_hashrate_difficulty, DateTime >= start_date & DateTime <= end_date) # price
date_range_btc_hashrate_difficulty <- as.Date(substr(filtered_btc_hashrate_difficulty$DateTime, 1, 10))

filtered_btc_hashrate_difficulty$log_HashRate <- log(filtered_btc_hashrate_difficulty$Hash.Rate)

# Plot
ggplot(filtered_btc_hashrate_difficulty, aes(x = date_range_btc_hashrate_difficulty, y = filtered_btc_hashrate_difficulty$Hash.Rate)) +
  geom_line(color = "orange", size = 1) +
  labs(x = "Date", y = "Total Hash Rate", title = "Bitcoin Address over time")

########
# PLOT #
ggplot() +
  geom_line(data = filtered_btc_price, aes(x = date_range_btc, y = log_Price / max(log_Price)), color = "orange", size = 1, linetype = "solid") +
  geom_line(data = filtered_btc_price, aes(x = date_range_btc, y = log_Price / max(log_Price)), color = "red", size = 1, linetype = "solid") +
  geom_line(data = filtered_btc_hashrate_difficulty, aes(x = date_range_btc_hashrate_difficulty, y = log_HashRate / max(log_HashRate)), color = "blue", size = 1, linetype = "dashed") +
  labs(x = "Date", y = "Log(Price)", title = "Bitcoin Price and Another Time Series") +
  scale_linetype_manual(name = "Legend", values = c("solid", "dashed"), labels = c("Bitcoin Price", "Another Time Series"))



