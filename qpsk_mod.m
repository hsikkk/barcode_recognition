function x=qpsk_mod(a,b,fb,fc,fs)
% QPSK modulation
% a: data row vector (+1 or -1)
% b: data row vector (+1 or -1)
% fb: baud rate (1/Tb, where Tb = symbol period)
% fc: carrier frequency
% fs: sampling rate, integer multiple of fb
% x: output row vector

n=length(a);    % length of input vector
m=round(fs/fb);
if m~=fs/fb
    error('fs/fb needs to be an integer')
end
s1=zeros(1,n*m);
s2=zeros(1,n*m);
s1(1:m:end)=a;   % interpolate by m
s2(1:m:end)=b;
r=rcosdesign(0.3,50,m); % root raised cosine with roll-off factor 0.3 and span from -25 to 25
q1=conv(s1,r);    % pulse shaping filtering
q2=conv(s2,r);
t=(0:length(q1)-1)/fs;
x=q1.*cos(2*pi*fc*t)+q2.*sin(2*pi*fc*t);
