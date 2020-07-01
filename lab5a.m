fc=2000;        % carrier freq.
fb=100;         % baud rate
fs=44100;       % sampling rate
% a=zeros(1,40);  % 30 symbols
% b=zeros(1,40);  % 30 symbols
% a(1:5)=1;       % preamble, five 1's
% b(1:5)=1;
% a(6:40)=randi(2,1,35)*2-3;   % 25 random samples of +1/-1
% b(6:40)=randi(2,1,35)*2-3;
% x=qpsk_mod(a,b,fb,fc,fs);
% sound(x,fs)

[x,fs]=audioread('lab5_qpsk_received_line.wav');
x = x';
% rec=audiorecorder(fs,16,1,1);
% recordblocking(rec,2); 
% x=getaudiodata(rec)';
%%

tt=(0:length(x)-1)/fs;
figure
plot(tt,x)      % plot of modulated signal
xlabel('time [sec]')
fvtool(x)       % magnitude in frequency domain 

[start, theta, freq_offset]=find_timing_phase_freq_offset(x,fb,fc,fs); 
freq_offset=0;
y1=x.*cos(2*pi*(fc+freq_offset)*tt+theta);  % multiplication by cosine and sine
y2=x.*sin(2*pi*(fc+freq_offset)*tt+theta);
m=fs/fb;    % this needs to be an integer
r=rcosdesign(0.3,50,m); % root raised cosine with roll-off factor 0.3 and span from -25 to 25
y1f=conv(y1,r);  % matched filtering (since r is symmetric, it does not need to be flipped)
y2f=conv(y2,r);
t=(0:length(y1f)-1)/fs;   % change 't' to match the length of y1f and y2f
y1s=y1f(start:m:end);   % sampling
y2s=y2f(start:m:end);
ts=t(start:m:end);
figure
plot(t,y1f,'b',t,y2f,'r',ts,y1s,'o',ts,y2s,'o')
xlabel('time [sec]')
figure
plot(y1f,y2f,':',y1s,y2s,'o')
axis equal
grid on
xlabel('Real')
ylabel('Imaginary')

length1 = max(length(y1s),length(y2s));
n=0;
a_bit=zeros(1,40);
b_bit=zeros(1,40);
location=0;
 
for i= 1:length1
    if(y1s(i)>0.1&&y2s(i)>0.1)       
        n=n+1;                   
        if(n==5)                          
           a_bit(1:5)=1;
           b_bit(1:5)=1; 
           location=i;               
           break
        end
        
    else
        n=0;
    end
end   
 
if(location)                              
    for i=1:35
        if(y1s(location+i)>0.01)
            a_bit(i+5)=1;
        end    
        if(y1s(location+i)<-0.01)
            a_bit(i+5)=-1;
        end
        if(y2s(location+i)>0.01)
            b_bit(i+5)=1;
        end
        if(y2s(location+i)<-0.01)
            b_bit(i+5)=-1;
        end      
    end        
end   

 %%
 a_TA=xlsread('a_THU.csv');
b_TA=xlsread('b_THU.csv');

a_bit - a_TA
b_bit - b_TA
