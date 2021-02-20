function [ Pe ,P] = complex_system(n , diaspora,snr_db ) % η εντολη nargin ‘μετράει’ τα inputs της function
%System 2
if nargin == 0% αμα δεν εχω βάλει κανένα input μου βάζει n = 20000 και διασπορά 10^(-6) και snr_db = 0:10 δηλαδή το function τρέχει και σαν script
	n = 20000;
	diaspora = 10 ^(-6);
	snr_db = 0 : 10;
elseif nargin == 1
	diaspora = 10 ^(-6);
	snr_db = 0 : 10;
elseif nargin == 2
	snr_db = 0 : 10;
end
test_n = isscalar(n); % ελεχνω αμα το n (length των διανυσμάτων) αμα είναι scalar δηλαδή 1 Χ 1 η εντολη isscalar και η isvector εχουνε εξοδο Boolean δηλαδή true false
test_d = isscalar(diaspora);
test_S = isvector(snr_db); %ελενχω αμα το snr_db είναι διάνυσμα
if (test_n == false )|| (test_d == false) || (test_S == false )
	% || σημαίνει λογικο OR
	errordlg('wrong inputs','error') % αμα έστω και ένα απτα παραπανω είναι false βγάζει ένα errordlg
	return % η εντολη return τερματίζει την function
end
tipiki_apoklisi = sqrt(diaspora);
snr = 10.^(snr_db/10);%απο λογαριθμιζω
% φτιάχνω διανύσματα γεμάτο από μηδενικά
dn = zeros(1 ,n );
rn = zeros(1 ,n );
receiver = zeros(1 ,n );
Pe = zeros( 1, length(snr));
P = zeros ( 1, length(snr));
for j = 1 :length(snr)
	E = snr(j)*diaspora; % υπολογιζω την μεση ενέργεια
	temp = 2*diaspora;
	A = sqrt(E); % υπολογιζω τα σύμβολα για κάθε τιμή του Ε αρα για κάθε τιμή του snr
	klasma = E/temp;
	Pe(j) = (qfunc(sqrt(klasma))); %υπολογισμός της θεωριτηκης πιθανότητας . Ο τύπος δίνεται απτο project οπου qfunc = Q
	xn = rand(1,n);%δημιουργώ την πηγή
	noise = tipiki_apoklisi.* randn(1,n);%θόρυβος με κατανομή Gaussian
	noise1 = tipiki_apoklisi.* randn(1,n);
	noise = 1j .*noise; % φτιαχνω το μιγαδικο μέρος του θορύβου
	wn = noise1+noise;% τελικος μιγαδικος θόρυβος οπου το κάθε μέρος του( πραγματικο και φανταστικο ) είναι διαφορετικά όπως ζητηθικε στο project
	counter= 0;
	for i = 1 : length(source)
		if xn(i) >= 0.5%κωδικοποιηση πομπου αφου η πηγή μου δημιουργήθηκε μεσω μιας rand η τιμές που θα παίρνει είναι από 0 – 1 αρα αμα κάποια τιμή της πηγής είναι μεγαλύτερο από 0.5 ή ισο τοτε βαλέ το σύμβολο Α αλλιώς 1j*A
			dn(i) = A;
		else
			dn(i) =1j* A;
		end
		% δημιουργώ τον δεκτή προσθέτοντας την κάθε τιμή του θορύβου στο κάθε ένα σύμβολο της πηγής
		receiver(i) = wn(i) + dn(i);
		% για να κωδικοποιήσω τον δεκτή
		temp1 = abs(receiver(i) - A );
		temp2 = abs(receiver(i) - 1j*A) ; % οπου abs είναι το μετρο
		if temp2>= temp1 %
			rn(i) = A;
		else
			rn(i) = 1j *A;
		end
		if rn(i) ~= dn(i)%αμα τα σύμβολα του δεκτή και του πομπού είναι διαφορετικά μεταξύ τους τοτε πρόσθεσε ένα counter
			counter = counter +1;
		end
	end
	P(j) = counter/n; % υπολογισμος της πειραματικής πιθανότητας
	counter= 0; %μηδενίζω τον counter αλλιώς η πιθανότητα θα μεγαλώνει για κάθε τιμή του snr
end
end