function [Fx, Fy] = fftreal(x, y)
    if nargin<1
        Fs = 1000;            % Sampling frequency                    
        T = 1/Fs;             % Sampling period       
        L = 1500;             % Length of signal
        t = (0:L-1)*T;        % Time vector
        f = Fs*(0:L-1)/L;

        x = cos(2*pi*150*t);
        y = sin(2*pi*100*t);
    end

    f3 = x + i*y;
    F3 = fft(f3);
    L = length(F3);
    %第1項為平均值所以跳過
    for m = 2:L
        Fx(m) = (F3(m) + conj( F3(L-m+2) )) / 2;
        Fy(m) = (F3(m) - conj( F3(L-m+2) )) / (i*2);
    end
    figure;
    plot(abs(Fx));
    title("Fx");
    figure;
    plot(abs(Fy));
    title("Fy");
end