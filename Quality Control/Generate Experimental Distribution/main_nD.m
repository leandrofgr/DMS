%% Ramdom sampling from the distribution (analytical form)
n_points = 10000;
L_range = 15;
[corr_func] = construct_correlation_function(L_range,1,zeros(n_points,1),3,0);

%% Gaussian random fields with zero mean and std 1
sampling_normal01_1 = FFT_MA_3D(corr_func,randn(n_points,1));
sampling_normal01_1 = sampling_normal01_1-mean(sampling_normal01_1(:));
sampling_normal01_1 = sampling_normal01_1/std(sampling_normal01_1 );

sampling_normal01_2 = FFT_MA_3D(corr_func,randn(n_points,1));
sampling_normal01_2 = sampling_normal01_2-mean(sampling_normal01_2(:));
sampling_normal01_2 = sampling_normal01_2/std(sampling_normal01_2 );

sampling_normal01_3 = FFT_MA_3D(corr_func,randn(n_points,1));
sampling_normal01_3 = sampling_normal01_3-mean(sampling_normal01_3(:));
sampling_normal01_3 = sampling_normal01_3/std(sampling_normal01_3 );

sampling_normal01_4 = FFT_MA_3D(corr_func,randn(n_points,1));
sampling_normal01_4 = sampling_normal01_4-mean(sampling_normal01_4(:));
sampling_normal01_4 = sampling_normal01_4/std(sampling_normal01_4 );

sampling_normal01_5 = FFT_MA_3D(corr_func,randn(n_points,1));
sampling_normal01_5 = sampling_normal01_5-mean(sampling_normal01_5(:));
sampling_normal01_5 = sampling_normal01_5/std(sampling_normal01_5 );

sampling_normal01_6 = FFT_MA_3D(corr_func,randn(n_points,1));
sampling_normal01_6 = sampling_normal01_6-mean(sampling_normal01_6(:));
sampling_normal01_6 = sampling_normal01_6/std(sampling_normal01_6 );


%% Sampling from the conditional distributions (Gaussian with a mean that depends on the other variables)
z1_analytic = sampling_normal01_1;
z2_analytic = sampling_normal01_2 - (z1_analytic-1).^2;
z3_analytic = sampling_normal01_3 - 10*sin(z2_analytic/5);
z4_analytic = sampling_normal01_4 - (z3_analytic)/4;
z5_analytic = sampling_normal01_5.*z1_analytic - (z2_analytic)/4;
z6_analytic = sampling_normal01_6 - 10*cos(z2_analytic/5);


% generate_logs
% generate_variograms