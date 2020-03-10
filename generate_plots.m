close all
clear all
clc

t = 0;
x = ['05' ;'10'; '18'; '25'; '28'; '30'];

% Uncomment if want to re interpolate the data
%for i=1:6
%    filename = ['./x',x(i,:),'/tan000',num2str(t),'.okc'];
%    [X Y U dU u du] = readokc(filename);
%    outfile = ['./x',x(i,:),'/data',num2str(t),'.mat'];
%    save(outfile,'X','Y','U','dU','u','du')
%end

Xc = cell(6,1);
Yc = cell(6,1);
Uc = cell(6,1);
uc = cell(6,1);
minU = 100;
%%
minu = 100;
maxU = 0;
maxu = 0;
for i=1:6
    infile = ['./x',x(i,:),'/data',num2str(t),'.mat'];
    data = load(infile);
    Xc{i} = data.X;
    Yc{i} = data.Y;
    Uc{i} = data.U;
    uc{i} = data.u;
    if min(Uc{i}(:))<minU
        minU = min(Uc{i}(:));
    end
    if min(uc{i}(:))<minu
        minu = min(uc{i}(:));
    end
    if max(Uc{i}(:))>maxU
        maxU = max(Uc{i}(:));
    end
    if max(uc{i}(:))>maxu
        maxu = max(uc{i}(:));
    end
end

[ny,nx] = size(Xc{1});
y99 = zeros(6,1);
u99 = zeros(6,1);
dth = zeros(6,1);

for i=1:6
    xi = str2double(x(i,:))*0.01;
    [u99(i),y99(i),dth(i)] = uinf(xi);
end

nx = nx  + 1;

for plotId=1:6
    X = Xc{plotId};
    Y = Yc{plotId};
    U = Uc{plotId};
    u = uc{plotId};
    Y = Y -min(Y(:));
    figure(2000)
    sgtitle('Tangent Perturbation')
    subplot(3,2,plotId)
    hold on
    xco = X./dth(plotId,1);
    yco = Y./dth(plotId,1);
    y99i = y99(plotId)*ones(length(X(1,:)),1)/dth(plotId,1);
    contourf(xco,yco,u,'LineStyle','none')
    plot(xco(1,:),y99i,'k-','LineWidth',1.5)
    if plotId==2
        str = 'Boundary Layer';
        text(-20,1.2*y99i(1),str)
    end
    xlabel('Span/$\delta^*$','Interpreter','latex')
    ylabel('Normal/$\delta^*$','Interpreter','latex')
    ylim([0, 10])
    title([x(plotId,:),'% chord'])
    hold off
    %caxis([minu maxu])
    colorbar()

    figure(2001)
    sgtitle('Tangent Velocity')
    subplot(3,2,plotId)
    contourf(xco,yco,U,'LineStyle','none')
    xlabel('Span/$\delta^*$','Interpreter','latex')
    ylabel('Normal/$\delta^*$','Interpreter','latex')
    ylim([0, 10])
    %caxis([minU maxU])
    title([x(plotId,:),'% chord'])
    colorbar()


    xf = linspace(-0.015,0.015,nx);
    yf = [1.0 1.5 2.0]*dth(plotId);
    %yf = [0.5 0.8 1 1.5 2 2.5 3]*1e-3;
    [Xi,Yi] = meshgrid(xf,yf);
    ui = interp2(X,Y,u, Xi,Yi,'makima');

    FF = fft(ui');
    size(ui);
    T = xf(2) - xf(1);
    L = nx;
    Fr = 1/T;
    f = Fr*(0:(L/2))/L;
    P2 = abs(FF/L);
    P1 = P2(1:L/2+1,:);
    P1(2:end-1,:) = 2*P1(2:end-1,:);
    size(P1);

    lbl = cell(length(yf),1);
    figure(2002)
    sgtitle('FFT')
    subplot(3,2,plotId)
    hold on
    for i=1:length(yf)
      lbl{i} = ['y=',num2str(yf(i)/dth(plotId),'%.2f'),'$\delta^*$'];
      plot(1./f/dth(plotId), P1(:,i),'-o')
      %semilogx(1./f,P1(:,i),'-')
    end
    xlabel("$\lambda/\delta^*$",'Interpreter','latex')
    ylabel("$|u'(\lambda)|$", 'Interpreter','latex')
    %caxis([minU maxU])
    title([x(plotId,:),'% chord'])
    hold off
    if plotId==2
      lbl = char(lbl);
      legend(lbl, 'Position', [0.9 0.8 0.05 0.1],'Interpreter','latex')
    end
end
