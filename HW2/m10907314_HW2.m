function m10907314_HW2(k, transition_band)

if nargin<2
   transition_band = [0.46 0.54];
end
if nargin<1
   k = 8;
end

N = 2*k + 1;
delta_F = 0.001;
sample_rate_F = 1/delta_F;

F = -0.5:delta_F:0.5;
Hd = fftshift(1i*2*pi*F);
F = 0:delta_F:1;
transition_linear = linspace(Hd(transition_band(1)*sample_rate_F),Hd(transition_band(2)*sample_rate_F),transition_band(2)*sample_rate_F-transition_band(1)*sample_rate_F);
Hd(transition_band(1)*sample_rate_F:transition_band(2)*sample_rate_F-1) = transition_linear;
%plot(F,imag(Hd),'r','lineWidth',1);

%hold on
Rn = [];
fn = [];
for m=0:N-1
    Rn = [Rn Hd(floor(m*sample_rate_F/N)+1)];
    fn = [fn F(floor(m*sample_rate_F/N)+1)];
end
%plot(fn,imag(Rn),'ro');

rn1 = ifft(Rn);
rn = fftshift(rn1);

RF = zeros(1,length(F));
for n=1:N
    RF = RF + rn(n)*exp(-1i*2*pi*F*(n-k-1));
end
hn = rn;

figure;
subplot(3,1,1)
x = 0:1:N-1;
stem(x,real(rn1))
xlim([-N N])
title('r1[n]')
xlabel('time')

subplot(3,1,2)
x = -k:1:k;
stem(x,real(rn))
xlim([-N N])
title('r[n]')
xlabel('time')

subplot(3,1,3)
x = 0:1:N-1;
stem(x,real(hn))
xlim([-N N])
title('h[n]')
xlabel('time')

figure;
subplot(2,1,1)
x = 0:1:N-1;
stem(x,real(hn))
xlim([-N N])
title('h[n]')
xlabel('time')

subplot(2,1,2)
plot(F,imag(RF),F,imag(Hd),'r','lineWidth',1);
title('Frequency Response')
xlabel('Frequency(Hz)')

