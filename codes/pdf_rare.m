function [pxy,py,xx,yy]=pdf_rare(D,ni,nf,indicator)

nt=length(D);
maxD=nan(nt-nf,1);
for j=1:nt-nf
    maxD(j)=max(D(j+ni:j+nf));
end

nx=20; % number of samples in x
ny=30; % numeber of samples in y
dx = (max(maxD(:))-min(maxD(:)))/nx;
dy = (max(indicator(:))-min(indicator(:)))/ny;

%% Compute joint PDF of maxD and indicator
[N2,C2]=hist3([maxD indicator(1:length(maxD))],[nx ny]);
pxy=N2/sum(N2(:))/(dx*dy); % normalize
xx=C2{1}; % range of maxD
yy=C2{2}; % range of indicator

%% Compute PDF of the indicator
[N1,~]=hist(indicator(1:length(maxD)),ny);
ind=(N1<1); % find the regions with few samples
N1=N1/sum(N1(:))/dy; % normalize
N1(ind)=Inf; % remove the regions with few samples
py=repmat(N1,nx,1);


%% plotting
figure;
cond_pdf=pxy./py; % conditional PDF
F = [.05 .1 .05; .1 .4 .1; .05 .1 .05]; cond_pdf = conv2(cond_pdf,F,'same'); %smooth data
pcolor(xx,yy,cond_pdf');

% colormap 
CC = colormap(flipud(hot)); temp = CC(:,1);
CC(:,1) = CC(:,3); CC(:,3) = temp; CF = zeros(1e4,3);
for ii = 1:3
    CF(:,ii) = interp1(linspace(0,1,size(CC,1)),CC(:,ii),sqrt(linspace(0,1,1e4)));
end
colormap(CF);

% figure axes
shading interp; hold on
colorbar
set(gca,'fontsize',18);
xlabel('$D_m$','interpreter','latex','fontsize',28);
ylabel('$\lambda$','interpreter','latex','fontsize',28);