%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TRABAJO DE CLUSTERING. K-MEANS. Yolanda Gonzalez Ruiz                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear,close all, clc

%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Selección de las variables de interés que permiten agrupar los          %
% municipios según la riqueza y la diferencia de la misma.                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Población de cada municipio
poblacion=xlsread('Datos.xlsx','Hoja1','G8:G1116');
% Quintiles re la riqueza
quintiles=xlsread('Datos.xlsx','Hoja1','M8:Q1116');
% Qué porcentaje de riqueza tiene el 1% de la población de ese municipio
porciento=xlsread('Datos.xlsx','Hoja1','P8:P1116');
% Renta imponible media por declarante
rimd=xlsread('Datos.xlsx','Hoja1','I8:I1116');
% Renta imponible media por habitante
rimh=xlsread('Datos.xlsx','Hoja1','J8:J1116');
% Diferencia de renta
dif_renta=rimd-rimh;
% Indice de Gini
gini=xlsread('Datos.xlsx','Hoja1','K8:K1116');
% Listado de los nombres de provincia por fila
[n,nombre_provincia]=xlsread('Datos.xlsx','Hoja1', 'D8:D1116');
% Listdo de los nombres de municipio por fila
[n,nombre_municipio]=xlsread('Datos.xlsx','Hoja1', 'F8:F1116');
% Matriz en la que se recogen los nombres de municipios y su provincia
lugar=[nombre_provincia nombre_municipio];

% Normalización de todas las variables

poblacion= (poblacion-mean(poblacion))/(std(poblacion));
gini= (gini-mean(gini))/(std(gini));
porciento=(porciento-mean(porciento))/std(porciento)
dif_renta= (dif_renta-mean(dif_renta))/(std(dif_renta));

for k=1:size(quintiles,2)
    quintiles(:,k)=(quintiles(:,k)-mean(quintiles(:,k)))/(std(quintiles(:,k)));
end

% Agrupación de las variables que se desean estudiar.
X=[poblacion dif_renta gini porciento quintiles(:,1)];

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Estudio previo del número de grupos que sería más correcto seleccionar  %
% mediante el estudio de BIC                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Se obtiene el BIC resultante de realizar entre 2 y 10 grupos
for K=2:10
    [cidx] = kmeans(X, K,'Replicates',10);
    [Bic_K,xi]=BIC(K,cidx,X);
    BICK(K)=Bic_K;
end
figure(1)
plot(2:K',BICK(2:K)','s-','MarkerSize',6,...
     'MarkerEdgeColor','r', 'MarkerFaceColor','r')
xlabel('K','fontsize',18)      
ylabel('BIC(K)','fontsize',18) 

% Se han seleccionado 8 grupos
num_grupos=8;

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Realización del clustering K-means                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

opts = statset('Display','iter','MaxIter',100);
[cidx, ctrs,sumd,D] = kmeans(X, num_grupos,'Replicates',1, 'Distance',...
                           'sqEuclidean','Options',opts);

% Se representan las muestras sin agrupar y agrupadas.

figure(2)  
hold on    
subplot(1,2,1),plot(X(:,1),X(:,2:size(X,2)),'s','MarkerSize',6,'MarkerEdgeColor','r','MarkerFaceColor','r');
xlabel('POblacion','fontsize',10),ylabel('Variables','fontsize',10)
axis('square'), box on;
title('Poblacion-Variables','fontsize',10)

color=["r","b","g","y","c","m","k"];
form=["o","*","s"];

c=1;
f=1;

for i=1:num_grupos
    if c>size(color)
        c=1;
        f=f+1;
    end
    hold on
    subplot(1,2,2),plot(X(cidx==i,1),X(cidx==i,2:size(X,2)),form(f),'MarkerSize',6,'MarkerEdgeColor',color(c),'MarkerFaceColor',color(c));
    c=c+1;
end
xlabel('Poblacion','fontsize',10),ylabel('Variables','fontsize',10)
axis('square'), box on;
title('Poblacion-Variables','fontsize',10)

% Se calcula la matriz medf donde se recoge la media de cada uno de los
% valores estudiados para cada uno de los grupos.
for i=1:num_grupos
    for j=1:size(X,2)
        medf(i,j)=mean(X(cidx==i,j));
    end
end

% Para observar estos vaores medios y poderlos comparar entre los grupos se
% representan los datos con un diagrama de barras.

figure(3)
bar(medf),legend('Poblacion','Dif-renta','gini','Porciento', 'Quinti1');
xlabel('Grupos','fontsize',12);

% Obtenemos una tabla de cada grupo donde se puede observar los municipios 
% pertenecientes a cada grupo

tableG1 = table(lugar(cidx==1,1),lugar(cidx==1,2),'VariableNames',{'Provincia','Municipio'})
tableG2 = table(lugar(cidx==2,1),lugar(cidx==2,2),'VariableNames',{'Provincia','Municipio'})
tableG3 = table(lugar(cidx==3,1),lugar(cidx==3,2),'VariableNames',{'Provincia','Municipio'})
tableG4 = table(lugar(cidx==4,1),lugar(cidx==4,2),'VariableNames',{'Provincia','Municipio'})
tableG5 = table(lugar(cidx==5,1),lugar(cidx==5,2),'VariableNames',{'Provincia','Municipio'})
tableG6 = table(lugar(cidx==6,1),lugar(cidx==6,2),'VariableNames',{'Provincia','Municipio'})
tableG7 = table(lugar(cidx==7,1),lugar(cidx==7,2),'VariableNames',{'Provincia','Municipio'})
tableG8 = table(lugar(cidx==8,1),lugar(cidx==8,2),'VariableNames',{'Provincia','Municipio'})

