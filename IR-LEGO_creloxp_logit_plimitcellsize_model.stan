data {
  int<lower=0> N;
  vector[N] power;
  vector[N] size;
  int<lower=0,upper=1> induction[N];
}
parameters {
  real<lower=-1,upper=5> alpha_one;
  real<lower=-10,upper=2> alpha_two;
  real<lower=-5,upper=5> alpha_three;
  real<lower=-40,upper=10> beta;
  real<lower=-1,upper=1> plimit_b;
  real<lower=-1,upper=1> plimit_a;
}
transformed parameters {
  real<lower=-100,upper=100> x[N];
  for (k in 1:N)
    x[k]=(plimit_b+plimit_a*size[k])*Phi_approx(beta+alpha_one*power[k]+alpha_two*size[k]+alpha_three*power[k]*size[k]);
}
model {
  for (n in 1:N)
    induction[n] ~ bernoulli(x[n]);
}
