clc;clear;

N = 19;
k = (N-1)/2;
delta_F = 0.00025;
delta_Err = 0.0001;
passband = [0.2, 0.5];
stopband = [0, 0.2];
weight_passband = 1;
weight_stopband = 0.5;
transition_band = [0.175, 0.225];
sample_rate_F = 1/delta_F;
Extreme_F = [0, 0.05, 0.10, 0.15, 0.25, 0.30, 0.35, 0.40, 0.45, 0.48, 0.5];

iteration_Err = []
previous_MaxErr = 0;
F = 0:delta_F:0.5;
Hd = 1.*(passband(1) <= F & F <= passband(2)) + 0.*(stopband(1) <= F & F <= stopband(2));
WF = weight_passband.*(passband(1) <= F & F <= passband(2)) + weight_stopband.*(stopband(1) <= F & F <= stopband(2));
WF( transition_band(1)*sample_rate_F+1 : transition_band(2)*sample_rate_F-1) = 0;
plot(F,WF,'r','lineWidth',1);
figure;
plot(F,Hd,'r','lineWidth',1);
set(gca,'YLim',[-0.5 1.5])
xlabel('F¶b');
ylabel('Hd(F)¶b');
grid on;

n = 0:1:k;
m = 0:1:k+1;
W = weight_passband.*(passband(1) <= Extreme_F & Extreme_F <= passband(2)) + weight_stopband.*(stopband(1) <= Extreme_F & Extreme_F <= stopband(2));
Flip = 1*(mod(m,2)==0) + -1*(mod(m,2)==1);

iteration_count = 0;
while(1)
    iteration_count = iteration_count +1;
    A = [cos(2*pi*Extreme_F'*n) (Flip./W)'];
    b = 1.*(passband(1) <= Extreme_F & Extreme_F <= passband(2)) + 0.*(stopband(1) <= Extreme_F & Extreme_F <= stopband(2));
    s = A\b'

    R = 0.*F;
    for i = (1:length(s)-1)
        R = R + s(i)*cos(2*pi*(i-1)*F);
    end
%     plot(F,R,F,Hd,'r','lineWidth',1);
%     set(gca,'YLim',[-0.5 1.5])
%     figure;

    Err = (R-Hd).*WF;
%     plot(F,Err,'r','lineWidth',1);

    tmp_Err = [0 Err 0];
    Err_index = [];
    Err_value = [];
    for i = (2:length(tmp_Err)-1)
        if (tmp_Err(i-1) < tmp_Err(i) && tmp_Err(i) > tmp_Err(i+1)) || (tmp_Err(i-1) > tmp_Err(i) && tmp_Err(i) < tmp_Err(i+1))
            Err_value = [Err_value tmp_Err(i)];
            Err_index = [Err_index i-1];
        end
    end

    New_Extreme_F = [];
    boundaries_F = [];
    boundaries_err_Err_value = [];
    for i = (1:length(Err_index))
        if Err_index(i) == 1 || Err_index(i) == length(F) || Err_index(i) == int32(transition_band(1)*sample_rate_F) || Err_index(i) == int32(transition_band(2)*sample_rate_F)
            boundaries_F = [boundaries_F (Err_index(i)-1)*delta_F];
            boundaries_err_Err_value = [boundaries_err_Err_value Err_value(i)];
        else
            New_Extreme_F = [New_Extreme_F (Err_index(i)-1)*delta_F];
        end
    end

    [value, index] = sort(abs(boundaries_err_Err_value), 'descend');
    for i = (1:length(Extreme_F)-length(New_Extreme_F))
        New_Extreme_F = [New_Extreme_F boundaries_F(index(i))];
    end

    now_MaxErr = max(abs(Err))
    iteration_Err = [iteration_Err now_MaxErr];
    if 0 <= previous_MaxErr - now_MaxErr && previous_MaxErr - now_MaxErr <= delta_Err
        break;
    else
        Extreme_F = sort(New_Extreme_F)
        previous_MaxErr = now_MaxErr;
    end
end
iteration_count 

subplot(2,1,1)
h_f = [(fliplr(s(2:end-1).'))/2 s(1) s(2:end-1).'/2];
x = 0:1:length(h_f)-1;
stem(x,h_f)
xlim([-1 length(h_f)+1])
ylim([min(h_f)-0.1 max(h_f)+0.1])
title('Impulse Response')
xlabel('time')

subplot(2,1,2)
plot(F,R,F,Hd,'r','lineWidth',1);
axis([0,0.5,-0.5,1.5])
title('Frequency Response')
xlabel('Frequency(Hz)')
% for i = 2:length(F)-1
%     xline(F(i),'--');
% end
%Extreme_F = sort(New_Extreme_F);