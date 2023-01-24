clear
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

% Misfit analysis between observed and modelled GPS velocities for dip-slip faults
% (Variable: Slip rate, Locking Depth, Dip, Vertical Offset uY)

Fault_slip=load('SF_profile_Vigny_sites.txt');
dist=Fault_slip(:,1);
slip=Fault_slip(:,2);
error=Fault_slip(:,3);
% errorbar(dist,slip,error)

hold off

RMSE1=[];

for i=0:1000:30000   % Locking depth (in meters)
    for j=0:30       % Fault slip rate (in mm)
        for k=70:89  % Fault Dip (in degrees)
            for m=-5:5 % Fault slip vertical offset (in mm)

fault=[0,1e9; 0,-1e9];
dip1=k;
dip=k*pi/180;
depth=[0e3,i];
B=j;
type='S';
Mu=30e9;
Poisson=0.25;
nobs=18;
x=dist*1e3;
y=0*x+0;
z=0*x;

[uX,uY,uZ]=Okada1992(x,y,z,fault,dip,depth,B,type,Mu,Poisson);

uY(x<0)=uY(x<0)-(B/2);
uY(x>0)=uY(x>0)+(B/2);
% plot(x/1e3,uY+(B/2),'r','linewidth',1)
uY=uY+(B/2);
uY=uY+m;

     RMSE1 = [RMSE1;i/1000,j,k,m,(1/nobs)*sqrt(sum((slip(:)-uY(:)).^2./error.^2))];  % RMSE estimation between observed and modelled GPS velocities
uY=[]; 
            end 
        end
    end
end


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
[uX,uY,uZ]=Okada1992(x,y,z,fault,dip,[0,depth2*1e3],slip2,type,Mu,Poisson);
uY(x>0)=uY(x>0)+(slip2);
plot(x/1e3,uY+Vert_offset,'-rx','linewidth',1,'DisplayName','Modelled')
hold on
errorbar(dist,slip,error,'DisplayName','Observed')
xlim([-200,200])
legend ('location','northwest')

figure(2),clf
nobs=200;
x=linspace(-500e3,500e3,nobs);
y=0*x+0;
z=0*x;
[uX,uY,uZ]=Okada1992(x,y,z,fault,dip,[0,depth2*1e3],slip2,type,Mu,Poisson);
uY(x>0)=uY(x>0)+(slip2);

legend(plot(x/1e3,uY+Vert_offset,'g','linewidth',1,'DisplayName','Best Fit'))
hold on
errorbar(dist,slip,error,'DisplayName','Observed')
xlim([-200,200])
legend ('location','northwest')
caption = sprintf('Dip = %g, Locking Depth = %g km, Slip = %g mm/yr, uY = %g mm/yr', dip2, depth2, slip2, Vert_offset);
title(caption, 'FontSize', 10);




