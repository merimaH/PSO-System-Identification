function [parametri,greska] = PSO(kriterij, velicina_populacije, max_iter,...
    dimenzionalnost, x_max, x_min)

v_max = x_max;

%parametri algoritma
c1 = 2;
c2 = 2;
runno = 70; %broj ponavljanja vanjske petlje

%kreiranje pocetne populacije koristenjem uniformne raspodjele
x = (x_max - x_min)*rand(velicina_populacije,dimenzionalnost,1)...
    + x_min;

parametri = zeros(1,dimenzionalnost);
greska = kriterij(x(end,:));
for run = 1:runno
    p_best = x;
    
    %racunanje fitnessa za svaku jedinku populacije
    for i = 1:velicina_populacije
        f_x(i) = kriterij(x(i,:));
        f_pbest(i) = f_x(i);
    end
    
    %trazenje indeksa najbolje jedinke iz populacije
    %ukoliko ih ima vise uzima se ona sa najnizim indeksom
    g = min(find(f_pbest==min(f_pbest(1:velicina_populacije))));
    g_best = p_best(g,:); %memorisanje najbolje jedinke
    f_gbest = f_pbest(g); %memorisanje vrijednosti kriterija
    %za najbolju jedinku
    for n=1:max_iter
        w = (0.9-0.4)*(max_iter-n)/max_iter+0.4;
        [m,p] = size(x);
        v = zeros(m,p);
        %modifikacija pozicija cestica populacije
        for i = 1:velicina_populacije
            
            v(i,:)=v(i,:)+c1*rand(1,dimenzionalnost).*(p_best(i,:)-x(i,:))+...
                c2*rand(1,dimenzionalnost).*(g_best-x(i,:));
            v(i,:)=sign(v(i,:) ).*min(abs(v(i,:) ),v_max);
            x(i,:)=x(i,:)+v(i,:);
            f_x(i)=kriterij(x(i,:));
            %smjena najboljih jedinki
            if f_x(i)<f_pbest(i)
                p_best(i,:)=x(i,:);
                f_pbest(i)=f_x(i);
            end
            if f_pbest(i)<f_gbest
                g_best=p_best(i,:);
                f_gbest=f_pbest(i);
            end
        end
    end
    if f_gbest<greska
        greska = f_gbest;
        parametri = g_best;
    end
    
end
end