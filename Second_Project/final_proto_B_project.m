function [ P_matlab,P_theory ] = final_proto( diaspora,n,snr_db)
if nargin ==0 %
diaspora = 10^(-6);
n = 10000;
snr_db = 5;
elseif nargin == 1
n = 10000;
snr_db = 10;
elseif nargin == 2
snr_db = 10;
end

Ç åíôïëç isscalar âãÜæåé ëïãéêï false or true
compare = isscalar(diaspora);
compare1 = isscalar(n );
compare2 = isscalar(snr_db );
if (compare) == 0 || (compare1 == 0) || (compare2 == 0)
errordlg('the inputs must be scalar','error');
P_matlab = 0; %|| 
P_theory = 0;
return; %
end

snr = 10^(snr_db/10); % 
e = snr *diaspora; 
l = sqrt(e); 
source = rand(1,n); 
x_n = zeros(size(source));

simvola = [l*(1+1j)/sqrt(2) , l*(-1+1j)/sqrt(2) ,l*(-1-1j)/sqrt(2) , l*(1-1j)/sqrt(2) ];
for i = 1 : length(source)
	if source(i) <= 0.25
		x_n (i) = simvola(1);
	elseif source(i) <= 0.5
		x_n(i) = simvola(2);
	elseif source(i) <= 0.75
		x_n(i) = simvola(3);
	else
		x_n(i) = simvola(end);
	end
end


noise1 = randn(1,n).*sqrt(diaspora);
noise2 = randn(1,n).*sqrt(diaspora);
w_n = noise1 + noise2.*1j;

r_n = x_n + w_n;

Ôá äéáíýóìáôá color êáé color_erot èá ôá ÷ñçóéìïðïéÞóù óôï åñþôçìá 2 ôï color åßíáé Ýíá cell-array ðïõ ìðïñåß íá ðåñéÝ÷åé êåëéÜ ðïõ óôï êÜèå êåëß ìðïñù íá âÜëù üôé èÝëù (strings,matrix,arrays) åãþ Ýâáëá strings
d_n = zeros(size(receiver));
temp = zeros(1,4);
color_erot = cell(1,n);
color = {'x yellow','x blue','x cyan','x green'};
for i = 1 : length(r_n)
	for j = 1 :length(temp)
		temp (j) = abs(r_n(i)-simvola(j));%
	end %(end j)
temp_min = min (temp); 

	for t = 1 : length(simvola)
		if temp_min == abs(r_n(i)-simvola(t))
			d_n (i) = simvola(t);
			color_erot{i} = color{t};
		end %(end if)
	end %(end t)
end %(end i)

P_theory = 2*qfunc(sqrt(e/(2*diaspora)))*(1 - 0.5*qfunc(sqrt(e/(2*diaspora))));

counter = 0;
for i = 1 : length(d_n)
	if d_n(i) ~= x_n(i)
		counter = counter + 1;
	end
end

P_matlab = counter/n;
save('project','d_n','x_n','r_n','color_erot')
end 
