function [parametri,greska,G] = identificiraj(ulaz,izlaz,red_sistema,...
    period_uzorkovanja)

%otklanjanje srednje vrijednosti iz ulaznog i izlaznog signala
%radi bolje identifikacije
ulaz_sr = mean(ulaz);
izlaz_sr = mean(izlaz);
%ulaz = ulaz - ulaz_sr;
%izlaz = izlaz - izlaz_sr;

duzina = size(izlaz,1);
N = duzina-red_sistema-1;

%formiranje matrice podataka psi
psi =[];
for i = red_sistema-1:-1:0
    kolona = [];
    for k = 1:N+1
        kolona = [kolona;-izlaz(i+k)];
    end
    psi = [psi kolona];
end
for i = red_sistema-1:-1:0
    kolona = [];
    for k = 1:N+1
        kolona = [kolona;ulaz(i+k)];
    end
    psi = [psi kolona];
end

%formiranje vektora izlaza
y = izlaz(red_sistema+1:red_sistema+N+1);

%definisanje kriterija
kriterij = @(x) sum((y-psi*x').^2); %j=e^2

%definicija parametara algoritma
velicina_populacije = 20;
broj_iteracija = 1000;
min_vrijednost_param = -1000;
max_vrijednost_param = 1000;
[parametri,greska] = PSO(kriterij,velicina_populacije,broj_iteracija,...
    2*red_sistema,max_vrijednost_param,min_vrijednost_param);

%formiranje prijenosne funkcije sistema
nazivnik = [1;parametri(1:red_sistema)'];
brojnik = [0; parametri(red_sistema+1:red_sistema+red_sistema)'];
G = tf(brojnik',nazivnik',period_uzorkovanja);
end