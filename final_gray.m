function [ P_gray] = final_gray( snr_db,diaspora,n )
if nargin == 0
	diaspora = 10^(-6);
	n = 10000;
	snr_db = 5;
elseif nargin == 1
	n = 10000;
	snr_db = 10;
elseif nargin == 2
	snr_db = 10;
end


compare = isscalar(snr_db );
compare1 = isscalar(diaspora);
compare2 = isscalar(n );
if (compare == false) || (compare1 == false) || (compare2 == false)
	errordlg('inputs must be scalar','error')
	P_binary = 0;
	return;
end
%
snr = 10^(snr_db/10); % 
e = snr *diaspora; % 
l = sqrt(e); %
simvola = [l*(1+1j)/sqrt(2) , l*(-1+1j)/sqrt(2) ,l*(-1-1j)/sqrt(2) , l*(1-1j)/sqrt(2) ];
source = rand(1,n); %
for i = 1 : length(source) %
	if source(i)>= 0.5
		source(i) = 1;
	else
		source(i) = 0;
	end
end
x_n_gray = zeros(1,n/2); 
counter = 1;

for i = 1 :2: length(source)
	if source(i) == 0 && source(i+1)== 0
		x_n_gray(counter) = simvola(1);
	elseif source(i) ==0 && source(i+1) ==1
		x_n_gray(counter) = simvola(2);
	elseif source(i) ==1 && source(i+1) ==1
		x_n_gray(counter) = simvola(3);
	else`
		x_n_gray(counter) = simvola(4);
	end
	counter = counter+1;
end


noise1 = randn(1,n/2).*sqrt(diaspora);
noise2 = randn(1,n/2).*sqrt(diaspora);
w_n = noise1 + noise2.*1j;


r_n = x_n_gray + w_n; % 
d_n = zeros(size(r_n));
temp = zeros(1,4);
for i = 1 : length(r_n)
	for j = 1 :length(temp)
		temp(j) = abs(r_n(i)-simvola(j)); 
	end%(end j)
temp_min = min(temp);

	for t = 1 : length(temp)
		if temp_min == abs(r_n(i)-simvola(t))
			d_n(i) = simvola(t);
		end
	end
end
counter =1 ;
receiver_bits_gray = zeros(size(source));
for j = 1 : length(receiver_coding)
	if (d_n(j) == simvola(1))
		receiver_bits_gray (counter)=0;
		receiver_bits_gray (counter+1)=0;
	elseif (d_n (j) ==simvola(2))
		receiver_bits_gray (counter)=0;
		receiver_bits_gray (counter+1)=1;
	elseif (d_n (j) ==simvola(3))
		receiver_bits_gray (counter) = 1 ;
		receiver_bits_gray (counter+1) = 1;
	else
		receiver_bits_gray (counter) = 1 ;
		receiver_bits_gray (counter+1) = 0;
	end
	counter = counter+2;
end
counter = 0;

for k = 1 : length(receiver_bits_gray)
	if receiver_bits_gray (k) ~= source(k)
		counter = counter+1;
	end
end
P_gray = counter/n;
end