data {
  int<lower=0> N;
  vector[N] power;
  int<lower=0,upper=1> induction[N];
}
parameters {
  real<lower=0,upper=5> alpha;
  real<lower=-40,upper=10> beta;
  real<lower=0,upper=1> plimit;
}
transformed parameters {
  real<lower=-100,upper=100> x[N];
  for (k in 1:N)
    x[k]=plimit*Phi_approx(beta+alpha*power[k]);
}
model {
  for (n in 1:N)
    induction[n] ~ bernoulli(x[n]);
}
