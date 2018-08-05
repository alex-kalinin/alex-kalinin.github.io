---
title: "Sampling from a Normal distribution"
output:
  # pdf_document: default
  html_document:
    keep_md: yes
---


Most (if not all) programming languages have random numbers generator functions that produce *uniformly* distributed values. What about random numbers from an arbiutrary, *non-unform* distribution?

In this post we'll explore several methods to generate random numbers from a *Normal* distribution. To simplify things a bit we'll work with a *standard* Normal distribution. This distrubtion has a mean $\mu = 0$, and standard deviation $\sigma = 1$. This choice doesn't limit us in any way because there's a one-to-one mapping between the standard Normal distrubtion and any other normal distribution wiht the mean of $\mu$ and variance of $\sigma$:
$$
    x = x_{starndard} * \sigma + \mu
$$

# Method 1: Central Limit Theorem

[Central limit theorem](https://en.wikipedia.org/wiki/Central_limit_theorem) states that the mean of a *sum* of samples from *any* distribution approaches *Normal* as the size of the sample increases. This is really cool. Regardless how our original values are distributed, if we sum them up, we'll get an (approximate) Normal distribution! 

As little as ten elements in a sample is sufficient to approximate the normal distrubution quite closely. Here's the plan:

1. Generate 10 samples from our uniform random numbers generator, and add them up. 
0. Repeate this process 10,000 times to obtain 10,000 *normally* distributed samples.
0. Plot our distribution and compare it to the theoretical Normal disbribution to see if get the right result.

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
##           [,1]      [,2]        [,3]      [,4]      [,5]      [,6]
## [1,] 0.1550154 0.6081589 0.524891462 0.8443432 0.2974440 0.4264723
## [2,] 0.1760678 0.4134619 0.004717798 0.7105235 0.3728931 0.8227863
##           [,7]      [,8]      [,9]     [,10]
## [1,] 0.8957022 0.6740209 0.8091838 0.9741247
## [2,] 0.9284858 0.5291920 0.3129438 0.5810235
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

![]({{site.baseurl}}/assets/Sampling_From_a_Normal_Distribution_files/figure-html/unnamed-chunk-5-1.png)<!-- -->

# Inverse Transform Sampling

Inverse transform sampling relies on the fact, that if $X$ a random variable, $F$ is its cumulative distrubtion function (i.e. $F(x)$ is the probability of the value $\le$ x) then $F(x)$ is distributed *uniformly*. Let's test this statement:


```r
inverse_transform <- function () {
  samples <- rnorm(n = 100000, mean=0, sd=1)
  cdf <- pnorm(samples)
  dens(cdf)
}
inverse_transform()
```

![]({{site.baseurl}}/assets/Sampling_From_a_Normal_Distribution_files/figure-html/unnamed-chunk-6-1.png)<!-- -->

Indeed, a comulative distrition function is approximately uniform. So, if we know a CDF $F$ for a *Normal* distribution, we can generate sample from a Normal distribution via the following steps:

1. Generate samples $u$ from the *uniform* distribution
2. Calculate $x = F^{-1}(u)$, where $F$ is the CDF for the Normal distribution. Then $x$ will be normally distriubted.

However, this method is not very efficient for continuous cases where the $CDF$ doens't have an analytic integral. Normal distribution is such an example. Because of this, other methods are more popular.

# Box-Muller Transform

The box Box-Muller Transform algorithms transforms two *uniformly* distributed variables to two *normally* distributed variable. You can find the details on Wikipedia, https://en.wikipedia.org/wiki/Box%E2%80%93Muller_transform. Below is the implementation.


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
## [1,] 0.8666131 0.6518296
## [2,] 0.4394714 0.2100527
```

Apply the Box-Muller transform to obtain *normally* distributed sample. Both variables $z_{0}$ and $z_{1}$ will be normally distributed:

```r
z0 = sqrt(-2 * log(samples_matrix[,1])) * cos(two_pi * samples_matrix[,2])
z1 = sqrt(-2 * log(samples_matrix[,1])) * sin(two_pi * samples_matrix[,2])
head(z0)
```

```
## [1] -0.3095230  0.3184909 -0.2394092 -1.0529899  0.5878480  2.9463914
```

Let's combine $z_{0}$ and $z_{1}$ into a single array $z$. Let's plot the density function of $z$ and compare it to the true normal distribution:

```r
z = cbind(z0, z1)
dens(z, adj = 1)

true_normal.x <- seq(-3, 3, length.out = 100)
true_normal.y <- dnorm(true_normal.x, mean=0, sd=1)
lines(true_normal.x, true_normal.y, col="red")
```

![]({{site.baseurl}}/assets/Sampling_From_a_Normal_Distribution_files/figure-html/unnamed-chunk-11-1.png)<!-- -->

As we can see, Box-Muller transform indeed produces normally distributed values.
