plot_ratiostackbar <- function(df, title="ratio-stack bar plot") {
  
  df <- na.omit(df)
  input_category <- unique(df[,1])
  output_number_positive <- integer(length(input_category))
  output_number_negative <- integer(length(input_category))
  
  for (i in 1:length(input_category)){
    df_single_category <- df[df[,1] == input_category[i],]
    output_number_positive[i] <- dim(df_single_category[df_single_category[,2] == 1,])[1]
    output_number_negative[i] <- dim(df_single_category[df_single_category[,2] == 0,])[1]
  }
  
  data_plotting <- data.frame(input_category = rep(input_category,2),
                              output_number = c(output_number_positive, output_number_negative),
                              output_class = rep(c("positive","negative"), each=length(input_category)))
  
  g <- ggplot(data_plotting, aes(fill=output_class, y=output_number, x=input_category)) + 
    geom_bar(position="fill", stat="identity") +
    ylab("observation_ratio") +
    ggtitle(label=title)
  
  plot(g)
 }
 
