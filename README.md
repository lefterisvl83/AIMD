# AIMD scheduling and resource allocation of distributed computing systems

## Repository
This repository contains MATLAB files for running simulations and computing limit sets of an AIMD-based scheduling and resource allocation control method. The scheduling algorithm is described below.

## The algorithm

We consider a set of $n$ computing nodes and assume that a workload $\lambda(t)$ enters the system via a central queue (buffer). We define workload as the arrival rate of requests entering a system of computing nodes via an aggregation point. 

We consider an event-triggered scheme where an event occurs once the central queue (buffer) vanishes. The logic of the proposed scheduling algorithm is as follows. Intuitively, should the buffer be non-empty, individual nodes attempt to drain the buffer by increasing their admission rates linearly. When an event occurs at $t_k$, individual admission rates drop instantaneously. We stress that this is the opposite of the classic AIMD scheme where individual nodes attempt to fill up the underlying buffer. In other words, individual admission rates are triggered to instantaneously shrink to a fraction of $u_i(t^{-})$ at each event. This is called the \emph{Multiplicative Decrease} (MD) phase. We note that multiple successive drops are permitted during the MD phase. Instantaneous drops are carried out as long as the buffer remains empty. Right after the MD phase, we require the $i^{\text{th}}$ admission rate $u_i(t)$ grow in a ramp fashion, i.e., $u_i(t) = \beta_i u(t_{k}^{-}) + \alpha_i (t-t_{k}), \; t > t_{k}$, where the slope of the ramp $\alpha_i >0$ is called the \emph{growth rate} or the \emph{increase parameter}. Since $u_i(t)$ is strictly increasing in $t$, there exists a finite $t_{k+1} \geq t_k$ such that the buffer vanishes, under a bounded workload. We call $T(k) = t_{k+1} - t_k$ the \emph{inter-event period}, and the interval $[t_{k}^{+},\;t_{k+1}^{-}]$ the \emph{Additive Increase} (AI) phase.


## Requirements
`compute_limit_set.m` requires the MPT3 toolbox for generating Polyhedra objects

## Saturated AIMD
The fixed point of our AIMD algorithm contrained by saturators can be computed in `search_fixed_point.m` for arbitrary AIMD configurations. Simulations under constraints can be carried out in `AIMD_scheduler_and_resource_allocator.m` for constant or time-varying workload profiles.


## Main references
Description and preliminary results of the algorithm can be found here https://doi.org/10.1109/CDC45484.2021.9683379 

A journal version is under review. It will be released once accepted for publication.
