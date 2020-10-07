function [corr_fun,scale_X,scale_Y] = compute_experimental_correlation_function(signal, L, sampling_rate_x, sampling_rate_y)


I = size(signal,1);
J = size(signal,2);

corr_fun = (ifftn( fftn(signal-mean(signal)).*conj(fftn(signal-mean(signal))) ));
corr_fun = corr_fun/max(corr_fun(:));

corr_fun = fftshift(corr_fun);

corr_fun = corr_fun(round(I/2)-round(L/2):round(I/2)+round(L/2),round(J/2)-round(L/2):round(J/2)+round(L/2));

scale_X = [-L/2:L/2]*sampling_rate_x;
scale_Y = [-L/2:L/2]*sampling_rate_y;