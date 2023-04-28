% The matlab code help to model the observed velocities from GPS stations across thrust faults 
% by analyzing misfit between the fault Slip rate & Locking Depth (Based on methods by Okada 1992)

% Misfit analysis between the observed and modelled GPS velocities for dip-slip faults 
% (Variable: Slip rate & Locking Depth ; Constant: Dip & Vertical Offset uY)

% Last modified on: 26 April, 2023 by Dibyashakti


clear all
close all
clc

%%

% To visualize motion at surface

fault=[0,0;5000e3,0];
dip1=7;
dip=(180-dip1)*pi/180;
depth=[0e3,20e3];
B=20;
type='D';
Mu=30e9;
Poisson=0.25;

nobs=100;
x=linspace(-500e3,500e3,nobs*2);
y=1e3*[ 100 ];
[X,Y]=meshgrid(x,y);
Z=0*X-0e3;

[uX,uY,uZ]=Okada1992(X,Y,Z,fault,dip,depth,B,type,Mu,Poisson);

quiver(x/1e3,y/1e3,uX,uY,1,'color','k')
xlim([-600,600])
ylim([0,250])
% hold on 
% plot(x/1e3,uY,'r','linewidth',1)

%%

% Generate Okada dislocation (slip rate deficit curve)
fault=[-1e9,0;1e9,0];
dip1=7;
dip=(180-dip1)*pi/180;
depth=[0e3,10e3];
B=12;
type='D';
Mu=30e9;
Poisson=0.25;

nobs=100;
y=linspace(-500e3,500e3,nobs*2);
x=1e3*[500];
[X,Y]=meshgrid(x,y);
Z=0*X-0e3;

[uX,uY,uZ]=Okada1992(X,Y,Z,fault,dip,depth,B,type,Mu,Poisson);

% uY(Y<0)=uY(Y<0)+(B/2);
% uY(Y>0)=uY(Y>0)-(B/2);

uY(Y>0)=uY(Y>0)+(B*cosd(dip1));
plot(y/1e3,uY,'r','linewidth',1)

hold on
%%

% Misfit analysis between observed and modelled GPS velocities for dip-slip faults
% (Variable: Slip rate & Locking Depth ; Constant: Dip & Vertical Offset uY)

Fault_slip=load('Dauki_test.txt');
dist=Fault_slip(:,1);
slip=Fault_slip(:,2);
error=Fault_slip(:,3);
% errorbar(dist,slip,error)

RMSE1=[];

fprintf('Estimating RMSE by varying fault slip rate and locking depth...\n')

for i=0:500:30000       % Locking depth (in meters) 
    for j=0:0.50:20     % Fault slip rate (in mm)

fault=[-1e9,0;1e9,0];
dip1=30;                 % Dip of the fault
dip=(180-dip1)*pi/180;
depth=[0e3,i];
B=j;
type='D';
Mu=30e9;
Poisson=0.25;
nobs=16;               % Number of GPS stations
% y=linspace(-500e3,500e3,nobs);
% x=1e3*[500];
y=dist*1e3;
x=0*y;
z=0*y;

[uX,uY,uZ]=Okada1992(x,y,z,fault,dip,depth,B,type,Mu,Poisson);

uY(y>0)=uY(y>0)+(B*cosd(dip1));
% uY=uY+1;
% plot(y/1e3,uY,'-r','linewidth',1)
% 
% hold on
% 
% Fault_slip=load('Test_data_th.txt');
% dist=Fault_slip(:,1);
% slip=Fault_slip(:,2);
% error=Fault_slip(:,3);
% errorbar(dist,slip,error)

%    RMSE1 = [RMSE1;i/1000,(i/1000)/sind(dip),j,sqrt(mean((slip(:)-uY(:)).^2))];
     RMSE1 = [RMSE1;i/1000,j,(1/nobs)*sqrt(sum((slip(:)-uY(:)).^2./error.^2))];  % RMSE estimation between observed and modelled GPS velocities
    end 
    uY=[];

end

fprintf('Estimating RMSE by varying fault slip rate and locking depth...Done\n')

%%

x2=RMSE1(:,1);
y2=RMSE1(:,2);
z2=RMSE1(:,3);
[X,Y]=meshgrid(min(x2):0.5:max(x2),min(y2):0.5:max(y2));
Z=griddata(x2,y2,z2,X,Y);


figure(1),clf
contourf(X, Y, Z)
minError = find(Z == min(Z(:)));
minX=X(minError);
minY=Y(minError);
hold on
plot(minX,minY,'o','color','red')


figure(2),clf
[uX,uY,uZ]=Okada1992(x,y,z,fault,dip,[0,minX*1e3],minY,type,Mu,Poisson);
uY(y>0)=uY(y>0)+(minY*cosd(dip1));
% uY=uY+1;
plot(y/1e3,uY,'-bx','linewidth',1,'DisplayName','Modelled')
hold on
errorbar(dist,slip,error,'DisplayName','Observed')
xlim([-300,300])
legend ('location','northwest')


figure(3),clf
nobs=200;
y=linspace(-500e3,500e3,nobs*2);
x=0*y;
z=0*y;
[uX,uY,uZ]=Okada1992(x,y,z,fault,dip,[0,minX*1e3],minY,type,Mu,Poisson);
uY(y>0)=uY(y>0)+(minY*cosd(dip1));


legend(plot(y/1e3,uY,'g','linewidth',1,'DisplayName','Best Fit'))
hold on
errorbar(dist,slip,error,'DisplayName','Observed')
xlim([-300,300])
legend ('location','northwest')

% plot(nan, nan, 'DisplayName', "Dip = " + dip1)

title(['Dip =  ' num2str(dip1), ' ; Locking Depth = ' num2str(minX), ' ; Slip = ' num2str(minY)])



% Write RMSE and Okada Locking curve files
fprintf('Saving file: Misfit between fault slip rate and locking depth...Done\n')
% save('DS_RMSE.txt','RMSE1','-ascii');
header1={'Locking_Depth_km','Slip_mm','rmse'}; 
file1=[header1;num2cell(RMSE1)];
writecell(file1,'DS_RMSE.txt');

fprintf('Saving file: Slip rate deficit curve...Done\n')
% save('DS_Okada_curve.txt','[(y/1000)',uY']','-ascii');
header2={'Distance_km','Slip_mm'}; 
file2=[header2;num2cell([(y/1000)',uY'])];
writecell(file2,'DS_Okada_curve.txt');

