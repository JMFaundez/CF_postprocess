addpath matlab_script/
clear all
close all
input_p = 'fringe_m20.f00008';
nelx = 165;
nely = 40;
[data_p,lr1,elmap,time,istep,fields,emode,wdsz,etag,header,status] = readnek(input_p);
[xx,yy,vx,vy,p,t] = reshapenek(data_p,nelx,nely);

xa = xx(1,:);
[x0, in] = min(abs(xa));
in = 600; % consider just the upper surface
xa = xa(in:end);
pa = p(1,in:end);
[ny,nx] = size(xx);
alpha = zeros(ny,nx);
dx = xx(10,:) - xx(1,:);
dy = yy(10,:) - yy(1,:);
L = sqrt(dx.^2 + dy.^2);
a = acos(dy./L);
for i=1:nx
    alpha(:,i) = a(i);
end
U0 = 1;
pinf = 0;
pref = U0^2/2+pinf;

Uv = sqrt((pref-pa)*2);
cp = (pa-pinf)/(pref - pinf);

ut = vx.*cos(alpha) + vy.*sin(alpha);

dth = zeros(length(pa),1);
y99 = zeros(length(pa),1);
for i=1:length(pa)
  for j=1:ny
	if ut(j,i+in-1)>=0.99*Uv(i)
	  j = j-2;
	  integrand = 1-ut(1:j,in+i-1)/Uv(i);
	  nn = zeros(j,1);
	  nn = sqrt((yy(1:j,in+i-1)-yy(1,in+i-1)).^2+(xx(1:j,in+i-1)-xx(1,in+i-1)).^2);
	  dth(i) = trapz(nn,integrand);
	  y99(i) =  sqrt((yy(j,in+i-1)-yy(1,in+i-1))^2+(xx(j,in+i-1)-xx(1,in+i-1))^2);
	  j = j+2;
	end
  end
end

figure()
plot(xa,pa)
xlabel('Chord')
ylabel('Pressure')

figure()
plot(xa,dth)
xlim([0 0.35])
xlabel('Chord')
ylabel("$\delta^*$", 'Interpreter','latex')

figure()
plot(xa,y99)
xlim([0 0.35])
xlabel('Chord')
ylabel("$\delta$", 'Interpreter','latex')
