function [yy,Pee]=plot_predictor(pxy,py,xx,yy,De)

% Compute conditional PDF 
cond_pdf=pxy./py;

[~,ny]=size(cond_pdf);

if ~isempty(De)
    ind_ee = find(xx>=De);
    ind_ee = ind_ee(1);
else
    ind_ee=1;
end

% Compute probability of extreme event Pee
Pee=nan(ny,1);
for j=1:ny
    Pee(j)=sum(cond_pdf(ind_ee:end,j))*(xx(2)-xx(1));
end

%% plot probability of extreme event
yy=yy(1:ny)';
Pee=smooth(Pee(1:ny,1));
figure;
plot(yy,Pee,'-o','linewidth',2)
set(gca,'fontsize',18);
xlabel('$\lambda_0$','interpreter','latex','fontsize',28);
ylabel('$P_{ee}$','interpreter','latex','fontsize',28);
grid on
