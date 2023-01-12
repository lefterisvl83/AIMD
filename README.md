# AIMD
This repository contains MATLAB files for running simulations and computing limit sets of an AIMD-based scheduling control method. The scheduling algorithm is described as follows.

We consider a set of $n$ computing nodes and assume that a workload $\lambda(t)$ enters the system via a central queue (buffer), as illustrated in Fig. \ref{fig:tandem_multi_2}. We assume that $\lambda: \mathbb{R}_{\geq 0} \to L$ is a measurable function \cite{Carothers2000}, with $L \subset \mathbb{R}_{>0}$. %\footnote{This assumption is compatible with a large class of workload profiles and consistent with our fluid-approximation setting. It also implies that $\lambda(t)$ is an integrable function guaranteeing that \eqref{eq:continousSystem_delta_w} is well-defined, and the integral in \eqref{eq:lambda(k)} exists.}
The continuous-time dynamics of the multi-queue system with backlog $[\delta(t)\;w(t)^\top]^\top$ can be written in a compact form as
\begin{align}\label{eq:continousSystem_delta_w}
\begin{bmatrix} \dot{\delta}(t) \\ \dot{w}(t) \end{bmatrix} = \begin{bmatrix}
     1 & -1^\top & 0^\top \\ 0 & I & -I 
\end{bmatrix} \begin{bmatrix}
     \lambda(t) \\ u(t) \\ \gamma(t)
\end{bmatrix}.
\end{align}


We transform \eqref{eq:continousSystem_delta_w} to a discrete-event system by introducing the following triggering mechanism. An event occurs at $t_k$, $k\in\mathbb{N}$, when the backlog in the buffer vanishes, i.e., when
\begin{equation}\label{eq:condition_delta}
    \delta(t_{k}) = 0.% \;\text{and}\; \lim_{\substack{t\to t_{k} \\ t< t_{k}}}\delta(t) \geq 0,
\end{equation}
Condition \eqref{eq:condition_delta} implies that all the requests queued in the buffer up to time $t_{k}$ have been dispatched to individual nodes. Hence, the buffer instantaneously vanishes at $t_{k}$. The sequence $\{t_k\}_{k=0}^\infty$ is non-decreasing, i.e., $t_k\leq t_{k+1}$. By associating $t_k$ with the $k^{\text{th}}$ event, we count events by the sequence $\{k\}_0^\infty$. The following scheduling logic guarantees the generation of events. Intuitively, should the buffer be non-empty, individual nodes attempt to drain the buffer by increasing their admission rates linearly. When an event occurs at $t_k$, individual admission rates drop instantaneously. We stress that this is the opposite of the classic AIMD scheme \cite{Chiu1989} where individual nodes attempt to fill up the underlying buffer. By denoting 
\begin{align}
    u_i(t_{k}^{-}) = \lim_{\substack{t\to t_{k} \\ t< t_{k}}} u_i(t), \;\;
    u_i(t_{k}^{+}) = \lim_{\substack{t\to t_{k} \\ t> t_{k}}} u_i(t),
\end{align}
i.e., the admission rate of the $i^{\text{th}}$ node right before and right after the $k^{\text{th}}$ event, respectively, we define
% Since we have $\delta(t_{k}^{+}) = 0$, i.e., no backlog lying in the buffer, it is sensible to require
\begin{equation}\label{eq:backoffing}
    u_i(t_{k}^{+}) = \beta_i u_i(t_{k}^{-}),
\end{equation}
where $0 \leq \beta_i < 1$ is called the \emph{multiplicative decrease parameter} or \emph{drop factor}. Intuitively, when the buffer is empty, individual admission rates are triggered to instantaneously shrink to a fraction of $u_i(t^{-})$ according to \eqref{eq:backoffing}. This is called the \emph{Multiplicative Decrease} (MD) phase. We note that multiple successive drops are permitted during the MD phase. Instantaneous drops are carried out as long as the buffer remains empty. Right after the MD phase, i.e., when $\delta(t_k^+) > 0$, we require the $i^{\text{th}}$ admission rate $u_i(t)$ grow in a ramp fashion as
\begin{equation}\label{eq:continuous_u(t)}
    u_i(t) = \beta_i u(t_{k}^{-}) + \alpha_i (t-t_{k}), \; t > t_{k},
\end{equation}
where the slope of the ramp $\alpha_i >0$ is called the \emph{growth rate} or the \emph{increase parameter}. Since $u_i(t)$ is strictly increasing in $t$, there exists a finite $t_{k+1} \geq t_k$ such that $\delta(t_{k+1}) = 0$, under a bounded workload. We call $T(k) = t_{k+1} - t_k$ the \emph{inter-event period}, and the interval $[t_{k}^{+},\;t_{k+1}^{-}]$ the \emph{Additive Increase} (AI) phase.
