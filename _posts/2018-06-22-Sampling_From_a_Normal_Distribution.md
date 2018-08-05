---
title: "Sampling from a Normal distribution"
output:
  # pdf_document: default
  html_document:
    keep_md: yes
---


Most (if not all) programming languages have random number functions that produce *uniformly* distributed values. What about random numbers from an arbiutrary, *non-unform* distribution?

In this post we'll explore several methods to generate random numbers from a *Normal* distribution. To simplify things a bit we'll work with a *standard* Normal distribution. This distrubtion has a mean $\mu = 0$, and a standard deviation $\sigma = 1$. This choice doesn't limit us in any way because there's a one-to-one mapping between the standard Normal distrubtion and any other normal distribution with the mean of $\mu$ and variance of $\sigma$:

$$
    x = x_{starndard} * \sigma + \mu
$$

# Method 1: Central Limit Theorem

[Central limit theorem](https://en.wikipedia.org/wiki/Central_limit_theorem) states that the mean of a *sum* of samples from *any* distribution approaches *normal* distribution as the size of the sample increases. This is really cool. Regardless of how our original values are distributed, if we sum them up we get an (approximate) normal distribution! 

As little as ten elements in a sample is sufficient to approximate the normal distrubution quite closely. Here's the plan:

1. Generate 10 samples from our uniform random numbers generator. 
1. Sum them up. 
0. Repeate this process 10,000 times to obtain 10,000 *normally* distributed samples.
0. Plot our distribution and compare it to the theoretical normal disbribution to see if get the right result.

Below is the annotated code in **R** language. You can easily re-implement this in any other language.

The number of samples per iteration is 10:

```r
sample_n = 10 # We will draw samples form the uniform distribution
```

The number of values from a Normal distibution:

```r
n = 10000 # The number of normal samples
```

Generate 10 x 10,000 total random numbers from a *uniform* distribution $[0, 1]$:

```r
uniform_samples = runif(n = sample_n * n, min = 0, max = 1)
```

Reshape our array into a matrix of 10,000 rows with 10 elements in each row:

```r
samples_matrix <- matrix(uniform_samples, nrow=n, byrow = T)
head(samples_matrix, n = 2)
```

```
##           [,1]      [,2]      [,3]      [,4]      [,5]       [,6]
## [1,] 0.9727642 0.5018574 0.3576453 0.8427131 0.4238725 0.32359105
## [2,] 0.6406173 0.1055573 0.6640449 0.7001536 0.9661355 0.03897372
##           [,7]      [,8]      [,9]     [,10]
## [1,] 0.8323036 0.2403960 0.4343607 0.9390714
## [2,] 0.8014148 0.9892574 0.3761951 0.5546839
```


```r
x <- rowMeans(samples_matrix)
# dens(samples)
mu = 0.5
sigma = sd(uniform_samples) / sqrt(sample_n)
normal_x = (x - mu) / sigma

dens(normal_x, adj = 1)
true_normal.x <- seq(-3, 3, length.out = 100)
true_normal.y <- dnorm(true_normal.x, mean=0, sd=1)
lines(true_normal.x, true_normal.y, col="red")
```

![](Sampling_From_a_Normal_Distribution_files/figure-html/unnamed-chunk-5-1.png)<!-- -->

# Inverse Transform Sampling

Inverse transform sampling relies on the fact that if $X$ is a random variable, $F$ is its cumulative distribution function (i.e. $F(x)$ is the probability of the value being $\le x$ ) then $F(x)$ is distributed *uniformly*. Let's test this statement:


```r
inverse_transform <- function () {
  samples <- rnorm(n = 100000, mean=0, sd=1)
  cdf <- pnorm(samples)
  dens(cdf)
}
inverse_transform()
```

![](Sampling_From_a_Normal_Distribution_files/figure-html/unnamed-chunk-6-1.png)<!-- -->

Indeed, a comulative distribution function is approximately uniform. So, if we know a CDF $F$ for a *Normal* distribution, we can generate samples from the Normal distribution via the following steps:

1. Generate samples $u$ from the *uniform* distribution
2. Calculate $x = F^{-1}(u)$, where $F$ is the CDF for the Normal distribution. Then $x$ will be normally distriubted.

However, this method is not very efficient for continuous cases where the cumilative distribution function $CDF$ doesn't have an analytic integral. Normal distribution is such an example. Because of this, other methods are more popular.

# Box-Muller Transform

[The Box-Muller Transform](https://en.wikipedia.org/wiki/Box%E2%80%93Muller_transform. Below is the implementation) algorithm transforms two *uniformly* distributed variables into two *normally* distributed variables. The implementation is below.


First, let's define some constants:

```r
eps = .Machine$double.eps
two_pi = 2 * 3.141592653589793
```

The number of normally distributed samples we want to get:

```r
n = 10000
```

Generate uniform samples, 5,000 rows x 2 samples in each row, the total of 10,000 samples:

```r
uniform_samples = runif(n = n, min = 0, max = 1)
samples_matrix <- matrix(uniform_samples, nrow=n / 2, byrow = T)
head(samples_matrix, n = 2)
```

```
##           [,1]      [,2]
## [1,] 0.1982855 0.4757175
## [2,] 0.1236461 0.9002370
```

Apply the Box-Muller transform to obtain *normally* distributed samples. Both variables $z_{0}$ and $z_{1}$ will be normally distributed:

```r
z0 = sqrt(-2 * log(samples_matrix[,1])) * cos(two_pi * samples_matrix[,2])
z1 = sqrt(-2 * log(samples_matrix[,1])) * sin(two_pi * samples_matrix[,2])
head(z0)
```

```
## [1] -1.77801793  1.65595782  0.63486864  0.02115269 -0.10711628  0.75609500
```

Let's combine $z_{0}$ and $z_{1}$ into a single array $z$, plot the density function of $z$, and compare it to the true normal distribution:

```r
z = cbind(z0, z1)
dens(z, adj = 1)

true_normal.x <- seq(-3, 3, length.out = 100)
true_normal.y <- dnorm(true_normal.x, mean=0, sd=1)
lines(true_normal.x, true_normal.y, col="red")
```

![](Sampling_From_a_Normal_Distribution_files/figure-html/unnamed-chunk-11-1.png)<!-- -->

As we can see, Box-Muller transform indeed produces normally distributed values.
