function   PlotFittedLorentzian(fb_plot,Pb_plot,nblock_plot,parameters,sigma_par,chi2,fNyq,hydroparam)

% calculate fitted curve
Pfit = theoreticalP(parameters,fb_plot,fNyq,hydroparam);

% plot fit and standard error of fit
hf = plot(fb_plot,Pfit,'r-'); set(hf,'LineWidth',2,'Color','r'); hold on;       
he1 = plot(fb_plot,Pfit+Pfit./sqrt(nblock_plot),'k:'); 
set(he1,'LineWidth',0.5,'Color','r');
he2 = plot(fb_plot,Pfit-Pfit./sqrt(nblock_plot),'k:'); 
set(he2,'LineWidth',0.5,'Color','r');
h = xlabel('Frequency (Hz)'); 
set(h,'FontUnits','normalized','FontSize',0.04,'FontWeight','bold');
h = ylabel(['P(f) (arbitrary units) ']); 
set(h,'FontUnits','normalized','FontSize',0.04,'FontWeight','bold');
set(gca,'XScale','log','YScale','log','FontUnits','normalized','FontSize',0.04,'FontWeight','bold');

% plot blocks
index = find(isnan(Pb_plot),1,'last');
hd = plot(fb_plot(index+1,:),Pb_plot(index+1,:), 'ko'); 
set(hd,'MarkerFaceColor','w','MarkerEdgeColor','b','MarkerSize',3); 
hd2 = plot(fb_plot, Pb_plot, 'ko'); 
set(hd2,'MarkerFaceColor','b','MarkerEdgeColor','b','MarkerSize',3);
h = xlabel('Frequency (Hz)'); 
set(h,'FontUnits','normalized','FontSize',0.04,'FontWeight','bold');
h = ylabel(['P(f) (arbitrary units) ']); 
set(h,'FontUnits','normalized','FontSize',0.04,'FontWeight','bold');   

% label fits
STR(1) = {['fc (Hz) = ' num2str(parameters(1),'%5.2f') ' \pm ' num2str(sigma_par(1),'%5.2f')]};  
STR(2) = {['D (arb. units)^2/s = ' num2str(exp(parameters(2)),'%5.2e') ' \pm ' num2str(exp(parameters(2))*sigma_par(2),'%5.2e')]};        
STR(3) = {['\chi^2 per degree of freedom = ' num2str(chi2,'%8.2f')]};
hcap = axes('Position',[0 0 1 1],'Visible','off');
set(gcf,'CurrentAxes',hcap);
text(.2,0.25,STR,'FontUnits','normalized','FontSize',0.03);

hold off;
