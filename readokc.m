function [X,Y,U,dU,u,du] = readokc(filename)
% read and unroll data
fid = fopen(filename,'r');
data = textscan(fid,'%f %f %f %f %f %f %f','HeaderLines',16);
xf = data{1};
yf = data{2};
zf = data{3};
Uf = data{4};
dUf = data{5};
uf = data{6};
duf = data{7};

x = sort(unique(xf));
y = sort(unique(yf));

[X,Y] = meshgrid(x,y);
method = 'nearest';
U = griddata(xf,yf,Uf,X,Y,method);
dU = griddata(xf,yf,dUf,X,Y,method);
u = griddata(xf,yf,uf,X,Y,method);
du = griddata(xf,yf,duf,X,Y,method);
end


%tri = delaunay(xf,yf);
%figure()
%trisurf(tri,xf,yf,zeros(length(xf),1),uf,'LineStyle','none')
%ylim([min(y) 0.05])
%view(0,90)
