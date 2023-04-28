% The matlab code help to model the observed velocities from GPS stations across srike-slip faults 
% by analyzing misfit between the fault Slip rate & Locking Depth (Based on methods by Okada 1992)

% Misfit analysis between the observed and modelled GPS velocities for strike-slip faults 
% (Variable: Slip rate & Locking Depth ; Constant: Dip & Vertical Offset uY)

% Last modified on: 26 April, 2023 by Dibyashakti


clear all
close all
clc

%%
% To visualize motion at surface

fault=[0,-1e9; 0,1e9];
dip=89*pi/180;
depth=[0e3,15e3];
B=20;
type='S';
Mu=30e9;
Poisson=0.25;

nobs=100;
x=linspace(-500e3,500e3,nobs*2);
y=0*x;
[X,Y]=meshgrid(x,y);
Z=0*X-0e15;

[uX,uY,uZ]=Okada1992(X,Y,Z,fault,dip,depth,B,type,Mu,Poisson);

% uY(X<0)=uY(X<0)-(B/2);
% uY(X>0)=uY(X>0)+(B/2);
figure(1),clf
quiver(x/1e3,y/1e3,uX,uY,0,'color','k')
xlim([-500,500])
ylim([-20,20])
hold off

%%

% Generate Okada dislocation (slip rate deficit curve)
nobs=100;
x=linspace(-100e3,100e3,nobs);
y=0*x+0;
z=0*x;

[uX,uY,uZ]=Okada1992(x,y,z,fault,dip,depth,B,type,Mu,Poisson);

uY(x<0)=uY(x<0)-(B/2);
uY(x>0)=uY(x>0)+(B/2);
figure(2),clf
plot(x/1e3,uY+(B/2),'r','linewidth',1)

hold off

%%

% Misfit analysis between observed and modelled GPS velocities for strike-slip faults
% (Variable: Slip rate & Locking Depth ; Constant: Dip & Vertical Offset uY)

Fault_slip=load('SF_profile_Vigny_sites.txt');
dist=Fault_slip(:,1);
slip=Fault_slip(:,2);
error=Fault_slip(:,3);
errorbar(dist,slip,error)

hold off

RMSE1=[];

fprintf('Estimating RMSE by varying fault slip rate and locking depth...\n')

for i=0:1000:40000   % Locking depth (in meters)
    for j=0:40       % Fault slip rate (in mm)

fault=[0,1e9; 0,-1e9];
dip1=89;             % Dip of the fault
dip=89*pi/180;
depth=[0e3,i];
B=j;
type='S';
Mu=30e9;
Poisson=0.25;
nobs=18;             % Number of GPS stations
x=dist*1e3;
y=0*x+0;
z=0*x;

[uX,uY,uZ]=Okada1992(x,y,z,fault,dip,depth,B,type,Mu,Poisson);

uY(x<0)=uY(x<0)-(B/2);
uY(x>0)=uY(x>0)+(B/2);
% plot(x/1e3,uY+(B/2),'r','linewidth',1)
uY=uY+(B/2);

     RMSE1 = [RMSE1;i/1000,j,(1/nobs)*sqrt(sum((slip(:)-uY(:)).^2./error.^2))];  % RMSE estimation between observed and modelled GPS velocities

    end 
    uY=[]; 
end

fprintf('Estimating RMSE by varying fault slip rate and locking depth...Done\n')

%%

x2=RMSE1(:,1);
y2=RMSE1(:,2);
z2=RMSE1(:,3);
[X,Y]=meshgrid(min(x2):max(x2),min(y2):max(y2));
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
uY(x>0)=uY(x>0)+(minY);
plot(x/1e3,uY,'-rx','linewidth',1,'DisplayName','Modelled')
hold on
errorbar(dist,slip,error,'DisplayName','Observed')
xlim([-200,200])
legend ('location','northwest')

figure(3),clf
nobs=200;
x=linspace(-500e3,500e3,nobs*2);
y=0*x+0;
z=0*x;
[uX,uY,uZ]=Okada1992(x,y,z,fault,dip,[0,minX*1e3],minY,type,Mu,Poisson);
uY(x>0)=uY(x>0)+(minY);

legend(plot(x/1e3,uY,'g','linewidth',1,'DisplayName','Best Fit'))
hold on
errorbar(dist,slip,error,'DisplayName','Observed')
xlim([-200,200])
legend ('location','northwest')

% plot(nan, nan, 'DisplayName', "Dip = " + dip1)

title(['Dip =  ' num2str(dip1), ' ; Locking Depth = ' num2str(minX), ' ; Slip = ' num2str(minY)])


% Write RMSE and Okada Locking curve files
fprintf('Saving file: Misfit between fault slip rate and locking depth...Done\n')
% save('SS_RMSE.txt','RMSE1','-ascii');
header1={'Locking_Depth_km','Slip_mm','rmse'}; 
file1=[header1;num2cell(RMSE1)];
writecell(file1,'SS_RMSE.txt');

fprintf('Saving file: Slip rate deficit curve...Done\n')
% save('SS_Okada_curve.txt','[(x/1000)',uY']','-ascii');
header2={'Distance_km','Slip_mm'}; 
file2=[header2;num2cell([(x/1000)',uY'])];
writecell(file2,'SS_Okada_curve.txt');

