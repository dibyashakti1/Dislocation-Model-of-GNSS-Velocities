% The matlab code help to model the observed velocities from GPS stations across thrust faults 
% by analyzing misfit between the fault Slip rate, Locking Depth, Fault Dip, and Vertical offset (Based on methods by Okada 1992)

% Misfit analysis between the observed and modelled GPS velocities for dip-slip faults 
% (Variable: Slip rate, Locking Depth, Fault Dip & Vertical Offset uY)

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
hold off 
plot(x/1e3,uY,'r','linewidth',1)

%%

% Generate Okada dislocation (slip rate deficit curve)
fault=[-1e9,0;1e9,0];
dip1=10;
dip=(180-dip1)*pi/180;
depth=[0e3,18e3];
B=13;
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
% (Variable: Slip rate, Locking Depth, Dip, Vertical Offset uY)

Fault_slip=load('Dauki_test.txt');
dist=Fault_slip(:,1);
slip=Fault_slip(:,2);
error=Fault_slip(:,3);
% errorbar(dist,slip,error)

RMSE1=[];

fprintf('Estimating RMSE by varying fault Slip rate, Locking Depth, Dip, Vertical Offset...\n')

for i=0:1000:20000     % Locking depth (in meters) 
    for j=0:1:20       % Fault slip rate (in mm)
        for k=1:45     % Fault Dip (in degrees)
            for m=-5:5 % Fault slip vertical offset (in mm)
            

fault=[-1e9,0;1e9,0];
dip1=k;
dip=(180-dip1)*pi/180;
depth=[0e3,i];
B=j;
type='D';
Mu=30e9;
Poisson=0.25;
nobs=16;
% y=linspace(-500e3,500e3,nobs);
% x=1e3*[500];
y=dist*1e3;
x=0*y;
z=0*y;

[uX,uY,uZ]=Okada1992(x,y,z,fault,dip,depth,B,type,Mu,Poisson);

uY(y>0)=uY(y>0)+(B*cosd(dip1));
uY=uY+m;
%plot(y/1e3,uY,'-rx','linewidth',1)

% hold on

% Fault_slip=load('Detachment_sites.txt');
% dist=Fault_slip(:,1);
% slip=Fault_slip(:,2);
% error=Fault_slip(:,3);
% errorbar(dist,slip,error)

%    RMSE1 = [RMSE1;i/1000,(i/1000)/sind(dip),j,sqrt(mean((slip(:)-uY(:)).^2))];
     RMSE1 = [RMSE1;i/1000,j,k,m,(1/nobs)*sqrt(sum((slip(:)-uY(:)).^2./error.^2))];  % RMSE estimation between observed and modelled GPS velocities
    end 
    uY=[]; 
end
end
end

fprintf('Estimating RMSE by varying fault Slip rate, Locking Depth, Dip, Vertical Offset...Done\n')

%%

x2=RMSE1(:,1);
y2=RMSE1(:,2);
z2=RMSE1(:,3);
p1=RMSE1(:,4);
p2=RMSE1(:,5);

minError = find(p2==min(p2));
depth2=x2(minError);
slip2=y2(minError);
dip2=z2(minError);
dip3=(180-dip2)*pi/180;
Vert_offset=p1(minError);

figure(1),clf
[uX,uY,uZ]=Okada1992(x,y,z,fault,dip3,[0,depth2*1e3],slip2,type,Mu,Poisson);
uY(y>0)=uY(y>0)+(slip2*cosd(dip2));
plot(y/1e3,uY+Vert_offset,'-bx','linewidth',1,'DisplayName','Modelled')
hold on
errorbar(dist,slip,error,'DisplayName','Observed')
xlim([-300,300])
legend ('location','northwest')


figure(2),clf
nobs=200;
y=linspace(-500e3,500e3,nobs*2);
x=0*y;
z=0*y;
[uX,uY,uZ]=Okada1992(x,y,z,fault,dip3,[0,depth2*1e3],slip2,type,Mu,Poisson);
uY(y>0)=uY(y>0)+(slip2*cosd(dip2));

legend(plot(y/1e3,uY+Vert_offset,'g','linewidth',1,'DisplayName','Best Fit'))
hold on
errorbar(dist,slip,error,'DisplayName','Observed')
xlim([-300,300])
legend ('location','northwest')
caption = sprintf('Dip = %g, Locking Depth = %g km, Slip = %g mm/yr, uY = %g mm/yr', dip2, depth2, slip2, Vert_offset);
title(caption, 'FontSize', 10);

