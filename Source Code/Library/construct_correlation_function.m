function [correlation_function] = construct_correlation_function(Lv, Lh, signal, type, angle)
% Lv - Vertical correlation range
% Lh - Horizontal correlation range
% signal - It is just to define the size of the simulations (FFTMA works better if we define the filter with the same size of the white noise)
% type - 1 for Gaussian, 1 for exponential and 3 for spherical
% angle - Used for anisotropic spherical models

ordem = 2;
I = size(signal,1);
J= size(signal,2);
K = size(signal,3);
desvio = 1.0*1/4;

correlation_function = zeros(I,J,K);
for i=1:I
    for j=1:J
        for k=1:K
            
            x = (i-round(I/2));
            y = (j-round(J/2));
            theta = atand(y/x);
            a = 1 / sqrt( sind( angle-theta )^2 * Lh^-2 + cosd( angle-theta )^2 * Lv^-2 );
            
            h = sqrt( ( x )^2 + ( y )^2 + ((k-round(K/2)))^2);
            h = h/a;
            
            if type==1
                h = h*3;
                value = exp( -h.^2  );
            end
            if type==2
                h = h*3;
                value = exp( -h );
            end
            
            if type==3
                if h<=1
                    value = 1 - 1.5 * h + 0.5 * h^3;
                else
                    value=0;
                end
            end
            
            % taper to avoid FFT artefacts:
            value_window = exp( -(abs((i-round(I/2))/(desvio*I))^ordem + abs((j-round(J/2))/(desvio*J))^ordem  + abs((k-round(K/2))/(desvio*K))^ordem));            
            correlation_function(i,j,k) = value*value_window;
            %correlation_function(i,j,k) = value;
            
        end
    end
end

correlation_function(round(I/2),round(J/2),round(K/2)) = 1;

