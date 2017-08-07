function [Hit,CR,FN,FP]=probAnalysis(D,ti,tf,indicator,De)
%% Inputs
% D : energy dissipation rate
% indicator : Indicator of extreme energy dissipaiton
% ti,tf : [t+ti,t+tf] is the future time window containing the extremes
% De : Extreme event threshold, D>De constitutes an extreme event
%      Re=40 -> De=mean(D)+2*std(D);
%      Re>40 -> De=mean(D)+std(D);

%% Outputs
% Hit: Correct prediction of an upcoming extreme event.
% CR : Correct prediction of no upcoming extremes
% FN : False negatives
% FP : False positives

%% Compute probabilistic quantities
ni=round(ti/.1);
nf=round(tf/.1);

% Compute joint PDF and plot the conditional PDF
[pxy,py,xx,yy]=pdf_rare(D,ni,nf,indicator);

% Compute probability of extreme event Pee
[lmda,Pee]=plot_predictor(pxy,py,xx,yy,De);

% Compute the indicator's critical value, Pee(Le)=0.5
Le = fsolve(@(x)myfun(x,lmda,Pee),.45);

figure(1);
plot(De*ones(size(yy)),yy,'--r','linewidth',2);
plot(xx,Le*ones(size(xx)),'--r','linewidth',2);

%% Compute false positive (FP), false negatives (FN), hits and correct rejections (CR)
nt=length(D);
maxD=nan(nt-nf,1);
for j=1:nt-nf
    maxD(j)=max(D(j+ni:j+nf));
end
indic = indicator(1:length(maxD));
ind1 = find(indic>Le & maxD>De);
ind2 = find(indic<Le & maxD<De);
ind3 = find(indic<Le & maxD>De);
ind4 = find(indic>Le & maxD<De);
FN = length(ind1)/length(indic);
FP = length(ind2)/length(indic);
Hit= length(ind3)/length(indic);
CR = length(ind4)/length(indic);
end

function f=myfun(x,lmda,Pee)
f=interp1(lmda,Pee,x,'linear')-.5;
end
