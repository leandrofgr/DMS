# DMS
Direct Multivariate Simulation


Several geological applications require the generation of multiple realizations of random fields of subsurface properties to quantify and represent the model uncertainty. Some of the applications present complex multivariate distributions with  heteroscedasticity  and non-linear relations among the  variables. We propose a new algorithm, namely Direct Multivariate Simulation, for random field simulations of non-parametric multivariate joint distribution functions. The methodology is based on a generalization of the normal score and back transformation for multivariate distributions, also called Stepwise Conditional transformation. The sequential sampling of each variable is performed by decomposing the target joint distribution as a product of univariate marginal and conditional probability density functions. We  propose  numerical solutions to improve the algorithm efficiency and complexity for real case applications  with a large number of variables. The method is demonstrated for the sampling of a multivariate joint distributions in 2 and 6 dimensions with strong nonlinear dependencies among the variables. The results are validated by comparing the results to the Projection Pursuit Multivariate Transform, by computing the experimental correlation functions, the marginal distributions and the bi-histograms of the simulated variables. 

To use the algorithm, the user has to add the folders "Source Code" and "Quality Control" to the Matlab path. Then, any of the examples will be able to run. 
For the conditional simulations, the method is not very efficient because of the kriging library. The next version of DMS will address several aspects of computational efficiency including this one. 

For questions and suggestion, please send an e-mail to leandro@ltrace.com.br
