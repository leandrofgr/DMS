close all;
root_noises = randn(1000,1, 1);  
%FFTMA
range_vertical = 10;
range_horizontal = 1;
noises = root_noises;
[correlation_function] = construct_correlation_function(range_vertical,range_horizontal,noises,1,0);
noises = FFT_MA_3D(correlation_function,noises);
%FFTMA

figure;


subplot(1,5,1:4);
plot(noises)
noises2 = make_it_gaussian(noises);
hold on;
plot(noises2);
title('Tracks')
xlabel('index');
ylabel('g');
legend('Original Noise', 'Post-Processed Noise ');

subplot(1,5,5);
histogram(noises, 'DisplayStyle','stairs', 'NumBins', 100);
hold on
histogram(noises2, 'DisplayStyle','stairs', 'NumBins', 100 );
set(gca,'view',[90 -90])
title('Histograms');
xlabel('g');
ylabel('Frequence');
% legend('Histogram of Original Noise', 'Histogram of Post-Processed Noise');