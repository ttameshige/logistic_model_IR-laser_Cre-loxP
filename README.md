# logistic_model_IR-laser_Cre-loxP

This is a program to analyze probabilities of stochastic cellular events like cellular Cre-loxP DNA recombination or cell death.
This works on R with Stan.
input data: tab delimited file including objective variable (0 or 1 indicating occurance of Cre-loxP recombination) and explanatory variable (continuous values of laser power)
outputs: probability plots from logistic model

# output examples

解析結果を直感的に伝える図を載せる

# Requirements
* R
* cmdstanr
* posterior
* ggplot2
* dplyr
* tidyverse
* tibble
* posterior
* bayesplot

# Installation

Requirementで列挙したライブラリなどのインストール方法を説明する

cmdstanr 
は、

他のRパッケージは
```{r}
library(cmdstanr)
library(posterior)
library(ggplot2)
library(dplyr)
library(tidyverse)
library(bayesplot)
```

# Usage

DEMOの実行方法など、基本的な使い方を説明する

Bayesian model from Stan
```{r}
source(描画関数1)
data <- read.delim()
model <- 

```

GLM model
```{r}
source(描画関数1)
data <- read.delim()
model <- 

```

# Note

右肩上がりのデータ、1でプラトーに達するデータについては glm がおすすめ、
1未満でプラトーに達するデータについては Stan で求めた bayesian model がおすすめ、
後者はN数を要求する点と、convergence をチェックした方が良い。

# Author

Toshiaki Tameshige
affiliation1: KIBR, YCU
E-mail:
affiliation1: Niigata Univ.

# License
MIT license (https://en.wikipedia.org/wiki/MIT_License).
