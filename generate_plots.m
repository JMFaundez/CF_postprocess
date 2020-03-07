close all
clear all
clc


t = 1;
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
% find BL thickness
U_inf = 1;
ind_bl = zeros(6,1);
for i=1:6
    U_av = mean(Uc{i},2);
    for j=1:length(U_av)
        if U_av(j)>=0.99*U_inf
            ind_bl(i) = j;
            break
        end
    end
end


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
    contourf(X,Y,u,'LineStyle','none')
    plot(X(1,:),Y(ind_bl(plotId),:),'r-')
    xlabel('Span')
    ylabel('Normal')
    ylim([0, 0.01])
    title([x(plotId,:),'% chord'])
    hold off
    %caxis([minu maxu])
    colorbar()
    
    figure(2001)
    sgtitle('Tangent Velocity')
    subplot(3,2,plotId)
    contourf(X,Y,U,'LineStyle','none')
    xlabel('Span')
    ylabel('Normal')
    ylim([0, 0.01])
    %caxis([minU maxU])
    title([x(plotId,:),'% chord'])
    colorbar()
end