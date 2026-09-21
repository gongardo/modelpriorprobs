# Prior Model Probabilities for Bayesian Variable Selection

This repository provides the R function `priorprobs()`, which computes several prior model probability distributions for Bayesian variable selection as studied in:

> Berger, J., García-Donato, G., and Pericchi, L. (2026). *On Model Prior Probabilities in Variable Selection*.

The function is intended to be used together with the R package **BayesVarSel** for Bayesian variable selection and model uncertainty analysis.

## Overview

In Bayesian variable selection problems, the choice of prior probabilities over the model space can have a substantial impact on posterior inference, particularly in high-dimensional settings.

The function `priorprobs()` implements the model prior specifications discussed and compared in the accompanying paper, including:

- Half-k prior
- Half-p prior
- Casella-Moreno-Girón (CGM) prior
- Hierarchical Beta (HB) prior
- Harmonic prior
- Beta(1,2) prior

These priors provide alternatives to the commonly used Uniform and Jeffreys model priors, with varying degrees of parsimony and multiplicity control.

## Installation

Clone this repository or download the function file:

```bash
git clone https://github.com/your_username/your_repository.git
```

Then source the R file:

```r
source("priorprobs.R")
```

## Function Description

```r
priorprobs(k, type = "Half-k")
```

### Arguments

| Argument | Description |
|-----------|-------------|
| `k` | Number of candidate explanatory variables in the full model (excluding fixed covariates). |
| `type` | Character string indicating the prior model probability specification. |

Possible values for `type` are:

```r
"Half-k"
"Half-p"
"CGM"
"HB"
"Harmonic"
"Beta(1,2)"
```

### Value

The function returns a numeric vector of length `k + 1`.

The `d`-th component (with `d = 0, ..., k`) gives the probability assigned to 
a single model containing exactly `d` explanatory variables (not counting fixed ones).

These probabilities can be directly supplied to `BayesVarSel`.

## Using with BayesVarSel

The output of `priorprobs()` can be passed to functions such as `Bvs()` or `GibbsBvs()` through the argument `priorprobs`, setting `prior.models = "User"`.

### Example

```r
library(BayesVarSel)

pr <- priorprobs(k = 20, type = "Half-p")

fit <- Bvs(
  formula = y ~ .,
  data = mydata,
  prior.models = "User",
  priorprobs = pr
)
```

## Examples

### Half-k Prior

```r
pr <- priorprobs(30, "Half-k")
```

### Half-p Prior

```r
pr <- priorprobs(30, "Half-p")
```

### Harmonic Prior

```r
pr <- priorprobs(30, "Harmonic")
```

### Beta(1,2) Prior

```r
pr <- priorprobs(30, "Beta(1,2)")
```

## Dependencies

Only the `"Half-p"` specification requires an additional package:

```r
install.packages("zipfR")
```

The package is used to evaluate the incomplete Beta function.

## Implemented Priors

### Half-k

A strongly parsimonious prior that follows Jeffreys-type probabilities for smaller model sizes while penalizing large models more aggressively.

### Half-p

A prior induced by assigning a uniform distribution to the prior inclusion probability over approximately half of its parameter space. It satisfies strong parsimony while remaining simple to compute.

### CGM

The Casella-Moreno-Girón prior, based on a Poisson mixture motivated by intrinsic prior ideas.

### HB

A hierarchical Beta prior obtained by placing a hyperprior on the Beta shape parameter governing variable inclusion probabilities.

### Harmonic

A prior assigning probability to model dimensions proportional to the reciprocal of dimension plus one.

### Beta(1,2)

A simple Beta-binomial specification corresponding to a Beta(1,2) prior distribution on the common inclusion probability.

## Reference

Berger, J., García-Donato, G., and Pericchi, L. (2026). *On Model Prior Probabilities in Variable Selection*.

## Citation

If you use this code in academic work, please cite the accompanying article.

```bibtex
@misc{berger2026objective,
title = {On Model Prior Probabilities in Variable Selection},
author = {Berger, J., García-Donato, G., Pericchi, L.},
year = {2026},
eprint = {2603.19728},
archivePrefix= {arXiv},
primaryClass = {stat.ME},
doi = {10.48550/arXiv.2603.19728},
url = {https://arxiv.org/abs/2603.19728}
}
}
```

## License

This repository is distributed for research and educational purposes. Please refer to the repository license for details.
