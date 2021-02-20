
function [ Pe,P ] = system_one( n,diaspora,Snr_db)
%System 1
% η εντολη nargin ‘μετράει’ τα inputs της function
if nargin == 1 % για nargin =1 δηλαδή αμα εχω ένα input από default μου βάζει διασπορά =0.000001 και snr_db = 0:10
	diaspora = 10^(-6);
	Snr_db = 0:10;
elseif nargin == 0 % αμα δεν εχω βάλει κανένα input μου βάζει n = 20000 και διασπορά 10^(-6) και snr_db = 0:10 δηλαδή το function τρέχει και σαν script
	n = 20000;
	diaspora = 10^(-6);
	Snr_db = 0 : 10;
end
test_n = isscalar(n); % ελέγχω αμα το n (length των διανυσμάτων) αμα είναι scalar δηλαδή 1 Χ 1 η εντολη isscalar και η isvector εχουνε εξοδο Boolean δηλαδή true ή false
test_d = isscalar(diaspora);
test_S = isvector(Snr_db); %ελέγχω αμα το snr_db είναι διάνυσμα
if (test_n == false )|| (test_d == false) || (test_S == false )
	% || σημαίνει λογικο OR
	errordlg('wrong inputs','error') % αμα έστω και ένα απτα παραπανω είναι false βγάζει ένα errordlg
	return % η εντολη return τερματίζει την function
end
snr = 10.^(Snr_db./(10)); % από λογαριθμιζω
receiver = zeros(1,n);
P = zeros(1,length(snr)); % το P και το Pe είναι και αυτά διανύσματα γεμάτο μηδενικά που θα αποθηκευσω την κάθε τιμή τους για διαφορετικά snr
Pe = P ;
counter=0;%τον counter τον χρειάζομαι για να υπολογίσω την πιθανότητα P (την πειραματική πιθανότητα δηλαδή) για κάθε τιμή του snr
for i = 1 : length(snr)
	E = snr(i)*diaspora;% υπολογιζω την το Ε ,Α για κάθε τιμή του snr
	A = sqrt(E);
	Temp = E/diaspora;
	Pe(i) = qfunc(sqrt(Temp));%για να βρω την θεωρητική πιθανότητα χρησιμοποιώ τον τύπο που δίνετε απτο project για την κάθε τιμή του snr
	xn = rand (1,n);%φτιάχνω μια τυχαία πηγή
	wn = randn(1,n);%αφου ο θόρυβος πρέπει να ακόλουθη την κανονική κατανομή
	wn = wn .*0.001; % ο θορυβος θα πρέπει να έχει διασπορά 10 ^(-6)
	dn = zeros(1,n);%διάνυσμα γεμάτο με μηδενικά που θα αποθηκεύσω τα σύμβολα της πηγής
	rn = dn;%σύμβολα του δεκτή
	%%κωδικοποίηση του πομπού
	for j = 1 : n
		if xn(j)>= 0.5 % μεσω της for παίρνω την κάθε τιμή της source (πηγής ) και την κωδικοποιώ αφου την πηγή την έφτιαξα με την εντολη rand ολες οι τιμές θα είναι από 0 – 1 αρα λεω αμα κάποια τιμή της source είναι μεγαλύτερο από 0.5 ή ισο τοτε βαλέ Α αλλιώς -Α
			dn(j) = A;
		else
			dn(j) = -A; end % τέλος της if
			receiver(j) = dn(j)+ wn(j);
			% για κάθε τιμή του θορύβου πρόσθεσε το ανάλογο σύμβολο ( Α ή –Α) και το αποτέλεσμα τους αποθηκευσετο στα σύμβολα του δεκτή
			%% κωδικοποίηση δεκτή
		if receiver (j)>=0
			rn(j) = A;
		else
			rn (j) = -A;
		end
		if rn (j)~=dn(j)%αμα τα σύμβολα του δεκτή με του πομπού ειναι διαφορετικά πρόσθεσε ένα στον counter counter=counter +1;
		counter = counter + 1
		end
	end
	P(i)=counter / n; %υπολογισμός πειραματικής πιθανότητας
	counter=0; % ξανά ‘ρυθμίζω’ τον counter = 0 διότι αλλιώς η πιθανότητα θα αυξανόταν αφου ποτέ δεν θα μηδένιζε
end
end
