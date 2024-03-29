# logistic_model_IR-laser_Cre-loxP

* This is a program to analyze probabilities of stochastic cellular events like cellular Cre-loxP DNA recombination and cell death, which are occured when the cells are heated with IR-LEGO system (Kamei et al. Nat. Methods 6, 79-81. 2009)
This works on R with Stan.
* input data: tab delimited file including objective variable (0 or 1 indicating occurance of Cre-loxP recombination) and explanatory variable (continuous values of laser power)
* outputs: probability plots from logistic model
* demoData_analysis.Rmd is a simple analysis example. If you would like to consider some effects of cell sizes, try modeling and significance test according to demoData_analysis_3.Rmd. In it, *p*-value of the cell size effect is calculated by chi-square distribution-based method, but another calculation (parametric bootstrap approach) can be performed as in demoData_analysis_4pbLRT.Rmd. To run demoData_analysis_4pbLRT.Rmd, unzip original_model_parameters.zip.
- The original dataset obtained by Dr. Tomoi is in original_data_Tomoi_et_al_2023.zip (Reference: Tomoi et al. (2023) *Front. Plant Sci.* doi: 10.3389/fpls.2023.1171531)

# output examples

from such a data
![download-2](https://user-images.githubusercontent.com/51182565/143690704-5e0aea83-8e27-40f8-b54d-15a491b53551.png)
calculate a logistic model like this.
![download](https://user-images.githubusercontent.com/51182565/143690433-b35130a3-508d-4013-9d35-95ff71d3278d.png)

# Requirements
* R and following R libraries
* cmdstanr
* posterior
* bayesplot
* ggplot2
* dplyr
* tidyverse

# Installation

To install 'cmdstanr', 'posterior' and 'bayesplot', see the github page https://github.com/stan-dev/cmdstanr
In my environment, installation was done by following three commands.
```{r}
devtools::install_github("stan-dev/cmdstanr")
library(cmdstanr)
install_cmdstan()
```

For other R packages: 'tidyverse', 'ggplot2' and 'dplyr', see tidyverse web page https://tidyverse.tidyverse.org/
In my environment, installation was done by following commands.
```{r}
install.packages("tidyverse")
```

# Usage

get a Bayesian model from Stan
```{r}
# import data
data <- read.delim("demoData_IR-LEGO_Cre-loxP_2.txt")

# data formatting
power_upper_limit <- 15.5    #set upper limit of fitting data
data <- data[data$laser_power < power_upper_limit,]    #data filtering 
data.list <- list(N=dim(data)[1], 
                        induction=data$recombination, 
                        power=data$laser_power)

# import Stan model
file <- "IR-LEGO_creloxp_logit_plimit_model.stan" #define the Stan model file
mod <- cmdstan_model(file)    #compile the model

# MCMC sampling for logistic model: induction ~ power
fit_plimit_model <- mod$sample(
  data = data.list,
  seed = 123,
  adapt_delta = 0.999,
  chains = 4,
  parallel_chains = 2,
  refresh = 500
)

# format the sampling result into a data.frame
draws <- fit_plimit_model$draws()
fit_df <- as_draws_df(draws)

# get the most likely parameters from MCMC sampling
alpha <- median(fit_df$alpha)
beta <- median(fit_df$beta)
p.limit <- median(fit_df$plimit)

# make a data frame to plot the logistic model
x <- seq(5, 15, length.out = 50)
y <- p.limit / (1 + exp(- beta - alpha * x))
plot_df <- data.frame(x, y)

# plot the model
p <- ggplot() +
  geom_line(aes(x, y), data = plot_df, size = 2, color="green") +
  scale_x_continuous("Laser Power (mW)", limits = c(5, 20), breaks = seq(5, 20, 2),
                       ) +
    scale_y_continuous("Probability", limits = c(-0.05, 1.05),
                       breaks = seq(0, 1, 0.2))
print(p)

```

get standard logistic model from glm()
```{r}
data <- read.delim("demoData_IR-LEGO_Cre-loxP_1.txt")
model <- glm(recombination ~ laser_power, data=data,family=binomial(link="logit"))
x <- seq(5, 18, length.out = 50)
y <- 1 / (1 + exp(- model$coefficients["(Intercept)"] - model$coefficients["laser_power"] * x))    # fitting model
plot_df <- data.frame(x, y)

p <- ggplot() +
  geom_line(aes(x, y), data = plot_df, size = 2, color="blue") +
  scale_x_continuous("Laser Power (mW)", limits = c(5, 20), breaks = seq(5, 20, 2),
                       ) +
    scale_y_continuous("Probability", limits = c(-0.05, 1.05),
                       breaks = seq(0, 1, 0.2))
print(p)
```

# Note

If the maximum probability is  almost 100%, glm() works well.
If there is a plateau at lower probability, bayesian modeling with Stan works well. 
It should be considered that the latter method requires a larger data size and confirming the sampling convergence.

# Author

#### Toshiaki Tameshige PhD.
#### affiliation1: Kihara Institute for Biological Research, Yokohama City Univ.
#### affiliation2: Division of Biological Sciences, Graduate School of Science and Technology, Nara Institute of Science and Technology

# Acknowledgments
I appreciate Dr. Yasuhiro Sato for kind advise in appropriate usage of MCMC.

# License
MIT license (https://en.wikipedia.org/wiki/MIT_License).
